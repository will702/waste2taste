import 'dart:math';

import 'package:flutter/material.dart';

import '../models/ingredient.dart';
import '../models/recipe.dart';
import '../theme.dart';

Color _parseHex(String hex) {
  final h = hex.replaceAll('#', '');
  return Color(int.parse('FF$h', radix: 16));
}

/// Circular glyph representing an ingredient.
/// Port of IngredientGlyph in components/FoodVisual.tsx.
class IngredientGlyph extends StatelessWidget {
  const IngredientGlyph({
    super.key,
    required this.ingredient,
    this.size = 54,
  });

  final Ingredient ingredient;
  final double size;

  @override
  Widget build(BuildContext context) {
    final bgColor = _parseHex(ingredient.color);
    final accentColor = _parseHex(ingredient.accent);
    final accentSize = size * 0.46;
    final rotation = ingredient.category == 'produce'
        ? -14.0 * pi / 180
        : 8.0 * pi / 180;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0x14351609), // rgba(53,22,9,0.08)
          width: 1,
        ),
      ),
      child: Center(
        child: Transform.rotate(
          angle: rotation,
          child: Opacity(
            opacity: 0.92,
            child: Container(
              width: accentSize,
              height: accentSize,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(accentSize * 0.3),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Hero visual for a recipe card.
/// Port of RecipeVisual in components/FoodVisual.tsx.
class RecipeVisual extends StatelessWidget {
  const RecipeVisual({
    super.key,
    required this.recipe,
    this.compact = false,
  });

  final Recipe recipe;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final height = compact ? 86.0 : 170.0;
    final bgColor = recipe.heroColor != null
        ? _parseHex(recipe.heroColor!)
        : AppColors.red;
    final accentColor = recipe.accentColor != null
        ? _parseHex(recipe.accentColor!)
        : AppColors.cream;

    // Circle sizes
    final circle1Size = compact ? 92.0 : 170.0;
    final circle2Size = compact ? 72.0 : 132.0;

    // Offsets
    final circle1Top = compact ? -20.0 : -32.0;
    final circle1Right = compact ? -18.0 : -28.0;
    final circle2Bottom = compact ? -10.0 : -18.0;
    final circle2Left = compact ? -10.0 : -16.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(compact ? 12 : 16),
      child: SizedBox(
        height: height,
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            // Background
            Positioned.fill(
              child: ColoredBox(color: bgColor),
            ),
            // Top-right decorative circle
            Positioned(
              top: circle1Top,
              right: circle1Right,
              child: Opacity(
                opacity: 0.86,
                child: Container(
                  width: circle1Size,
                  height: circle1Size,
                  decoration: BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            // Bottom-left decorative circle
            Positioned(
              bottom: circle2Bottom,
              left: circle2Left,
              child: Opacity(
                opacity: 0.38,
                child: Container(
                  width: circle2Size,
                  height: circle2Size,
                  decoration: const BoxDecoration(
                    color: AppColors.cream,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            // Text overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.all(compact ? 10 : 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      style: TextStyle(
                        color: AppColors.cream,
                        fontWeight: FontWeight.bold,
                        fontSize: compact ? 13 : 18,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (!compact && recipe.subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        recipe.subtitle!,
                        style: const TextStyle(
                          color: Color(0xC7FFDC9D), // rgba(255,220,157,0.78)
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
