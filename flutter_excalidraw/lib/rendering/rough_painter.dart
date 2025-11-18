import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/element_base.dart';
import '../models/elements.dart';

// Hand-drawn style renderer inspired by rough.js
class RoughPainter {
  final math.Random random;
  final double roughness;
  final int seed;

  RoughPainter({
    required this.roughness,
    required this.seed,
  }) : random = math.Random(seed);

  // Draw a hand-drawn rectangle
  Path drawRectangle(double x, double y, double width, double height,
      {Roundness? roundness}) {
    final path = Path();

    if (roundness != null && roundness.value != null && roundness.value! > 0) {
      // Rounded rectangle with roughness
      final radius = roundness.value!;
      path.moveTo(x + radius + _offset(), y + _offset());
      path.lineTo(x + width - radius + _offset(), y + _offset());
      path.quadraticBezierTo(
        x + width + _offset(),
        y + _offset(),
        x + width + _offset(),
        y + radius + _offset(),
      );
      path.lineTo(x + width + _offset(), y + height - radius + _offset());
      path.quadraticBezierTo(
        x + width + _offset(),
        y + height + _offset(),
        x + width - radius + _offset(),
        y + height + _offset(),
      );
      path.lineTo(x + radius + _offset(), y + height + _offset());
      path.quadraticBezierTo(
        x + _offset(),
        y + height + _offset(),
        x + _offset(),
        y + height - radius + _offset(),
      );
      path.lineTo(x + _offset(), y + radius + _offset());
      path.quadraticBezierTo(
        x + _offset(),
        y + _offset(),
        x + radius + _offset(),
        y + _offset(),
      );
    } else {
      // Regular rectangle with roughness
      path.moveTo(x + _offset(), y + _offset());
      path.lineTo(x + width + _offset(), y + _offset());
      path.lineTo(x + width + _offset(), y + height + _offset());
      path.lineTo(x + _offset(), y + height + _offset());
      path.close();
    }

    return path;
  }

  // Draw a hand-drawn diamond
  Path drawDiamond(double x, double y, double width, double height) {
    final path = Path();
    final cx = x + width / 2;
    final cy = y + height / 2;

    path.moveTo(cx + _offset(), y + _offset());
    path.lineTo(x + width + _offset(), cy + _offset());
    path.lineTo(cx + _offset(), y + height + _offset());
    path.lineTo(x + _offset(), cy + _offset());
    path.close();

    return path;
  }

  // Draw a hand-drawn ellipse
  Path drawEllipse(double x, double y, double width, double height) {
    final path = Path();
    final cx = x + width / 2;
    final cy = y + height / 2;
    final rx = width / 2;
    final ry = height / 2;

    // Approximate ellipse with bezier curves
    const kappa = 0.5522848;
    final ox = rx * kappa;
    final oy = ry * kappa;

    path.moveTo(cx - rx + _offset(), cy + _offset());
    path.cubicTo(
      cx - rx + _offset(),
      cy - oy + _offset(),
      cx - ox + _offset(),
      cy - ry + _offset(),
      cx + _offset(),
      cy - ry + _offset(),
    );
    path.cubicTo(
      cx + ox + _offset(),
      cy - ry + _offset(),
      cx + rx + _offset(),
      cy - oy + _offset(),
      cx + rx + _offset(),
      cy + _offset(),
    );
    path.cubicTo(
      cx + rx + _offset(),
      cy + oy + _offset(),
      cx + ox + _offset(),
      cy + ry + _offset(),
      cx + _offset(),
      cy + ry + _offset(),
    );
    path.cubicTo(
      cx - ox + _offset(),
      cy + ry + _offset(),
      cx - rx + _offset(),
      cy + oy + _offset(),
      cx - rx + _offset(),
      cy + _offset(),
    );

    return path;
  }

  // Draw a hand-drawn line through points
  Path drawLine(List<ElementPoint> points) {
    if (points.isEmpty) return Path();

    final path = Path();
    path.moveTo(points.first.x + _offset(), points.first.y + _offset());

    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].x + _offset(), points[i].y + _offset());
    }

    return path;
  }

  // Draw arrow head
  Path drawArrowHead(Offset tip, Offset base, double size) {
    final path = Path();
    final angle = math.atan2(tip.dy - base.dy, tip.dx - base.dx);

    final point1 = Offset(
      tip.dx - size * math.cos(angle - math.pi / 6),
      tip.dy - size * math.sin(angle - math.pi / 6),
    );

    final point2 = Offset(
      tip.dx - size * math.cos(angle + math.pi / 6),
      tip.dy - size * math.sin(angle + math.pi / 6),
    );

    path.moveTo(point1.dx + _offset(), point1.dy + _offset());
    path.lineTo(tip.dx + _offset(), tip.dy + _offset());
    path.lineTo(point2.dx + _offset(), point2.dy + _offset());

    return path;
  }

  // Get fill pattern based on fill style
  Path? getFillPattern(
    double x,
    double y,
    double width,
    double height,
    FillStyle fillStyle,
  ) {
    switch (fillStyle) {
      case FillStyle.solid:
        return null; // Use solid fill paint

      case FillStyle.hachure:
        return _createHachurePattern(x, y, width, height, math.pi / 4);

      case FillStyle.crossHatch:
        final path1 = _createHachurePattern(x, y, width, height, math.pi / 4);
        final path2 =
            _createHachurePattern(x, y, width, height, -math.pi / 4);
        return Path.combine(PathOperation.union, path1, path2);

      case FillStyle.zigzag:
        return _createZigzagPattern(x, y, width, height);
    }
  }

  Path _createHachurePattern(
    double x,
    double y,
    double width,
    double height,
    double angle,
  ) {
    final path = Path();
    final gap = 4.0 + roughness * 2;

    final diagonal = math.sqrt(width * width + height * height);
    final count = (diagonal / gap).ceil();

    for (int i = 0; i < count; i++) {
      final offset = i * gap;
      final startX = x + offset * math.cos(angle);
      final startY = y + offset * math.sin(angle);
      final endX = startX + width * math.cos(angle + math.pi / 2);
      final endY = startY + width * math.sin(angle + math.pi / 2);

      path.moveTo(startX + _offset(), startY + _offset());
      path.lineTo(endX + _offset(), endY + _offset());
    }

    return path;
  }

  Path _createZigzagPattern(
    double x,
    double y,
    double width,
    double height,
  ) {
    final path = Path();
    final gap = 8.0 + roughness * 2;
    final zigzagHeight = 4.0;

    for (double dy = 0; dy < height; dy += gap) {
      bool up = true;
      for (double dx = 0; dx < width; dx += gap / 2) {
        final py = y + dy + (up ? 0 : zigzagHeight);
        if (dx == 0) {
          path.moveTo(x + dx + _offset(), py + _offset());
        } else {
          path.lineTo(x + dx + _offset(), py + _offset());
        }
        up = !up;
      }
    }

    return path;
  }

  // Generate random offset based on roughness
  double _offset() {
    if (roughness == 0) return 0;
    return (random.nextDouble() - 0.5) * roughness;
  }

  // Create stroke style
  List<double>? getStrokeDash(StrokeStyle strokeStyle, double strokeWidth) {
    switch (strokeStyle) {
      case StrokeStyle.solid:
        return null;
      case StrokeStyle.dashed:
        return [strokeWidth * 4, strokeWidth * 2];
      case StrokeStyle.dotted:
        return [strokeWidth, strokeWidth * 1.5];
    }
  }
}
