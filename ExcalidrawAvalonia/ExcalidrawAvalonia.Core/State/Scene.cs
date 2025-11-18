using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Linq;
using ExcalidrawAvalonia.Core.Models;

namespace ExcalidrawAvalonia.Core.State;

/// <summary>
/// Scene manages the collection of elements and notifies observers of changes
/// </summary>
public class Scene
{
    private ImmutableArray<ExcalidrawElement> _elements = ImmutableArray<ExcalidrawElement>.Empty;
    private ImmutableDictionary<string, ExcalidrawElement> _elementsMap = ImmutableDictionary<string, ExcalidrawElement>.Empty;
    private ImmutableArray<ExcalidrawElement> _nonDeletedElements = ImmutableArray<ExcalidrawElement>.Empty;
    private int _sceneNonce;
    private readonly List<Action<SceneChange>> _callbacks = new();

    /// <summary>
    /// Current scene nonce (incremented on each change for cache invalidation)
    /// </summary>
    public int SceneNonce => _sceneNonce;

    /// <summary>
    /// All elements (including deleted)
    /// </summary>
    public ImmutableArray<ExcalidrawElement> Elements => _elements;

    /// <summary>
    /// Element lookup map
    /// </summary>
    public ImmutableDictionary<string, ExcalidrawElement> ElementsMap => _elementsMap;

    /// <summary>
    /// Non-deleted elements
    /// </summary>
    public ImmutableArray<ExcalidrawElement> NonDeletedElements => _nonDeletedElements;

    /// <summary>
    /// Subscribe to scene changes
    /// </summary>
    public void Subscribe(Action<SceneChange> callback)
    {
        _callbacks.Add(callback);
    }

    /// <summary>
    /// Unsubscribe from scene changes
    /// </summary>
    public void Unsubscribe(Action<SceneChange> callback)
    {
        _callbacks.Remove(callback);
    }

    /// <summary>
    /// Replace all elements in the scene
    /// </summary>
    public void ReplaceAllElements(IEnumerable<ExcalidrawElement> newElements)
    {
        var elementsArray = newElements.ToImmutableArray();

        _elements = elementsArray;
        _elementsMap = elementsArray.ToImmutableDictionary(e => e.Id);
        _nonDeletedElements = elementsArray.Where(e => !e.IsDeleted).ToImmutableArray();
        _sceneNonce = Random.Shared.Next();

        NotifyCallbacks(new SceneChange(
            Added: elementsArray,
            Removed: ImmutableArray<ExcalidrawElement>.Empty,
            Updated: ImmutableArray<ExcalidrawElement>.Empty
        ));
    }

    /// <summary>
    /// Add elements to the scene
    /// </summary>
    public void AddElements(params ExcalidrawElement[] elements)
    {
        _elements = _elements.AddRange(elements);
        _elementsMap = _elementsMap.AddRange(elements.Select(e => new KeyValuePair<string, ExcalidrawElement>(e.Id, e)));
        _nonDeletedElements = _elements.Where(e => !e.IsDeleted).ToImmutableArray();
        _sceneNonce = Random.Shared.Next();

        NotifyCallbacks(new SceneChange(
            Added: elements.ToImmutableArray(),
            Removed: ImmutableArray<ExcalidrawElement>.Empty,
            Updated: ImmutableArray<ExcalidrawElement>.Empty
        ));
    }

    /// <summary>
    /// Update an element in the scene
    /// </summary>
    public void UpdateElement(ExcalidrawElement updatedElement)
    {
        var index = _elements.FindIndex(e => e.Id == updatedElement.Id);
        if (index < 0) return;

        _elements = _elements.SetItem(index, updatedElement);
        _elementsMap = _elementsMap.SetItem(updatedElement.Id, updatedElement);
        _nonDeletedElements = _elements.Where(e => !e.IsDeleted).ToImmutableArray();
        _sceneNonce = Random.Shared.Next();

        NotifyCallbacks(new SceneChange(
            Added: ImmutableArray<ExcalidrawElement>.Empty,
            Removed: ImmutableArray<ExcalidrawElement>.Empty,
            Updated: ImmutableArray.Create(updatedElement)
        ));
    }

