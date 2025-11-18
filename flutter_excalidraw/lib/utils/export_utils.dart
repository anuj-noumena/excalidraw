import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../models/element_base.dart';
import '../rendering/element_painter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ExportUtils {
  // Export to PNG
  static Future<Uint8List?> exportToPNG(
    List<ExcalidrawElement> elements, {
    double zoom = 1.0,
    Color backgroundColor = Colors.white,
  }) async {
    if (elements.isEmpty) return null;

    // Calculate bounding box of all elements
    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;

    for (final element in elements) {
      if (element.isDeleted) continue;
      minX = minX < element.x ? minX : element.x;
      minY = minY < element.y ? minY : element.y;
      maxX = maxX > element.x2 ? maxX : element.x2;
      maxY = maxY > element.y2 ? maxY : element.y2;
    }

    final padding = 20.0;
    final width = ((maxX - minX) + padding * 2) * zoom;
    final height = ((maxY - minY) + padding * 2) * zoom;

    // Create a picture recorder
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Draw background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, width, height),
      Paint()..color = backgroundColor,
    );

    // Apply transformations
    canvas.save();
    canvas.scale(zoom);
    canvas.translate(-minX + padding, -minY + padding);

    // Draw all elements
    final painter = ElementPainter(canvas, zoom);
    for (final element in elements) {
      if (!element.isDeleted) {
        painter.paintElement(element);
      }
    }

    canvas.restore();

    // Convert to image
    final picture = recorder.endRecording();
    final image = await picture.toImage(width.toInt(), height.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    return byteData?.buffer.asUint8List();
  }

  // Save PNG to file
  static Future<String?> savePNGToFile(
    List<ExcalidrawElement> elements,
    String fileName, {
    double zoom = 1.0,
    Color backgroundColor = Colors.white,
  }) async {
    try {
      final pngData = await exportToPNG(
        elements,
        zoom: zoom,
        backgroundColor: backgroundColor,
      );

      if (pngData == null) return null;

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName.png');
      await file.writeAsBytes(pngData);

      return file.path;
    } catch (e) {
      print('Error saving PNG: $e');
      return null;
    }
  }

  // Export to SVG
  static String exportToSVG(
    List<ExcalidrawElement> elements, {
    Color backgroundColor = Colors.white,
  }) {
    if (elements.isEmpty) return '';

    // Calculate bounding box
    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;

    for (final element in elements) {
      if (element.isDeleted) continue;
      minX = minX < element.x ? minX : element.x;
      minY = minY < element.y ? minY : element.y;
      maxX = maxX > element.x2 ? maxX : element.x2;
      maxY = maxY > element.y2 ? maxY : element.y2;
    }

    final padding = 20.0;
    final width = maxX - minX + padding * 2;
    final height = maxY - minY + padding * 2;

    final buffer = StringBuffer();

    // SVG header
    buffer.writeln('<?xml version="1.0" encoding="UTF-8"?>');
    buffer.writeln('<svg xmlns="http://www.w3.org/2000/svg" '
        'viewBox="0 0 $width $height" '
        'width="$width" height="$height">');

    // Background
    buffer.writeln('  <rect x="0" y="0" width="$width" height="$height" '
        'fill="${_colorToHex(backgroundColor)}"/>');

    // Group with offset
    buffer.writeln('  <g transform="translate(${-minX + padding}, ${-minY + padding})">');

    // Render each element
    for (final element in elements) {
      if (!element.isDeleted) {
        buffer.writeln(_elementToSVG(element));
      }
    }

    buffer.writeln('  </g>');
    buffer.writeln('</svg>');

    return buffer.toString();
  }

  // Save SVG to file
  static Future<String?> saveSVGToFile(
    List<ExcalidrawElement> elements,
    String fileName, {
    Color backgroundColor = Colors.white,
  }) async {
    try {
      final svgData = exportToSVG(
        elements,
        backgroundColor: backgroundColor,
      );

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName.svg');
      await file.writeAsString(svgData);

      return file.path;
    } catch (e) {
      print('Error saving SVG: $e');
      return null;
    }
  }

  static String _elementToSVG(ExcalidrawElement element) {
    final buffer = StringBuffer();
    final strokeColor = _colorToHex(element.strokeColor);
    final fillColor = _colorToHex(element.backgroundColor);
    final opacity = element.opacity / 100;

    // Common attributes
    final commonAttrs = 'stroke="$strokeColor" '
        'stroke-width="${element.strokeWidth}" '
        'fill="${element.backgroundColor.opacity > 0 ? fillColor : 'none'}" '
        'opacity="$opacity"';

    final transform =
        element.angle != 0 ? ' transform="rotate(${element.angle * 180 / 3.14159} ${element.center.dx} ${element.center.dy})"' : '';

    switch (element.type) {
      case ElementType.rectangle:
        buffer.writeln('    <rect x="${element.x}" y="${element.y}" '
            'width="${element.width}" height="${element.height}" '
            '$commonAttrs$transform/>');
        break;

      case ElementType.ellipse:
        final cx = element.x + element.width / 2;
        final cy = element.y + element.height / 2;
        final rx = element.width / 2;
        final ry = element.height / 2;
        buffer.writeln('    <ellipse cx="$cx" cy="$cy" rx="$rx" ry="$ry" '
            '$commonAttrs$transform/>');
        break;

      case ElementType.diamond:
        final cx = element.x + element.width / 2;
        final cy = element.y + element.height / 2;
        final points =
            '${cx},${element.y} ${element.x2},${cy} ${cx},${element.y2} ${element.x},${cy}';
        buffer.writeln('    <polygon points="$points" '
            '$commonAttrs$transform/>');
        break;

      case ElementType.arrow:
      case ElementType.line:
        final el = element as dynamic;
        if (el.points != null && el.points.isNotEmpty) {
          final pathData = StringBuffer('M ${el.points[0].x} ${el.points[0].y}');
          for (int i = 1; i < el.points.length; i++) {
            pathData.write(' L ${el.points[i].x} ${el.points[i].y}');
          }
          buffer.writeln('    <path d="$pathData" '
              'fill="none" stroke="$strokeColor" '
              'stroke-width="${element.strokeWidth}" '
              'opacity="$opacity"$transform/>');
        }
        break;

      case ElementType.freedraw:
        final el = element as dynamic;
        if (el.points != null && el.points.isNotEmpty) {
          final pathData = StringBuffer('M ${el.points[0].x} ${el.points[0].y}');
          for (int i = 1; i < el.points.length; i++) {
            pathData.write(' L ${el.points[i].x} ${el.points[i].y}');
          }
          buffer.writeln('    <path d="$pathData" '
              'fill="none" stroke="$strokeColor" '
              'stroke-width="${element.strokeWidth}" '
              'opacity="$opacity"$transform/>');
        }
        break;

      case ElementType.text:
        final el = element as dynamic;
        buffer.writeln('    <text x="${element.x}" y="${element.y + el.fontSize}" '
            'font-size="${el.fontSize}" '
            'font-family="${el.fontFamily}" '
            'fill="$strokeColor" '
            'opacity="$opacity"$transform>${_escapeXML(el.text)}</text>');
        break;

      default:
        break;
    }

    return buffer.toString();
  }

  static String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  static String _escapeXML(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&apos;');
  }
}
