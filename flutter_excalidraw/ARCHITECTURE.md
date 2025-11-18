# Flutter Excalidraw - Architecture Documentation

This document explains the architecture of the Flutter Excalidraw port and how it maps to the original Excalidraw implementation.

## Overview

Flutter Excalidraw is a faithful port of the original Excalidraw application, translating its React/TypeScript architecture to Flutter/Dart while maintaining the same core concepts and functionality.

## Architecture Comparison

### Original Excalidraw

```
Excalidraw (React)
├── packages/excalidraw/        # Core library
│   ├── element/                # Element operations
│   ├── scene/                  # Scene management
│   ├── renderer/               # Canvas rendering
│   ├── types.ts                # TypeScript types
│   └── App.tsx                 # Main component
├── packages/math/              # Math utilities
├── packages/utils/             # Common utilities
└── excalidraw-app/             # Web application
```

### Flutter Port

```
flutter_excalidraw/
├── lib/
│   ├── models/                 # = packages/element/types
│   ├── rendering/              # = packages/excalidraw/renderer
│   ├── state/                  # = React state + Jotai
│   ├── utils/                  # = packages/math + packages/utils
│   ├── widgets/                # = React components
│   └── main.dart               # = App.tsx
```

## Core Systems

### 1. Element System

**Original (TypeScript):**
```typescript
interface ExcalidrawElement {
  id: string;
  x: number;
  y: number;
  // ... properties
}

type ExcalidrawRectangleElement = ExcalidrawElement & {
  type: "rectangle";
};
```

**Flutter (Dart):**
```dart
abstract class ExcalidrawElement {
  final String id;
  final double x;
  final double y;
  // ... properties

  ElementType get type;
}

class RectangleElement extends ExcalidrawElement {
  @override
  ElementType get type => ElementType.rectangle;
}
```

**Key Differences:**
- TypeScript uses union types and intersection types
- Dart uses abstract classes and concrete implementations
- Both maintain immutability (readonly in TS, final in Dart)

### 2. Rendering System

**Original (rough.js + Canvas 2D):**
```javascript
// Uses rough.js library
const rc = rough.canvas(canvas);
rc.rectangle(x, y, width, height, {
  roughness: 1,
  stroke: '#000',
  fill: '#fff',
  fillStyle: 'hachure',
});
```

**Flutter (CustomPainter):**
```dart
class RoughPainter {
  Path drawRectangle(double x, double y, double width, double height) {
    // Custom implementation of rough.js algorithm
    final path = Path();
    // Add roughness to path
    return path;
  }
}
```

**Implementation:**
- Original uses rough.js library (4.6.4)
- Flutter implements hand-drawn algorithm from scratch
- Both produce visually similar results with randomized roughness

### 3. State Management

**Original (Jotai):**
```typescript
// Atomic state management
const elementsAtom = atom<ExcalidrawElement[]>([]);
const selectedIdsAtom = atom<Set<string>>(new Set());
```

**Flutter (Provider):**
```dart
class AppState extends ChangeNotifier {
  final List<ExcalidrawElement> _elements = [];
  final Set<String> _selectedElementIds = {};

  void addElement(ExcalidrawElement element) {
    _elements.add(element);
    notifyListeners();
  }
}
```

**Comparison:**
- Original uses Jotai for atomic state
- Flutter uses Provider (ChangeNotifier) for reactive state
- Both provide reactive updates to UI
- Both support derived state and computed values

### 4. Canvas and Gestures

**Original (React Events):**
```typescript
<canvas
  onPointerDown={handlePointerDown}
  onPointerMove={handlePointerMove}
  onPointerUp={handlePointerUp}
  onWheel={handleWheel}
/>
```

**Flutter (GestureDetector):**
```dart
GestureDetector(
  onPanStart: _handlePanStart,
  onPanUpdate: _handlePanUpdate,
  onPanEnd: _handlePanEnd,
  child: CustomPaint(
    painter: CanvasPainter(appState),
  ),
)
```

**Differences:**
- React uses pointer events (standardized across browsers)
- Flutter uses gesture recognizers (unified across platforms)
- Flutter has better built-in gesture composition

### 5. Math Utilities

Both implementations share similar math operations:

