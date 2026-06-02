import 'dart:math';

import 'package:flutter/material.dart';

import '../theme.dart';

/// Brand logo with wordmark and optional tagline.
/// Port of components/BrandMark.tsx.
class BrandMark extends StatelessWidget {
  const BrandMark({
    super.key,
    this.compact = false,
    this.light = false,
  });

  final bool compact;
  final bool light;

  Color get _inkColor => light ? AppColors.cream : AppColors.green;
  Color get _accentColor => light ? AppColors.yellow : AppColors.red;
  Color get _leafColor => light ? AppColors.green : AppColors.cream;

  double get _logoSize => compact ? 32.0 : 44.0;
  double get _leafWidth => compact ? 15.0 : 20.0;
  double get _leafHeight => compact ? 20.0 : 26.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Rotated logo box
        Transform.rotate(
          angle: -8 * pi / 180,
          child: Container(
            width: _logoSize,
            height: _logoSize,
            decoration: BoxDecoration(
              color: _accentColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Container(
                width: _leafWidth,
                height: _leafHeight,
                decoration: BoxDecoration(
                  color: _leafColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(2),
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Text column
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Waste2Taste',
              style: TextStyle(
                color: _inkColor,
                fontWeight: FontWeight.bold,
                fontSize: compact ? 15 : 18,
                height: 1.1,
              ),
            ),
            if (!compact) ...[
              const SizedBox(height: 2),
              Text(
                'Sustainable bites, delightful flavors.',
                style: TextStyle(
                  color: _inkColor.withAlpha(178), // ~0.7 opacity
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
