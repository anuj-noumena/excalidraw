import 'package:flutter/material.dart';
import 'element_base.dart';
import '../utils/fractional_index.dart';

// Rectangle Element
class RectangleElement extends ExcalidrawElement {
  const RectangleElement({
    required super.id,
    required super.x,
    required super.y,
    required super.width,
    required super.height,
    required super.angle,
    required super.strokeColor,
    required super.backgroundColor,
    required super.fillStyle,
    required super.strokeWidth,
    required super.strokeStyle,
    super.roundness,
    required super.roughness,
    required super.opacity,
    required super.seed,
    required super.version,
    required super.versionNonce,
    required super.index,
    super.isDeleted,
    super.groupIds,
    super.frameId,
    super.boundElements,
    required super.updated,
    super.link,
    super.locked,
    super.customData,
  });

  @override
  ElementType get type => ElementType.rectangle;

  @override
  RectangleElement copyWith({
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
  }) {
    return RectangleElement(
      id: id ?? this.id,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      angle: angle ?? this.angle,
      strokeColor: strokeColor ?? this.strokeColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      fillStyle: fillStyle ?? this.fillStyle,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      strokeStyle: strokeStyle ?? this.strokeStyle,
      roundness: roundness ?? this.roundness,
      roughness: roughness ?? this.roughness,
      opacity: opacity ?? this.opacity,
      seed: seed ?? this.seed,
      version: version ?? this.version,
      versionNonce: versionNonce ?? this.versionNonce,
      index: index ?? this.index,
      isDeleted: isDeleted ?? this.isDeleted,
      groupIds: groupIds ?? this.groupIds,
      frameId: frameId ?? this.frameId,
      boundElements: boundElements ?? this.boundElements,
      updated: updated ?? this.updated,
      link: link ?? this.link,
      locked: locked ?? this.locked,
      customData: customData ?? this.customData,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'rectangle',
      'id': id,
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'angle': angle,
      'strokeColor': '#${strokeColor.value.toRadixString(16).padLeft(8, '0')}',
      'backgroundColor': '#${backgroundColor.value.toRadixString(16).padLeft(8, '0')}',
      'fillStyle': fillStyle.name,
      'strokeWidth': strokeWidth,
      'strokeStyle': strokeStyle.name,
      if (roundness != null) 'roundness': roundness!.toJson(),
      'roughness': roughness,
      'opacity': opacity,
      'seed': seed,
      'version': version,
      'versionNonce': versionNonce,
      'isDeleted': isDeleted,
      'groupIds': groupIds,
      if (frameId != null) 'frameId': frameId,
      if (boundElements != null)
        'boundElements': boundElements!.map((e) => e.toJson()).toList(),
      'updated': updated,
      if (link != null) 'link': link,
      'locked': locked,
      if (customData != null) 'customData': customData,
    };
  }
}

// Diamond Element
class DiamondElement extends ExcalidrawElement {
  const DiamondElement({
    required super.id,
    required super.x,
    required super.y,
    required super.width,
    required super.height,
    required super.angle,
    required super.strokeColor,
    required super.backgroundColor,
    required super.fillStyle,
    required super.strokeWidth,
    required super.strokeStyle,
    super.roundness,
    required super.roughness,
    required super.opacity,
    required super.seed,
    required super.version,
    required super.versionNonce,
    required super.index,
    super.isDeleted,
    super.groupIds,
    super.frameId,
    super.boundElements,
    required super.updated,
    super.link,
    super.locked,
    super.customData,
  });

  @override
  ElementType get type => ElementType.diamond;

  @override
  DiamondElement copyWith({
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
  }) {
    return DiamondElement(
      id: id ?? this.id,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      angle: angle ?? this.angle,
      strokeColor: strokeColor ?? this.strokeColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      fillStyle: fillStyle ?? this.fillStyle,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      strokeStyle: strokeStyle ?? this.strokeStyle,
      roundness: roundness ?? this.roundness,
      roughness: roughness ?? this.roughness,
      opacity: opacity ?? this.opacity,
      seed: seed ?? this.seed,
      version: version ?? this.version,
      versionNonce: versionNonce ?? this.versionNonce,
      index: index ?? this.index,
      isDeleted: isDeleted ?? this.isDeleted,
      groupIds: groupIds ?? this.groupIds,
      frameId: frameId ?? this.frameId,
      boundElements: boundElements ?? this.boundElements,
      updated: updated ?? this.updated,
      link: link ?? this.link,
      locked: locked ?? this.locked,
      customData: customData ?? this.customData,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'diamond',
      'id': id,
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'angle': angle,
      'strokeColor': '#${strokeColor.value.toRadixString(16).padLeft(8, '0')}',
      'backgroundColor': '#${backgroundColor.value.toRadixString(16).padLeft(8, '0')}',
      'fillStyle': fillStyle.name,
      'strokeWidth': strokeWidth,
      'strokeStyle': strokeStyle.name,
      if (roundness != null) 'roundness': roundness!.toJson(),
      'roughness': roughness,
      'opacity': opacity,
      'seed': seed,
      'version': version,
      'versionNonce': versionNonce,
      'isDeleted': isDeleted,
      'groupIds': groupIds,
      if (frameId != null) 'frameId': frameId,
      if (boundElements != null)
        'boundElements': boundElements!.map((e) => e.toJson()).toList(),
      'updated': updated,
      if (link != null) 'link': link,
      'locked': locked,
      if (customData != null) 'customData': customData,
    };
  }
}

