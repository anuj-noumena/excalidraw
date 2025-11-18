import 'package:flutter/material.dart';
import '../models/element_base.dart';
import 'math_utils.dart';

class LassoSelection {
  final List<Offset> lassoPoints;

  LassoSelection(this.lassoPoints);

  // Check if an element is inside the lasso selection
  bool containsElement(ExcalidrawElement element) {
    // Get the element's corner points
    final corners = [
      Offset(element.x, element.y),
      Offset(element.x2, element.y),
      Offset(element.x2, element.y2),
      Offset(element.x, element.y2),
    ];

    // If element is rotated, rotate the corners
    if (element.angle != 0) {
      final center = element.center;
      for (int i = 0; i < corners.length; i++) {
        corners[i] = MathUtils.rotatePoint(corners[i], center, element.angle);
      }
    }

    // Check if all corners are inside the lasso
    return corners.every((corner) => _pointInLasso(corner));
  }

  // Check if element partially intersects with lasso
  bool intersectsElement(ExcalidrawElement element) {
    // Get the element's corner points
    final corners = [
      Offset(element.x, element.y),
      Offset(element.x2, element.y),
      Offset(element.x2, element.y2),
      Offset(element.x, element.y2),
    ];

    // If element is rotated, rotate the corners
    if (element.angle != 0) {
      final center = element.center;
      for (int i = 0; i < corners.length; i++) {
        corners[i] = MathUtils.rotatePoint(corners[i], center, element.angle);
      }
    }

    // Check if any corner is inside the lasso
    return corners.any((corner) => _pointInLasso(corner));
  }

  // Point-in-polygon test using ray casting algorithm
  bool _pointInLasso(Offset point) {
    if (lassoPoints.length < 3) return false;

    return MathUtils.pointInPolygon(point, lassoPoints);
  }

  // Get the path for drawing the lasso
  Path getLassoPath() {
    if (lassoPoints.isEmpty) return Path();

    final path = Path();
    path.moveTo(lassoPoints.first.dx, lassoPoints.first.dy);

    for (int i = 1; i < lassoPoints.length; i++) {
      path.lineTo(lassoPoints[i].dx, lassoPoints[i].dy);
    }

    path.close();
    return path;
  }

  // Simplify the lasso path by removing redundant points
  static List<Offset> simplifyPath(List<Offset> points, double tolerance) {
    if (points.length < 3) return points;

    final simplified = <Offset>[points.first];

    for (int i = 1; i < points.length - 1; i++) {
      final prev = simplified.last;
      final current = points[i];
      final next = points[i + 1];

      // Calculate perpendicular distance from current point to line prev-next
      final distance = MathUtils.distanceToLine(current, prev, next);

      if (distance > tolerance) {
        simplified.add(current);
      }
    }

    simplified.add(points.last);
    return simplified;
  }

  // Check if lasso is valid (has enough points and forms a closed shape)
  bool isValid() {
    return lassoPoints.length >= 3;
  }
}

class LassoSelectionPainter extends CustomPainter {
  final List<Offset> lassoPoints;
  final double zoom;

  LassoSelectionPainter(this.lassoPoints, this.zoom);

  @override
  void paint(Canvas canvas, Size size) {
    if (lassoPoints.length < 2) return;

    // Draw the lasso path
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0 / zoom
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    path.moveTo(lassoPoints.first.dx, lassoPoints.first.dy);

    for (int i = 1; i < lassoPoints.length; i++) {
      path.lineTo(lassoPoints[i].dx, lassoPoints[i].dy);
    }

    if (lassoPoints.length > 2) {
      path.close();
      canvas.drawPath(path, paint);
    }

    canvas.drawPath(path, strokePaint);

    // Draw points
    final pointPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    for (final point in lassoPoints) {
      canvas.drawCircle(point, 3.0 / zoom, pointPaint);
    }
  }

  @override
  bool shouldRepaint(LassoSelectionPainter oldDelegate) {
    return lassoPoints != oldDelegate.lassoPoints;
  }
}
