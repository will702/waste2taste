import 'package:flutter/material.dart';

import '../models/ingredient.dart';
import '../theme.dart';
import 'food_visual.dart';

/// Tappable card for ingredient selection.
/// Used in AddIngredientsScreen.
class IngredientChip extends StatelessWidget {
  const IngredientChip({
    super.key,
    required this.ingredient,
    required this.selected,
    required this.onTap,
  });

  final Ingredient ingredient;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Minimum width ~30% of screen minus padding
    final minWidth = (screenWidth - 40) * 0.30;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        constraints: BoxConstraints(minWidth: minWidth),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEEF5DE) : AppColors.paper,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.green : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.ink.withAlpha(18),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IngredientGlyph(ingredient: ingredient, size: 48),
            const SizedBox(height: 6),
            Text(
              ingredient.name,
              style: TextStyle(
                color: selected ? AppColors.green : AppColors.ink,
                fontSize: 12,
                fontWeight:
                    selected ? FontWeight.w700 : FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
