import 'package:flutter/material.dart';

import '../theme.dart';

/// Safe-area aware scroll/fixed wrapper.
/// Port of components/Screen.tsx.
class ScreenWrapper extends StatelessWidget {
  const ScreenWrapper({
    super.key,
    required this.child,
    this.scroll = true,
    this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
  });

  final Widget child;
  final bool scroll;
  final Color? backgroundColor;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? AppColors.yellow;
    if (!scroll) {
      return Scaffold(
        backgroundColor: bg,
        body: SafeArea(child: Padding(padding: padding, child: child)),
      );
    }
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: padding.copyWith(top: 18, bottom: 28),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: child,
          ),
        ),
      ),
    );
  }
}
