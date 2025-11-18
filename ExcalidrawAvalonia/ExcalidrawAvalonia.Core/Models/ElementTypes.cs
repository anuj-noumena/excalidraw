using System;
using System.Collections.Generic;
using SkiaSharp;

namespace ExcalidrawAvalonia.Core.Models;

/// <summary>
/// Rectangle element
/// </summary>
public record RectangleElement : ExcalidrawElement
{
    public override ExcalidrawElement WithUpdates(Action<ElementBuilder> configure)
    {
        var builder = new ElementBuilder();
        configure(builder);
        return this with
        {
            X = builder.X ?? X,
            Y = builder.Y ?? Y,
            Width = builder.Width ?? Width,
            Height = builder.Height ?? Height,
            Angle = builder.Angle ?? Angle,
            StrokeColor = builder.StrokeColor ?? StrokeColor,
            BackgroundColor = builder.BackgroundColor ?? BackgroundColor,
            FillStyle = builder.FillStyle ?? FillStyle,
            StrokeWidth = builder.StrokeWidth ?? StrokeWidth,
            StrokeStyle = builder.StrokeStyle ?? StrokeStyle,
            RoundnessConfig = builder.RoundnessConfig ?? RoundnessConfig,
            Roughness = builder.Roughness ?? Roughness,
            Opacity = builder.Opacity ?? Opacity,
            IsDeleted = builder.IsDeleted ?? IsDeleted,
            Locked = builder.Locked ?? Locked,
            Link = builder.Link ?? Link,
            Version = Version + 1,
            VersionNonce = Random.Shared.Next(),
            Updated = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds()
        };
    }
}

/// <summary>
/// Diamond element
/// </summary>
public record DiamondElement : ExcalidrawElement
{
    public override ExcalidrawElement WithUpdates(Action<ElementBuilder> configure)
    {
        var builder = new ElementBuilder();
        configure(builder);
        return this with
        {
            X = builder.X ?? X,
            Y = builder.Y ?? Y,
            Width = builder.Width ?? Width,
            Height = builder.Height ?? Height,
            Angle = builder.Angle ?? Angle,
            StrokeColor = builder.StrokeColor ?? StrokeColor,
            BackgroundColor = builder.BackgroundColor ?? BackgroundColor,
            FillStyle = builder.FillStyle ?? FillStyle,
            StrokeWidth = builder.StrokeWidth ?? StrokeWidth,
            StrokeStyle = builder.StrokeStyle ?? StrokeStyle,
            Roughness = builder.Roughness ?? Roughness,
            Opacity = builder.Opacity ?? Opacity,
            IsDeleted = builder.IsDeleted ?? IsDeleted,
            Locked = builder.Locked ?? Locked,
            Link = builder.Link ?? Link,
            Version = Version + 1,
            VersionNonce = Random.Shared.Next(),
            Updated = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds()
        };
    }
}

/// <summary>
/// Ellipse element
/// </summary>
public record EllipseElement : ExcalidrawElement
{
    public override ExcalidrawElement WithUpdates(Action<ElementBuilder> configure)
    {
        var builder = new ElementBuilder();
        configure(builder);
        return this with
        {
            X = builder.X ?? X,
            Y = builder.Y ?? Y,
            Width = builder.Width ?? Width,
            Height = builder.Height ?? Height,
            Angle = builder.Angle ?? Angle,
            StrokeColor = builder.StrokeColor ?? StrokeColor,
            BackgroundColor = builder.BackgroundColor ?? BackgroundColor,
            FillStyle = builder.FillStyle ?? FillStyle,
            StrokeWidth = builder.StrokeWidth ?? StrokeWidth,
            StrokeStyle = builder.StrokeStyle ?? StrokeStyle,
            Roughness = builder.Roughness ?? Roughness,
            Opacity = builder.Opacity ?? Opacity,
            IsDeleted = builder.IsDeleted ?? IsDeleted,
            Locked = builder.Locked ?? Locked,
            Link = builder.Link ?? Link,
            Version = Version + 1,
            VersionNonce = Random.Shared.Next(),
            Updated = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds()
        };
    }
}

