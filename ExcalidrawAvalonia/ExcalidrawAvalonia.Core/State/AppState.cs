using System.Collections.Generic;
using System.Collections.Immutable;
using ExcalidrawAvalonia.Core.Models;

namespace ExcalidrawAvalonia.Core.State;

/// <summary>
/// Application state (UI and selection state)
/// </summary>
public record AppState
{
    /// <summary>
    /// Currently selected tool
    /// </summary>
    public ToolType CurrentTool { get; init; } = ToolType.Selection;

    /// <summary>
    /// IDs of selected elements
    /// </summary>
    public ImmutableHashSet<string> SelectedElementIds { get; init; } = ImmutableHashSet<string>.Empty;

    /// <summary>
    /// Current stroke color
    /// </summary>
    public string StrokeColor { get; init; } = "#000000";

    /// <summary>
    /// Current background color
    /// </summary>
    public string BackgroundColor { get; init; } = "#ffffff";

    /// <summary>
    /// Current fill style
    /// </summary>
    public FillStyle FillStyle { get; init; } = FillStyle.Hachure;

    /// <summary>
    /// Current stroke width
    /// </summary>
    public double StrokeWidth { get; init; } = 1.0;

    /// <summary>
    /// Current stroke style
    /// </summary>
    public StrokeStyle StrokeStyle { get; init; } = StrokeStyle.Solid;

    /// <summary>
    /// Current roughness
    /// </summary>
    public double Roughness { get; init; } = 1.0;

    /// <summary>
    /// Current opacity
    /// </summary>
    public double Opacity { get; init; } = 1.0;

    /// <summary>
    /// Current font size
    /// </summary>
    public double FontSize { get; init; } = 20.0;

    /// <summary>
    /// Current font family
    /// </summary>
    public string FontFamily { get; init; } = "Virgil";

    /// <summary>
    /// Current text alignment
    /// </summary>
    public TextAlign TextAlign { get; init; } = TextAlign.Left;

    /// <summary>
    /// Zoom level
    /// </summary>
    public double Zoom { get; init; } = 1.0;

    /// <summary>
    /// Scroll X offset
    /// </summary>
    public double ScrollX { get; init; } = 0.0;

    /// <summary>
    /// Scroll Y offset
    /// </summary>
    public double ScrollY { get; init; } = 0.0;

    /// <summary>
    /// Whether grid is visible
    /// </summary>
    public bool ShowGrid { get; init; } = true;

    /// <summary>
    /// Whether rulers are visible
    /// </summary>
    public bool ShowRulers { get; init; }

    /// <summary>
    /// View mode (normal, zen, view-only)
    /// </summary>
    public ViewMode ViewMode { get; init; } = ViewMode.Normal;

    /// <summary>
    /// Current theme
    /// </summary>
    public Theme Theme { get; init; } = Theme.Light;

    /// <summary>
    /// Whether the app is in pen mode
    /// </summary>
    public bool PenMode { get; init; }

    /// <summary>
    /// Arrowhead settings
    /// </summary>
    public Arrowhead CurrentStartArrowhead { get; init; } = Arrowhead.None;
    public Arrowhead CurrentEndArrowhead { get; init; } = Arrowhead.Arrow;
}

/// <summary>
/// Tool types
/// </summary>
public enum ToolType
{
    Selection,
    Hand,
    Rectangle,
    Diamond,
    Ellipse,
    Arrow,
    Line,
    FreeDraw,
    Text,
    Image,
    Eraser,
    Frame,
    Laser
}

/// <summary>
/// View modes
/// </summary>
public enum ViewMode
{
    Normal,
    Zen,
    ViewOnly
}

/// <summary>
/// Theme
/// </summary>
public enum Theme
{
    Light,
    Dark
}
