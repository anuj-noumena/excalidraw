import 'dart:math' as math;
import 'package:flutter/material.dart';

class MathUtils {
  // Point operations
  static Offset rotatePoint(Offset point, Offset center, double angle) {
    final cos = math.cos(angle);
    final sin = math.sin(angle);
    final dx = point.dx - center.dx;
    final dy = point.dy - center.dy;

    return Offset(
      center.dx + dx * cos - dy * sin,
      center.dy + dx * sin + dy * cos,
    );
  }

  static double distance(Offset a, Offset b) {
    final dx = b.dx - a.dx;
    final dy = b.dy - a.dy;
    return math.sqrt(dx * dx + dy * dy);
  }

  static Offset midpoint(Offset a, Offset b) {
    return Offset((a.dx + b.dx) / 2, (a.dy + b.dy) / 2);
  }

  // Vector operations
  static double dotProduct(Offset a, Offset b) {
    return a.dx * b.dx + a.dy * b.dy;
  }

  static double crossProduct(Offset a, Offset b) {
    return a.dx * b.dy - a.dy * b.dx;
  }

  static Offset normalize(Offset vector) {
    final length = math.sqrt(vector.dx * vector.dx + vector.dy * vector.dy);
    if (length == 0) return Offset.zero;
    return Offset(vector.dx / length, vector.dy / length);
  }

  static double vectorLength(Offset vector) {
    return math.sqrt(vector.dx * vector.dx + vector.dy * vector.dy);
  }

  // Angle operations
  static double normalizeAngle(double angle) {
    while (angle < 0) {
      angle += 2 * math.pi;
    }
    while (angle >= 2 * math.pi) {
      angle -= 2 * math.pi;
    }
    return angle;
  }

  static double angleBetweenPoints(Offset a, Offset b) {
    return math.atan2(b.dy - a.dy, b.dx - a.dx);
  }

  // Line operations
  static Offset? lineIntersection(
    Offset a1,
    Offset a2,
    Offset b1,
    Offset b2,
  ) {
    final d = (a1.dx - a2.dx) * (b1.dy - b2.dy) -
        (a1.dy - a2.dy) * (b1.dx - b2.dx);

    if (d.abs() < 0.0001) return null; // Lines are parallel

    final t = ((a1.dx - b1.dx) * (b1.dy - b2.dy) -
            (a1.dy - b1.dy) * (b1.dx - b2.dx)) /
        d;
    final u = -((a1.dx - a2.dx) * (a1.dy - b1.dy) -
            (a1.dy - a2.dy) * (a1.dx - b1.dx)) /
        d;

    if (t >= 0 && t <= 1 && u >= 0 && u <= 1) {
      return Offset(
        a1.dx + t * (a2.dx - a1.dx),
        a1.dy + t * (a2.dy - a1.dy),
      );
    }

    return null;
  }

  static double distanceToLine(Offset point, Offset lineStart, Offset lineEnd) {
    final dx = lineEnd.dx - lineStart.dx;
    final dy = lineEnd.dy - lineStart.dy;
    final lengthSquared = dx * dx + dy * dy;

    if (lengthSquared == 0) {
      return distance(point, lineStart);
    }

    var t = ((point.dx - lineStart.dx) * dx + (point.dy - lineStart.dy) * dy) /
        lengthSquared;
    t = math.max(0, math.min(1, t));

    final projection = Offset(
      lineStart.dx + t * dx,
      lineStart.dy + t * dy,
    );

    return distance(point, projection);
  }

  // Rectangle operations
  static Rect getBoundingRect(List<Offset> points) {
    if (points.isEmpty) return Rect.zero;

    double minX = points.first.dx;
    double minY = points.first.dy;
    double maxX = points.first.dx;
    double maxY = points.first.dy;

    for (final point in points) {
      minX = math.min(minX, point.dx);
      minY = math.min(minY, point.dy);
      maxX = math.max(maxX, point.dx);
      maxY = math.max(maxY, point.dy);
    }

    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }

