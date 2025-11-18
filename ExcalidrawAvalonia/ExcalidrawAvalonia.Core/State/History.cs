using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Linq;
using ExcalidrawAvalonia.Core.Models;

namespace ExcalidrawAvalonia.Core.State;

/// <summary>
/// Manages undo/redo history
/// </summary>
public class History
{
    private readonly Stack<HistoryEntry> _undoStack = new();
    private readonly Stack<HistoryEntry> _redoStack = new();
    private readonly int _maxHistorySize;

    public History(int maxHistorySize = 100)
    {
        _maxHistorySize = maxHistorySize;
    }

    /// <summary>
    /// Whether undo is available
    /// </summary>
    public bool CanUndo => _undoStack.Count > 0;

    /// <summary>
    /// Whether redo is available
    /// </summary>
    public bool CanRedo => _redoStack.Count > 0;

    /// <summary>
    /// Record a change
    /// </summary>
    public void RecordChange(ImmutableArray<ExcalidrawElement> elements, AppState appState, string description)
    {
        var entry = new HistoryEntry(elements, appState, description, DateTimeOffset.UtcNow);
        _undoStack.Push(entry);

        // Limit history size
        if (_undoStack.Count > _maxHistorySize)
        {
            var items = _undoStack.ToArray();
            _undoStack.Clear();
            for (int i = 0; i < _maxHistorySize; i++)
            {
                _undoStack.Push(items[i]);
            }
        }

        // Clear redo stack when new change is made
        _redoStack.Clear();
    }

    /// <summary>
    /// Get the previous state (for undo)
    /// </summary>
    public HistoryEntry? Undo(ImmutableArray<ExcalidrawElement> currentElements, AppState currentAppState)
    {
        if (!CanUndo) return null;

        // Push current state to redo stack
        _redoStack.Push(new HistoryEntry(currentElements, currentAppState, "current", DateTimeOffset.UtcNow));

        // Pop from undo stack
        return _undoStack.Pop();
    }

    /// <summary>
    /// Get the next state (for redo)
    /// </summary>
    public HistoryEntry? Redo(ImmutableArray<ExcalidrawElement> currentElements, AppState currentAppState)
    {
        if (!CanRedo) return null;

        // Push current state to undo stack
        _undoStack.Push(new HistoryEntry(currentElements, currentAppState, "current", DateTimeOffset.UtcNow));

        // Pop from redo stack
        return _redoStack.Pop();
    }

    /// <summary>
    /// Clear all history
    /// </summary>
    public void Clear()
    {
        _undoStack.Clear();
        _redoStack.Clear();
    }
}

/// <summary>
/// Represents a snapshot in history
/// </summary>
public record HistoryEntry(
    ImmutableArray<ExcalidrawElement> Elements,
    AppState AppState,
    string Description,
    DateTimeOffset Timestamp
);
