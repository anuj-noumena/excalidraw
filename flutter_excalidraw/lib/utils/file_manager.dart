import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../models/element_base.dart';
import '../models/elements.dart';
import '../utils/fractional_index.dart';

class FileManager {
  // Export to JSON
  static Future<Map<String, dynamic>> exportToJson(
    List<ExcalidrawElement> elements,
  ) async {
    return {
      'type': 'excalidraw',
      'version': 2,
      'source': 'flutter_excalidraw',
      'elements': elements.map((e) => e.toJson()).toList(),
      'appState': {
        'viewBackgroundColor': '#ffffff',
        'gridSize': 20,
      },
    };
  }

  // Save to file
  static Future<void> saveToFile(
    List<ExcalidrawElement> elements,
    String fileName,
  ) async {
    try {
      final jsonData = await exportToJson(elements);
      final jsonString = jsonEncoder.convert(jsonData);

      // Get documents directory
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName.excalidraw');

      await file.writeAsString(jsonString);
    } catch (e) {
      throw Exception('Failed to save file: $e');
    }
  }

  // Load from JSON
  static Future<List<ExcalidrawElement>> loadFromJson(
    Map<String, dynamic> json,
  ) async {
    final elements = <ExcalidrawElement>[];

    if (json['elements'] != null) {
      for (final elementJson in json['elements']) {
        final element = _parseElement(elementJson);
        if (element != null) {
          elements.add(element);
        }
      }
    }

    return elements;
  }