/// <summary>
/// Linear element (base for lines and arrows)
/// </summary>
public record LinearElement : ExcalidrawElement
{
    /// <summary>
    /// Points defining the line (relative to X, Y)
    /// </summary>
    public required IReadOnlyList<SKPoint> Points { get; init; }

    /// <summary>
    /// Last committed point (for in-progress drawing)
    /// </summary>
    public SKPoint? LastCommittedPoint { get; init; }

    public override ExcalidrawElement WithUpdates(Action<ElementBuilder> configure)
    {
        var builder = new ElementBuilder();
        configure(builder);
        return this with
        {
            X = builder.X ?? X,
            Y = builder.Y ?? Y,
            Width = builder.Width ?? Width,
            Height = builder.Height ?? Height,
            Angle = builder.Angle ?? Angle,
            StrokeColor = builder.StrokeColor ?? StrokeColor,
            BackgroundColor = builder.BackgroundColor ?? BackgroundColor,
            StrokeWidth = builder.StrokeWidth ?? StrokeWidth,
            StrokeStyle = builder.StrokeStyle ?? StrokeStyle,
            Roughness = builder.Roughness ?? Roughness,
            Opacity = builder.Opacity ?? Opacity,
            IsDeleted = builder.IsDeleted ?? IsDeleted,
            Locked = builder.Locked ?? Locked,
            Link = builder.Link ?? Link,
            Version = Version + 1,
            VersionNonce = Random.Shared.Next(),
            Updated = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds()
        };
    }
}

/// <summary>
/// Arrow element
/// </summary>
public record ArrowElement : LinearElement
{
    /// <summary>
    /// Start arrowhead type
    /// </summary>
    public Arrowhead StartArrowhead { get; init; } = Arrowhead.None;

    /// <summary>
    /// End arrowhead type
    /// </summary>
    public Arrowhead EndArrowhead { get; init; } = Arrowhead.Arrow;

    /// <summary>
    /// Binding to element at start
    /// </summary>
    public ElementBinding? StartBinding { get; init; }

    /// <summary>
    /// Binding to element at end
    /// </summary>
    public ElementBinding? EndBinding { get; init; }
}

/// <summary>
/// Binding between arrow and shape
/// </summary>
public record ElementBinding(string ElementId, string Focus, double[] Gap);

/// <summary>
/// Line element (no arrowheads)
/// </summary>
public record LineElement : LinearElement
{
}

/// <summary>
/// FreeDraw element (freehand drawing)
/// </summary>
public record FreeDrawElement : ExcalidrawElement
{
    /// <summary>
    /// Points defining the freedraw path (relative to X, Y)
    /// </summary>
    public required IReadOnlyList<SKPoint> Points { get; init; }

    /// <summary>
    /// Pressure values for each point (0-1)
    /// </summary>
    public IReadOnlyList<double>? Pressures { get; init; }

    /// <summary>
    /// Whether to simulate pressure if not available
    /// </summary>
    public bool SimulatePressure { get; init; } = true;

    /// <summary>
    /// Last committed point (for in-progress drawing)
    /// </summary>
    public SKPoint? LastCommittedPoint { get; init; }

    public override ExcalidrawElement WithUpdates(Action<ElementBuilder> configure)
    {
        var builder = new ElementBuilder();
        configure(builder);
        return this with
        {
            X = builder.X ?? X,
            Y = builder.Y ?? Y,
            StrokeColor = builder.StrokeColor ?? StrokeColor,
            StrokeWidth = builder.StrokeWidth ?? StrokeWidth,
            Roughness = builder.Roughness ?? Roughness,
            Opacity = builder.Opacity ?? Opacity,
            IsDeleted = builder.IsDeleted ?? IsDeleted,
            Locked = builder.Locked ?? Locked,
            Link = builder.Link ?? Link,
            Version = Version + 1,
            VersionNonce = Random.Shared.Next(),
            Updated = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds()
        };
    }
}

