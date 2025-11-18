import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/element_base.dart';

class SnapGuide {
  final Offset start;
  final Offset end;
  final SnapType type;

  const SnapGuide({
    required this.start,
    required this.end,
    required this.type,
  });
}

enum SnapType {
  horizontal,
  vertical,
  center,
  edge,
}

class SnapResult {
  final Offset snappedPosition;
  final List<SnapGuide> guides;

  const SnapResult({
    required this.snappedPosition,
    required this.guides,
  });
}

class SnapToElementGuides {
  static const double snapThreshold = 8.0;

  // Find snap guides for an element being moved/resized
  static SnapResult findSnapGuides(
    ExcalidrawElement movingElement,
    List<ExcalidrawElement> allElements,
    Offset proposedPosition,
  ) {
    final guides = <SnapGuide>[];
    var snappedX = proposedPosition.dx;
    var snappedY = proposedPosition.dy;
    bool snappedHorizontally = false;
    bool snappedVertically = false;

    // Get key points of the moving element
    final movingCenter = Offset(
      proposedPosition.dx + movingElement.width / 2,
      proposedPosition.dy + movingElement.height / 2,
    );
    final movingLeft = proposedPosition.dx;
    final movingRight = proposedPosition.dx + movingElement.width;
    final movingTop = proposedPosition.dy;
    final movingBottom = proposedPosition.dy + movingElement.height;

    // Check against all other elements
    for (final element in allElements) {
      if (element.id == movingElement.id || element.isDeleted) continue;

      final targetCenter = element.center;
      final targetLeft = element.x;
      final targetRight = element.x2;
      final targetTop = element.y;
      final targetBottom = element.y2;

      // Vertical alignment checks
      if (!snappedVertically) {
        // Center to center
        if ((movingCenter.dx - targetCenter.dx).abs() < snapThreshold) {
          snappedX = targetCenter.dx - movingElement.width / 2;
          snappedVertically = true;
          guides.add(SnapGuide(
            start: Offset(targetCenter.dx, math.min(movingCenter.dy, targetCenter.dy)),
            end: Offset(targetCenter.dx, math.max(movingCenter.dy, targetCenter.dy)),
            type: SnapType.center,
          ));
        }
        // Left to left
        else if ((movingLeft - targetLeft).abs() < snapThreshold) {
          snappedX = targetLeft;
          snappedVertically = true;
          guides.add(SnapGuide(
            start: Offset(targetLeft, math.min(movingTop, targetTop)),
            end: Offset(targetLeft, math.max(movingBottom, targetBottom)),
            type: SnapType.edge,
          ));
        }
        // Right to right
        else if ((movingRight - targetRight).abs() < snapThreshold) {
          snappedX = targetRight - movingElement.width;
          snappedVertically = true;
          guides.add(SnapGuide(
            start: Offset(targetRight, math.min(movingTop, targetTop)),
            end: Offset(targetRight, math.max(movingBottom, targetBottom)),
            type: SnapType.edge,
          ));
        }
        // Left to right
        else if ((movingLeft - targetRight).abs() < snapThreshold) {
          snappedX = targetRight;
          snappedVertically = true;
          guides.add(SnapGuide(
            start: Offset(targetRight, math.min(movingTop, targetTop)),
            end: Offset(targetRight, math.max(movingBottom, targetBottom)),
            type: SnapType.edge,
          ));
        }
        // Right to left
        else if ((movingRight - targetLeft).abs() < snapThreshold) {
          snappedX = targetLeft - movingElement.width;
          snappedVertically = true;
          guides.add(SnapGuide(
            start: Offset(targetLeft, math.min(movingTop, targetTop)),
            end: Offset(targetLeft, math.max(movingBottom, targetBottom)),
            type: SnapType.edge,
          ));
        }
      }

      // Horizontal alignment checks
      if (!snappedHorizontally) {
        // Center to center
        if ((movingCenter.dy - targetCenter.dy).abs() < snapThreshold) {
          snappedY = targetCenter.dy - movingElement.height / 2;
          snappedHorizontally = true;
          guides.add(SnapGuide(
            start: Offset(math.min(movingCenter.dx, targetCenter.dx), targetCenter.dy),
            end: Offset(math.max(movingCenter.dx, targetCenter.dx), targetCenter.dy),
            type: SnapType.center,
          ));
        }
        // Top to top
        else if ((movingTop - targetTop).abs() < snapThreshold) {
          snappedY = targetTop;
          snappedHorizontally = true;
          guides.add(SnapGuide(
            start: Offset(math.min(movingLeft, targetLeft), targetTop),
            end: Offset(math.max(movingRight, targetRight), targetTop),
            type: SnapType.edge,
          ));
        }
        // Bottom to bottom
        else if ((movingBottom - targetBottom).abs() < snapThreshold) {
          snappedY = targetBottom - movingElement.height;
          snappedHorizontally = true;
          guides.add(SnapGuide(
            start: Offset(math.min(movingLeft, targetLeft), targetBottom),
            end: Offset(math.max(movingRight, targetRight), targetBottom),
            type: SnapType.edge,
          ));
        }
        // Top to bottom
        else if ((movingTop - targetBottom).abs() < snapThreshold) {
          snappedY = targetBottom;
          snappedHorizontally = true;
          guides.add(SnapGuide(
            start: Offset(math.min(movingLeft, targetLeft), targetBottom),
            end: Offset(math.max(movingRight, targetRight), targetBottom),
            type: SnapType.edge,
          ));
        }
        // Bottom to top
        else if ((movingBottom - targetTop).abs() < snapThreshold) {
          snappedY = targetTop - movingElement.height;
          snappedHorizontally = true;
          guides.add(SnapGuide(
            start: Offset(math.min(movingLeft, targetLeft), targetTop),
            end: Offset(math.max(movingRight, targetRight), targetTop),
            type: SnapType.edge,
          ));
        }
      }

      if (snappedHorizontally && snappedVertically) break;
    }

    return SnapResult(
      snappedPosition: Offset(snappedX, snappedY),
      guides: guides,
    );
  }

  // Draw snap guides on canvas
  static void drawGuides(Canvas canvas, List<SnapGuide> guides, double zoom) {
    final paint = Paint()
      ..color = Colors.purple.withOpacity(0.6)
      ..strokeWidth = 1.0 / zoom
      ..style = PaintingStyle.stroke;

    for (final guide in guides) {
      canvas.drawLine(guide.start, guide.end, paint);

      // Draw dots at ends for visibility
      final dotPaint = Paint()
        ..color = Colors.purple
        ..style = PaintingStyle.fill;

      canvas.drawCircle(guide.start, 2.0 / zoom, dotPaint);
      canvas.drawCircle(guide.end, 2.0 / zoom, dotPaint);
    }
  }
}
