import 'package:flutter/material.dart';

import '../data/catalog.dart';
import '../models/pantry_item.dart';
import '../theme.dart';
import 'food_visual.dart';

/// Row widget displaying a pantry item with quantity controls.
/// Port of PantryRow + QuantityButton in components/Cards.tsx.
class PantryRow extends StatelessWidget {
  const PantryRow({
    super.key,
    required this.item,
    required this.onDecrease,
    required this.onIncrease,
  });

  final PantryItem item;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    final ingredient = getIngredient(item.ingredientId);
    if (ingredient == null) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.yellow,
        border: Border.all(color: AppColors.red, width: 1.5),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          IngredientGlyph(ingredient: ingredient, size: 46),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ingredient.name,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${ingredient.category} • ${ingredient.unit}',
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _QuantityButton(label: '-', onTap: onDecrease),
          const SizedBox(width: 8),
          SizedBox(
            width: 24,
            child: Text(
              '${item.quantity}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.ink,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(width: 8),
          _QuantityButton(label: '+', onTap: onIncrease),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatefulWidget {
  const _QuantityButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  State<_QuantityButton> createState() => _QuantityButtonState();
}

class _QuantityButtonState extends State<_QuantityButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: Opacity(
        opacity: _pressed ? 0.65 : 1.0,
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.paper,
            border: Border.all(color: AppColors.line),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              widget.label,
              style: const TextStyle(
                color: AppColors.ink,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