/// <summary>
/// Text element
/// </summary>
public record TextElement : ExcalidrawElement
{
    /// <summary>
    /// Text content
    /// </summary>
    public required string Text { get; init; }

    /// <summary>
    /// Font size
    /// </summary>
    public double FontSize { get; init; } = 20.0;

    /// <summary>
    /// Font family
    /// </summary>
    public string FontFamily { get; init; } = "Virgil";

    /// <summary>
    /// Text alignment
    /// </summary>
    public TextAlign TextAlign { get; init; } = TextAlign.Left;

    /// <summary>
    /// Vertical alignment
    /// </summary>
    public VerticalAlign VerticalAlign { get; init; } = VerticalAlign.Top;

    /// <summary>
    /// Container ID (for bound text)
    /// </summary>
    public string? ContainerId { get; init; }

    /// <summary>
    /// Original text (before wrapping)
    /// </summary>
    public string? OriginalText { get; init; }

    /// <summary>
    /// Line height multiplier
    /// </summary>
    public double LineHeight { get; init; } = 1.25;

    public override ExcalidrawElement WithUpdates(Action<ElementBuilder> configure)
    {
        var builder = new ElementBuilder();
        configure(builder);
        return this with
        {
            X = builder.X ?? X,
            Y = builder.Y ?? Y,
            Width = builder.Width ?? Width,
            Height = builder.Height ?? Height,
            Angle = builder.Angle ?? Angle,
            StrokeColor = builder.StrokeColor ?? StrokeColor,
            Opacity = builder.Opacity ?? Opacity,
            IsDeleted = builder.IsDeleted ?? IsDeleted,
            Locked = builder.Locked ?? Locked,
            Link = builder.Link ?? Link,
            Version = Version + 1,
            VersionNonce = Random.Shared.Next(),
            Updated = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds()
        };
    }
}

/// <summary>
/// Image element
/// </summary>
public record ImageElement : ExcalidrawElement
{
    /// <summary>
    /// File ID for the image
    /// </summary>
    public string? FileId { get; init; }

    /// <summary>
    /// Image status
    /// </summary>
    public ImageStatus Status { get; init; } = ImageStatus.Pending;

    /// <summary>
    /// Scale factors for flipping (-1 to 1 for each axis)
    /// </summary>
    public (double X, double Y) Scale { get; init; } = (1.0, 1.0);

    public override ExcalidrawElement WithUpdates(Action<ElementBuilder> configure)
    {
        var builder = new ElementBuilder();
        configure(builder);
        return this with
        {
            X = builder.X ?? X,
            Y = builder.Y ?? Y,
            Width = builder.Width ?? Width,
            Height = builder.Height ?? Height,
            Angle = builder.Angle ?? Angle,
            Opacity = builder.Opacity ?? Opacity,
            IsDeleted = builder.IsDeleted ?? IsDeleted,
            Locked = builder.Locked ?? Locked,
            Link = builder.Link ?? Link,
            Version = Version + 1,
            VersionNonce = Random.Shared.Next(),
            Updated = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds()
        };
    }
}

public enum ImageStatus
{
    Pending,
    Saved,
    Error
}

/// <summary>
/// Frame element (container)
/// </summary>
public record FrameElement : ExcalidrawElement
{
    /// <summary>
    /// Frame name
    /// </summary>
    public string? Name { get; init; }

    public override ExcalidrawElement WithUpdates(Action<ElementBuilder> configure)
    {
        var builder = new ElementBuilder();
        configure(builder);
        return this with
        {
            X = builder.X ?? X,
            Y = builder.Y ?? Y,
            Width = builder.Width ?? Width,
            Height = builder.Height ?? Height,
            StrokeColor = builder.StrokeColor ?? StrokeColor,
            BackgroundColor = builder.BackgroundColor ?? BackgroundColor,
            IsDeleted = builder.IsDeleted ?? IsDeleted,
            Locked = builder.Locked ?? Locked,
            Version = Version + 1,
            VersionNonce = Random.Shared.Next(),
            Updated = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds()
        };
    }
}