**Point Rotation:**
```typescript
// Original
function rotatePoint(point: Point, center: Point, angle: number): Point {
  const cos = Math.cos(angle);
  const sin = Math.sin(angle);
  // ... rotation matrix
}
```

```dart
// Flutter
static Offset rotatePoint(Offset point, Offset center, double angle) {
  final cos = math.cos(angle);
  final sin = math.sin(angle);
  // ... rotation matrix
}
```

The algorithms are identical, only syntax differs.

### 6. File Format

Both use the same JSON format:

```json
{
  "type": "excalidraw",
  "version": 2,
  "source": "flutter_excalidraw",
  "elements": [
    {
      "type": "rectangle",
      "id": "uuid",
      "x": 100,
      "y": 100,
      "width": 200,
      "height": 150,
      "strokeColor": "#000000",
      "backgroundColor": "#ffffff",
      "fillStyle": "hachure",
      "strokeWidth": 2,
      "roughness": 1,
      // ... more properties
    }
  ],
  "appState": {
    "viewBackgroundColor": "#ffffff",
    "gridSize": 20
  }
}
```

**Compatibility:**
- Files are 100% compatible between versions
- Flutter can load files created in web Excalidraw
- Web Excalidraw can load files created in Flutter version

## Key Features Mapping

| Feature | Original Excalidraw | Flutter Port |
|---------|-------------------|--------------|
| **Elements** | TypeScript union types | Dart class hierarchy |
| **Rendering** | rough.js + Canvas 2D | Custom rough algorithm + Flutter Canvas |
| **State** | Jotai atoms | Provider ChangeNotifier |
| **History** | Delta-based | Full snapshot (simplified) |
| **Gestures** | Pointer events | Gesture detectors |
| **File I/O** | Browser APIs | File picker + path provider |
| **Math** | Shared algorithms | Ported to Dart |

## Design Patterns

### Immutability

**Original:**
```typescript
const newElement = {
  ...element,
  x: newX,
  y: newY,
};
```

**Flutter:**
```dart
final newElement = element.copyWith(
  x: newX,
  y: newY,
);
```

Both enforce immutability for predictable state updates.

### Factory Pattern

**Element Creation:**
```dart
class ElementFactory {
  static ExcalidrawElement create(ToolType tool, /* params */) {
    switch (tool) {
      case ToolType.rectangle:
        return RectangleElement(/* ... */);
      case ToolType.ellipse:
        return EllipseElement(/* ... */);
      // ...
    }
  }
}
```

### Observer Pattern

**State Updates:**
```dart
class AppState extends ChangeNotifier {
  void updateElement(String id, ExcalidrawElement element) {
    // Update element
    notifyListeners(); // Notify observers
  }
}
```

## Performance Optimizations

### Original Excalidraw
- WeakMap for shape caching
- Canvas layering (3 canvases: static, interactive, temporary)
- Viewport culling
- Throttled rendering (requestAnimationFrame)

### Flutter Port
- Widget rebuild optimization via Provider
- Single CustomPainter with efficient shouldRepaint
- Canvas save/restore for transformations
- Viewport-aware rendering

## Future Architecture Improvements

1. **Delta-based History**: Implement like original for better memory efficiency
2. **Canvas Layering**: Split into multiple CustomPaint widgets
3. **Element Caching**: Cache rendered paths for complex elements
4. **Offscreen Rendering**: Use RenderRepaintBoundary for optimization
5. **Web Workers Equivalent**: Use Isolates for heavy computations

## Testing Strategy

### Unit Tests
- Math utilities
- Element operations
- State management
- File parsing

### Widget Tests
- Toolbar interactions
- Canvas gestures
- Color pickers

### Integration Tests
- Full drawing workflows
- File save/load
- Undo/redo

## Platform Considerations

### Mobile (iOS/Android)
- Touch-optimized UI
- Larger tap targets
- Gesture conflicts resolution
- File storage in app documents

### Desktop (macOS/Windows/Linux)
- Keyboard shortcuts
- Menu bar integration
- Mouse wheel zoom
- File dialogs

### Web
- Responsive layout
- Browser file downloads
- Clipboard integration
- URL state persistence

## Conclusion

The Flutter port maintains architectural fidelity to the original Excalidraw while adapting to Flutter's patterns and best practices. The core algorithms, data structures, and file formats remain compatible, ensuring a consistent experience across platforms.
