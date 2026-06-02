import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme.dart';

enum AppButtonVariant { primary, red, cream, ghost }

/// Four-variant branded button.
/// Port of components/AppButton.tsx.
class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPress,
    this.variant = AppButtonVariant.primary,
  });

  final String label;
  final VoidCallback onPress;
  final AppButtonVariant variant;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _pressed = false;

  Color get _bgColor => switch (widget.variant) {
        AppButtonVariant.primary => AppColors.green,
        AppButtonVariant.red => AppColors.red,
        AppButtonVariant.cream => AppColors.cream,
        AppButtonVariant.ghost => Colors.transparent,
      };

  Color get _textColor => switch (widget.variant) {
        AppButtonVariant.primary => AppColors.cream,
        AppButtonVariant.red => AppColors.cream,
        AppButtonVariant.cream => AppColors.green,
        AppButtonVariant.ghost => AppColors.red,
      };

  Border? get _border => widget.variant == AppButtonVariant.ghost
      ? Border.all(color: AppColors.red, width: 1.5)
      : null;

  void _handleTapDown(TapDownDetails _) => setState(() => _pressed = true);
  void _handleTapUp(TapUpDetails _) => setState(() => _pressed = false);
  void _handleTapCancel() => setState(() => _pressed = false);

  void _handleTap() {
    HapticFeedback.selectionClick();
    widget.onPress();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: _handleTap,
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 80),
        child: AnimatedOpacity(
          opacity: _pressed ? 0.78 : 1.0,
          duration: const Duration(milliseconds: 80),
          child: Container(
            constraints: const BoxConstraints(minHeight: 52),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: _bgColor,
              border: _border,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Center(
              child: Text(
                widget.label,
                style: TextStyle(
                  color: _textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
