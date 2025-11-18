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
- 🔄 **Element Rotation** - Rotate elements with rotation handles
- 📋 **Copy/Paste/Cut** - Full clipboard support
- 📑 **Duplicate** - Quickly duplicate selected elements

### Advanced Features
- 🗂️ **Grouping** - Group and ungroup elements (Ctrl+G / Ctrl+Shift+G)
- 🔒 **Lock/Unlock** - Lock elements to prevent modification (Ctrl+L)
- 📚 **Layer Control** - Bring to front, send to back, and layer reordering
- ⌨️ **Keyboard Shortcuts** - Comprehensive keyboard shortcut system
- 🖱️ **Context Menu** - Right-click context menu with common operations
- 🖼️ **Image Support** - Insert and manipulate images (basic support)

### File Management & Export
- 💾 **Save** - Export to .excalidraw format
- 📂 **Load** - Import .excalidraw files
- 🖼️ **PNG Export** - Export drawings as PNG images
- 📄 **SVG Export** - Export drawings as scalable SVG files
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

#### Tool Selection
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

#### Editing
| Key | Action |
|-----|--------|
| `Delete` or `Backspace` | Delete selected |
| `Escape` | Clear selection |
| `Ctrl+Z` | Undo |
| `Ctrl+Y` or `Ctrl+Shift+Z` | Redo |

#### Clipboard
| Key | Action |
|-----|--------|
| `Ctrl+C` | Copy selected |
| `Ctrl+X` | Cut selected |
| `Ctrl+V` | Paste |
| `Ctrl+D` | Duplicate selected |

#### Selection
| Key | Action |
|-----|--------|
| `Ctrl+A` | Select all |

#### Grouping & Locking
| Key | Action |
|-----|--------|
| `Ctrl+G` | Group selected |
| `Ctrl+Shift+G` | Ungroup selected |
| `Ctrl+L` | Lock/Unlock selected |

#### Layer Ordering
| Key | Action |
|-----|--------|
| `Ctrl+]` | Bring forward |
| `Ctrl+[` | Send backward |
| `Ctrl+Shift+]` | Bring to front |
| `Ctrl+Shift+[` | Send to back |

#### Zoom
| Key | Action |
|-----|--------|
| `Ctrl++` or `Ctrl+=` | Zoom in |
| `Ctrl+-` | Zoom out |
| `Ctrl+0` | Reset zoom to 100% |

### File Operations

**Save Drawing:**
1. Click the save icon in the app bar
2. File is saved to documents directory

**Load Drawing:**
1. Click the open folder icon
2. Select a .excalidraw file
3. Drawing loads into canvas

### Advanced Features

**Text Editing:**
- Click text tool and click on canvas
- Opens advanced text editor dialog
- Supports font selection (Virgil, Helvetica, Cascadia)
- Font sizes from 12-48px
- Text color picker
- Bold, italic, underline formatting
- Text alignment (left, center, right)

**Lasso Selection:**
- Select lasso tool
- Draw freeform selection around elements
- Automatically selects all enclosed elements
- Works with complex element arrangements

**Snap Guides:**
- Automatically enabled when moving elements
- Shows alignment guides for:
  - Center-to-center alignment
  - Edge-to-edge alignment
  - Equal spacing
- Purple guide lines appear when aligned
- Snaps within 8px threshold

**Arrow Binding:**
- Draw arrows near element edges
- Arrows automatically bind to shapes
- Bound arrows move with attached elements
- Supports gap and focus parameters
- Visual feedback when binding

**Frames:**
- Use frame tool to create containers
- Group elements visually
- Magic frames for AI-powered organization
- Named frames for better organization
- Child elements tracked automatically

**Library:**
- Save frequently used element groups
- Create reusable templates
- Search and sort library items
- Thumbnails for quick identification
- Import/export library collections

**Collaboration:**
- Real-time multiplayer editing
- WebSocket-based sync
- See collaborator cursors
- View other users' selections
- Conflict resolution for concurrent edits
- Automatic element synchronization

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

- All basic drawing tools (rectangle, diamond, ellipse, arrow, line, freehand, text)
- Hand-drawn rendering style with configurable roughness
- Fill patterns (hachure, cross-hatch, solid, zigzag) and stroke styles
- Customizable appearance (colors, stroke width, opacity)
- Zoom and pan with keyboard shortcuts
- Undo/redo with 50-step history
- File export/import (.excalidraw format)
- PNG and SVG export
- Selection system with multi-select
- Grid view
- Element rotation with rotation state management
- Copy/paste/cut/duplicate operations
- Grouping and ungrouping elements
- Layer ordering (bring to front, send to back, etc.)
- Lock/unlock elements
- Comprehensive keyboard shortcuts
- Context menu support
- Image elements (basic support)
- **Advanced text editing** with formatting (bold, italic, underline, fonts, sizes, colors)
- **Lasso selection** for freeform element selection
- **Snap-to-element guides** for smart alignment
- **Arrow element binding** to connect arrows to shapes
- **Frames and magic frames** for grouping and organizing
- **Library items system** for reusable templates
- **Real-time collaboration** with WebSocket support

### Not Yet Implemented ⏳

- Text containers and bound text (advanced)
- Embedding external content (iframes, embeddables)
- Advanced image manipulation (cropping, filters)
- Custom fonts upload
- Presentation mode
- Comments and annotations
- Version history
- Cloud storage integration

## Future Enhancements

1. **Text Containers** - Advanced bound text to shapes
2. **Presentation Mode** - Full-screen presentation with slides
3. **Comments & Annotations** - Collaborative commenting system
4. **Version History** - Time-travel through drawing history
5. **Cloud Storage** - Automatic sync with cloud services
6. **Advanced Image Features** - Cropping, filters, effects
7. **Custom Fonts** - Upload and use custom fonts
8. **Mobile Optimization** - Touch-optimized UI for tablets
9. **Accessibility** - Screen reader support and WCAG compliance
10. **Embedding** - iframe and external content support

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
