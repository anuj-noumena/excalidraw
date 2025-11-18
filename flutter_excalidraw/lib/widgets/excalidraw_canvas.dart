import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../rendering/element_painter.dart';
import '../utils/math_utils.dart';

class ExcalidrawCanvas extends StatefulWidget {
  const ExcalidrawCanvas({Key? key}) : super(key: key);

  @override
  State<ExcalidrawCanvas> createState() => _ExcalidrawCanvasState();
}

class _ExcalidrawCanvasState extends State<ExcalidrawCanvas> {
  Offset? _lastPanPosition;
  bool _isPanning = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return GestureDetector(
          onPanStart: (details) => _handlePanStart(details, appState),
          onPanUpdate: (details) => _handlePanUpdate(details, appState),
          onPanEnd: (details) => _handlePanEnd(details, appState),
          onScaleStart: (details) => _handleScaleStart(details, appState),
          onScaleUpdate: (details) => _handleScaleUpdate(details, appState),
          child: Listener(
            onPointerSignal: (event) {
              if (event is PointerScrollEvent) {
                _handleScroll(event, appState);
              }
            },
            child: CustomPaint(
              painter: CanvasPainter(appState),
              size: Size.infinite,
              child: Container(),
            ),
          ),
        );
      },
    );
  }

  void _handlePanStart(DragStartDetails details, AppState appState) {
    _lastPanPosition = details.localPosition;

    if (appState.activeTool == ToolType.hand) {
      _isPanning = true;
    } else if (appState.activeTool != ToolType.selection) {
      final scenePos = MathUtils.viewportToScene(
        details.localPosition,
        appState.scrollOffset,
        appState.zoom,
      );
      appState.startDrawing(scenePos);
    }
  }

  void _handlePanUpdate(DragUpdateDetails details, AppState appState) {
    if (_isPanning) {
      final delta = details.localPosition - _lastPanPosition!;
      appState.pan(delta / appState.zoom);
      _lastPanPosition = details.localPosition;
    } else if (appState.activeTool != ToolType.selection &&
        appState.activeTool != ToolType.hand) {
      final scenePos = MathUtils.viewportToScene(
        details.localPosition,
        appState.scrollOffset,
        appState.zoom,
      );
      appState.updateDrawing(scenePos);
    }
  }

  void _handlePanEnd(DragEndDetails details, AppState appState) {
    _isPanning = false;
    _lastPanPosition = null;

    if (appState.activeTool != ToolType.selection &&
        appState.activeTool != ToolType.hand) {
      appState.finishDrawing();
    }
  }

  void _handleScaleStart(ScaleStartDetails details, AppState appState) {
    _lastPanPosition = details.localFocalPoint;
  }

  void _handleScaleUpdate(ScaleUpdateDetails details, AppState appState) {
    if (details.scale != 1.0) {
      // Pinch to zoom
      final newZoom = appState.zoom * details.scale;
      appState.setZoom(newZoom);
    }
  }

  void _handleScroll(PointerScrollEvent event, AppState appState) {
    // Scroll to zoom
    final delta = event.scrollDelta.dy;
    final zoomFactor = delta > 0 ? 0.9 : 1.1;
    appState.setZoom(appState.zoom * zoomFactor);
  }
}

class CanvasPainter extends CustomPainter {
  final AppState appState;

  CanvasPainter(this.appState) : super(repaint: appState);

  @override
  void paint(Canvas canvas, Size size) {
    // Fill background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.white,
    );

    // Apply transformations
    canvas.save();
    canvas.scale(appState.zoom);
    canvas.translate(appState.scrollOffset.dx, appState.scrollOffset.dy);

    // Draw grid if enabled
    if (appState.showGrid) {
      _drawGrid(canvas, size);
    }

    // Draw all elements
    final painter = ElementPainter(canvas, appState.zoom);
    for (final element in appState.elements) {
      painter.paintElement(element);

      // Highlight selected elements
      if (appState.selectedElementIds.contains(element.id)) {
        _drawSelectionBox(canvas, element);
      }
    }

    // Draw current element being created
    if (appState.currentElement != null) {
      painter.paintElement(appState.currentElement!);
    }

    canvas.restore();
  }

  void _drawGrid(Canvas canvas, Size size) {
    const gridSize = 20.0;
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1;

    final viewportSize = size / appState.zoom;
    final startX = (appState.scrollOffset.dx / gridSize).floor() * gridSize;
    final startY = (appState.scrollOffset.dy / gridSize).floor() * gridSize;

    for (double x = startX;
        x < startX + viewportSize.width + gridSize;
        x += gridSize) {
      canvas.drawLine(
        Offset(x, startY),
        Offset(x, startY + viewportSize.height + gridSize),
        paint,
      );
    }

    for (double y = startY;
        y < startY + viewportSize.height + gridSize;
        y += gridSize) {
      canvas.drawLine(
        Offset(startX, y),
        Offset(startX + viewportSize.width + gridSize, y),
        paint,
      );
    }
  }

  void _drawSelectionBox(Canvas canvas, element) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2 / appState.zoom
      ..style = PaintingStyle.stroke;

    final rect = Rect.fromLTWH(
      element.x,
      element.y,
      element.width,
      element.height,
    );

    canvas.drawRect(rect, paint);

    // Draw resize handles
    const handleSize = 8.0;
    final handlePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final handles = [
      rect.topLeft,
      rect.topCenter,
      rect.topRight,
      rect.centerLeft,
      rect.centerRight,
      rect.bottomLeft,
      rect.bottomCenter,
      rect.bottomRight,
    ];

    for (final handle in handles) {
      canvas.drawCircle(
        handle,
        handleSize / appState.zoom,
        handlePaint,
      );
    }
  }

  @override
  bool shouldRepaint(CanvasPainter oldDelegate) => true;
}
