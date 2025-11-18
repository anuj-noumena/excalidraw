import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/element_base.dart';

class Toolbar extends StatelessWidget {
  const Toolbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Tool selection
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ToolButton(
                    icon: Icons.near_me,
                    tooltip: 'Selection',
                    isSelected: appState.activeTool == ToolType.selection,
                    onPressed: () => appState.setActiveTool(ToolType.selection),
                  ),
                  _ToolButton(
                    icon: Icons.pan_tool,
                    tooltip: 'Hand',
                    isSelected: appState.activeTool == ToolType.hand,
                    onPressed: () => appState.setActiveTool(ToolType.hand),
                  ),
                  const SizedBox(width: 8),
                  _ToolButton(
                    icon: Icons.square_outlined,
                    tooltip: 'Rectangle',
                    isSelected: appState.activeTool == ToolType.rectangle,
                    onPressed: () => appState.setActiveTool(ToolType.rectangle),
                  ),
                  _ToolButton(
                    icon: Icons.diamond_outlined,
                    tooltip: 'Diamond',
                    isSelected: appState.activeTool == ToolType.diamond,
                    onPressed: () => appState.setActiveTool(ToolType.diamond),
                  ),
                  _ToolButton(
                    icon: Icons.circle_outlined,
                    tooltip: 'Ellipse',
                    isSelected: appState.activeTool == ToolType.ellipse,
                    onPressed: () => appState.setActiveTool(ToolType.ellipse),
                  ),
                  _ToolButton(
                    icon: Icons.arrow_forward,
                    tooltip: 'Arrow',
                    isSelected: appState.activeTool == ToolType.arrow,
                    onPressed: () => appState.setActiveTool(ToolType.arrow),
                  ),
                  _ToolButton(
                    icon: Icons.remove,
                    tooltip: 'Line',
                    isSelected: appState.activeTool == ToolType.line,
                    onPressed: () => appState.setActiveTool(ToolType.line),
                  ),
                  _ToolButton(
                    icon: Icons.edit,
                    tooltip: 'Draw',
                    isSelected: appState.activeTool == ToolType.freedraw,
                    onPressed: () => appState.setActiveTool(ToolType.freedraw),
                  ),
                  _ToolButton(
                    icon: Icons.text_fields,
                    tooltip: 'Text',
                    isSelected: appState.activeTool == ToolType.text,
                    onPressed: () => appState.setActiveTool(ToolType.text),
                  ),
                  _ToolButton(
                    icon: Icons.delete_outline,
                    tooltip: 'Eraser',
                    isSelected: appState.activeTool == ToolType.eraser,
                    onPressed: () => appState.setActiveTool(ToolType.eraser),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Properties
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Stroke color
                  _ColorPicker(
                    label: 'Stroke',
                    color: appState.strokeColor,
                    onChanged: appState.setStrokeColor,
                  ),
                  const SizedBox(width: 8),
                  // Background color
                  _ColorPicker(
                    label: 'Fill',
                    color: appState.backgroundColor,
                    onChanged: appState.setBackgroundColor,
                  ),
                  const SizedBox(width: 8),
                  // Stroke width
                  SizedBox(
                    width: 120,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Width', style: TextStyle(fontSize: 12)),
                        Slider(
                          value: appState.strokeWidth,
                          min: 1,
                          max: 20,
                          divisions: 19,
                          label: appState.strokeWidth.toInt().toString(),
                          onChanged: appState.setStrokeWidth,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Roughness
                  SizedBox(
                    width: 120,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Roughness', style: TextStyle(fontSize: 12)),
                        Slider(
                          value: appState.roughness,
                          min: 0,
                          max: 2,
                          divisions: 20,
                          label: appState.roughness.toStringAsFixed(1),
                          onChanged: appState.setRoughness,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Stroke style
                  DropdownButton<StrokeStyle>(
                    value: appState.strokeStyle,
                    items: const [
                      DropdownMenuItem(
                        value: StrokeStyle.solid,
                        child: Text('Solid'),
                      ),
                      DropdownMenuItem(
                        value: StrokeStyle.dashed,
                        child: Text('Dashed'),
                      ),
                      DropdownMenuItem(
                        value: StrokeStyle.dotted,
                        child: Text('Dotted'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) appState.setStrokeStyle(value);
                    },
                  ),
                  const SizedBox(width: 8),
                  // Fill style
                  DropdownButton<FillStyle>(
                    value: appState.fillStyle,
                    items: const [
                      DropdownMenuItem(
                        value: FillStyle.hachure,
                        child: Text('Hachure'),
                      ),
                      DropdownMenuItem(
                        value: FillStyle.crossHatch,
                        child: Text('Cross-hatch'),
                      ),
                      DropdownMenuItem(
                        value: FillStyle.solid,
                        child: Text('Solid'),
                      ),
                      DropdownMenuItem(
                        value: FillStyle.zigzag,
                        child: Text('Zigzag'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) appState.setFillStyle(value);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Actions
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.undo),
                    tooltip: 'Undo',
                    onPressed: appState.canUndo ? appState.undo : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.redo),
                    tooltip: 'Redo',
                    onPressed: appState.canRedo ? appState.redo : null,
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    tooltip: 'Delete selected',
                    onPressed: appState.selectedElementIds.isNotEmpty
                        ? appState.deleteSelectedElements
                        : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.clear),
                    tooltip: 'Clear canvas',
                    onPressed: () => _showClearDialog(context, appState),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(
                      appState.showGrid ? Icons.grid_on : Icons.grid_off,
                    ),
                    tooltip: 'Toggle grid',
                    onPressed: appState.toggleGrid,
                  ),
                  const SizedBox(width: 8),
                  Text('Zoom: ${(appState.zoom * 100).toInt()}%'),
                  IconButton(
                    icon: const Icon(Icons.zoom_out),
                    tooltip: 'Zoom out',
                    onPressed: () => appState.setZoom(appState.zoom * 0.8),
                  ),
                  IconButton(
                    icon: const Icon(Icons.zoom_in),
                    tooltip: 'Zoom in',
                    onPressed: () => appState.setZoom(appState.zoom * 1.25),
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_center_focus),
                    tooltip: 'Reset zoom',
                    onPressed: () => appState.setZoom(1.0),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showClearDialog(BuildContext context, AppState appState) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear canvas'),
        content: const Text('Are you sure you want to clear the entire canvas?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              appState.clearCanvas();
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}

class _ToolButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final bool isSelected;
  final VoidCallback onPressed;

  const _ToolButton({
    required this.icon,
    required this.tooltip,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.2) : null,
          borderRadius: BorderRadius.circular(4),
        ),
        child: IconButton(
          icon: Icon(icon),
          color: isSelected ? Colors.blue : Colors.black87,
          onPressed: onPressed,
        ),
      ),
    );
  }
}

class _ColorPicker extends StatelessWidget {
  final String label;
  final Color color;
  final ValueChanged<Color> onChanged;

  const _ColorPicker({
    required this.label,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () => _showColorPicker(context),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ],
    );
  }

  void _showColorPicker(BuildContext context) {
    final colors = [
      Colors.black,
      Colors.white,
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
      Colors.pink,
      Colors.brown,
      Colors.grey,
      Colors.transparent,
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select $label Color'),
        content: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: colors.map((c) {
            return GestureDetector(
              onTap: () {
                onChanged(c);
                Navigator.pop(context);
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: c,
                  border: Border.all(
                    color: c == color ? Colors.blue : Colors.grey,
                    width: c == color ? 3 : 1,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