// Ellipse Element
class EllipseElement extends ExcalidrawElement {
  const EllipseElement({
    required super.id,
    required super.x,
    required super.y,
    required super.width,
    required super.height,
    required super.angle,
    required super.strokeColor,
    required super.backgroundColor,
    required super.fillStyle,
    required super.strokeWidth,
    required super.strokeStyle,
    super.roundness,
    required super.roughness,
    required super.opacity,
    required super.seed,
    required super.version,
    required super.versionNonce,
    required super.index,
    super.isDeleted,
    super.groupIds,
    super.frameId,
    super.boundElements,
    required super.updated,
    super.link,
    super.locked,
    super.customData,
  });

  @override
  ElementType get type => ElementType.ellipse;

  @override
  EllipseElement copyWith({
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
  }) {
    return EllipseElement(
      id: id ?? this.id,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      angle: angle ?? this.angle,
      strokeColor: strokeColor ?? this.strokeColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      fillStyle: fillStyle ?? this.fillStyle,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      strokeStyle: strokeStyle ?? this.strokeStyle,
      roundness: roundness ?? this.roundness,
      roughness: roughness ?? this.roughness,
      opacity: opacity ?? this.opacity,
      seed: seed ?? this.seed,
      version: version ?? this.version,
      versionNonce: versionNonce ?? this.versionNonce,
      index: index ?? this.index,
      isDeleted: isDeleted ?? this.isDeleted,
      groupIds: groupIds ?? this.groupIds,
      frameId: frameId ?? this.frameId,
      boundElements: boundElements ?? this.boundElements,
      updated: updated ?? this.updated,
      link: link ?? this.link,
      locked: locked ?? this.locked,
      customData: customData ?? this.customData,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'ellipse',
      'id': id,
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'angle': angle,
      'strokeColor': '#${strokeColor.value.toRadixString(16).padLeft(8, '0')}',
      'backgroundColor': '#${backgroundColor.value.toRadixString(16).padLeft(8, '0')}',
      'fillStyle': fillStyle.name,
      'strokeWidth': strokeWidth,
      'strokeStyle': strokeStyle.name,
      if (roundness != null) 'roundness': roundness!.toJson(),
      'roughness': roughness,
      'opacity': opacity,
      'seed': seed,
      'version': version,
      'versionNonce': versionNonce,
      'isDeleted': isDeleted,
      'groupIds': groupIds,
      if (frameId != null) 'frameId': frameId,
      if (boundElements != null)
        'boundElements': boundElements!.map((e) => e.toJson()).toList(),
      'updated': updated,
      if (link != null) 'link': link,
      'locked': locked,
      if (customData != null) 'customData': customData,
    };
  }
}

// Point for linear elements
class ElementPoint {
  final double x;
  final double y;

  const ElementPoint(this.x, this.y);

  factory ElementPoint.fromJson(List<dynamic> json) {
    return ElementPoint(json[0].toDouble(), json[1].toDouble());
  }

  List<double> toJson() => [x, y];

  @override
  String toString() => '($x, $y)';
}

// Arrow Element
class ArrowElement extends ExcalidrawElement {
  final List<ElementPoint> points;
  final String? startBinding;
  final String? endBinding;
  final String? startArrowhead;
  final String? endArrowhead;
  final bool elbowed;

