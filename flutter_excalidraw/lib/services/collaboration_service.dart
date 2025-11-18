import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/element_base.dart';

class Collaborator {
  final String id;
  final String name;
  final String color;
  final Offset? cursorPosition;
  final Set<String> selectedElementIds;

  Collaborator({
    required this.id,
    required this.name,
    required this.color,
    this.cursorPosition,
    this.selectedElementIds = const {},
  });

  factory Collaborator.fromJson(Map<String, dynamic> json) {
    return Collaborator(
      id: json['id'],
      name: json['name'],
      color: json['color'],
      cursorPosition: json['cursorPosition'] != null
          ? Offset(
              (json['cursorPosition']['x'] as num).toDouble(),
              (json['cursorPosition']['y'] as num).toDouble(),
            )
          : null,
      selectedElementIds: (json['selectedElementIds'] as List?)?.cast<String>().toSet() ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
      if (cursorPosition != null)
        'cursorPosition': {
          'x': cursorPosition!.dx,
          'y': cursorPosition!.dy,
        },
      'selectedElementIds': selectedElementIds.toList(),
    };
  }
}

enum CollaborationEventType {
  join,
  leave,
  cursorMove,
  elementUpdate,
  elementCreate,
  elementDelete,
  selection,
  sync,
}

class CollaborationEvent {
  final CollaborationEventType type;
  final String userId;
  final Map<String, dynamic> data;
  final int timestamp;

  CollaborationEvent({
    required this.type,
    required this.userId,
    required this.data,
    required this.timestamp,
  });

  factory CollaborationEvent.fromJson(Map<String, dynamic> json) {
    return CollaborationEvent(
      type: CollaborationEventType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => CollaborationEventType.sync,
      ),
      userId: json['userId'],
      data: json['data'] as Map<String, dynamic>,
      timestamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'userId': userId,
      'data': data,
      'timestamp': timestamp,
    };
  }
}

class CollaborationService {
  WebSocketChannel? _channel;
  final String roomId;
  final String userId;
  final String userName;

  final StreamController<CollaborationEvent> _eventController =
      StreamController<CollaborationEvent>.broadcast();

  final Map<String, Collaborator> _collaborators = {};

  Stream<CollaborationEvent> get eventStream => _eventController.stream;
  Map<String, Collaborator> get collaborators => Map.unmodifiable(_collaborators);

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  CollaborationService({
    required this.roomId,
    required this.userId,
    required this.userName,
  });

  // Connect to collaboration server
  Future<void> connect(String serverUrl) async {
    try {
      final wsUrl = '$serverUrl/room/$roomId';
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

      _isConnected = true;

      // Send join event
      _sendEvent(CollaborationEvent(
        type: CollaborationEventType.join,
        userId: userId,
        data: {
          'name': userName,
          'color': _generateUserColor(),
        },
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ));

      // Listen to incoming messages
      _channel!.stream.listen(
        _handleIncomingMessage,
        onError: (error) {
          _isConnected = false;
          print('WebSocket error: $error');
        },
        onDone: () {
          _isConnected = false;
          print('WebSocket connection closed');
        },
      );
    } catch (e) {
      _isConnected = false;
      throw Exception('Failed to connect to collaboration server: $e');
    }
  }

  // Disconnect from collaboration server
  void disconnect() {
    if (_channel != null) {
      _sendEvent(CollaborationEvent(
        type: CollaborationEventType.leave,
        userId: userId,
        data: {},
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ));

      _channel!.sink.close();
      _channel = null;
      _isConnected = false;
    }
  }

  // Send cursor position update
  void updateCursor(Offset position) {
    _sendEvent(CollaborationEvent(
      type: CollaborationEventType.cursorMove,
      userId: userId,
      data: {
        'x': position.dx,
        'y': position.dy,
      },
      timestamp: DateTime.now().millisecondsSinceEpoch,
    ));
  }

  // Send element update
  void updateElement(ExcalidrawElement element) {
    _sendEvent(CollaborationEvent(
      type: CollaborationEventType.elementUpdate,
      userId: userId,
      data: {
        'element': element.toJson(),
      },
      timestamp: DateTime.now().millisecondsSinceEpoch,
    ));
  }

  // Send element creation
  void createElement(ExcalidrawElement element) {
    _sendEvent(CollaborationEvent(
      type: CollaborationEventType.elementCreate,
      userId: userId,
      data: {
        'element': element.toJson(),
      },
      timestamp: DateTime.now().millisecondsSinceEpoch,
    ));
  }

