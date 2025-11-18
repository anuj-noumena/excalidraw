using System;
using System.Collections.Generic;
using System.Linq;
using SkiaSharp;
using ExcalidrawAvalonia.Core.Models;
using ExcalidrawAvalonia.Core.State;

namespace ExcalidrawAvalonia.Core.Utils;

/// <summary>
/// Factory for creating new elements
/// </summary>
public static class ElementFactory
{
    private static readonly Random _random = new();

    public static string GenerateId() => Guid.NewGuid().ToString("N");

    public static RectangleElement CreateRectangle(double x, double y, double width, double height, AppState appState)
    {
        return new RectangleElement
        {
            Id = GenerateId(),
            Type = ElementType.Rectangle,
            X = x,
            Y = y,
            Width = width,
            Height = height,
            Angle = 0,
            StrokeColor = appState.StrokeColor,
            BackgroundColor = appState.BackgroundColor,
            FillStyle = appState.FillStyle,
            StrokeWidth = appState.StrokeWidth,
            StrokeStyle = appState.StrokeStyle,
            Roughness = appState.Roughness,
            Opacity = appState.Opacity,
            Seed = _random.Next(),
            Version = 1,
            VersionNonce = _random.Next(),
            Updated = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds()
        };
    }

    public static DiamondElement CreateDiamond(double x, double y, double width, double height, AppState appState)
    {
        return new DiamondElement
        {
            Id = GenerateId(),
            Type = ElementType.Diamond,
            X = x,
            Y = y,
            Width = width,
            Height = height,
            Angle = 0,
            StrokeColor = appState.StrokeColor,
            BackgroundColor = appState.BackgroundColor,
            FillStyle = appState.FillStyle,
            StrokeWidth = appState.StrokeWidth,
            StrokeStyle = appState.StrokeStyle,
            Roughness = appState.Roughness,
            Opacity = appState.Opacity,
            Seed = _random.Next(),
            Version = 1,
            VersionNonce = _random.Next(),
            Updated = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds()
        };
    }

    public static EllipseElement CreateEllipse(double x, double y, double width, double height, AppState appState)
    {
        return new EllipseElement
        {
            Id = GenerateId(),
            Type = ElementType.Ellipse,
            X = x,
            Y = y,
            Width = width,
            Height = height,
            Angle = 0,
            StrokeColor = appState.StrokeColor,
            BackgroundColor = appState.BackgroundColor,
            FillStyle = appState.FillStyle,
            StrokeWidth = appState.StrokeWidth,
            StrokeStyle = appState.StrokeStyle,
            Roughness = appState.Roughness,
            Opacity = appState.Opacity,
            Seed = _random.Next(),
            Version = 1,
            VersionNonce = _random.Next(),
            Updated = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds()
        };
    }

    public static ArrowElement CreateArrow(List<SKPoint> points, double x, double y, AppState appState)
    {
        var (width, height) = CalculateDimensions(points);

        return new ArrowElement
        {
            Id = GenerateId(),
            Type = ElementType.Arrow,
            X = x,
            Y = y,
            Width = width,
            Height = height,
            Angle = 0,
            Points = points,
            StrokeColor = appState.StrokeColor,
            BackgroundColor = "transparent",
            StrokeWidth = appState.StrokeWidth,
            StrokeStyle = appState.StrokeStyle,
            Roughness = appState.Roughness,
            Opacity = appState.Opacity,
            StartArrowhead = appState.CurrentStartArrowhead,
            EndArrowhead = appState.CurrentEndArrowhead,
            Seed = _random.Next(),
            Version = 1,
            VersionNonce = _random.Next(),
            Updated = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds()
        };
    }

    public static LineElement CreateLine(List<SKPoint> points, double x, double y, AppState appState)
    {
        var (width, height) = CalculateDimensions(points);

        return new LineElement
        {
            Id = GenerateId(),
            Type = ElementType.Line,
            X = x,
            Y = y,
            Width = width,
            Height = height,
            Angle = 0,
            Points = points,
            StrokeColor = appState.StrokeColor,
            BackgroundColor = "transparent",
            StrokeWidth = appState.StrokeWidth,
            StrokeStyle = appState.StrokeStyle,
            Roughness = appState.Roughness,
            Opacity = appState.Opacity,
            Seed = _random.Next(),
            Version = 1,
            VersionNonce = _random.Next(),
            Updated = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds()
        };
    }

    public static FreeDrawElement CreateFreeDraw(List<SKPoint> points, double x, double y, AppState appState)
    {
        var (width, height) = CalculateDimensions(points);

        return new FreeDrawElement
        {
            Id = GenerateId(),
            Type = ElementType.FreeDraw,
            X = x,
            Y = y,
            Width = width,
            Height = height,
            Angle = 0,
            Points = points,
            StrokeColor = appState.StrokeColor,
            BackgroundColor = "transparent",
            StrokeWidth = appState.StrokeWidth,
            Roughness = appState.Roughness,
            Opacity = appState.Opacity,
            SimulatePressure = true,
            Seed = _random.Next(),
            Version = 1,
            VersionNonce = _random.Next(),
            Updated = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds()
        };
    }

    public static TextElement CreateText(string text, double x, double y, AppState appState)
    {
        return new TextElement
        {
            Id = GenerateId(),
            Type = ElementType.Text,
            X = x,
            Y = y,
            Width = 200, // Default width
            Height = 50, // Will be calculated based on text
            Angle = 0,
            Text = text,
            FontSize = appState.FontSize,
            FontFamily = appState.FontFamily,
            TextAlign = appState.TextAlign,
            StrokeColor = appState.StrokeColor,
            BackgroundColor = "transparent",
            Opacity = appState.Opacity,
            Seed = _random.Next(),
            Version = 1,
            VersionNonce = _random.Next(),
            Updated = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds()
        };
    }

    public static FrameElement CreateFrame(double x, double y, double width, double height, string? name = null)
    {
        return new FrameElement
        {
            Id = GenerateId(),
            Type = ElementType.Frame,
            X = x,
            Y = y,
            Width = width,
            Height = height,
            Angle = 0,
            Name = name,
            StrokeColor = "#000000",
            BackgroundColor = "transparent",
            Seed = _random.Next(),
            Version = 1,
            VersionNonce = _random.Next(),
            Updated = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds()
        };
    }

    private static (double width, double height) CalculateDimensions(List<SKPoint> points)
    {
        if (points.Count == 0)
            return (0, 0);

        var minX = points.Min(p => p.X);
        var maxX = points.Max(p => p.X);
        var minY = points.Min(p => p.Y);
        var maxY = points.Max(p => p.Y);

        return (maxX - minX, maxY - minY);
    }
}
