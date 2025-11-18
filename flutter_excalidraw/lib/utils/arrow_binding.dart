import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/element_base.dart';
import '../models/elements.dart';
import 'math_utils.dart';

class ArrowBindingInfo {
  final String elementId;
  final String side; // 'top', 'right', 'bottom', 'left'
  final double gap;
  final Offset focus;

  const ArrowBindingInfo({
    required this.elementId,
    required this.side,
    this.gap = 10.0,
    this.focus = Offset.zero,
  });

  Map<String, dynamic> toJson() {
    return {
      'elementId': elementId,
      'side': side,
      'gap': gap,
      'focus': {'x': focus.dx, 'y': focus.dy},
    };
  }

  factory ArrowBindingInfo.fromJson(Map<String, dynamic> json) {
    return ArrowBindingInfo(
      elementId: json['elementId'],
      side: json['side'],
      gap: (json['gap'] as num?)?.toDouble() ?? 10.0,
      focus: json['focus'] != null
          ? Offset(
              (json['focus']['x'] as num).toDouble(),
              (json['focus']['y'] as num).toDouble(),
            )
          : Offset.zero,
    );
  }
}

class ArrowBinding {
  // Find the best binding point for an arrow endpoint
  static ArrowBindingInfo? findBestBinding(
    Offset point,
    List<ExcalidrawElement> elements,
    {double threshold = 20.0}
  ) {
    ExcalidrawElement? closestElement;
    double closestDistance = threshold;
    String? closestSide;

    for (final element in elements) {
      if (element.isDeleted || element.type == ElementType.arrow || element.type == ElementType.line) {
        continue;
      }

      // Check distance to each side
      final sides = _getElementSides(element);
      for (final entry in sides.entries) {
        final distance = MathUtils.distanceToLine(
          point,
          entry.value.$1,
          entry.value.$2,
        );

        if (distance < closestDistance) {
          closestDistance = distance;
          closestElement = element;
          closestSide = entry.key;
        }
      }
    }

    if (closestElement != null && closestSide != null) {
      final bindingPoint = _getBindingPoint(closestElement, closestSide, point);
      final focus = Offset(
        (point.dx - bindingPoint.dx) / closestElement.width,
        (point.dy - bindingPoint.dy) / closestElement.height,
      );

      return ArrowBindingInfo(
        elementId: closestElement.id,
        side: closestSide,
        focus: focus,
      );
    }

    return null;
  }

  // Get the actual binding point on an element
  static Offset getBindingPoint(
    ExcalidrawElement element,
    ArrowBindingInfo binding,
  ) {
    return _getBindingPoint(element, binding.side, element.center);
  }

  static Offset _getBindingPoint(
    ExcalidrawElement element,
    String side,
    Offset referencePoint,
  ) {
    final center = element.center;
    final halfWidth = element.width / 2;
    final halfHeight = element.height / 2;

    switch (side) {
      case 'top':
        return Offset(center.dx, element.y);
      case 'right':
        return Offset(element.x2, center.dy);
      case 'bottom':
        return Offset(center.dx, element.y2);
      case 'left':
        return Offset(element.x, center.dy);
      default:
        return center;
    }
  }

  static Map<String, (Offset, Offset)> _getElementSides(ExcalidrawElement element) {
    return {
      'top': (Offset(element.x, element.y), Offset(element.x2, element.y)),
      'right': (Offset(element.x2, element.y), Offset(element.x2, element.y2)),
      'bottom': (Offset(element.x2, element.y2), Offset(element.x, element.y2)),
      'left': (Offset(element.x, element.y2), Offset(element.x, element.y)),
    };
  }

  // Update arrow points when bound element moves
  static List<ElementPoint> updateBoundArrowPoints(
    ArrowElement arrow,
    List<ExcalidrawElement> elements,
  ) {
    final points = List<ElementPoint>.from(arrow.points);

    // Update start point if bound
    if (arrow.startBinding != null) {
      final binding = ArrowBindingInfo.fromJson({'elementId': arrow.startBinding!, 'side': 'top'});
      final element = elements.firstWhere((e) => e.id == binding.elementId);
      final bindingPoint = getBindingPoint(element, binding);
      points[0] = ElementPoint(bindingPoint.dx, bindingPoint.dy);
    }

    // Update end point if bound
    if (arrow.endBinding != null) {
      final binding = ArrowBindingInfo.fromJson({'elementId': arrow.endBinding!, 'side': 'top'});
      final element = elements.firstWhere((e) => e.id == binding.elementId);
      final bindingPoint = getBindingPoint(element, binding);
      points[points.length - 1] = ElementPoint(bindingPoint.dx, bindingPoint.dy);
    }

    return points;
  }

  // Check if a point is near an element for binding
  static bool isNearElement(
    Offset point,
    ExcalidrawElement element,
    {double threshold = 20.0}
  ) {
    final sides = _getElementSides(element);
    for (final entry in sides.values) {
      final distance = MathUtils.distanceToLine(point, entry.$1, entry.$2);
      if (distance < threshold) {
        return true;
      }
    }
    return false;
  }
}
