import 'package:flutter/material.dart';

import '../theme.dart';

/// Section heading with optional trailing action widget.
/// Used across tab screens to label content sections.
class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.title, this.action});

  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.red,
            fontSize: 15,
            fontWeight: FontWeight.w900,
          ),
        ),
        if (action != null) action!,
      ],
    );
  }
}
