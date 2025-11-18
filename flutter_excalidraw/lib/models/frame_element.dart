import 'package:flutter/material.dart';
import 'element_base.dart';
import '../utils/fractional_index.dart';

// Frame Element - Container for grouping elements
class FrameElement extends ExcalidrawElement {
  final String? name;
  final List<String> children; // IDs of elements inside the frame

  const FrameElement({
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
    this.name,
    this.children = const [],
  });

  @override
  ElementType get type => ElementType.frame;

  @override
  FrameElement copyWith({
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
    String? name,
    List<String>? children,
  }) {
    return FrameElement(
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
      name: name ?? this.name,
      children: children ?? this.children,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'frame',
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
      if (name != null) 'name': name,
      'children': children,
    };
  }
}

// Magic Frame Element - Frame with AI capabilities
class MagicFrameElement extends FrameElement {
  const MagicFrameElement({
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
    super.name,
    super.children,
  });

  @override
  ElementType get type => ElementType.magicframe;

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['type'] = 'magicframe';
    return json;
  }
}
