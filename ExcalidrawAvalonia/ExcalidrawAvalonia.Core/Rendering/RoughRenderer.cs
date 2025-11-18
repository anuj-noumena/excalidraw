using System;
using System.Collections.Generic;
using System.Linq;
using SkiaSharp;
using ExcalidrawAvalonia.Core.Models;

namespace ExcalidrawAvalonia.Core.Rendering;

/// <summary>
/// Renders elements with hand-drawn aesthetic using SkiaSharp
/// </summary>
public class RoughRenderer
{
    private readonly Random _random = new();
    private readonly Dictionary<string, SKPath> _pathCache = new();

    /// <summary>
    /// Render an element to a canvas
    /// </summary>
    public void RenderElement(SKCanvas canvas, ExcalidrawElement element, bool isSelected = false)
    {
        if (element.IsDeleted)
            return;

        canvas.Save();

        // Apply rotation
        if (element.Angle != 0)
        {
            var centerX = (float)(element.X + element.Width / 2);
            var centerY = (float)(element.Y + element.Height / 2);
            canvas.RotateRadians((float)element.Angle, centerX, centerY);
        }

        // Render based on type
        switch (element)
        {
            case RectangleElement rect:
                RenderRectangle(canvas, rect);
                break;
            case DiamondElement diamond:
                RenderDiamond(canvas, diamond);
                break;
            case EllipseElement ellipse:
                RenderEllipse(canvas, ellipse);
                break;
            case ArrowElement arrow:
                RenderArrow(canvas, arrow);
                break;
            case LineElement line:
                RenderLine(canvas, line);
                break;
            case FreeDrawElement freedraw:
                RenderFreeDraw(canvas, freedraw);
                break;
            case TextElement text:
                RenderText(canvas, text);
                break;
            case ImageElement image:
                RenderImage(canvas, image);
                break;
            case FrameElement frame:
                RenderFrame(canvas, frame);
                break;
        }

        // Render selection if selected
        if (isSelected)
        {
            RenderSelection(canvas, element);
        }

        canvas.Restore();
    }

    private void RenderRectangle(SKCanvas canvas, RectangleElement element)
    {
        var rect = new SKRect((float)element.X, (float)element.Y,
            (float)(element.X + element.Width), (float)(element.Y + element.Height));

        // Apply roughness for hand-drawn effect
        var path = GetRoughRectPath(element.Id, rect, element.Roughness, element.Seed, element.RoundnessConfig);

        RenderShape(canvas, path, element);
    }

    private void RenderDiamond(SKCanvas canvas, DiamondElement element)
    {
        var centerX = (float)(element.X + element.Width / 2);
        var centerY = (float)(element.Y + element.Height / 2);
        var halfWidth = (float)(element.Width / 2);
        var halfHeight = (float)(element.Height / 2);

        var path = GetRoughDiamondPath(element.Id, centerX, centerY, halfWidth, halfHeight,
            element.Roughness, element.Seed);

        RenderShape(canvas, path, element);
    }

    private void RenderEllipse(SKCanvas canvas, EllipseElement element)
    {
        var rect = new SKRect((float)element.X, (float)element.Y,
            (float)(element.X + element.Width), (float)(element.Y + element.Height));

        var path = GetRoughEllipsePath(element.Id, rect, element.Roughness, element.Seed);

        RenderShape(canvas, path, element);
    }

    private void RenderArrow(SKCanvas canvas, ArrowElement element)
    {
        if (element.Points.Count < 2) return;

        var path = GetRoughLinePath(element.Id, element.Points, element.X, element.Y,
            element.Roughness, element.Seed);

        RenderLinearElement(canvas, path, element);

        // Render arrowheads
        if (element.StartArrowhead != Arrowhead.None)
        {
            RenderArrowhead(canvas, element.Points[0], element.Points[1],
                element.X, element.Y, element.StartArrowhead, element);
        }

        if (element.EndArrowhead != Arrowhead.None)
        {
            var lastIdx = element.Points.Count - 1;
            RenderArrowhead(canvas, element.Points[lastIdx], element.Points[lastIdx - 1],
                element.X, element.Y, element.EndArrowhead, element);
        }
    }

    private void RenderLine(SKCanvas canvas, LineElement element)
    {
        if (element.Points.Count < 2) return;

        var path = GetRoughLinePath(element.Id, element.Points, element.X, element.Y,
            element.Roughness, element.Seed);

        RenderLinearElement(canvas, path, element);
    }

