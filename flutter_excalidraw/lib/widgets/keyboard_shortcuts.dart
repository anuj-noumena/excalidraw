import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

class KeyboardShortcuts extends StatelessWidget {
  final Widget child;

  const KeyboardShortcuts({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) => _handleKeyEvent(event, context),
      child: child,
    );
  }

  KeyEventResult _handleKeyEvent(KeyEvent event, BuildContext context) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final appState = context.read<AppState>();
    final isCtrlPressed = HardwareKeyboard.instance.isControlPressed ||
        HardwareKeyboard.instance.isMetaPressed;
    final isShiftPressed = HardwareKeyboard.instance.isShiftPressed;
    final isAltPressed = HardwareKeyboard.instance.isAltPressed;

    // Tool shortcuts
    if (!isCtrlPressed && !isShiftPressed && !isAltPressed) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.keyV:
          appState.setActiveTool(ToolType.selection);
          return KeyEventResult.handled;
        case LogicalKeyboardKey.keyH:
          appState.setActiveTool(ToolType.hand);
          return KeyEventResult.handled;
        case LogicalKeyboardKey.keyR:
          appState.setActiveTool(ToolType.rectangle);
          return KeyEventResult.handled;
        case LogicalKeyboardKey.keyD:
          appState.setActiveTool(ToolType.diamond);
          return KeyEventResult.handled;
        case LogicalKeyboardKey.keyO:
          appState.setActiveTool(ToolType.ellipse);
          return KeyEventResult.handled;
        case LogicalKeyboardKey.keyA:
          appState.setActiveTool(ToolType.arrow);
          return KeyEventResult.handled;
        case LogicalKeyboardKey.keyL:
          appState.setActiveTool(ToolType.line);
          return KeyEventResult.handled;
        case LogicalKeyboardKey.keyP:
          appState.setActiveTool(ToolType.freedraw);
          return KeyEventResult.handled;
        case LogicalKeyboardKey.keyT:
          appState.setActiveTool(ToolType.text);
          return KeyEventResult.handled;
        case LogicalKeyboardKey.keyE:
          appState.setActiveTool(ToolType.eraser);
          return KeyEventResult.handled;
        case LogicalKeyboardKey.delete:
        case LogicalKeyboardKey.backspace:
          appState.deleteSelectedElements();
          return KeyEventResult.handled;
        case LogicalKeyboardKey.escape:
          appState.clearSelection();
          return KeyEventResult.handled;
      }
    }

    // Ctrl/Cmd shortcuts
    if (isCtrlPressed && !isShiftPressed) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.keyZ:
          appState.undo();
          return KeyEventResult.handled;
        case LogicalKeyboardKey.keyY:
          appState.redo();
          return KeyEventResult.handled;
        case LogicalKeyboardKey.keyA:
          appState.selectAll();
          return KeyEventResult.handled;
        case LogicalKeyboardKey.keyG:
          appState.groupSelectedElements();
          return KeyEventResult.handled;
        case LogicalKeyboardKey.keyD:
          appState.duplicateSelectedElements();
          return KeyEventResult.handled;
        case LogicalKeyboardKey.keyC:
          appState.copySelectedElements();
          return KeyEventResult.handled;
        case LogicalKeyboardKey.keyV:
          appState.pasteElements();
          return KeyEventResult.handled;
        case LogicalKeyboardKey.keyX:
          appState.cutSelectedElements();
          return KeyEventResult.handled;
      }
    }

    // Ctrl+Shift shortcuts
    if (isCtrlPressed && isShiftPressed) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.keyG:
          appState.ungroupSelectedElements();
          return KeyEventResult.handled;
        case LogicalKeyboardKey.keyZ:
          appState.redo();
          return KeyEventResult.handled;
      }
    }

    // Layer ordering shortcuts
    if (isCtrlPressed && !isShiftPressed) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.bracketRight:
          appState.bringForward();
          return KeyEventResult.handled;
        case LogicalKeyboardKey.bracketLeft:
          appState.sendBackward();
          return KeyEventResult.handled;
      }
    }

    if (isCtrlPressed && isShiftPressed) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.bracketRight:
          appState.bringToFront();
          return KeyEventResult.handled;
        case LogicalKeyboardKey.bracketLeft:
          appState.sendToBack();
          return KeyEventResult.handled;
      }
    }

    // Lock/Unlock
    if (isCtrlPressed && !isShiftPressed) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.keyL:
          appState.toggleLockSelectedElements();
          return KeyEventResult.handled;
      }
    }

    // Zoom shortcuts
    if (isCtrlPressed) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.equal:
        case LogicalKeyboardKey.add:
          appState.setZoom(appState.zoom * 1.25);
          return KeyEventResult.handled;
        case LogicalKeyboardKey.minus:
          appState.setZoom(appState.zoom * 0.8);
          return KeyEventResult.handled;
        case LogicalKeyboardKey.digit0:
          appState.setZoom(1.0);
          return KeyEventResult.handled;
      }
    }

    return KeyEventResult.ignored;
  }
}
