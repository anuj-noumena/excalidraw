import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/elements.dart';

class TextEditorDialog extends StatefulWidget {
  final TextElement? existingElement;
  final Offset? position;

  const TextEditorDialog({
    Key? key,
    this.existingElement,
    this.position,
  }) : super(key: key);

  @override
  State<TextEditorDialog> createState() => _TextEditorDialogState();
}

class _TextEditorDialogState extends State<TextEditorDialog> {
  late TextEditingController _controller;
  late double _fontSize;
  late String _fontFamily;
  late String _textAlign;
  late bool _isBold;
  late bool _isItalic;
  late bool _isUnderline;
  late Color _textColor;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.existingElement?.text ?? '');
    _fontSize = widget.existingElement?.fontSize ?? 20.0;
    _fontFamily = widget.existingElement?.fontFamily ?? 'Virgil';
    _textAlign = widget.existingElement?.textAlign ?? 'left';
    _isBold = false;
    _isItalic = false;
    _isUnderline = false;
    _textColor = widget.existingElement?.strokeColor ?? Colors.black;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Text(
                  'Text Editor',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Formatting toolbar
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // Font size
                SizedBox(
                  width: 100,
                  child: DropdownButtonFormField<double>(
                    value: _fontSize,
                    decoration: const InputDecoration(
                      labelText: 'Size',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    ),
                    items: [12.0, 16.0, 20.0, 24.0, 28.0, 32.0, 40.0, 48.0]
                        .map((size) => DropdownMenuItem(
                              value: size,
                              child: Text('${size.toInt()}'),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _fontSize = value);
                      }
                    },
                  ),
                ),
                // Font family
                SizedBox(
                  width: 120,
                  child: DropdownButtonFormField<String>(
                    value: _fontFamily,
                    decoration: const InputDecoration(
                      labelText: 'Font',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    ),
                    items: ['Virgil', 'Helvetica', 'Cascadia']
                        .map((font) => DropdownMenuItem(
                              value: font,
                              child: Text(font),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _fontFamily = value);
                      }
                    },
                  ),
                ),
                // Text color
                GestureDetector(
                  onTap: _showColorPicker,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _textColor,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                // Bold
                IconButton(
                  icon: const Icon(Icons.format_bold),
                  isSelected: _isBold,
                  onPressed: () => setState(() => _isBold = !_isBold),
                  style: IconButton.styleFrom(
                    backgroundColor: _isBold ? Colors.blue.shade100 : null,
                  ),
                ),
                // Italic
                IconButton(
                  icon: const Icon(Icons.format_italic),
                  isSelected: _isItalic,
                  onPressed: () => setState(() => _isItalic = !_isItalic),
                  style: IconButton.styleFrom(
                    backgroundColor: _isItalic ? Colors.blue.shade100 : null,
                  ),
                ),
                // Underline
                IconButton(
                  icon: const Icon(Icons.format_underline),
                  isSelected: _isUnderline,
                  onPressed: () => setState(() => _isUnderline = !_isUnderline),
                  style: IconButton.styleFrom(
                    backgroundColor: _isUnderline ? Colors.blue.shade100 : null,
                  ),
                ),
                // Align left
                IconButton(
                  icon: const Icon(Icons.format_align_left),
                  isSelected: _textAlign == 'left',
                  onPressed: () => setState(() => _textAlign = 'left'),
                  style: IconButton.styleFrom(
                    backgroundColor: _textAlign == 'left' ? Colors.blue.shade100 : null,
                  ),
                ),
                // Align center
                IconButton(
                  icon: const Icon(Icons.format_align_center),
                  isSelected: _textAlign == 'center',
                  onPressed: () => setState(() => _textAlign = 'center'),
                  style: IconButton.styleFrom(
                    backgroundColor: _textAlign == 'center' ? Colors.blue.shade100 : null,
                  ),
                ),
                // Align right
                IconButton(
                  icon: const Icon(Icons.format_align_right),
                  isSelected: _textAlign == 'right',
                  onPressed: () => setState(() => _textAlign = 'right'),
                  style: IconButton.styleFrom(
                    backgroundColor: _textAlign == 'right' ? Colors.blue.shade100 : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Text input
            Container(
              constraints: const BoxConstraints(minHeight: 200, maxHeight: 400),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: TextField(
                controller: _controller,
                maxLines: null,
                autofocus: true,
                style: TextStyle(
                  fontSize: _fontSize,
                  fontFamily: _fontFamily,
                  color: _textColor,
                  fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
                  fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
                  decoration: _isUnderline ? TextDecoration.underline : TextDecoration.none,
                ),
                decoration: const InputDecoration(
                  hintText: 'Enter text...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _saveText,
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showColorPicker() {
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
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Text Color'),
        content: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: colors.map((color) {
            return GestureDetector(
              onTap: () {
                setState(() => _textColor = color);
                Navigator.pop(context);
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  border: Border.all(
                    color: color == _textColor ? Colors.blue : Colors.grey,
                    width: color == _textColor ? 3 : 1,
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

  void _saveText() {
    final appState = Provider.of<AppState>(context, listen: false);
    final text = _controller.text;

    if (text.isEmpty) {
      Navigator.pop(context);
      return;
    }

    if (widget.existingElement != null) {
      // Update existing element
      final updated = widget.existingElement!.copyWith(
        text: text,
        fontSize: _fontSize,
        fontFamily: _fontFamily,
        textAlign: _textAlign,
        strokeColor: _textColor,
        updated: DateTime.now().millisecondsSinceEpoch,
      );
      appState.updateElement(widget.existingElement!.id, updated);
    } else if (widget.position != null) {
      // Create new text element
      appState.createTextElement(
        position: widget.position!,
        text: text,
        fontSize: _fontSize,
        fontFamily: _fontFamily,
        textAlign: _textAlign,
        textColor: _textColor,
      );
    }

    Navigator.pop(context);
  }
}