    private void RenderFreeDraw(SKCanvas canvas, FreeDrawElement element)
    {
        if (element.Points.Count < 2) return;

        var path = new SKPath();
        path.MoveTo((float)(element.X + element.Points[0].X),
            (float)(element.Y + element.Points[0].Y));

        for (int i = 1; i < element.Points.Count; i++)
        {
            path.LineTo((float)(element.X + element.Points[i].X),
                (float)(element.Y + element.Points[i].Y));
        }

        using var paint = new SKPaint
        {
            Style = SKPaintStyle.Stroke,
            Color = ParseColor(element.StrokeColor).WithAlpha((byte)(element.Opacity * 255)),
            StrokeWidth = (float)element.StrokeWidth,
            IsAntialias = true,
            StrokeCap = SKStrokeCap.Round,
            StrokeJoin = SKStrokeJoin.Round
        };

        canvas.DrawPath(path, paint);
    }

    private void RenderText(SKCanvas canvas, TextElement element)
    {
        using var paint = new SKPaint
        {
            Color = ParseColor(element.StrokeColor).WithAlpha((byte)(element.Opacity * 255)),
            TextSize = (float)element.FontSize,
            IsAntialias = true,
            Typeface = SKTypeface.FromFamilyName(element.FontFamily)
        };

        var lines = element.Text.Split('\n');
        var y = (float)element.Y;
        var lineHeight = (float)(element.FontSize * element.LineHeight);

        foreach (var line in lines)
        {
            var x = (float)element.X;

            // Apply text alignment
            if (element.TextAlign == TextAlign.Center)
            {
                var width = paint.MeasureText(line);
                x += (float)((element.Width - width) / 2);
            }
            else if (element.TextAlign == TextAlign.Right)
            {
                var width = paint.MeasureText(line);
                x += (float)(element.Width - width);
            }

            canvas.DrawText(line, x, y + (float)element.FontSize, paint);
            y += lineHeight;
        }
    }

    private void RenderImage(SKCanvas canvas, ImageElement element)
    {
        // Placeholder for image rendering
        using var paint = new SKPaint
        {
            Style = SKPaintStyle.Stroke,
            Color = SKColors.Gray,
            StrokeWidth = 1,
            IsAntialias = true
        };

        var rect = new SKRect((float)element.X, (float)element.Y,
            (float)(element.X + element.Width), (float)(element.Y + element.Height));

        canvas.DrawRect(rect, paint);

        // Draw placeholder text
        using var textPaint = new SKPaint
        {
            Color = SKColors.Gray,
            TextSize = 14,
            IsAntialias = true,
            TextAlign = SKTextAlign.Center
        };

        canvas.DrawText("Image", rect.MidX, rect.MidY, textPaint);
    }

    private void RenderFrame(SKCanvas canvas, FrameElement element)
    {
        using var paint = new SKPaint
        {
            Style = SKPaintStyle.Stroke,
            Color = ParseColor(element.StrokeColor).WithAlpha((byte)(element.Opacity * 255)),
            StrokeWidth = 2,
            IsAntialias = true,
            PathEffect = SKPathEffect.CreateDash(new[] { 5f, 5f }, 0)
        };

        var rect = new SKRect((float)element.X, (float)element.Y,
            (float)(element.X + element.Width), (float)(element.Y + element.Height));

        canvas.DrawRect(rect, paint);

        // Draw frame name
        if (!string.IsNullOrEmpty(element.Name))
        {
            using var textPaint = new SKPaint
            {
                Color = ParseColor(element.StrokeColor),
                TextSize = 12,
                IsAntialias = true
            };

            canvas.DrawText(element.Name, (float)element.X + 5, (float)element.Y + 15, textPaint);
        }
    }

    private void RenderShape(SKCanvas canvas, SKPath path, ExcalidrawElement element)
    {
        // Fill
        if (!string.IsNullOrEmpty(element.BackgroundColor) && element.BackgroundColor != "transparent")
        {
            using var fillPaint = new SKPaint
            {
                Style = SKPaintStyle.Fill,
                Color = ParseColor(element.BackgroundColor).WithAlpha((byte)(element.Opacity * 255)),
                IsAntialias = true
            };

            // Apply fill style
            if (element.FillStyle == FillStyle.Hachure || element.FillStyle == FillStyle.CrossHatch)
            {
                fillPaint.PathEffect = CreateHatchPattern(element.FillStyle);
            }

            canvas.DrawPath(path, fillPaint);
        }

        // Stroke
        using var strokePaint = new SKPaint
        {
            Style = SKPaintStyle.Stroke,
            Color = ParseColor(element.StrokeColor).WithAlpha((byte)(element.Opacity * 255)),
            StrokeWidth = (float)element.StrokeWidth,
            IsAntialias = true
        };

        ApplyStrokeStyle(strokePaint, element.StrokeStyle);

        canvas.DrawPath(path, strokePaint);
    }

