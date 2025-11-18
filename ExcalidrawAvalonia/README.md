# Excalidraw Avalonia

A comprehensive port of [Excalidraw](https://excalidraw.com) to Avalonia UI, bringing the hand-drawn whiteboard experience to cross-platform desktop applications.

## Features

### Core Drawing Tools
- **Rectangle** - Create rectangular shapes with customizable properties
- **Diamond** - Draw diamond/rhombus shapes
- **Ellipse** - Create circular and elliptical shapes
- **Arrow** - Draw arrows with customizable arrowheads
- **Line** - Create straight lines
- **FreeDraw** - Freehand drawing with pressure sensitivity support
- **Text** - Add text elements with various fonts and alignments
- **Frame** - Create organizational frames to group elements

### Hand-Drawn Aesthetic
- Powered by SkiaSharp for high-performance rendering
- Rough.js-inspired hand-drawn look and feel
- Customizable roughness levels for each element
- Multiple fill styles: Hachure, Cross-Hatch, Solid, Zigzag

### Element Properties
- **Stroke Color** - Customizable outline color
- **Background Color** - Fill color with transparency support
- **Stroke Width** - Adjustable line thickness
- **Stroke Style** - Solid, dashed, or dotted lines
- **Opacity** - Per-element transparency
- **Roughness** - Control the hand-drawn aesthetic intensity
- **Roundness** - Rounded corners for rectangles

### Editing Capabilities
- **Selection Tool** - Click to select and move elements
- **Multi-Selection** - Select multiple elements
- **Resize** - Drag handles to resize elements
- **Rotate** - Rotate elements around their center
- **Delete** - Remove selected elements
- **Undo/Redo** - Full history support with 100-level depth

### Export Options
- **PNG** - Export as raster image
- **SVG** - Export as scalable vector graphics
- **JSON** - Save/load in Excalidraw-compatible format

### Canvas Controls
- **Pan** - Middle-click or Shift+drag to pan the canvas
- **Zoom** - Ctrl+Scroll to zoom in/out (10%-500%)
- **Grid** - Optional grid overlay for alignment

## Architecture

### Project Structure

```
ExcalidrawAvalonia/
├── ExcalidrawAvalonia.Core/          # Core library (platform-independent)
│   ├── Models/                        # Element data models
│   │   ├── ExcalidrawElement.cs      # Base element class
│   │   └── ElementTypes.cs            # Specific element types
│   ├── State/                         # State management
│   │   ├── Scene.cs                   # Element collection manager
│   │   ├── AppState.cs                # Application state
│   │   └── History.cs                 # Undo/redo management
│   ├── Rendering/                     # Rendering engine
│   │   └── RoughRenderer.cs           # Skia-based renderer
│   ├── Utils/                         # Utilities
│   │   └── ElementFactory.cs          # Element creation
│   └── Export/                        # Export functionality
│       └── Exporter.cs                # PNG/SVG/JSON export
└── ExcalidrawAvalonia/               # Avalonia UI application
    ├── Views/                         # UI views
    │   └── MainWindow.axaml           # Main window
    ├── ViewModels/                    # View models (MVVM)
    │   └── MainWindowViewModel.cs     # Main view model
    └── Controls/                      # Custom controls
        └── DrawingCanvas.cs           # Interactive canvas

```

### Key Design Patterns

#### Immutable Elements
Elements use C# records for immutability, making undo/redo trivial and preventing bugs from shared mutable state.

```csharp
public record RectangleElement : ExcalidrawElement
{
    public override ExcalidrawElement WithUpdates(Action<ElementBuilder> configure) { ... }
}
```

#### Observable Scene
The `Scene` class uses the observer pattern to notify UI of changes:

```csharp
scene.Subscribe(change => {
    // Automatically triggers re-render
});
```

#### Versioned Updates
Every element mutation increments a `version` counter and regenerates a `versionNonce` for collaborative conflict resolution (future feature).

#### Skia Rendering
Uses SkiaSharp for high-performance, hand-drawn rendering:
- Path caching for performance
- Roughness simulation with randomized offsets
- Support for complex fill patterns

## Building & Running

### Prerequisites
- .NET 8.0 SDK or later
- Visual Studio 2022 / JetBrains Rider / VS Code

### Build
```bash
cd ExcalidrawAvalonia
dotnet build
```

### Run
```bash
dotnet run --project ExcalidrawAvalonia/ExcalidrawAvalonia.csproj
```

## Keyboard Shortcuts

### Tools
- `V` - Selection tool
- `H` - Hand tool (pan)
- `R` - Rectangle
- `D` - Diamond
- `E` - Ellipse
- `A` - Arrow
- `L` - Line
- `P` - Pen (FreeDraw)
- `T` - Text

### Actions
- `Ctrl+N` - New canvas
- `Ctrl+O` - Open file
- `Ctrl+S` - Save file
- `Ctrl+Z` - Undo
- `Ctrl+Y` - Redo
- `Delete` / `Backspace` - Delete selected elements
- `Ctrl+Scroll` - Zoom in/out
- `Middle Click + Drag` - Pan canvas
- `Shift + Drag` - Pan canvas (alternative)

## Differences from Original Excalidraw

This is a comprehensive port focused on desktop usage with Avalonia UI:

### Implemented
✅ All core drawing tools
✅ Hand-drawn aesthetic with roughness
✅ Element properties (stroke, fill, opacity, etc.)
✅ Undo/Redo
✅ Export to PNG, SVG, JSON
✅ Keyboard shortcuts
✅ Pan and zoom

### Not Yet Implemented
⏳ Collaboration (multiplayer)
⏳ Library system
⏳ Image elements
⏳ Embedded content
⏳ Mobile touch support
⏳ Cloud sync

### Avalonia-Specific Features
- Native desktop performance
- Cross-platform (Windows, macOS, Linux)
- MVVM architecture with ReactiveUI
- File system integration

## Technology Stack

- **UI Framework**: Avalonia UI 11.x
- **Rendering**: SkiaSharp 2.88.x
- **Architecture**: MVVM with ReactiveUI
- **Language**: C# 12 / .NET 8.0
- **State Management**: Immutable records + Observer pattern

## Inspiration & Credits

This project is inspired by and based on the architecture of:
- [Excalidraw](https://excalidraw.com) - The original web-based whiteboard
- [Rough.js](https://roughjs.com) - Hand-drawn graphics library
- Avalonia UI community for cross-platform .NET

## License

MIT License - see original Excalidraw project for licensing details

## Contributing

This is a port project demonstrating Avalonia UI capabilities. Contributions welcome for:
- Performance optimizations
- Additional tools and features
- Bug fixes
- Documentation improvements

## Roadmap

### Phase 1 (Current)
- [x] Core element types
- [x] Basic rendering engine
- [x] Drawing tools
- [x] Undo/Redo
- [x] Export functionality

### Phase 2 (Planned)
- [ ] Transform handles for resize/rotate
- [ ] Multi-selection with bounding box
- [ ] Grouping and z-order management
- [ ] Improved text editing (WYSIWYG)
- [ ] Color picker UI

### Phase 3 (Future)
- [ ] Library system
- [ ] Image support
- [ ] Collaboration features
- [ ] Plugin system
- [ ] Performance optimizations

---

**Note**: This is a demonstration project showing how to port a complex web application (React/Canvas) to Avalonia UI using modern C# and Skia for rendering.