    /// <summary>
    /// Update multiple elements
    /// </summary>
    public void UpdateElements(IEnumerable<ExcalidrawElement> updatedElements)
    {
        var updates = updatedElements.ToImmutableArray();
        var updateMap = updates.ToDictionary(e => e.Id);

        _elements = _elements.Select(e => updateMap.TryGetValue(e.Id, out var updated) ? updated : e).ToImmutableArray();
        _elementsMap = _elements.ToImmutableDictionary(e => e.Id);
        _nonDeletedElements = _elements.Where(e => !e.IsDeleted).ToImmutableArray();
        _sceneNonce = Random.Shared.Next();

        NotifyCallbacks(new SceneChange(
            Added: ImmutableArray<ExcalidrawElement>.Empty,
            Removed: ImmutableArray<ExcalidrawElement>.Empty,
            Updated: updates
        ));
    }

    /// <summary>
    /// Remove elements (soft delete)
    /// </summary>
    public void RemoveElements(params string[] elementIds)
    {
        var idsSet = elementIds.ToHashSet();
        var removed = new List<ExcalidrawElement>();

        _elements = _elements.Select(e =>
        {
            if (idsSet.Contains(e.Id) && !e.IsDeleted)
            {
                var deleted = e.WithUpdates(b => b.IsDeleted = true);
                removed.Add(deleted);
                return deleted;
            }
            return e;
        }).ToImmutableArray();

        _elementsMap = _elements.ToImmutableDictionary(e => e.Id);
        _nonDeletedElements = _elements.Where(e => !e.IsDeleted).ToImmutableArray();
        _sceneNonce = Random.Shared.Next();

        NotifyCallbacks(new SceneChange(
            Added: ImmutableArray<ExcalidrawElement>.Empty,
            Removed: removed.ToImmutableArray(),
            Updated: ImmutableArray<ExcalidrawElement>.Empty
        ));
    }

    /// <summary>
    /// Get element by ID
    /// </summary>
    public ExcalidrawElement? GetElement(string id)
    {
        return _elementsMap.TryGetValue(id, out var element) ? element : null;
    }

    /// <summary>
    /// Get elements at a specific point
    /// </summary>
    public IEnumerable<ExcalidrawElement> GetElementsAtPoint(double x, double y)
    {
        // Iterate in reverse order (top to bottom)
        for (int i = _nonDeletedElements.Length - 1; i >= 0; i--)
        {
            var element = _nonDeletedElements[i];
            if (element.ContainsPoint(x, y))
            {
                yield return element;
            }
        }
    }

    /// <summary>
    /// Clear all elements
    /// </summary>
    public void Clear()
    {
        var removed = _nonDeletedElements;
        _elements = ImmutableArray<ExcalidrawElement>.Empty;
        _elementsMap = ImmutableDictionary<string, ExcalidrawElement>.Empty;
        _nonDeletedElements = ImmutableArray<ExcalidrawElement>.Empty;
        _sceneNonce = Random.Shared.Next();

        NotifyCallbacks(new SceneChange(
            Added: ImmutableArray<ExcalidrawElement>.Empty,
            Removed: removed,
            Updated: ImmutableArray<ExcalidrawElement>.Empty
        ));
    }

    private void NotifyCallbacks(SceneChange change)
    {
        foreach (var callback in _callbacks)
        {
            callback(change);
        }
    }
}

/// <summary>
/// Describes changes to the scene
/// </summary>
public record SceneChange(
    ImmutableArray<ExcalidrawElement> Added,
    ImmutableArray<ExcalidrawElement> Removed,
    ImmutableArray<ExcalidrawElement> Updated
);