    private void RenderLinearElement(SKCanvas canvas, SKPath path, ExcalidrawElement element)
    {
        using var paint = new SKPaint
        {
            Style = SKPaintStyle.Stroke,
            Color = ParseColor(element.StrokeColor).WithAlpha((byte)(element.Opacity * 255)),
            StrokeWidth = (float)element.StrokeWidth,
            IsAntialias = true
        };

        ApplyStrokeStyle(paint, element.StrokeStyle);

        canvas.DrawPath(path, paint);
    }

    private void RenderArrowhead(SKCanvas canvas, SKPoint point, SKPoint previousPoint,
        double offsetX, double offsetY, Arrowhead type, ExcalidrawElement element)
    {
        var x = (float)(offsetX + point.X);
        var y = (float)(offsetY + point.Y);
        var prevX = (float)(offsetX + previousPoint.X);
        var prevY = (float)(offsetY + previousPoint.Y);

        // Calculate angle
        var angle = Math.Atan2(y - prevY, x - prevX);
        var size = (float)element.StrokeWidth * 3;

        using var paint = new SKPaint
        {
            Style = type == Arrowhead.Triangle ? SKPaintStyle.Fill : SKPaintStyle.Stroke,
            Color = ParseColor(element.StrokeColor).WithAlpha((byte)(element.Opacity * 255)),
            StrokeWidth = (float)element.StrokeWidth,
            IsAntialias = true
        };

        switch (type)
        {
            case Arrowhead.Arrow:
            case Arrowhead.Triangle:
                var path = new SKPath();
                var angle1 = angle + Math.PI * 0.75;
                var angle2 = angle - Math.PI * 0.75;

                path.MoveTo(x, y);
                path.LineTo(x + size * (float)Math.Cos(angle1), y + size * (float)Math.Sin(angle1));
                path.LineTo(x + size * (float)Math.Cos(angle2), y + size * (float)Math.Sin(angle2));
                path.Close();

                canvas.DrawPath(path, paint);
                break;

            case Arrowhead.Bar:
                var perpAngle = angle + Math.PI / 2;
                var barSize = size * 0.7f;
                canvas.DrawLine(
                    x + barSize * (float)Math.Cos(perpAngle),
                    y + barSize * (float)Math.Sin(perpAngle),
                    x - barSize * (float)Math.Cos(perpAngle),
                    y - barSize * (float)Math.Sin(perpAngle),
                    paint);
                break;

            case Arrowhead.Dot:
                canvas.DrawCircle(x, y, size, paint);
                break;
        }
    }

    private void RenderSelection(SKCanvas canvas, ExcalidrawElement element)
    {
        var bounds = element.GetBoundingBox();
        bounds.Inflate(2, 2);

        using var paint = new SKPaint
        {
            Style = SKPaintStyle.Stroke,
            Color = SKColors.DodgerBlue,
            StrokeWidth = 1,
            PathEffect = SKPathEffect.CreateDash(new[] { 4f, 4f }, 0),
            IsAntialias = true
        };

        canvas.DrawRect(bounds, paint);

        // Draw resize handles
        DrawHandle(canvas, bounds.Left, bounds.Top);
        DrawHandle(canvas, bounds.MidX, bounds.Top);
        DrawHandle(canvas, bounds.Right, bounds.Top);
        DrawHandle(canvas, bounds.Right, bounds.MidY);
        DrawHandle(canvas, bounds.Right, bounds.Bottom);
        DrawHandle(canvas, bounds.MidX, bounds.Bottom);
        DrawHandle(canvas, bounds.Left, bounds.Bottom);
        DrawHandle(canvas, bounds.Left, bounds.MidY);
    }

    private void DrawHandle(SKCanvas canvas, float x, float y)
    {
        using var paint = new SKPaint
        {
            Style = SKPaintStyle.Fill,
            Color = SKColors.White,
            IsAntialias = true
        };

        using var strokePaint = new SKPaint
        {
            Style = SKPaintStyle.Stroke,
            Color = SKColors.DodgerBlue,
            StrokeWidth = 1,
            IsAntialias = true
        };

        var rect = new SKRect(x - 4, y - 4, x + 4, y + 4);
        canvas.DrawRect(rect, paint);
        canvas.DrawRect(rect, strokePaint);
    }

    private SKPath GetRoughRectPath(string id, SKRect rect, double roughness, int seed, Roundness? roundness)
    {
        var cacheKey = $"rect_{id}_{rect}_{roughness}_{seed}_{roundness}";
        if (_pathCache.TryGetValue(cacheKey, out var cached))
            return cached;

        var path = new SKPath();
        var rng = new Random(seed);
        var rough = (float)roughness;

        if (roundness != null && roundness.Value.HasValue)
        {
            var radius = (float)roundness.Value.Value;
            path.AddRoundRect(rect, radius, radius);
        }
        else
        {
            // Add roughness by offsetting points slightly
            var offset = rough * 0.5f;
            path.MoveTo(rect.Left + RandomOffset(rng, offset), rect.Top + RandomOffset(rng, offset));
            path.LineTo(rect.Right + RandomOffset(rng, offset), rect.Top + RandomOffset(rng, offset));
            path.LineTo(rect.Right + RandomOffset(rng, offset), rect.Bottom + RandomOffset(rng, offset));
            path.LineTo(rect.Left + RandomOffset(rng, offset), rect.Bottom + RandomOffset(rng, offset));
            path.Close();
        }

        _pathCache[cacheKey] = path;
        return path;
    }

