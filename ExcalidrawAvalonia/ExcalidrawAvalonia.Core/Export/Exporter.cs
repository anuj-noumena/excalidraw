using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;
using SkiaSharp;
using ExcalidrawAvalonia.Core.Models;
using ExcalidrawAvalonia.Core.Rendering;
using ExcalidrawAvalonia.Core.State;

namespace ExcalidrawAvalonia.Core.Export;

/// <summary>
/// Exports scene to various formats
/// </summary>
public class Exporter
{
    private readonly RoughRenderer _renderer = new();

    /// <summary>
    /// Export to PNG
    /// </summary>
    public byte[] ExportToPng(Scene scene, int width, int height, double scale = 1.0)
    {
        var info = new SKImageInfo((int)(width * scale), (int)(height * scale));
        using var surface = SKSurface.Create(info);
        var canvas = surface.Canvas;

        // Clear canvas
        canvas.Clear(SKColors.White);

        // Apply scale
        canvas.Scale((float)scale);

        // Render all elements
        foreach (var element in scene.NonDeletedElements)
        {
            _renderer.RenderElement(canvas, element);
        }

        // Encode to PNG
        using var image = surface.Snapshot();
        using var data = image.Encode(SKEncodedImageFormat.Png, 100);
        return data.ToArray();
    }

    /// <summary>
    /// Export to SVG
    /// </summary>
    public string ExportToSvg(Scene scene, int width, int height)
    {
        var svg = new StringBuilder();
        svg.AppendLine($"<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"{width}\" height=\"{height}\" viewBox=\"0 0 {width} {height}\">");

        foreach (var element in scene.NonDeletedElements)
        {
            svg.AppendLine(ElementToSvg(element));
        }

        svg.AppendLine("</svg>");
        return svg.ToString();
    }

    /// <summary>
    /// Export to JSON (Excalidraw format)
    /// </summary>
    public string ExportToJson(Scene scene, AppState appState)
    {
        var data = new ExcalidrawData
        {
            Type = "excalidraw",
            Version = 2,
            Source = "https://github.com/excalidraw-avalonia",
            Elements = scene.NonDeletedElements.ToList(),
            AppState = appState
        };

        var options = new JsonSerializerOptions
        {
            WriteIndented = true,
            DefaultIgnoreCondition = JsonIgnoreCondition.WhenWritingNull
        };

        return JsonSerializer.Serialize(data, options);
    }

    /// <summary>
    /// Import from JSON
    /// </summary>
    public (List<ExcalidrawElement> elements, AppState? appState) ImportFromJson(string json)
    {
        var options = new JsonSerializerOptions
        {
            PropertyNameCaseInsensitive = true
        };

        var data = JsonSerializer.Deserialize<ExcalidrawData>(json, options);
        if (data == null)
            return (new List<ExcalidrawElement>(), null);

        return (data.Elements ?? new List<ExcalidrawElement>(), data.AppState);
    }

