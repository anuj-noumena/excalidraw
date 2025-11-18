import 'package:flutter/material.dart';
import '../models/element_base.dart';
import '../models/elements.dart';
import '../utils/fractional_index.dart';
import 'package:uuid/uuid.dart';
import 'dart:math' as math;

enum ToolType {
  selection,
  rectangle,
  diamond,
  ellipse,
  arrow,
  line,
  freedraw,
  text,
  eraser,
  hand,
}

class AppState extends ChangeNotifier {
  // Elements
  final List<ExcalidrawElement> _elements = [];
  List<ExcalidrawElement> get elements => List.unmodifiable(_elements);

  // Selected elements
  final Set<String> _selectedElementIds = {};
  Set<String> get selectedElementIds => Set.unmodifiable(_selectedElementIds);

  // Current tool
  ToolType _activeTool = ToolType.selection;
  ToolType get activeTool => _activeTool;

  // Tool properties
  Color _strokeColor = Colors.black;
  Color get strokeColor => _strokeColor;

  Color _backgroundColor = Colors.transparent;
  Color get backgroundColor => _backgroundColor;

  double _strokeWidth = 2.0;
  double get strokeWidth => _strokeWidth;

  StrokeStyle _strokeStyle = StrokeStyle.solid;
  StrokeStyle get strokeStyle => _strokeStyle;

  FillStyle _fillStyle = FillStyle.hachure;
  FillStyle get fillStyle => _fillStyle;

  double _roughness = 1.0;
  double get roughness => _roughness;

  int _opacity = 100;
  int get opacity => _opacity;

  // Canvas state
  Offset _scrollOffset = Offset.zero;
  Offset get scrollOffset => _scrollOffset;

  double _zoom = 1.0;
  double get zoom => _zoom;

  bool _showGrid = false;
  bool get showGrid => _showGrid;

  // Temporary drawing state
  ExcalidrawElement? _currentElement;
  ExcalidrawElement? get currentElement => _currentElement;

  List<ElementPoint> _currentPoints = [];

  // History
  final List<List<ExcalidrawElement>> _history = [];
  int _historyIndex = -1;

  final _uuid = const Uuid();

  // Add element
  void addElement(ExcalidrawElement element) {
    _elements.add(element);
    _pushHistory();
    notifyListeners();
  }

  // Update element
  void updateElement(String id, ExcalidrawElement element) {
    final index = _elements.indexWhere((e) => e.id == id);
    if (index != -1) {
      _elements[index] = element;
      notifyListeners();
    }
  }

  // Delete selected elements
  void deleteSelectedElements() {
    _elements.removeWhere((e) => _selectedElementIds.contains(e.id));
    _selectedElementIds.clear();
    _pushHistory();
    notifyListeners();
  }

  // Selection methods
  void selectElement(String id) {
    _selectedElementIds.add(id);
    notifyListeners();
  }

  void deselectElement(String id) {
    _selectedElementIds.remove(id);
    notifyListeners();
  }

  void clearSelection() {
    _selectedElementIds.clear();
    notifyListeners();
  }

  void selectMultiple(Set<String> ids) {
    _selectedElementIds.clear();
    _selectedElementIds.addAll(ids);
    notifyListeners();
  }

  // Tool methods
  void setActiveTool(ToolType tool) {
    _activeTool = tool;
    _currentElement = null;
    _currentPoints.clear();
    notifyListeners();
  }

  // Property setters
  void setStrokeColor(Color color) {
    _strokeColor = color;
    notifyListeners();
  }

  void setBackgroundColor(Color color) {
    _backgroundColor = color;
    notifyListeners();
  }

  void setStrokeWidth(double width) {
    _strokeWidth = width;
    notifyListeners();
  }

  void setStrokeStyle(StrokeStyle style) {
    _strokeStyle = style;
    notifyListeners();
  }

  void setFillStyle(FillStyle style) {
    _fillStyle = style;
    notifyListeners();
  }

  void setRoughness(double value) {
    _roughness = value;
    notifyListeners();
  }

  void setOpacity(int value) {
    _opacity = value;
    notifyListeners();
  }

  // Canvas methods
  void setZoom(double value) {
    _zoom = value.clamp(0.1, 10.0);
    notifyListeners();
  }

  void pan(Offset delta) {
    _scrollOffset += delta;
    notifyListeners();
  }

