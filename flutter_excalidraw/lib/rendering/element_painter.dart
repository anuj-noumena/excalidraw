import 'package:flutter/material.dart';
import '../models/element_base.dart';
import '../models/elements.dart';
import '../utils/math_utils.dart';
import 'rough_painter.dart';

// Renders individual elements to canvas
class ElementPainter {
  final Canvas canvas;
  final double zoom;

  ElementPainter(this.canvas, this.zoom);

  void paintElement(ExcalidrawElement element) {
    if (element.isDeleted) return;

    // Save canvas state
    canvas.save();

    // Apply element transformations
    if (element.angle != 0) {
      final center = element.center;
      canvas.translate(center.dx, center.dy);
      canvas.rotate(element.angle);
      canvas.translate(-center.dx, -center.dy);
    }

    // Apply opacity
    final paint = Paint()
      ..color = element.strokeColor.withOpacity(element.opacity / 100)
      ..strokeWidth = element.strokeWidth
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = element.backgroundColor.withOpacity(element.opacity / 100)
      ..style = PaintingStyle.fill;

    // Set stroke dash if needed
    final roughPainter = RoughPainter(
      roughness: element.roughness,
      seed: element.seed,
    );

    final dashArray = roughPainter.getStrokeDash(
      element.strokeStyle,
      element.strokeWidth,
    );

    if (dashArray != null) {
      paint.shader = null; // Dashed lines don't support shaders in basic impl
    }

    // Render based on element type
    switch (element.type) {
      case ElementType.rectangle:
        _paintRectangle(element as RectangleElement, paint, fillPaint,
            roughPainter, dashArray);
        break;
      case ElementType.diamond:
        _paintDiamond(
            element as DiamondElement, paint, fillPaint, roughPainter);
        break;
      case ElementType.ellipse:
        _paintEllipse(
            element as EllipseElement, paint, fillPaint, roughPainter);
        break;
      case ElementType.arrow:
        _paintArrow(element as ArrowElement, paint, roughPainter);
        break;
      case ElementType.line:
        _paintLine(element as LineElement, paint, roughPainter);
        break;
      case ElementType.freedraw:
        _paintFreedraw(element as FreedrawElement, paint);
        break;
      case ElementType.text:
        _paintText(element as TextElement, paint);
        break;
      default:
        break;
    }

    // Restore canvas state
    canvas.restore();
  }

  void _paintRectangle(
    RectangleElement element,
    Paint paint,
    Paint fillPaint,
    RoughPainter roughPainter,
    List<double>? dashArray,
  ) {
    final path = roughPainter.drawRectangle(
      element.x,
      element.y,
      element.width,
      element.height,
      roundness: element.roundness,
    );

    // Draw fill
    if (element.fillStyle == FillStyle.solid &&
        element.backgroundColor.opacity > 0) {
      canvas.drawPath(path, fillPaint);
    } else if (element.fillStyle != FillStyle.solid) {
      final fillPattern = roughPainter.getFillPattern(
        element.x,
        element.y,
        element.width,
        element.height,
        element.fillStyle,
      );
      if (fillPattern != null) {
        final fillStrokePaint = Paint()
          ..color = element.backgroundColor.withOpacity(element.opacity / 100)
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke;
        canvas.drawPath(fillPattern, fillStrokePaint);
      }
    }

    // Draw stroke
    if (dashArray != null) {
      _drawDashedPath(path, paint, dashArray);
    } else {
      canvas.drawPath(path, paint);
    }
  }

  void _paintDiamond(
    DiamondElement element,
    Paint paint,
    Paint fillPaint,
    RoughPainter roughPainter,
  ) {
    final path = roughPainter.drawDiamond(
      element.x,
      element.y,
      element.width,
      element.height,
    );

    // Draw fill
    if (element.fillStyle == FillStyle.solid &&
        element.backgroundColor.opacity > 0) {
      canvas.drawPath(path, fillPaint);
    } else if (element.fillStyle != FillStyle.solid) {
      final fillPattern = roughPainter.getFillPattern(
        element.x,
        element.y,
        element.width,
        element.height,
        element.fillStyle,
      );
      if (fillPattern != null) {
        final fillStrokePaint = Paint()
          ..color = element.backgroundColor.withOpacity(element.opacity / 100)
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke;
        canvas.drawPath(fillPattern, fillStrokePaint);
      }
    }

    // Draw stroke
    canvas.drawPath(path, paint);
  }