  // Send element deletion
  void deleteElement(String elementId) {
    _sendEvent(CollaborationEvent(
      type: CollaborationEventType.elementDelete,
      userId: userId,
      data: {
        'elementId': elementId,
      },
      timestamp: DateTime.now().millisecondsSinceEpoch,
    ));
  }

  // Send selection update
  void updateSelection(Set<String> selectedIds) {
    _sendEvent(CollaborationEvent(
      type: CollaborationEventType.selection,
      userId: userId,
      data: {
        'selectedElementIds': selectedIds.toList(),
      },
      timestamp: DateTime.now().millisecondsSinceEpoch,
    ));
  }

  // Request full sync
  void requestSync() {
    _sendEvent(CollaborationEvent(
      type: CollaborationEventType.sync,
      userId: userId,
      data: {},
      timestamp: DateTime.now().millisecondsSinceEpoch,
    ));
  }

  void _sendEvent(CollaborationEvent event) {
    if (_channel != null && _isConnected) {
      _channel!.sink.add(jsonEncode(event.toJson()));
    }
  }

  void _handleIncomingMessage(dynamic message) {
    try {
      final json = jsonDecode(message as String) as Map<String, dynamic>;
      final event = CollaborationEvent.fromJson(json);

      // Update collaborators
      if (event.type == CollaborationEventType.join) {
        _collaborators[event.userId] = Collaborator(
          id: event.userId,
          name: event.data['name'],
          color: event.data['color'],
        );
      } else if (event.type == CollaborationEventType.leave) {
        _collaborators.remove(event.userId);
      } else if (event.type == CollaborationEventType.cursorMove) {
        final collaborator = _collaborators[event.userId];
        if (collaborator != null) {
          _collaborators[event.userId] = Collaborator(
            id: collaborator.id,
            name: collaborator.name,
            color: collaborator.color,
            cursorPosition: Offset(
              (event.data['x'] as num).toDouble(),
              (event.data['y'] as num).toDouble(),
            ),
            selectedElementIds: collaborator.selectedElementIds,
          );
        }
      } else if (event.type == CollaborationEventType.selection) {
        final collaborator = _collaborators[event.userId];
        if (collaborator != null) {
          _collaborators[event.userId] = Collaborator(
            id: collaborator.id,
            name: collaborator.name,
            color: collaborator.color,
            cursorPosition: collaborator.cursorPosition,
            selectedElementIds: (event.data['selectedElementIds'] as List)
                .cast<String>()
                .toSet(),
          );
        }
      }

      // Broadcast event to listeners
      _eventController.add(event);
    } catch (e) {
      print('Error handling incoming message: $e');
    }
  }

  String _generateUserColor() {
    // Generate a random color for the user
    final colors = [
      '#FF6B6B',
      '#4ECDC4',
      '#45B7D1',
      '#FFA07A',
      '#98D8C8',
      '#F7DC6F',
      '#BB8FCE',
      '#85C1E2',
    ];
    return colors[userId.hashCode % colors.length];
  }

  void dispose() {
    disconnect();
    _eventController.close();
  }
}

// Conflict resolution for concurrent edits
class ConflictResolver {
  // Resolve conflicts between two versions of the same element
  static ExcalidrawElement? resolveConflict(
    ExcalidrawElement local,
    ExcalidrawElement remote,
  ) {
    // Use version nonce and timestamp for conflict resolution
    // Last-write-wins strategy with version nonce tie-breaker
    if (local.updated > remote.updated) {
      return local;
    } else if (local.updated < remote.updated) {
      return remote;
    } else {
      // Same timestamp, use version nonce
      return local.versionNonce > remote.versionNonce ? local : remote;
    }
  }

  // Merge changes from remote into local
  static List<ExcalidrawElement> mergeElements(
    List<ExcalidrawElement> localElements,
    List<ExcalidrawElement> remoteElements,
  ) {
    final merged = <String, ExcalidrawElement>{};

    // Add all local elements
    for (final element in localElements) {
      merged[element.id] = element;
    }

    // Merge remote elements
    for (final remoteElement in remoteElements) {
      final localElement = merged[remoteElement.id];
      if (localElement == null) {
        // New element from remote
        merged[remoteElement.id] = remoteElement;
      } else {
        // Conflict resolution
        final resolved = resolveConflict(localElement, remoteElement);
        if (resolved != null) {
          merged[remoteElement.id] = resolved;
        }
      }
    }

    return merged.values.toList();
  }
}