  void toggleGrid() {
    _showGrid = !_showGrid;
    notifyListeners();
  }

  // Drawing methods
  void startDrawing(Offset position) {
    final id = _uuid.v4();
    final now = DateTime.now().millisecondsSinceEpoch;
    final seed = math.Random().nextInt(1000000);

    _currentPoints = [ElementPoint(position.dx, position.dy)];

    switch (_activeTool) {
      case ToolType.rectangle:
        _currentElement = RectangleElement(
          id: id,
          x: position.dx,
          y: position.dy,
          width: 0,
          height: 0,
          angle: 0,
          strokeColor: _strokeColor,
          backgroundColor: _backgroundColor,
          fillStyle: _fillStyle,
          strokeWidth: _strokeWidth,
          strokeStyle: _strokeStyle,
          roughness: _roughness,
          opacity: _opacity,
          seed: seed,
          version: 1,
          versionNonce: math.Random().nextInt(1000000),
          index: _generateIndex(),
          updated: now,
        );
        break;

      case ToolType.diamond:
        _currentElement = DiamondElement(
          id: id,
          x: position.dx,
          y: position.dy,
          width: 0,
          height: 0,
          angle: 0,
          strokeColor: _strokeColor,
          backgroundColor: _backgroundColor,
          fillStyle: _fillStyle,
          strokeWidth: _strokeWidth,
          strokeStyle: _strokeStyle,
          roughness: _roughness,
          opacity: _opacity,
          seed: seed,
          version: 1,
          versionNonce: math.Random().nextInt(1000000),
          index: _generateIndex(),
          updated: now,
        );
        break;

      case ToolType.ellipse:
        _currentElement = EllipseElement(
          id: id,
          x: position.dx,
          y: position.dy,
          width: 0,
          height: 0,
          angle: 0,
          strokeColor: _strokeColor,
          backgroundColor: _backgroundColor,
          fillStyle: _fillStyle,
          strokeWidth: _strokeWidth,
          strokeStyle: _strokeStyle,
          roughness: _roughness,
          opacity: _opacity,
          seed: seed,
          version: 1,
          versionNonce: math.Random().nextInt(1000000),
          index: _generateIndex(),
          updated: now,
        );
        break;

      case ToolType.arrow:
      case ToolType.line:
        // Will be created on drag
        break;

      case ToolType.freedraw:
        _currentElement = FreedrawElement(
          id: id,
          x: position.dx,
          y: position.dy,
          width: 0,
          height: 0,
          angle: 0,
          strokeColor: _strokeColor,
          backgroundColor: _backgroundColor,
          fillStyle: _fillStyle,
          strokeWidth: _strokeWidth,
          strokeStyle: _strokeStyle,
          roughness: _roughness,
          opacity: _opacity,
          seed: seed,
          version: 1,
          versionNonce: math.Random().nextInt(1000000),
          index: _generateIndex(),
          updated: now,
          points: _currentPoints,
        );
        break;

      default:
        break;
    }

    notifyListeners();
  }

