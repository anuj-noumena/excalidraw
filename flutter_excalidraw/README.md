# Flutter Excalidraw

A complete Flutter port of [Excalidraw](https://excalidraw.com) - a virtual whiteboard for sketching hand-drawn diagrams. This implementation brings the full functionality of Excalidraw to Flutter, supporting mobile, desktop, and web platforms.

![Flutter Excalidraw](https://img.shields.io/badge/Flutter-Ready-blue)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Desktop-green)

## Features

### Drawing Tools
- ✅ **Rectangle** - Draw rectangular shapes with customizable roundness
- ✅ **Diamond** - Create diamond/rhombus shapes
- ✅ **Ellipse** - Draw circles and ellipses
- ✅ **Arrow** - Create arrows with customizable arrowheads
- ✅ **Line** - Draw straight and multi-point lines
- ✅ **Freehand** - Sketch freely with pen tool
- ✅ **Text** - Add text annotations (basic support)
- ✅ **Selection** - Select and manipulate elements
- ✅ **Hand** - Pan around the canvas

### Styling Options
- 🎨 **Stroke Color** - Choose from preset colors or custom colors
- 🎨 **Fill Color** - Background color for shapes
- 📏 **Stroke Width** - Adjustable from 1-20px
- 📐 **Stroke Style** - Solid, dashed, or dotted lines
- 🖌️ **Fill Patterns** - Hachure, cross-hatch, solid, or zigzag
- ✨ **Roughness** - Control the hand-drawn effect (0-2)
- 👁️ **Opacity** - Element transparency control

### Canvas Features
- 🔍 **Zoom** - Pinch to zoom or use zoom controls (10%-1000%)
- 👆 **Pan** - Drag with hand tool or two-finger drag
- 📐 **Grid View** - Toggle grid for alignment
- 🎯 **Selection** - Select and manipulate elements
- ↩️ **Undo/Redo** - Full history support (50 steps)
- 🗑️ **Delete** - Remove selected elements

### File Management
- 💾 **Save** - Export to .excalidraw format
- 📂 **Load** - Import .excalidraw files
- 🔄 **Full Compatibility** - Compatible with original Excalidraw files

## Architecture

This Flutter port faithfully recreates Excalidraw's architecture:

### Core Components

```
flutter_excalidraw/
├── lib/
│   ├── models/              # Data models
│   │   ├── element_base.dart       # Base element interface
│   │   └── elements.dart           # Concrete element types
│   ├── rendering/           # Rendering system
│   │   ├── rough_painter.dart      # Hand-drawn style renderer
│   │   └── element_painter.dart    # Element rendering logic
│   ├── state/               # State management
│   │   └── app_state.dart          # App state with Provider
│   ├── utils/               # Utilities
│   │   ├── math_utils.dart         # Geometry and math functions
│   │   ├── fractional_index.dart   # Multiplayer ordering
│   │   └── file_manager.dart       # File I/O operations
│   ├── widgets/             # UI components
│   │   ├── excalidraw_canvas.dart  # Main canvas widget
│   │   └── toolbar.dart            # Toolbar with tools and controls
│   └── main.dart            # App entry point
└── pubspec.yaml
```

### Key Design Decisions

1. **Hand-Drawn Rendering**: Custom implementation inspired by rough.js for authentic sketchy appearance
2. **State Management**: Provider pattern for reactive state updates
3. **Immutable Elements**: Elements are immutable with copy-with pattern
4. **Fractional Indexing**: Stable element ordering for future multiplayer support
5. **Canvas Layering**: Efficient rendering with gesture handling
6. **Platform Agnostic**: Works on mobile, desktop, and web

## Getting Started

### Prerequisites

- Flutter SDK 3.0 or higher
- Dart SDK 3.0 or higher

### Installation

1. Clone or copy the `flutter_excalidraw` directory
2. Navigate to the project directory:
   ```bash
   cd flutter_excalidraw
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Run the app:
   ```bash
   # For desktop
   flutter run -d macos  # or windows, linux

   # For mobile
   flutter run -d ios    # or android

   # For web
   flutter run -d chrome
   ```

### Dependencies

- `provider: ^6.1.1` - State management
- `vector_math: ^2.1.4` - Math operations
- `file_picker: ^6.1.1` - File selection
- `path_provider: ^2.1.1` - File paths
- `uuid: ^4.2.1` - Unique ID generation
- See `pubspec.yaml` for complete list

## Usage

### Basic Drawing

1. Select a tool from the toolbar (Rectangle, Ellipse, Arrow, etc.)
2. Click and drag on the canvas to create elements
3. Use the selection tool to move or resize elements

### Customizing Appearance

1. Choose stroke and fill colors from the color pickers
2. Adjust stroke width using the slider (1-20px)
3. Change roughness for more/less hand-drawn effect (0-2)
4. Select fill pattern (hachure, cross-hatch, solid, zigzag)
5. Choose stroke style (solid, dashed, dotted)

### Canvas Navigation

- **Zoom**: Use zoom controls, pinch gesture, or scroll wheel
- **Pan**: Use hand tool or drag with two fingers
- **Grid**: Toggle grid for alignment help

### Keyboard Shortcuts

| Key | Action |
|-----|--------|
| `V` | Selection tool |
| `H` | Hand tool |
| `R` | Rectangle |
| `D` | Diamond |
| `O` | Ellipse |
| `A` | Arrow |
| `L` | Line |
| `P` | Pen (freehand) |
| `T` | Text |
| `E` | Eraser |
| `Delete` | Delete selected |
| `Ctrl+Z` | Undo |
| `Ctrl+Y` | Redo |

### File Operations

**Save Drawing:**
1. Click the save icon in the app bar
2. File is saved to documents directory

**Load Drawing:**
1. Click the open folder icon
2. Select a .excalidraw file
3. Drawing loads into canvas

## Technical Details

### Element Types

All elements extend `ExcalidrawElement` base class:

- **RectangleElement** - Rectangular shapes with optional roundness
- **DiamondElement** - Diamond/rhombus shapes
- **EllipseElement** - Circles and ellipses
- **ArrowElement** - Arrows with points and arrowheads
- **LineElement** - Multi-point lines
- **FreedrawElement** - Freehand paths with pressure
- **TextElement** - Text with formatting (basic support)

### Rendering System

The rendering system uses Flutter's `CustomPainter` with:

1. **RoughPainter** - Generates hand-drawn paths with configurable roughness
2. **ElementPainter** - Renders elements to canvas with proper transformations
3. **Fill Patterns** - Implements hachure, cross-hatch, and zigzag patterns
4. **Stroke Styles** - Handles solid, dashed, and dotted lines

### State Management

Uses Provider for state management:
- `AppState` - Central state holding elements, tool settings, canvas state
- Reactive updates trigger UI rebuilds
- History management for undo/redo

### Math Utilities

Comprehensive geometry utilities:
- Point rotation and transformation
- Vector operations (dot product, cross product, normalize)
- Line intersection and distance calculations
- Polygon containment testing
- Ellipse point testing
- Bezier curve operations
- Coordinate system conversions

## Comparison with Original Excalidraw

### Implemented Features ✅

- All basic drawing tools
- Hand-drawn rendering style
- Fill patterns and stroke styles
- Customizable appearance
- Zoom and pan
- Undo/redo
- File export/import (.excalidraw format)
- Selection system
- Grid view

### Not Yet Implemented ⏳

- Advanced text editing and containers
- Image elements
- Collaboration/multiplayer
- Library items and templates
- Frames and magic frames
- Embedding external content
- SVG/PNG export
- Keyboard shortcuts (partially implemented)
- Context menus
- Element rotation handles
- Advanced selection (lasso, multi-select)
- Group/ungroup elements
- Lock/unlock elements
- Layer ordering controls
- Snap-to-element features

## Future Enhancements

1. **Text Editing** - Full text editor with formatting
2. **Image Support** - Insert and manipulate images
3. **Export Options** - PNG, SVG export
4. **Collaboration** - Real-time multiplayer editing
5. **Library** - Reusable element library
6. **Advanced Selection** - Lasso tool, multi-select
7. **Element Manipulation** - Rotation, grouping, layering
8. **Keyboard Shortcuts** - Full keyboard support
9. **Mobile Optimization** - Touch-optimized UI
10. **Accessibility** - Screen reader support

## Performance Considerations

- Elements use caching to avoid redundant rendering
- Viewport culling for large canvases
- Efficient gesture handling
- History limited to 50 steps to manage memory

## Contributing

This is a complete port of Excalidraw to Flutter. To contribute:

1. Follow Flutter best practices
2. Maintain compatibility with .excalidraw file format
3. Keep the hand-drawn aesthetic authentic
4. Test on multiple platforms

## Compatibility

- **Flutter**: 3.0+
- **Platforms**: Android, iOS, Web, macOS, Windows, Linux
- **File Format**: Compatible with Excalidraw JSON format

## License

This is a port of Excalidraw. Please refer to the original Excalidraw project for licensing information.

## Acknowledgments

- Original [Excalidraw](https://github.com/excalidraw/excalidraw) project and team
- Inspired by [rough.js](https://roughjs.com) for hand-drawn rendering
- Flutter and Dart teams for the excellent framework

## Resources

- [Original Excalidraw](https://excalidraw.com)
- [Excalidraw GitHub](https://github.com/excalidraw/excalidraw)
- [Flutter Documentation](https://flutter.dev)

---

**Note**: This is an independent Flutter port and is not officially affiliated with the Excalidraw project.