  // Parse individual element
  static ExcalidrawElement? _parseElement(Map<String, dynamic> json) {
    try {
      final type = json['type'] as String;
      final id = json['id'] as String;
      final x = (json['x'] as num).toDouble();
      final y = (json['y'] as num).toDouble();
      final width = (json['width'] as num).toDouble();
      final height = (json['height'] as num).toDouble();
      final angle = (json['angle'] as num?)?.toDouble() ?? 0.0;

      final strokeColor = _parseColor(json['strokeColor'] as String?);
      final backgroundColor =
          _parseColor(json['backgroundColor'] as String?);

      final fillStyle = FillStyle.values.firstWhere(
        (e) => e.name == json['fillStyle'],
        orElse: () => FillStyle.hachure,
      );

      final strokeWidth = (json['strokeWidth'] as num?)?.toDouble() ?? 2.0;

      final strokeStyle = StrokeStyle.values.firstWhere(
        (e) => e.name == json['strokeStyle'],
        orElse: () => StrokeStyle.solid,
      );

      final roughness = (json['roughness'] as num?)?.toDouble() ?? 1.0;
      final opacity = (json['opacity'] as num?)?.toInt() ?? 100;
      final seed = (json['seed'] as num?)?.toInt() ?? 0;
      final version = (json['version'] as num?)?.toInt() ?? 1;
      final versionNonce = (json['versionNonce'] as num?)?.toInt() ?? 0;

      final index = json['index'] != null
          ? FractionalIndex(json['index'] as String)
          : const FractionalIndex('a0');

      final isDeleted = json['isDeleted'] as bool? ?? false;
      final groupIds = (json['groupIds'] as List?)?.cast<String>() ?? [];
      final frameId = json['frameId'] as String?;
      final updated = (json['updated'] as num?)?.toInt() ??
          DateTime.now().millisecondsSinceEpoch;
      final link = json['link'] as String?;
      final locked = json['locked'] as bool? ?? false;

      Roundness? roundness;
      if (json['roundness'] != null) {
        roundness = Roundness.fromJson(json['roundness']);
      }

      switch (type) {
        case 'rectangle':
          return RectangleElement(
            id: id,
            x: x,
            y: y,
            width: width,
            height: height,
            angle: angle,
            strokeColor: strokeColor,
            backgroundColor: backgroundColor,
            fillStyle: fillStyle,
            strokeWidth: strokeWidth,
            strokeStyle: strokeStyle,
            roundness: roundness,
            roughness: roughness,
            opacity: opacity,
            seed: seed,
            version: version,
            versionNonce: versionNonce,
            index: index,
            isDeleted: isDeleted,
            groupIds: groupIds,
            frameId: frameId,
            updated: updated,
            link: link,
            locked: locked,
          );

        case 'diamond':
          return DiamondElement(
            id: id,
            x: x,
            y: y,
            width: width,
            height: height,
            angle: angle,
            strokeColor: strokeColor,
            backgroundColor: backgroundColor,
            fillStyle: fillStyle,
            strokeWidth: strokeWidth,
            strokeStyle: strokeStyle,
            roundness: roundness,
            roughness: roughness,
            opacity: opacity,
            seed: seed,
            version: version,
            versionNonce: versionNonce,
            index: index,
            isDeleted: isDeleted,
            groupIds: groupIds,
            frameId: frameId,
            updated: updated,
            link: link,
            locked: locked,
          );

        case 'ellipse':
          return EllipseElement(
            id: id,
            x: x,
            y: y,
            width: width,
            height: height,
            angle: angle,
            strokeColor: strokeColor,
            backgroundColor: backgroundColor,
            fillStyle: fillStyle,
            strokeWidth: strokeWidth,
            strokeStyle: strokeStyle,
            roundness: roundness,
            roughness: roughness,
            opacity: opacity,
            seed: seed,
            version: version,
            versionNonce: versionNonce,
            index: index,
            isDeleted: isDeleted,
            groupIds: groupIds,
            frameId: frameId,
            updated: updated,
            link: link,
            locked: locked,
          );

        case 'arrow':
          final points = (json['points'] as List)
              .map((p) => ElementPoint.fromJson(p))
              .toList();
          return ArrowElement(
            id: id,
            x: x,
            y: y,
            width: width,
            height: height,
            angle: angle,
            strokeColor: strokeColor,
            backgroundColor: backgroundColor,
            fillStyle: fillStyle,
            strokeWidth: strokeWidth,
            strokeStyle: strokeStyle,
            roundness: roundness,
            roughness: roughness,
            opacity: opacity,
            seed: seed,
            version: version,
            versionNonce: versionNonce,
            index: index,
            isDeleted: isDeleted,
            groupIds: groupIds,
            frameId: frameId,
            updated: updated,
            link: link,
            locked: locked,
            points: points,
            startBinding: json['startBinding'] as String?,
            endBinding: json['endBinding'] as String?,
            startArrowhead: json['startArrowhead'] as String?,
            endArrowhead: json['endArrowhead'] as String?,
            elbowed: json['elbowed'] as bool? ?? false,
          );

        case 'line':
          final points = (json['points'] as List)
              .map((p) => ElementPoint.fromJson(p))
              .toList();
          return LineElement(
            id: id,
            x: x,
            y: y,
            width: width,
            height: height,
            angle: angle,
            strokeColor: strokeColor,
            backgroundColor: backgroundColor,
            fillStyle: fillStyle,
            strokeWidth: strokeWidth,
            strokeStyle: strokeStyle,
            roundness: roundness,
            roughness: roughness,
            opacity: opacity,
            seed: seed,
            version: version,
            versionNonce: versionNonce,
            index: index,
            isDeleted: isDeleted,
            groupIds: groupIds,
            frameId: frameId,
            updated: updated,
            link: link,
            locked: locked,
            points: points,
            startBinding: json['startBinding'] as String?,
            endBinding: json['endBinding'] as String?,
          );

        case 'freedraw':
          final points = (json['points'] as List)
              .map((p) => ElementPoint.fromJson(p))
              .toList();
          return FreedrawElement(
            id: id,
            x: x,
            y: y,
            width: width,
            height: height,
            angle: angle,
            strokeColor: strokeColor,
            backgroundColor: backgroundColor,
            fillStyle: fillStyle,
            strokeWidth: strokeWidth,
            strokeStyle: strokeStyle,
            roundness: roundness,
            roughness: roughness,
            opacity: opacity,
            seed: seed,
            version: version,
            versionNonce: versionNonce,
            index: index,
            isDeleted: isDeleted,
            groupIds: groupIds,
            frameId: frameId,
            updated: updated,
            link: link,
            locked: locked,
            points: points,
            pressures: (json['pressures'] as List?)?.cast<double>(),
            simulatePressure: json['simulatePressure'] as bool? ?? false,
          );

        case 'text':
          return TextElement(
            id: id,
            x: x,
            y: y,
            width: width,
            height: height,
            angle: angle,
            strokeColor: strokeColor,
            backgroundColor: backgroundColor,
            fillStyle: fillStyle,
            strokeWidth: strokeWidth,
            strokeStyle: strokeStyle,
            roundness: roundness,
            roughness: roughness,
            opacity: opacity,
            seed: seed,
            version: version,
            versionNonce: versionNonce,
            index: index,
            isDeleted: isDeleted,
            groupIds: groupIds,
            frameId: frameId,
            updated: updated,
            link: link,
            locked: locked,
            text: json['text'] as String? ?? '',
            fontSize: (json['fontSize'] as num?)?.toDouble() ?? 20.0,
            fontFamily: json['fontFamily'] as String? ?? 'Virgil',
            textAlign: json['textAlign'] as String? ?? 'left',
            verticalAlign: json['verticalAlign'] as String? ?? 'top',
            containerId: json['containerId'] as String?,
            autoResize: json['autoResize'] as bool? ?? true,
            lineHeight: (json['lineHeight'] as num?)?.toDouble() ?? 1.25,
          );

        default:
          return null;
      }
    } catch (e) {
      print('Error parsing element: $e');
      return null;
    }
  }

  static Color _parseColor(String? colorString) {
    if (colorString == null || colorString.isEmpty) {
      return Colors.black;
    }

    // Remove # if present
    final hex = colorString.replaceAll('#', '');

    // Parse hex color
    if (hex.length == 6) {
      return Color(int.parse('FF$hex', radix: 16));
    } else if (hex.length == 8) {
      return Color(int.parse(hex, radix: 16));
    }

    return Colors.black;
  }

  // Pick and load file
  static Future<List<ExcalidrawElement>?> pickAndLoadFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['excalidraw', 'json'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final jsonString = await file.readAsString();
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        return await loadFromJson(json);
      }

      return null;
    } catch (e) {
      throw Exception('Failed to load file: $e');
    }
  }

  // Save file picker
  static Future<void> pickAndSaveFile(List<ExcalidrawElement> elements) async {
    try {
      final jsonData = await exportToJson(elements);
      final jsonString = jsonEncoder.convert(jsonData);

      final directory = await getApplicationDocumentsDirectory();
      final fileName =
          'excalidraw_${DateTime.now().millisecondsSinceEpoch}.excalidraw';
      final file = File('${directory.path}/$fileName');

      await file.writeAsString(jsonString);
    } catch (e) {
      throw Exception('Failed to save file: $e');
    }
  }

  static const jsonEncoder = JsonEncoder.withIndent('  ');
}
