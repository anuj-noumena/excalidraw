import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state/app_state.dart';
import 'widgets/excalidraw_canvas.dart';
import 'widgets/toolbar.dart';
import 'utils/file_manager.dart';

void main() {
  runApp(const ExcalidrawApp());
}

class ExcalidrawApp extends StatelessWidget {
  const ExcalidrawApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'Flutter Excalidraw',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.grey[100],
        ),
        home: const ExcalidrawScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class ExcalidrawScreen extends StatelessWidget {
  const ExcalidrawScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Excalidraw'),
        actions: [
          IconButton(
            icon: const Icon(Icons.folder_open),
            tooltip: 'Open file',
            onPressed: () => _loadFile(context),
          ),
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save file',
            onPressed: () => _saveFile(context),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'About',
            onPressed: () => _showAboutDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          const Toolbar(),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: const ExcalidrawCanvas(),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadFile(BuildContext context) async {
    try {
      final appState = Provider.of<AppState>(context, listen: false);
      final elements = await FileManager.pickAndLoadFile();

      if (elements != null) {
        appState.loadElements(elements);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Loaded ${elements.length} elements'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveFile(BuildContext context) async {
    try {
      final appState = Provider.of<AppState>(context, listen: false);
      await FileManager.pickAndSaveFile(appState.elements);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('File saved successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Flutter Excalidraw'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'A complete Flutter port of Excalidraw',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text('Features:'),
              SizedBox(height: 8),
              Text('• Multiple drawing tools (rectangle, ellipse, arrow, line, freehand)'),
              Text('• Hand-drawn style rendering'),
              Text('• Customizable colors, stroke width, and roughness'),
              Text('• Fill patterns (hachure, cross-hatch, solid, zigzag)'),
              Text('• Undo/redo functionality'),
              Text('• Zoom and pan'),
              Text('• Grid view'),
              Text('• Export/import .excalidraw files'),
              Text('• Selection and manipulation'),
              SizedBox(height: 16),
              Text(
                'Keyboard Shortcuts:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('V - Selection tool'),
              Text('H - Hand tool'),
              Text('R - Rectangle'),
              Text('D - Diamond'),
              Text('O - Ellipse'),
              Text('A - Arrow'),
              Text('L - Line'),
              Text('P - Pen (freehand)'),
              Text('T - Text'),
              Text('E - Eraser'),
              Text('Delete - Delete selected'),
              Text('Ctrl+Z - Undo'),
              Text('Ctrl+Y - Redo'),
              SizedBox(height: 16),
              Text(
                'Version 1.0.0',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
