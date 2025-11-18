using System;
using System.Collections.Generic;
using System.Linq;
using Avalonia;
using Avalonia.Controls;
using Avalonia.Input;
using Avalonia.Media;
using Avalonia.Platform;
using Avalonia.Rendering.SceneGraph;
using Avalonia.Skia;
using Avalonia.Threading;
using SkiaSharp;
using ExcalidrawAvalonia.Core.Models;
using ExcalidrawAvalonia.Core.Rendering;
using ExcalidrawAvalonia.Core.State;
using ExcalidrawAvalonia.Core.Utils;
using ExcalidrawAvalonia.ViewModels;

namespace ExcalidrawAvalonia.Controls;

public class DrawingCanvas : Control
{
    private MainWindowViewModel? _viewModel;
    private readonly RoughRenderer _renderer = new();

    // Drawing state
    private bool _isDrawing;
    private Point _startPoint;
    private Point _lastPoint;
    private List<SKPoint> _currentPoints = new();
    private ExcalidrawElement? _temporaryElement;
    private ExcalidrawElement? _selectedElement;

    // Pan state
    private bool _isPanning;
    private Point _panStart;
    private double _scrollX;
    private double _scrollY;

    static DrawingCanvas()
    {
        AffectsRender<DrawingCanvas>(DataContextProperty);
    }

    public DrawingCanvas()
    {
        Focusable = true;
        ClipToBounds = true;
        Background = Brushes.White;

        PointerPressed += OnPointerPressed;
        PointerMoved += OnPointerMoved;
        PointerReleased += OnPointerReleased;
        PointerWheelChanged += OnPointerWheelChanged;
        KeyDown += OnKeyDown;
    }

    protected override void OnDataContextChanged(EventArgs e)
    {
        base.OnDataContextChanged(e);

        if (DataContext is MainWindowViewModel vm)
        {
            _viewModel = vm;
            _viewModel.Scene.Subscribe(_ => InvalidateVisual());
        }
    }

    public override void Render(DrawingContext context)
    {
        base.Render(context);

        if (_viewModel == null)
            return;

        var leaseFeature = context.TryGetFeature<ISkiaSharpApiLeaseFeature>();
        if (leaseFeature == null)
            return;

        using var lease = leaseFeature.Lease();
        var canvas = lease.SkCanvas;

        // Clear background
        canvas.Clear(SKColors.White);

        // Apply pan offset
        canvas.Save();
        canvas.Translate((float)_scrollX, (float)_scrollY);

        // Draw grid
        DrawGrid(canvas);

        // Render all elements
        foreach (var element in _viewModel.Scene.NonDeletedElements)
        {
            var isSelected = element == _selectedElement ||
                           _viewModel.AppState.SelectedElementIds.Contains(element.Id);
            _renderer.RenderElement(canvas, element, isSelected);
        }

        // Render temporary element (during drawing)
        if (_temporaryElement != null)
        {
            _renderer.RenderElement(canvas, _temporaryElement);
        }

        canvas.Restore();
    }

    private void DrawGrid(SKCanvas canvas)
    {
        if (!_viewModel!.AppState.ShowGrid)
            return;

        var bounds = Bounds;
        var gridSize = 20f;

        using var paint = new SKPaint
        {
            Style = SKPaintStyle.Stroke,
            Color = new SKColor(230, 230, 230),
            StrokeWidth = 1,
            IsAntialias = true
        };

        // Vertical lines
        for (float x = 0; x < bounds.Width; x += gridSize)
        {
            canvas.DrawLine(x, 0, x, (float)bounds.Height, paint);
        }

        // Horizontal lines
        for (float y = 0; y < bounds.Height; y += gridSize)
        {
            canvas.DrawLine(0, y, (float)bounds.Width, y, paint);
        }
    }

    private void OnPointerPressed(object? sender, PointerPressedEventArgs e)
    {
        if (_viewModel == null) return;

        var point = e.GetPosition(this);
        var properties = e.GetCurrentPoint(this).Properties;

        // Handle middle button or space+left for panning
        if (properties.IsMiddleButtonPressed ||
            (properties.IsLeftButtonPressed && e.KeyModifiers.HasFlag(KeyModifiers.Shift)))
        {
            _isPanning = true;
            _panStart = point;
            Cursor = new Cursor(StandardCursorType.Hand);
            return;
        }

        if (!properties.IsLeftButtonPressed)
            return;

        Focus();
        _startPoint = point;
        _lastPoint = point;

        var toolType = _viewModel.CurrentTool;

        // Check if clicking on existing element for selection
        if (toolType == ToolType.Selection || toolType == ToolType.Hand)
        {
            var scenePoint = ToSceneCoordinates(point);
            var elements = _viewModel.Scene.GetElementsAtPoint(scenePoint.X, scenePoint.Y);
            _selectedElement = elements.FirstOrDefault();

            if (_selectedElement != null)
            {
                _viewModel.AppState = _viewModel.AppState with
                {
                    SelectedElementIds = new[] { _selectedElement.Id }.ToImmutableHashSet()
                };
            }
            InvalidateVisual();
            return;
        }

        // Start drawing
        _isDrawing = true;
        _currentPoints.Clear();
        _temporaryElement = null;

        if (toolType == ToolType.FreeDraw)
        {
            var scenePoint = ToSceneCoordinates(point);
            _currentPoints.Add(new SKPoint((float)scenePoint.X, (float)scenePoint.Y));
        }
    }