  void updateDrawing(Offset position) {
    if (_currentElement == null && _activeTool != ToolType.arrow &&
        _activeTool != ToolType.line) return;

    switch (_activeTool) {
      case ToolType.rectangle:
      case ToolType.diamond:
      case ToolType.ellipse:
        final start = _currentPoints.first;
        final width = position.dx - start.x;
        final height = position.dy - start.y;

        _currentElement = _currentElement!.copyWith(
          width: width.abs(),
          height: height.abs(),
          x: width < 0 ? position.dx : start.x,
          y: height < 0 ? position.dy : start.y,
        );
        break;

      case ToolType.arrow:
      case ToolType.line:
        _currentPoints.add(ElementPoint(position.dx, position.dy));

        if (_currentElement == null) {
          final id = _uuid.v4();
          final now = DateTime.now().millisecondsSinceEpoch;
          final seed = math.Random().nextInt(1000000);

          final minX = _currentPoints.map((p) => p.x).reduce(math.min);
          final minY = _currentPoints.map((p) => p.y).reduce(math.min);
          final maxX = _currentPoints.map((p) => p.x).reduce(math.max);
          final maxY = _currentPoints.map((p) => p.y).reduce(math.max);

          if (_activeTool == ToolType.arrow) {
            _currentElement = ArrowElement(
              id: id,
              x: minX,
              y: minY,
              width: maxX - minX,
              height: maxY - minY,
              angle: 0,
              strokeColor: _strokeColor,
              backgroundColor: _backgroundColor,
              fillStyle: _fillStyle,
              strokeWidth: _strokeWidth,
              strokeStyle: _strokeStyle,
              roughness: _roughness,
              opacity: _opacity,
              seed: seed,
              version: 1,
              versionNonce: math.Random().nextInt(1000000),
              index: _generateIndex(),
              updated: now,
              points: _currentPoints,
              endArrowhead: 'arrow',
            );
          } else {
            _currentElement = LineElement(
              id: id,
              x: minX,
              y: minY,
              width: maxX - minX,
              height: maxY - minY,
              angle: 0,
              strokeColor: _strokeColor,
              backgroundColor: _backgroundColor,
              fillStyle: _fillStyle,
              strokeWidth: _strokeWidth,
              strokeStyle: _strokeStyle,
              roughness: _roughness,
              opacity: _opacity,
              seed: seed,
              version: 1,
              versionNonce: math.Random().nextInt(1000000),
              index: _generateIndex(),
              updated: now,
              points: _currentPoints,
            );
          }
        } else {
          final minX = _currentPoints.map((p) => p.x).reduce(math.min);
          final minY = _currentPoints.map((p) => p.y).reduce(math.min);
          final maxX = _currentPoints.map((p) => p.x).reduce(math.max);
          final maxY = _currentPoints.map((p) => p.y).reduce(math.max);

          _currentElement = _currentElement!.copyWith(
            x: minX,
            y: minY,
            width: maxX - minX,
            height: maxY - minY,
          );

          if (_currentElement is ArrowElement) {
            _currentElement =
                (_currentElement as ArrowElement).copyWith(points: _currentPoints);
          } else if (_currentElement is LineElement) {
            _currentElement =
                (_currentElement as LineElement).copyWith(points: _currentPoints);
          }
        }
        break;

      case ToolType.freedraw:
        _currentPoints.add(ElementPoint(position.dx, position.dy));

        final minX = _currentPoints.map((p) => p.x).reduce(math.min);
        final minY = _currentPoints.map((p) => p.y).reduce(math.min);
        final maxX = _currentPoints.map((p) => p.x).reduce(math.max);
        final maxY = _currentPoints.map((p) => p.y).reduce(math.max);

        _currentElement = (_currentElement as FreedrawElement).copyWith(
          x: minX,
          y: minY,
          width: maxX - minX,
          height: maxY - minY,
          points: _currentPoints,
        );
        break;

      default:
        break;
    }

    notifyListeners();
  }

  void finishDrawing() {
    if (_currentElement != null) {
      _elements.add(_currentElement!);
      _currentElement = null;
      _currentPoints.clear();
      _pushHistory();
      notifyListeners();
    }
  }

  // History methods
  void undo() {
    if (_historyIndex > 0) {
      _historyIndex--;
      _elements.clear();
      _elements.addAll(
        _history[_historyIndex].map((e) => e).toList(),
      );
      notifyListeners();
    }
  }

  void redo() {
    if (_historyIndex < _history.length - 1) {
      _historyIndex++;
      _elements.clear();
      _elements.addAll(
        _history[_historyIndex].map((e) => e).toList(),
      );
      notifyListeners();
    }
  }

  bool get canUndo => _historyIndex > 0;
  bool get canRedo => _historyIndex < _history.length - 1;

  void _pushHistory() {
    // Remove any history after current index
    if (_historyIndex < _history.length - 1) {
      _history.removeRange(_historyIndex + 1, _history.length);
    }

    // Add current state to history
    _history.add(_elements.map((e) => e).toList());
    _historyIndex = _history.length - 1;

    // Limit history size
    if (_history.length > 50) {
      _history.removeAt(0);
      _historyIndex--;
    }
  }

  FractionalIndex _generateIndex() {
    if (_elements.isEmpty) {
      return const FractionalIndex('a0');
    }
    return FractionalIndex.between(_elements.last.index, null);
  }

  // Clear canvas
  void clearCanvas() {
    _elements.clear();
    _selectedElementIds.clear();
    _currentElement = null;
    _currentPoints.clear();
    _pushHistory();
    notifyListeners();
  }

  // Load elements
  void loadElements(List<ExcalidrawElement> elements) {
    _elements.clear();
    _elements.addAll(elements);
    _pushHistory();
    notifyListeners();
  }
}
