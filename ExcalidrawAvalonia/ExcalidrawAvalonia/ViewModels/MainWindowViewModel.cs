using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Reactive;
using System.Windows.Input;
using ReactiveUI;
using SkiaSharp;
using ExcalidrawAvalonia.Core.Models;
using ExcalidrawAvalonia.Core.State;
using ExcalidrawAvalonia.Core.Utils;
using ExcalidrawAvalonia.Core.Export;

namespace ExcalidrawAvalonia.ViewModels;

public class MainWindowViewModel : ReactiveObject
{
    private readonly Scene _scene = new();
    private readonly History _history = new();
    private readonly Exporter _exporter = new();

    private AppState _appState;
    private ToolType _currentTool;
    private string _statusText = "Ready";

    public MainWindowViewModel()
    {
        _appState = new AppState();
        _currentTool = ToolType.Selection;

        // Initialize commands
        NewCommand = ReactiveCommand.Create(OnNew);
        OpenCommand = ReactiveCommand.Create(OnOpen);
        SaveCommand = ReactiveCommand.Create(OnSave);
        ExportPngCommand = ReactiveCommand.Create(OnExportPng);
        ExportSvgCommand = ReactiveCommand.Create(OnExportSvg);
        UndoCommand = ReactiveCommand.Create(OnUndo, this.WhenAnyValue(x => x.CanUndo));
        RedoCommand = ReactiveCommand.Create(OnRedo, this.WhenAnyValue(x => x.CanRedo));
        ClearCanvasCommand = ReactiveCommand.Create(OnClearCanvas);
        SelectToolCommand = ReactiveCommand.Create<ToolType>(OnSelectTool);

        // Subscribe to scene changes
        _scene.Subscribe(OnSceneChanged);
    }

    public Scene Scene => _scene;
    public AppState AppState => _appState;

    public string StatusText
    {
        get => _statusText;
        set => this.RaiseAndSetIfChanged(ref _statusText, value);
    }

    public ToolType CurrentTool
    {
        get => _currentTool;
        set
        {
            this.RaiseAndSetIfChanged(ref _currentTool, value);
            _appState = _appState with { CurrentTool = value };
        }
    }

    public bool CanUndo => _history.CanUndo;
    public bool CanRedo => _history.CanRedo;

    // Commands
    public ICommand NewCommand { get; }
    public ICommand OpenCommand { get; }
    public ICommand SaveCommand { get; }
    public ICommand ExportPngCommand { get; }
    public ICommand ExportSvgCommand { get; }
    public ICommand UndoCommand { get; }
    public ICommand RedoCommand { get; }
    public ICommand ClearCanvasCommand { get; }
    public ICommand SelectToolCommand { get; }

    // Tool properties
    public string StrokeColor
    {
        get => _appState.StrokeColor;
        set
        {
            _appState = _appState with { StrokeColor = value };
            this.RaisePropertyChanged();
        }
    }

    public string BackgroundColor
    {
        get => _appState.BackgroundColor;
        set
        {
            _appState = _appState with { BackgroundColor = value };
            this.RaisePropertyChanged();
        }
    }

    public double StrokeWidth
    {
        get => _appState.StrokeWidth;
        set
        {
            _appState = _appState with { StrokeWidth = value };
            this.RaisePropertyChanged();
        }
    }

    public double Opacity
    {
        get => _appState.Opacity;
        set
        {
            _appState = _appState with { Opacity = value };
            this.RaisePropertyChanged();
        }
    }

    public double Roughness
    {
        get => _appState.Roughness;
        set
        {
            _appState = _appState with { Roughness = value };
            this.RaisePropertyChanged();
        }
    }

    public FillStyle FillStyle
    {
        get => _appState.FillStyle;
        set
        {
            _appState = _appState with { FillStyle = value };
            this.RaisePropertyChanged();
        }
    }

    private void OnNew()
    {
        _scene.Clear();
        _history.Clear();
        StatusText = "New canvas created";
    }

    private async void OnOpen()
    {
        // TODO: Implement file dialog and JSON import
        StatusText = "Open not yet implemented";
    }

    private async void OnSave()
    {
        // TODO: Implement file dialog and JSON export
        try
        {
            var json = _exporter.ExportToJson(_scene, _appState);
            StatusText = "File saved";
        }
        catch (Exception ex)
        {
            StatusText = $"Error saving: {ex.Message}";
        }
    }

    private async void OnExportPng()
    {
        // TODO: Implement file dialog and PNG export
        try
        {
            var png = _exporter.ExportToPng(_scene, 800, 600);
            StatusText = "Exported to PNG";
        }
        catch (Exception ex)
        {
            StatusText = $"Error exporting: {ex.Message}";
        }
    }

    private async void OnExportSvg()
    {
        // TODO: Implement file dialog and SVG export
        try
        {
            var svg = _exporter.ExportToSvg(_scene, 800, 600);
            StatusText = "Exported to SVG";
        }
        catch (Exception ex)
        {
            StatusText = $"Error exporting: {ex.Message}";
        }
    }

    private void OnUndo()
    {
        var entry = _history.Undo(_scene.Elements, _appState);
        if (entry != null)
        {
            _scene.ReplaceAllElements(entry.Elements);
            _appState = entry.AppState;
            StatusText = $"Undo: {entry.Description}";
            this.RaisePropertyChanged(nameof(CanUndo));
            this.RaisePropertyChanged(nameof(CanRedo));
        }
    }

    private void OnRedo()
    {
        var entry = _history.Redo(_scene.Elements, _appState);
        if (entry != null)
        {
            _scene.ReplaceAllElements(entry.Elements);
            _appState = entry.AppState;
            StatusText = $"Redo: {entry.Description}";
            this.RaisePropertyChanged(nameof(CanUndo));
            this.RaisePropertyChanged(nameof(CanRedo));
        }
    }

    private void OnClearCanvas()
    {
        RecordHistory("Clear canvas");
        _scene.Clear();
        StatusText = "Canvas cleared";
    }

    private void OnSelectTool(ToolType tool)
    {
        CurrentTool = tool;
        StatusText = $"Selected tool: {tool}";
    }

    private void OnSceneChanged(SceneChange change)
    {
        // Update status
        if (change.Added.Length > 0)
        {
            StatusText = $"Added {change.Added.Length} element(s)";
        }
        else if (change.Updated.Length > 0)
        {
            StatusText = $"Updated {change.Updated.Length} element(s)";
        }
        else if (change.Removed.Length > 0)
        {
            StatusText = $"Removed {change.Removed.Length} element(s)";
        }
    }

    public void RecordHistory(string description)
    {
        _history.RecordChange(_scene.Elements, _appState, description);
        this.RaisePropertyChanged(nameof(CanUndo));
        this.RaisePropertyChanged(nameof(CanRedo));
    }

    public void AddElement(ExcalidrawElement element)
    {
        _scene.AddElements(element);
    }

    public void UpdateElement(ExcalidrawElement element)
    {
        _scene.UpdateElement(element);
    }

    public void DeleteSelectedElements()
    {
        var selectedIds = _appState.SelectedElementIds.ToArray();
        if (selectedIds.Length > 0)
        {
            RecordHistory($"Delete {selectedIds.Length} element(s)");
            _scene.RemoveElements(selectedIds);
        }
    }
}