    private string ElementToSvg(ExcalidrawElement element)
    {
        var svg = new StringBuilder();
        var transform = element.Angle != 0
            ? $" transform=\"rotate({element.Angle * 180 / Math.PI} {element.X + element.Width / 2} {element.Y + element.Height / 2})\""
            : "";

        var fill = string.IsNullOrEmpty(element.BackgroundColor) || element.BackgroundColor == "transparent"
            ? "none"
            : element.BackgroundColor;

        var stroke = element.StrokeColor;
        var strokeWidth = element.StrokeWidth;
        var opacity = element.Opacity;

        switch (element)
        {
            case RectangleElement rect:
                svg.AppendLine($"<rect x=\"{rect.X}\" y=\"{rect.Y}\" width=\"{rect.Width}\" height=\"{rect.Height}\" " +
                    $"fill=\"{fill}\" stroke=\"{stroke}\" stroke-width=\"{strokeWidth}\" opacity=\"{opacity}\"{transform} />");
                break;

            case EllipseElement ellipse:
                var cx = ellipse.X + ellipse.Width / 2;
                var cy = ellipse.Y + ellipse.Height / 2;
                var rx = ellipse.Width / 2;
                var ry = ellipse.Height / 2;
                svg.AppendLine($"<ellipse cx=\"{cx}\" cy=\"{cy}\" rx=\"{rx}\" ry=\"{ry}\" " +
                    $"fill=\"{fill}\" stroke=\"{stroke}\" stroke-width=\"{strokeWidth}\" opacity=\"{opacity}\"{transform} />");
                break;

            case DiamondElement diamond:
                var centerX = diamond.X + diamond.Width / 2;
                var centerY = diamond.Y + diamond.Height / 2;
                var points = $"{centerX},{diamond.Y} {diamond.X + diamond.Width},{centerY} " +
                    $"{centerX},{diamond.Y + diamond.Height} {diamond.X},{centerY}";
                svg.AppendLine($"<polygon points=\"{points}\" " +
                    $"fill=\"{fill}\" stroke=\"{stroke}\" stroke-width=\"{strokeWidth}\" opacity=\"{opacity}\"{transform} />");
                break;

            case LineElement line:
            case ArrowElement arrow:
                if (element is LinearElement linear && linear.Points.Count >= 2)
                {
                    var pathData = new StringBuilder();
                    pathData.Append($"M {linear.X + linear.Points[0].X} {linear.Y + linear.Points[0].Y}");
                    for (int i = 1; i < linear.Points.Count; i++)
                    {
                        pathData.Append($" L {linear.X + linear.Points[i].X} {linear.Y + linear.Points[i].Y}");
                    }

                    svg.AppendLine($"<path d=\"{pathData}\" " +
                        $"fill=\"none\" stroke=\"{stroke}\" stroke-width=\"{strokeWidth}\" opacity=\"{opacity}\"{transform} />");

                    // Add arrowheads for arrows
                    if (element is ArrowElement arrowElem)
                    {
                        // Simplified arrowheads
                        if (arrowElem.EndArrowhead != Arrowhead.None)
                        {
                            svg.AppendLine($"<marker id=\"arrowhead\" markerWidth=\"10\" markerHeight=\"10\" refX=\"9\" refY=\"3\" orient=\"auto\">" +
                                $"<polygon points=\"0 0, 10 3, 0 6\" fill=\"{stroke}\" /></marker>");
                        }
                    }
                }
                break;

            case FreeDrawElement freedraw:
                if (freedraw.Points.Count >= 2)
                {
                    var pathData = new StringBuilder();
                    pathData.Append($"M {freedraw.X + freedraw.Points[0].X} {freedraw.Y + freedraw.Points[0].Y}");
                    for (int i = 1; i < freedraw.Points.Count; i++)
                    {
                        pathData.Append($" L {freedraw.X + freedraw.Points[i].X} {freedraw.Y + freedraw.Points[i].Y}");
                    }

                    svg.AppendLine($"<path d=\"{pathData}\" " +
                        $"fill=\"none\" stroke=\"{stroke}\" stroke-width=\"{strokeWidth}\" opacity=\"{opacity}\" " +
                        $"stroke-linecap=\"round\" stroke-linejoin=\"round\"{transform} />");
                }
                break;

            case TextElement text:
                svg.AppendLine($"<text x=\"{text.X}\" y=\"{text.Y + text.FontSize}\" " +
                    $"font-size=\"{text.FontSize}\" font-family=\"{text.FontFamily}\" " +
                    $"fill=\"{stroke}\" opacity=\"{opacity}\"{transform}>{text.Text}</text>");
                break;

            case FrameElement frame:
                svg.AppendLine($"<rect x=\"{frame.X}\" y=\"{frame.Y}\" width=\"{frame.Width}\" height=\"{frame.Height}\" " +
                    $"fill=\"none\" stroke=\"{stroke}\" stroke-width=\"2\" stroke-dasharray=\"5,5\" opacity=\"{opacity}\"{transform} />");
                break;
        }

        return svg.ToString();
    }
}

/// <summary>
/// Excalidraw data format
/// </summary>
public class ExcalidrawData
{
    [JsonPropertyName("type")]
    public string Type { get; set; } = "excalidraw";

    [JsonPropertyName("version")]
    public int Version { get; set; }

    [JsonPropertyName("source")]
    public string Source { get; set; } = "";

    [JsonPropertyName("elements")]
    public List<ExcalidrawElement>? Elements { get; set; }

    [JsonPropertyName("appState")]
    public AppState? AppState { get; set; }
}