  const ArrowElement({
    required super.id,
    required super.x,
    required super.y,
    required super.width,
    required super.height,
    required super.angle,
    required super.strokeColor,
    required super.backgroundColor,
    required super.fillStyle,
    required super.strokeWidth,
    required super.strokeStyle,
    super.roundness,
    required super.roughness,
    required super.opacity,
    required super.seed,
    required super.version,
    required super.versionNonce,
    required super.index,
    super.isDeleted,
    super.groupIds,
    super.frameId,
    super.boundElements,
    required super.updated,
    super.link,
    super.locked,
    super.customData,
    required this.points,
    this.startBinding,
    this.endBinding,
    this.startArrowhead,
    this.endArrowhead,
    this.elbowed = false,
  });

  @override
  ElementType get type => ElementType.arrow;

  @override
  ArrowElement copyWith({
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
    List<ElementPoint>? points,
    String? startBinding,
    String? endBinding,
    String? startArrowhead,
    String? endArrowhead,
    bool? elbowed,
  }) {
    return ArrowElement(
      id: id ?? this.id,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      angle: angle ?? this.angle,
      strokeColor: strokeColor ?? this.strokeColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      fillStyle: fillStyle ?? this.fillStyle,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      strokeStyle: strokeStyle ?? this.strokeStyle,
      roundness: roundness ?? this.roundness,
      roughness: roughness ?? this.roughness,
      opacity: opacity ?? this.opacity,
      seed: seed ?? this.seed,
      version: version ?? this.version,
      versionNonce: versionNonce ?? this.versionNonce,
      index: index ?? this.index,
      isDeleted: isDeleted ?? this.isDeleted,
      groupIds: groupIds ?? this.groupIds,
      frameId: frameId ?? this.frameId,
      boundElements: boundElements ?? this.boundElements,
      updated: updated ?? this.updated,
      link: link ?? this.link,
      locked: locked ?? this.locked,
      customData: customData ?? this.customData,
      points: points ?? this.points,
      startBinding: startBinding ?? this.startBinding,
      endBinding: endBinding ?? this.endBinding,
      startArrowhead: startArrowhead ?? this.startArrowhead,
      endArrowhead: endArrowhead ?? this.endArrowhead,
      elbowed: elbowed ?? this.elbowed,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'arrow',
      'id': id,
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'angle': angle,
      'strokeColor': '#${strokeColor.value.toRadixString(16).padLeft(8, '0')}',
      'backgroundColor': '#${backgroundColor.value.toRadixString(16).padLeft(8, '0')}',
      'fillStyle': fillStyle.name,
      'strokeWidth': strokeWidth,
      'strokeStyle': strokeStyle.name,
      if (roundness != null) 'roundness': roundness!.toJson(),
      'roughness': roughness,
      'opacity': opacity,
      'seed': seed,
      'version': version,
      'versionNonce': versionNonce,
      'isDeleted': isDeleted,
      'groupIds': groupIds,
      if (frameId != null) 'frameId': frameId,
      if (boundElements != null)
        'boundElements': boundElements!.map((e) => e.toJson()).toList(),
      'updated': updated,
      if (link != null) 'link': link,
      'locked': locked,
      if (customData != null) 'customData': customData,
      'points': points.map((p) => p.toJson()).toList(),
      if (startBinding != null) 'startBinding': startBinding,
      if (endBinding != null) 'endBinding': endBinding,
      if (startArrowhead != null) 'startArrowhead': startArrowhead,
      if (endArrowhead != null) 'endArrowhead': endArrowhead,
      'elbowed': elbowed,
    };
  }
}

// Line Element
class LineElement extends ExcalidrawElement {
  final List<ElementPoint> points;
  final String? startBinding;
  final String? endBinding;

  const LineElement({
    required super.id,
    required super.x,
    required super.y,
    required super.width,
    required super.height,
    required super.angle,
    required super.strokeColor,
    required super.backgroundColor,
    required super.fillStyle,
    required super.strokeWidth,
    required super.strokeStyle,
    super.roundness,
    required super.roughness,
    required super.opacity,
    required super.seed,
    required super.version,
    required super.versionNonce,
    required super.index,
    super.isDeleted,
    super.groupIds,
    super.frameId,
    super.boundElements,
    required super.updated,
    super.link,
    super.locked,
    super.customData,
    required this.points,
    this.startBinding,
    this.endBinding,
  });

  @override
  ElementType get type => ElementType.line;