  void _paintEllipse(
    EllipseElement element,
    Paint paint,
    Paint fillPaint,
    RoughPainter roughPainter,
  ) {
    final path = roughPainter.drawEllipse(
      element.x,
      element.y,
      element.width,
      element.height,
    );

    // Draw fill
    if (element.fillStyle == FillStyle.solid &&
        element.backgroundColor.opacity > 0) {
      canvas.drawPath(path, fillPaint);
    } else if (element.fillStyle != FillStyle.solid) {
      final fillPattern = roughPainter.getFillPattern(
        element.x,
        element.y,
        element.width,
        element.height,
        element.fillStyle,
      );
      if (fillPattern != null) {
        final fillStrokePaint = Paint()
          ..color = element.backgroundColor.withOpacity(element.opacity / 100)
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke;
        canvas.drawPath(fillPattern, fillStrokePaint);
      }
    }

    // Draw stroke
    canvas.drawPath(path, paint);
  }

  void _paintArrow(
    ArrowElement element,
    Paint paint,
    RoughPainter roughPainter,
  ) {
    final path = roughPainter.drawLine(element.points);
    canvas.drawPath(path, paint);

    // Draw arrowheads
    if (element.points.length >= 2) {
      final arrowSize = element.strokeWidth * 3;

      if (element.startArrowhead != null) {
        final start = Offset(element.points.first.x, element.points.first.y);
        final next = Offset(element.points[1].x, element.points[1].y);
        final arrowHead = roughPainter.drawArrowHead(start, next, arrowSize);
        canvas.drawPath(arrowHead, paint);
      }

      if (element.endArrowhead != null) {
        final end = Offset(element.points.last.x, element.points.last.y);
        final prev = Offset(
          element.points[element.points.length - 2].x,
          element.points[element.points.length - 2].y,
        );
        final arrowHead = roughPainter.drawArrowHead(end, prev, arrowSize);
        canvas.drawPath(arrowHead, paint);
      }
    }
  }

  void _paintLine(
    LineElement element,
    Paint paint,
    RoughPainter roughPainter,
  ) {
    final path = roughPainter.drawLine(element.points);
    canvas.drawPath(path, paint);
  }

  void _paintFreedraw(FreedrawElement element, Paint paint) {
    if (element.points.isEmpty) return;

    final path = Path();
    path.moveTo(element.points.first.x, element.points.first.y);

    for (int i = 1; i < element.points.length; i++) {
      path.lineTo(element.points[i].x, element.points[i].y);
    }

    // Apply pressure if available
    if (element.pressures != null && element.pressures!.isNotEmpty) {
      // Simulate variable stroke width based on pressure
      paint.strokeWidth = element.strokeWidth *
          (element.pressures!.first.clamp(0.5, 1.5));
    }

    canvas.drawPath(path, paint);
  }

  void _paintText(TextElement element, Paint paint) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: element.text,
        style: TextStyle(
          color: element.strokeColor.withOpacity(element.opacity / 100),
          fontSize: element.fontSize,
          fontFamily: element.fontFamily,
          height: element.lineHeight,
        ),
      ),
      textAlign: _getTextAlign(element.textAlign),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: element.autoResize ? double.infinity : element.width,
    );

    double dx = element.x;
    double dy = element.y;

    // Apply vertical alignment
    if (element.verticalAlign == 'middle') {
      dy += (element.height - textPainter.height) / 2;
    } else if (element.verticalAlign == 'bottom') {
      dy += element.height - textPainter.height;
    }

    textPainter.paint(canvas, Offset(dx, dy));
  }

  TextAlign _getTextAlign(String align) {
    switch (align) {
      case 'left':
        return TextAlign.left;
      case 'center':
        return TextAlign.center;
      case 'right':
        return TextAlign.right;
      default:
        return TextAlign.left;
    }
  }

  void _drawDashedPath(Path path, Paint paint, List<double> dashArray) {
    // Simple dashed path implementation
    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double distance = 0;
      bool draw = true;
      int dashIndex = 0;

      while (distance < metric.length) {
        final length = dashArray[dashIndex % dashArray.length];
        if (draw) {
          final extractPath = metric.extractPath(
            distance,
            distance + length,
          );
          canvas.drawPath(extractPath, paint);
        }
        distance += length;
        draw = !draw;
        dashIndex++;
      }
    }
  }
}
