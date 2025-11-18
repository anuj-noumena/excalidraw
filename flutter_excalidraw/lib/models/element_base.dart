import 'package:flutter/material.dart';
import '../utils/fractional_index.dart';

enum ElementType {
  rectangle,
  diamond,
  ellipse,
  arrow,
  line,
  freedraw,
  text,
  image,
  selection,
  frame,
  magicframe,
  iframe,
  embeddable,
}

enum FillStyle {
  hachure,
  crossHatch,
  solid,
  zigzag,
}

enum StrokeStyle {
  solid,
  dashed,
  dotted,
}

enum RoundnessType {
  legacy,
  proportionalRadius,
  adaptiveRadius,
}

class Roundness {
  final RoundnessType type;
  final double? value;

  const Roundness({required this.type, this.value});

  factory Roundness.fromJson(Map<String, dynamic> json) {
    return Roundness(
      type: RoundnessType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => RoundnessType.legacy,
      ),
      value: json['value']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      if (value != null) 'value': value,
    };
  }
}

class BoundElement {
  final String id;
  final String type;

  const BoundElement({
    required this.id,
    required this.type,
  });

  factory BoundElement.fromJson(Map<String, dynamic> json) {
    return BoundElement(
      id: json['id'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
    };
  }
}

abstract class ExcalidrawElement {
  final String id;
  final double x;
  final double y;
  final double width;
  final double height;
  final double angle;
  final Color strokeColor;
  final Color backgroundColor;
  final FillStyle fillStyle;
  final double strokeWidth;
  final StrokeStyle strokeStyle;
  final Roundness? roundness;
  final double roughness;
  final int opacity;
  final int seed;
  final int version;
  final int versionNonce;
  final FractionalIndex index;
  final bool isDeleted;
  final List<String> groupIds;
  final String? frameId;
  final List<BoundElement>? boundElements;
  final int updated;
  final String? link;
  final bool locked;
  final Map<String, dynamic>? customData;

  const ExcalidrawElement({
    required this.id,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.angle,
    required this.strokeColor,
    required this.backgroundColor,
    required this.fillStyle,
    required this.strokeWidth,
    required this.strokeStyle,
    this.roundness,
    required this.roughness,
    required this.opacity,
    required this.seed,
    required this.version,
    required this.versionNonce,
    required this.index,
    this.isDeleted = false,
    this.groupIds = const [],
    this.frameId,
    this.boundElements,
    required this.updated,
    this.link,
    this.locked = false,
    this.customData,
  });

  ElementType get type;

  ExcalidrawElement copyWith({
    String? id,
    double? x,
    double? y,
    double? width,
    double? height,
    double? angle,
    Color? strokeColor,
    Color? backgroundColor,
    FillStyle? fillStyle,
    double? strokeWidth,
    StrokeStyle? strokeStyle,
    Roundness? roundness,
    double? roughness,
    int? opacity,
    int? seed,
    int? version,
    int? versionNonce,
    FractionalIndex? index,
    bool? isDeleted,
    List<String>? groupIds,
    String? frameId,
    List<BoundElement>? boundElements,
    int? updated,
    String? link,
    bool? locked,
    Map<String, dynamic>? customData,
  });

  Map<String, dynamic> toJson();

  // Bounding box helpers
  double get x1 => x;
  double get y1 => y;
  double get x2 => x + width;
  double get y2 => y + height;

  Offset get center => Offset(x + width / 2, y + height / 2);
}