  @override
  LineElement copyWith({
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
    List<ElementPoint>? points,
    String? startBinding,
    String? endBinding,
  }) {
    return LineElement(
      id: id ?? this.id,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      angle: angle ?? this.angle,
      strokeColor: strokeColor ?? this.strokeColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      fillStyle: fillStyle ?? this.fillStyle,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      strokeStyle: strokeStyle ?? this.strokeStyle,
      roundness: roundness ?? this.roundness,
      roughness: roughness ?? this.roughness,
      opacity: opacity ?? this.opacity,
      seed: seed ?? this.seed,
      version: version ?? this.version,
      versionNonce: versionNonce ?? this.versionNonce,
      index: index ?? this.index,
      isDeleted: isDeleted ?? this.isDeleted,
      groupIds: groupIds ?? this.groupIds,
      frameId: frameId ?? this.frameId,
      boundElements: boundElements ?? this.boundElements,
      updated: updated ?? this.updated,
      link: link ?? this.link,
      locked: locked ?? this.locked,
      customData: customData ?? this.customData,
      points: points ?? this.points,
      startBinding: startBinding ?? this.startBinding,
      endBinding: endBinding ?? this.endBinding,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'line',
      'id': id,
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'angle': angle,
      'strokeColor': '#${strokeColor.value.toRadixString(16).padLeft(8, '0')}',
      'backgroundColor': '#${backgroundColor.value.toRadixString(16).padLeft(8, '0')}',
      'fillStyle': fillStyle.name,
      'strokeWidth': strokeWidth,
      'strokeStyle': strokeStyle.name,
      if (roundness != null) 'roundness': roundness!.toJson(),
      'roughness': roughness,
      'opacity': opacity,
      'seed': seed,
      'version': version,
      'versionNonce': versionNonce,
      'isDeleted': isDeleted,
      'groupIds': groupIds,
      if (frameId != null) 'frameId': frameId,
      if (boundElements != null)
        'boundElements': boundElements!.map((e) => e.toJson()).toList(),
      'updated': updated,
      if (link != null) 'link': link,
      'locked': locked,
      if (customData != null) 'customData': customData,
      'points': points.map((p) => p.toJson()).toList(),
      if (startBinding != null) 'startBinding': startBinding,
      if (endBinding != null) 'endBinding': endBinding,
    };
  }
}

// Freedraw Element
class FreedrawElement extends ExcalidrawElement {
  final List<ElementPoint> points;
  final List<double>? pressures;
  final bool simulatePressure;

  const FreedrawElement({
    required super.id,
    required super.x,
    required super.y,
    required super.width,
    required super.height,
    required super.angle,
    required super.strokeColor,
    required super.backgroundColor,
    required super.fillStyle,
    required super.strokeWidth,
    required super.strokeStyle,
    super.roundness,
    required super.roughness,
    required super.opacity,
    required super.seed,
    required super.version,
    required super.versionNonce,
    required super.index,
    super.isDeleted,
    super.groupIds,
    super.frameId,
    super.boundElements,
    required super.updated,
    super.link,
    super.locked,
    super.customData,
    required this.points,
    this.pressures,
    this.simulatePressure = false,
  });

  @override
  ElementType get type => ElementType.freedraw;

  @override
  FreedrawElement copyWith({
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
    List<ElementPoint>? points,
    List<double>? pressures,
    bool? simulatePressure,
  }) {
    return FreedrawElement(
      id: id ?? this.id,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      angle: angle ?? this.angle,
      strokeColor: strokeColor ?? this.strokeColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      fillStyle: fillStyle ?? this.fillStyle,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      strokeStyle: strokeStyle ?? this.strokeStyle,
      roundness: roundness ?? this.roundness,
      roughness: roughness ?? this.roughness,
      opacity: opacity ?? this.opacity,
      seed: seed ?? this.seed,
      version: version ?? this.version,
      versionNonce: versionNonce ?? this.versionNonce,
      index: index ?? this.index,
      isDeleted: isDeleted ?? this.isDeleted,
      groupIds: groupIds ?? this.groupIds,
      frameId: frameId ?? this.frameId,
      boundElements: boundElements ?? this.boundElements,
      updated: updated ?? this.updated,
      link: link ?? this.link,
      locked: locked ?? this.locked,
      customData: customData ?? this.customData,
      points: points ?? this.points,
      pressures: pressures ?? this.pressures,
      simulatePressure: simulatePressure ?? this.simulatePressure,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'freedraw',
      'id': id,
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'angle': angle,
      'strokeColor': '#${strokeColor.value.toRadixString(16).padLeft(8, '0')}',
      'backgroundColor': '#${backgroundColor.value.toRadixString(16).padLeft(8, '0')}',
      'fillStyle': fillStyle.name,
      'strokeWidth': strokeWidth,
      'strokeStyle': strokeStyle.name,
      if (roundness != null) 'roundness': roundness!.toJson(),
      'roughness': roughness,
      'opacity': opacity,
      'seed': seed,
      'version': version,
      'versionNonce': versionNonce,
      'isDeleted': isDeleted,
      'groupIds': groupIds,
      if (frameId != null) 'frameId': frameId,
      if (boundElements != null)
        'boundElements': boundElements!.map((e) => e.toJson()).toList(),
      'updated': updated,
      if (link != null) 'link': link,
      'locked': locked,
      if (customData != null) 'customData': customData,
      'points': points.map((p) => p.toJson()).toList(),
      if (pressures != null) 'pressures': pressures,
      'simulatePressure': simulatePressure,
    };
  }
}

