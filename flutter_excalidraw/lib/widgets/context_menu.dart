import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

class ContextMenu extends StatelessWidget {
  final Offset position;
  final VoidCallback onDismiss;

  const ContextMenu({
    Key? key,
    required this.position,
    required this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    final hasSelection = appState.selectedElementIds.isNotEmpty;

    return Stack(
      children: [
        // Backdrop to dismiss
        GestureDetector(
          onTap: onDismiss,
          child: Container(
            color: Colors.transparent,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        // Menu
        Positioned(
          left: position.dx,
          top: position.dy,
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hasSelection) ...[
                    _MenuItem(
                      icon: Icons.content_copy,
                      label: 'Copy',
                      shortcut: 'Ctrl+C',
                      onTap: () {
                        appState.copySelectedElements();
                        onDismiss();
                      },
                    ),
                    _MenuItem(
                      icon: Icons.content_cut,
                      label: 'Cut',
                      shortcut: 'Ctrl+X',
                      onTap: () {
                        appState.cutSelectedElements();
                        onDismiss();
                      },
                    ),
                    _MenuItem(
                      icon: Icons.content_paste,
                      label: 'Paste',
                      shortcut: 'Ctrl+V',
                      onTap: () {
                        appState.pasteElements();
                        onDismiss();
                      },
                      enabled: true,
                    ),
                    const Divider(height: 1),
                    _MenuItem(
                      icon: Icons.file_copy,
                      label: 'Duplicate',
                      shortcut: 'Ctrl+D',
                      onTap: () {
                        appState.duplicateSelectedElements();
                        onDismiss();
                      },
                    ),
                    _MenuItem(
                      icon: Icons.delete,
                      label: 'Delete',
                      shortcut: 'Del',
                      onTap: () {
                        appState.deleteSelectedElements();
                        onDismiss();
                      },
                    ),
                    const Divider(height: 1),
                    _MenuItem(
                      icon: Icons.flip_to_front,
                      label: 'Bring to Front',
                      shortcut: 'Ctrl+Shift+]',
                      onTap: () {
                        appState.bringToFront();
                        onDismiss();
                      },
                    ),
                    _MenuItem(
                      icon: Icons.flip,
                      label: 'Bring Forward',
                      shortcut: 'Ctrl+]',
                      onTap: () {
                        appState.bringForward();
                        onDismiss();
                      },
                    ),
                    _MenuItem(
                      icon: Icons.flip,
                      label: 'Send Backward',
                      shortcut: 'Ctrl+[',
                      onTap: () {
                        appState.sendBackward();
                        onDismiss();
                      },
                    ),
                    _MenuItem(
                      icon: Icons.flip_to_back,
                      label: 'Send to Back',
                      shortcut: 'Ctrl+Shift+[',
                      onTap: () {
                        appState.sendToBack();
                        onDismiss();
                      },
                    ),
                    const Divider(height: 1),
                    _MenuItem(
                      icon: Icons.group_work,
                      label: 'Group',
                      shortcut: 'Ctrl+G',
                      onTap: () {
                        appState.groupSelectedElements();
                        onDismiss();
                      },
                      enabled: appState.selectedElementIds.length >= 2,
                    ),
                    _MenuItem(
                      icon: Icons.ungroup,
                      label: 'Ungroup',
                      shortcut: 'Ctrl+Shift+G',
                      onTap: () {
                        appState.ungroupSelectedElements();
                        onDismiss();
                      },
                    ),
                    const Divider(height: 1),
                    _MenuItem(
                      icon: Icons.lock,
                      label: 'Lock/Unlock',
                      shortcut: 'Ctrl+L',
                      onTap: () {
                        appState.toggleLockSelectedElements();
                        onDismiss();
                      },
                    ),
                  ] else ...[
                    _MenuItem(
                      icon: Icons.content_paste,
                      label: 'Paste',
                      shortcut: 'Ctrl+V',
                      onTap: () {
                        appState.pasteElements();
                        onDismiss();
                      },
                      enabled: true,
                    ),
                    const Divider(height: 1),
                    _MenuItem(
                      icon: Icons.select_all,
                      label: 'Select All',
                      shortcut: 'Ctrl+A',
                      onTap: () {
                        appState.selectAll();
                        onDismiss();
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String shortcut;
  final VoidCallback onTap;
  final bool enabled;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.shortcut,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: enabled ? Colors.black87 : Colors.grey,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: enabled ? Colors.black87 : Colors.grey,
                ),
              ),
            ),
            Text(
              shortcut,
              style: TextStyle(
                fontSize: 11,
                color: enabled ? Colors.grey[600] : Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
