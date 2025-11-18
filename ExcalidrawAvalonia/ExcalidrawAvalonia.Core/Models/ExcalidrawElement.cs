using System;
using System.Collections.Generic;
using SkiaSharp;

namespace ExcalidrawAvalonia.Core.Models;

/// <summary>
/// Element types supported by Excalidraw
/// </summary>
public enum ElementType
{
    Selection,
    Rectangle,
    Diamond,
    Ellipse,
    Arrow,
    Line,
    FreeDraw,
    Text,
    Image,
    Frame,
    MagicFrame,
    Embeddable,
    Iframe
}

/// <summary>
/// Fill styles for shapes
/// </summary>
public enum FillStyle
{
    Hachure,
    CrossHatch,
    Solid,
    Zigzag
}

/// <summary>
/// Stroke styles
/// </summary>
public enum StrokeStyle
{
    Solid,
    Dashed,
    Dotted
}

/// <summary>
/// Roundness types
/// </summary>
public enum RoundnessType
{
    Legacy = 1,
    ProportionalRadius = 2,
    AdaptiveRadius = 3
}

/// <summary>
/// Text alignment
/// </summary>
public enum TextAlign
{
    Left,
    Center,
    Right
}

/// <summary>
/// Vertical alignment
/// </summary>
public enum VerticalAlign
{
    Top,
    Middle,
    Bottom
}

/// <summary>
/// Arrowhead types
/// </summary>
public enum Arrowhead
{
    None,
    Arrow,
    Bar,
    Dot,
    Triangle
}

/// <summary>
/// Roundness configuration for an element
/// </summary>
public record Roundness(RoundnessType Type, double? Value = null);

/// <summary>
/// Base class for all Excalidraw elements
/// </summary>
public abstract record ExcalidrawElement
{
    /// <summary>
    /// Unique identifier for the element
    /// </summary>
    public required string Id { get; init; }

    /// <summary>
    /// Element type
    /// </summary>
    public required ElementType Type { get; init; }

    /// <summary>
    /// X position on the canvas
    /// </summary>
    public required double X { get; init; }

    /// <summary>
    /// Y position on the canvas
    /// </summary>
    public required double Y { get; init; }

    /// <summary>
    /// Width of the element
    /// </summary>
    public required double Width { get; init; }

    /// <summary>
    /// Height of the element
    /// </summary>
    public required double Height { get; init; }

    /// <summary>
    /// Rotation angle in radians
    /// </summary>
    public double Angle { get; init; }

    /// <summary>
    /// Stroke color (hex format)
    /// </summary>
    public required string StrokeColor { get; init; }

    /// <summary>
    /// Background/fill color (hex format)
    /// </summary>
    public required string BackgroundColor { get; init; }

    /// <summary>
    /// Fill style for the shape
    /// </summary>
    public FillStyle FillStyle { get; init; } = FillStyle.Hachure;

    /// <summary>
    /// Stroke width in pixels
    /// </summary>
    public double StrokeWidth { get; init; } = 1.0;

    /// <summary>
    /// Stroke style
    /// </summary>
    public StrokeStyle StrokeStyle { get; init; } = StrokeStyle.Solid;

    /// <summary>
    /// Roundness configuration
    /// </summary>
    public Roundness? RoundnessConfig { get; init; }

    /// <summary>
    /// Roughness factor (0-2, controls hand-drawn aesthetic)
    /// </summary>
    public double Roughness { get; init; } = 1.0;

    /// <summary>
    /// Opacity (0-1)
    /// </summary>
    public double Opacity { get; init; } = 1.0;

    /// <summary>
    /// Random seed for consistent shape generation
    /// </summary>
    public int Seed { get; init; }

    /// <summary>
    /// Version counter for collaboration
    /// </summary>
    public int Version { get; init; }

    /// <summary>
    /// Random nonce for version tie-breaking
    /// </summary>
    public int VersionNonce { get; init; }

    /// <summary>
    /// Fractional index for z-ordering
    /// </summary>
    public string? Index { get; init; }

    /// <summary>
    /// Soft delete flag
    /// </summary>
    public bool IsDeleted { get; init; }

    /// <summary>
    /// Group IDs this element belongs to
    /// </summary>
    public IReadOnlyList<string> GroupIds { get; init; } = Array.Empty<string>();

    /// <summary>
    /// Frame ID this element belongs to
    /// </summary>
    public string? FrameId { get; init; }

    /// <summary>
    /// Timestamp of last update (milliseconds since epoch)
    /// </summary>
    public long Updated { get; init; }

    /// <summary>
    /// Link associated with the element
    /// </summary>
    public string? Link { get; init; }

    /// <summary>
    /// Whether the element is locked
    /// </summary>
    public bool Locked { get; init; }

    /// <summary>
    /// Custom data storage
    /// </summary>
    public Dictionary<string, object>? CustomData { get; init; }

    /// <summary>
    /// Create a new element with updated properties
    /// </summary>
    public abstract ExcalidrawElement WithUpdates(Action<ElementBuilder> configure);

    /// <summary>
    /// Get bounding box of the element (considering rotation)
    /// </summary>
    public SKRect GetBoundingBox()
    {
        if (Angle == 0)
        {
            return new SKRect((float)X, (float)Y, (float)(X + Width), (float)(Y + Height));
        }

        // Calculate rotated bounding box
        var centerX = X + Width / 2;
        var centerY = Y + Height / 2;
        var cos = Math.Cos(Angle);
        var sin = Math.Sin(Angle);

        var corners = new[]
        {
            (X, Y),
            (X + Width, Y),
            (X + Width, Y + Height),
            (X, Y + Height)
        };

        var minX = double.MaxValue;
        var minY = double.MaxValue;
        var maxX = double.MinValue;
        var maxY = double.MinValue;

        foreach (var (px, py) in corners)
        {
            var dx = px - centerX;
            var dy = py - centerY;
            var rotatedX = centerX + dx * cos - dy * sin;
            var rotatedY = centerY + dx * sin + dy * cos;

            minX = Math.Min(minX, rotatedX);
            minY = Math.Min(minY, rotatedY);
            maxX = Math.Max(maxX, rotatedX);
            maxY = Math.Max(maxY, rotatedY);
        }

        return new SKRect((float)minX, (float)minY, (float)maxX, (float)maxY);
    }

    /// <summary>
    /// Check if a point is inside the element
    /// </summary>
    public virtual bool ContainsPoint(double x, double y)
    {
        var bounds = GetBoundingBox();
        return bounds.Contains((float)x, (float)y);
    }
}

/// <summary>
/// Builder class for element updates
/// </summary>
public class ElementBuilder
{
    public double? X { get; set; }
    public double? Y { get; set; }
    public double? Width { get; set; }
    public double? Height { get; set; }
    public double? Angle { get; set; }
    public string? StrokeColor { get; set; }
    public string? BackgroundColor { get; set; }
    public FillStyle? FillStyle { get; set; }
    public double? StrokeWidth { get; set; }
    public StrokeStyle? StrokeStyle { get; set; }
    public Roundness? RoundnessConfig { get; set; }
    public double? Roughness { get; set; }
    public double? Opacity { get; set; }
    public bool? IsDeleted { get; set; }
    public bool? Locked { get; set; }
    public string? Link { get; set; }
}