  static Rect rotateRect(Rect rect, double angle) {
    final center = rect.center;
    final corners = [
      rect.topLeft,
      rect.topRight,
      rect.bottomRight,
      rect.bottomLeft,
    ];

    final rotatedCorners = corners
        .map((corner) => rotatePoint(corner, center, angle))
        .toList();

    return getBoundingRect(rotatedCorners);
  }

  // Polygon operations
  static bool pointInPolygon(Offset point, List<Offset> polygon) {
    bool inside = false;
    for (int i = 0, j = polygon.length - 1; i < polygon.length; j = i++) {
      final xi = polygon[i].dx;
      final yi = polygon[i].dy;
      final xj = polygon[j].dx;
      final yj = polygon[j].dy;

      final intersect = ((yi > point.dy) != (yj > point.dy)) &&
          (point.dx < (xj - xi) * (point.dy - yi) / (yj - yi) + xi);

      if (intersect) inside = !inside;
    }
    return inside;
  }

  // Ellipse operations
  static bool pointInEllipse(
    Offset point,
    Offset center,
    double radiusX,
    double radiusY,
    double angle,
  ) {
    final rotated = rotatePoint(point, center, -angle);
    final dx = (rotated.dx - center.dx) / radiusX;
    final dy = (rotated.dy - center.dy) / radiusY;
    return dx * dx + dy * dy <= 1;
  }

  // Grid snapping
  static Offset snapToGrid(Offset point, double gridSize) {
    return Offset(
      (point.dx / gridSize).round() * gridSize,
      (point.dy / gridSize).round() * gridSize,
    );
  }

  static double snapToAngle(double angle, double snapAngle) {
    return (angle / snapAngle).round() * snapAngle;
  }

  // Random with seed
  static math.Random createSeededRandom(int seed) {
    return math.Random(seed);
  }

  // Bezier curve operations
  static Offset cubicBezierPoint(
    double t,
    Offset p0,
    Offset p1,
    Offset p2,
    Offset p3,
  ) {
    final t1 = 1 - t;
    final t1Sq = t1 * t1;
    final t1Cube = t1Sq * t1;
    final tSq = t * t;
    final tCube = tSq * t;

    return Offset(
      t1Cube * p0.dx +
          3 * t1Sq * t * p1.dx +
          3 * t1 * tSq * p2.dx +
          tCube * p3.dx,
      t1Cube * p0.dy +
          3 * t1Sq * t * p1.dy +
          3 * t1 * tSq * p2.dy +
          tCube * p3.dy,
    );
  }

  static Offset quadraticBezierPoint(
    double t,
    Offset p0,
    Offset p1,
    Offset p2,
  ) {
    final t1 = 1 - t;
    return Offset(
      t1 * t1 * p0.dx + 2 * t1 * t * p1.dx + t * t * p2.dx,
      t1 * t1 * p0.dy + 2 * t1 * t * p1.dy + t * t * p2.dy,
    );
  }

  // Convert between coordinate systems
  static Offset sceneToViewport(
    Offset scenePoint,
    Offset scrollOffset,
    double zoom,
  ) {
    return Offset(
      (scenePoint.dx - scrollOffset.dx) * zoom,
      (scenePoint.dy - scrollOffset.dy) * zoom,
    );
  }

  static Offset viewportToScene(
    Offset viewportPoint,
    Offset scrollOffset,
    double zoom,
  ) {
    return Offset(
      viewportPoint.dx / zoom + scrollOffset.dx,
      viewportPoint.dy / zoom + scrollOffset.dy,
    );
  }

  // Clamp value between min and max
  static double clamp(double value, double min, double max) {
    return math.max(min, math.min(max, value));
  }

  // Linear interpolation
  static double lerp(double a, double b, double t) {
    return a + (b - a) * t;
  }

  static Offset lerpOffset(Offset a, Offset b, double t) {
    return Offset(lerp(a.dx, b.dx, t), lerp(a.dy, b.dy, t));
  }
}