// Text Element
class TextElement extends ExcalidrawElement {
  final String text;
  final double fontSize;
  final String fontFamily;
  final String textAlign;
  final String verticalAlign;
  final String? containerId;
  final double? originalText;
  final bool autoResize;
  final double lineHeight;

  const TextElement({
    required super.id,
    required super.x,
    required super.y,
    required super.width,
    required super.height,
    required super.angle,
    required super.strokeColor,
    required super.backgroundColor,
    required super.fillStyle,
    required super.strokeWidth,
    required super.strokeStyle,
    super.roundness,
    required super.roughness,
    required super.opacity,
    required super.seed,
    required super.version,
    required super.versionNonce,
    required super.index,
    super.isDeleted,
    super.groupIds,
    super.frameId,
    super.boundElements,
    required super.updated,
    super.link,
    super.locked,
    super.customData,
    required this.text,
    required this.fontSize,
    required this.fontFamily,
    required this.textAlign,
    required this.verticalAlign,
    this.containerId,
    this.originalText,
    this.autoResize = true,
    required this.lineHeight,
  });

  @override
  ElementType get type => ElementType.text;

  @override
  TextElement copyWith({
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
    String? text,
    double? fontSize,
    String? fontFamily,
    String? textAlign,
    String? verticalAlign,
    String? containerId,
    double? originalText,
    bool? autoResize,
    double? lineHeight,
  }) {
    return TextElement(
      id: id ?? this.id,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      angle: angle ?? this.angle,
      strokeColor: strokeColor ?? this.strokeColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      fillStyle: fillStyle ?? this.fillStyle,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      strokeStyle: strokeStyle ?? this.strokeStyle,
      roundness: roundness ?? this.roundness,
      roughness: roughness ?? this.roughness,
      opacity: opacity ?? this.opacity,
      seed: seed ?? this.seed,
      version: version ?? this.version,
      versionNonce: versionNonce ?? this.versionNonce,
      index: index ?? this.index,
      isDeleted: isDeleted ?? this.isDeleted,
      groupIds: groupIds ?? this.groupIds,
      frameId: frameId ?? this.frameId,
      boundElements: boundElements ?? this.boundElements,
      updated: updated ?? this.updated,
      link: link ?? this.link,
      locked: locked ?? this.locked,
      customData: customData ?? this.customData,
      text: text ?? this.text,
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
      textAlign: textAlign ?? this.textAlign,
      verticalAlign: verticalAlign ?? this.verticalAlign,
      containerId: containerId ?? this.containerId,
      originalText: originalText ?? this.originalText,
      autoResize: autoResize ?? this.autoResize,
      lineHeight: lineHeight ?? this.lineHeight,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'text',
      'id': id,
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'angle': angle,
      'strokeColor': '#${strokeColor.value.toRadixString(16).padLeft(8, '0')}',
      'backgroundColor': '#${backgroundColor.value.toRadixString(16).padLeft(8, '0')}',
      'fillStyle': fillStyle.name,
      'strokeWidth': strokeWidth,
      'strokeStyle': strokeStyle.name,
      if (roundness != null) 'roundness': roundness!.toJson(),
      'roughness': roughness,
      'opacity': opacity,
      'seed': seed,
      'version': version,
      'versionNonce': versionNonce,
      'isDeleted': isDeleted,
      'groupIds': groupIds,
      if (frameId != null) 'frameId': frameId,
      if (boundElements != null)
        'boundElements': boundElements!.map((e) => e.toJson()).toList(),
      'updated': updated,
      if (link != null) 'link': link,
      'locked': locked,
      if (customData != null) 'customData': customData,
      'text': text,
      'fontSize': fontSize,
      'fontFamily': fontFamily,
      'textAlign': textAlign,
      'verticalAlign': verticalAlign,
      if (containerId != null) 'containerId': containerId,
      if (originalText != null) 'originalText': originalText,
      'autoResize': autoResize,
      'lineHeight': lineHeight,
    };
  }
}
