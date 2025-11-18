import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/element_base.dart';

class LibraryItem {
  final String id;
  final String name;
  final List<ExcalidrawElement> elements;
  final DateTime created;
  final String? thumbnail; // Base64 encoded image

  LibraryItem({
    required this.id,
    required this.name,
    required this.elements,
    required this.created,
    this.thumbnail,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'elements': elements.map((e) => e.toJson()).toList(),
      'created': created.toIso8601String(),
      if (thumbnail != null) 'thumbnail': thumbnail,
    };
  }

  factory LibraryItem.fromJson(Map<String, dynamic> json) {
    // Note: Elements reconstruction would need proper factory method
    // This is a simplified version
    return LibraryItem(
      id: json['id'],
      name: json['name'],
      elements: [], // Would need proper element reconstruction
      created: DateTime.parse(json['created']),
      thumbnail: json['thumbnail'],
    );
  }
}

class LibraryManager {
  static const String _libraryFileName = 'excalidraw_library.json';

  // Save library items to file
  static Future<void> saveLibrary(List<LibraryItem> items) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_libraryFileName');

      final json = {
        'version': 1,
        'library': items.map((item) => item.toJson()).toList(),
      };

      await file.writeAsString(jsonEncode(json));
    } catch (e) {
      throw Exception('Failed to save library: $e');
    }
  }

  // Load library items from file
  static Future<List<LibraryItem>> loadLibrary() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_libraryFileName');

      if (!await file.exists()) {
        return [];
      }

      final jsonString = await file.readAsString();
      final json = jsonDecode(jsonString) as Map<String, dynamic>;

      final libraryJson = json['library'] as List;
      return libraryJson
          .map((item) => LibraryItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load library: $e');
    }
  }

  // Add item to library
  static Future<void> addToLibrary(LibraryItem item) async {
    final library = await loadLibrary();
    library.add(item);
    await saveLibrary(library);
  }

  // Remove item from library
  static Future<void> removeFromLibrary(String itemId) async {
    final library = await loadLibrary();
    library.removeWhere((item) => item.id == itemId);
    await saveLibrary(library);
  }

  // Update library item
  static Future<void> updateLibraryItem(LibraryItem updatedItem) async {
    final library = await loadLibrary();
    final index = library.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      library[index] = updatedItem;
      await saveLibrary(library);
    }
  }

  // Get default library items (shapes, diagrams, etc.)
  static List<LibraryItem> getDefaultLibraryItems() {
    return [
      // Add pre-defined templates here
      // For example: common shapes, flowchart symbols, etc.
    ];
  }

  // Search library items
  static List<LibraryItem> searchLibrary(
    List<LibraryItem> library,
    String query,
  ) {
    final lowerQuery = query.toLowerCase();
    return library
        .where((item) => item.name.toLowerCase().contains(lowerQuery))
        .toList();
  }

  // Sort library items
  static List<LibraryItem> sortLibrary(
    List<LibraryItem> library, {
    SortType sortType = SortType.dateNewest,
  }) {
    final sorted = List<LibraryItem>.from(library);

    switch (sortType) {
      case SortType.dateNewest:
        sorted.sort((a, b) => b.created.compareTo(a.created));
        break;
      case SortType.dateOldest:
        sorted.sort((a, b) => a.created.compareTo(b.created));
        break;
      case SortType.nameAZ:
        sorted.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortType.nameZA:
        sorted.sort((a, b) => b.name.compareTo(a.name));
        break;
    }

    return sorted;
  }
}

enum SortType {
  dateNewest,
  dateOldest,
  nameAZ,
  nameZA,
}