    private SKPath GetRoughDiamondPath(string id, float centerX, float centerY, float halfWidth, float halfHeight, double roughness, int seed)
    {
        var cacheKey = $"diamond_{id}_{centerX}_{centerY}_{halfWidth}_{halfHeight}_{roughness}_{seed}";
        if (_pathCache.TryGetValue(cacheKey, out var cached))
            return cached;

        var path = new SKPath();
        var rng = new Random(seed);
        var offset = (float)roughness * 0.5f;

        path.MoveTo(centerX + RandomOffset(rng, offset), centerY - halfHeight + RandomOffset(rng, offset));
        path.LineTo(centerX + halfWidth + RandomOffset(rng, offset), centerY + RandomOffset(rng, offset));
        path.LineTo(centerX + RandomOffset(rng, offset), centerY + halfHeight + RandomOffset(rng, offset));
        path.LineTo(centerX - halfWidth + RandomOffset(rng, offset), centerY + RandomOffset(rng, offset));
        path.Close();

        _pathCache[cacheKey] = path;
        return path;
    }

    private SKPath GetRoughEllipsePath(string id, SKRect rect, double roughness, int seed)
    {
        var cacheKey = $"ellipse_{id}_{rect}_{roughness}_{seed}";
        if (_pathCache.TryGetValue(cacheKey, out var cached))
            return cached;

        var path = new SKPath();
        var rng = new Random(seed);
        var offset = (float)roughness * 0.5f;

        // Create ellipse with slight roughness
        var centerX = rect.MidX;
        var centerY = rect.MidY;
        var radiusX = rect.Width / 2;
        var radiusY = rect.Height / 2;

        var points = 32;
        for (int i = 0; i < points; i++)
        {
            var angle = (float)(2 * Math.PI * i / points);
            var x = centerX + radiusX * (float)Math.Cos(angle) + RandomOffset(rng, offset);
            var y = centerY + radiusY * (float)Math.Sin(angle) + RandomOffset(rng, offset);

            if (i == 0)
                path.MoveTo(x, y);
            else
                path.LineTo(x, y);
        }
        path.Close();

        _pathCache[cacheKey] = path;
        return path;
    }

    private SKPath GetRoughLinePath(string id, IReadOnlyList<SKPoint> points, double offsetX, double offsetY, double roughness, int seed)
    {
        var cacheKey = $"line_{id}_{points.Count}_{roughness}_{seed}";
        if (_pathCache.TryGetValue(cacheKey, out var cached))
            return cached;

        var path = new SKPath();
        var rng = new Random(seed);
        var offset = (float)roughness * 0.5f;

        for (int i = 0; i < points.Count; i++)
        {
            var x = (float)(offsetX + points[i].X + RandomOffset(rng, offset));
            var y = (float)(offsetY + points[i].Y + RandomOffset(rng, offset));

            if (i == 0)
                path.MoveTo(x, y);
            else
                path.LineTo(x, y);
        }

        _pathCache[cacheKey] = path;
        return path;
    }

    private float RandomOffset(Random rng, float maxOffset)
    {
        return (float)(rng.NextDouble() * maxOffset * 2 - maxOffset);
    }

    private SKColor ParseColor(string colorString)
    {
        if (string.IsNullOrEmpty(colorString) || colorString == "transparent")
            return SKColors.Transparent;

        if (colorString.StartsWith("#"))
        {
            return SKColor.Parse(colorString);
        }

        return SKColors.Black;
    }

    private void ApplyStrokeStyle(SKPaint paint, StrokeStyle style)
    {
        switch (style)
        {
            case StrokeStyle.Dashed:
                paint.PathEffect = SKPathEffect.CreateDash(new[] { 10f, 5f }, 0);
                break;
            case StrokeStyle.Dotted:
                paint.PathEffect = SKPathEffect.CreateDash(new[] { 2f, 5f }, 0);
                break;
        }
    }

    private SKPathEffect CreateHatchPattern(FillStyle style)
    {
        // Simplified hatch pattern - in production would use more sophisticated approach
        return SKPathEffect.CreateDash(new[] { 4f, 4f }, 0);
    }

    public void ClearCache()
    {
        _pathCache.Clear();
    }
}
