import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import '../../../config/constants.dart';
import '../../../services/window_controls.dart';
import '../../../utils/platform_utils.dart';

class DesktopTopBar extends StatelessWidget {
  const DesktopTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    if (!isDesktopPlatform()) return const SizedBox.shrink();
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      height: 40,
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border(
            bottom: BorderSide(color: colors.outlineVariant, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            const _WindowButtons(),
            const SizedBox(width: 12),
            Text(
              AppConfig.appName,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: colors.onSurface,
              ),
            ),
            const Expanded(child: _DragArea()),
          ],
        ),
      ),
    );
  }
}

class _DragArea extends StatelessWidget {
  const _DragArea();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () => windowControls.maximizeOrUnmaximize(),
      child: const DragToMoveArea(child: SizedBox.expand()),
    );
  }
}

class _WindowButtons extends StatefulWidget {
  const _WindowButtons();

  @override
  State<_WindowButtons> createState() => _WindowButtonsState();
}

class _WindowButtonsState extends State<_WindowButtons> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _TrafficButton(
            color: const Color(0xFFFF5F57),
            glyph: Icons.close,
            showGlyph: _hovered,
            semanticLabel: 'close',
            onTap: () => windowControls.close(),
          ),
          const SizedBox(width: 8),
          _TrafficButton(
            color: const Color(0xFFFEBC2E),
            glyph: Icons.remove,
            showGlyph: _hovered,
            semanticLabel: 'minimize',
            onTap: () => windowControls.minimize(),
          ),
          const SizedBox(width: 8),
          _TrafficButton(
            color: const Color(0xFF28C840),
            glyph: Icons.add,
            showGlyph: _hovered,
            semanticLabel: 'maximize',
            onTap: () => windowControls.maximizeOrUnmaximize(),
          ),
        ],
      ),
    );
  }
}

class _TrafficButton extends StatelessWidget {
  final Color color;
  final IconData glyph;
  final bool showGlyph;
  final String semanticLabel;
  final VoidCallback onTap;

  const _TrafficButton({
    required this.color,
    required this.glyph,
    required this.showGlyph,
    required this.semanticLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: showGlyph
              ? Icon(glyph, size: 11, color: Colors.black.withAlpha(160))
              : null,
        ),
      ),
    );
  }
}