    private void OnPointerMoved(object? sender, PointerEventArgs e)
    {
        if (_viewModel == null) return;

        var point = e.GetPosition(this);

        // Handle panning
        if (_isPanning)
        {
            var delta = point - _panStart;
            _scrollX += delta.X;
            _scrollY += delta.Y;
            _panStart = point;
            InvalidateVisual();
            return;
        }

        if (!_isDrawing) return;

        var toolType = _viewModel.CurrentTool;
        var sceneStart = ToSceneCoordinates(_startPoint);
        var sceneCurrent = ToSceneCoordinates(point);

        switch (toolType)
        {
            case ToolType.Rectangle:
                _temporaryElement = ElementFactory.CreateRectangle(
                    Math.Min(sceneStart.X, sceneCurrent.X),
                    Math.Min(sceneStart.Y, sceneCurrent.Y),
                    Math.Abs(sceneCurrent.X - sceneStart.X),
                    Math.Abs(sceneCurrent.Y - sceneStart.Y),
                    _viewModel.AppState);
                break;

            case ToolType.Diamond:
                _temporaryElement = ElementFactory.CreateDiamond(
                    Math.Min(sceneStart.X, sceneCurrent.X),
                    Math.Min(sceneStart.Y, sceneCurrent.Y),
                    Math.Abs(sceneCurrent.X - sceneStart.X),
                    Math.Abs(sceneCurrent.Y - sceneStart.Y),
                    _viewModel.AppState);
                break;

            case ToolType.Ellipse:
                _temporaryElement = ElementFactory.CreateEllipse(
                    Math.Min(sceneStart.X, sceneCurrent.X),
                    Math.Min(sceneStart.Y, sceneCurrent.Y),
                    Math.Abs(sceneCurrent.X - sceneStart.X),
                    Math.Abs(sceneCurrent.Y - sceneStart.Y),
                    _viewModel.AppState);
                break;

            case ToolType.Arrow:
            case ToolType.Line:
                var points = new List<SKPoint>
                {
                    new SKPoint(0, 0),
                    new SKPoint((float)(sceneCurrent.X - sceneStart.X), (float)(sceneCurrent.Y - sceneStart.Y))
                };

                _temporaryElement = toolType == ToolType.Arrow
                    ? ElementFactory.CreateArrow(points, sceneStart.X, sceneStart.Y, _viewModel.AppState)
                    : ElementFactory.CreateLine(points, sceneStart.X, sceneStart.Y, _viewModel.AppState);
                break;

            case ToolType.FreeDraw:
                _currentPoints.Add(new SKPoint((float)sceneCurrent.X, (float)sceneCurrent.Y));

                // Calculate bounds
                var minX = _currentPoints.Min(p => p.X);
                var minY = _currentPoints.Min(p => p.Y);
                var normalizedPoints = _currentPoints.Select(p => new SKPoint(p.X - minX, p.Y - minY)).ToList();

                _temporaryElement = ElementFactory.CreateFreeDraw(
                    normalizedPoints,
                    minX,
                    minY,
                    _viewModel.AppState);
                break;
        }

        _lastPoint = point;
        InvalidateVisual();
    }

    private void OnPointerReleased(object? sender, PointerReleasedEventArgs e)
    {
        if (_isPanning)
        {
            _isPanning = false;
            Cursor = Cursor.Default;
            return;
        }

        if (!_isDrawing) return;
        if (_viewModel == null) return;

        _isDrawing = false;

        // Add the element to the scene
        if (_temporaryElement != null)
        {
            // Only add if it has some size
            if (_temporaryElement.Width > 1 || _temporaryElement.Height > 1 ||
                (_temporaryElement is FreeDrawElement && _currentPoints.Count > 2))
            {
                _viewModel.RecordHistory($"Create {_temporaryElement.Type}");
                _viewModel.AddElement(_temporaryElement);
            }

            _temporaryElement = null;
            _currentPoints.Clear();
            InvalidateVisual();
        }
    }

    private void OnPointerWheelChanged(object? sender, PointerWheelEventArgs e)
    {
        if (_viewModel == null) return;

        // Zoom with Ctrl+Wheel
        if (e.KeyModifiers.HasFlag(KeyModifiers.Control))
        {
            var delta = e.Delta.Y;
            var newZoom = _viewModel.AppState.Zoom * (1 + delta * 0.1);
            newZoom = Math.Clamp(newZoom, 0.1, 5.0);

            _viewModel.AppState = _viewModel.AppState with { Zoom = newZoom };
            InvalidateVisual();
            e.Handled = true;
        }
    }

    private void OnKeyDown(object? sender, KeyEventArgs e)
    {
        if (_viewModel == null) return;

        // Tool shortcuts
        switch (e.Key)
        {
            case Key.V:
                _viewModel.CurrentTool = ToolType.Selection;
                break;
            case Key.H:
                _viewModel.CurrentTool = ToolType.Hand;
                break;
            case Key.R:
                _viewModel.CurrentTool = ToolType.Rectangle;
                break;
            case Key.D:
                _viewModel.CurrentTool = ToolType.Diamond;
                break;
            case Key.E:
                _viewModel.CurrentTool = ToolType.Ellipse;
                break;
            case Key.A:
                _viewModel.CurrentTool = ToolType.Arrow;
                break;
            case Key.L:
                _viewModel.CurrentTool = ToolType.Line;
                break;
            case Key.P:
                _viewModel.CurrentTool = ToolType.FreeDraw;
                break;
            case Key.T:
                _viewModel.CurrentTool = ToolType.Text;
                break;
            case Key.Delete:
            case Key.Back:
                _viewModel.DeleteSelectedElements();
                break;
        }
    }

    private Point ToSceneCoordinates(Point screenPoint)
    {
        return new Point(
            screenPoint.X - _scrollX,
            screenPoint.Y - _scrollY
        );
    }
}
