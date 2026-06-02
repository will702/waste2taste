import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/catalog.dart';
import '../models/ingredient.dart';
import '../providers/history_provider.dart';
import '../providers/pantry_provider.dart';
import '../theme.dart';
import '../widgets/app_button.dart';
import '../widgets/food_visual.dart';
import '../widgets/screen_wrapper.dart';
import '../widgets/section_title.dart';

/// Recipe detail screen — port of app/recipe/[id].tsx.
class RecipeDetailScreen extends ConsumerWidget {
  const RecipeDetailScreen({super.key, required this.recipeId});

  final String recipeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipe = getRecipe(recipeId);

    if (recipe == null) {
      return ScreenWrapper(
        scroll: false,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Recipe not found',
                style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              AppButton(
                label: 'Go back',
                onPress: () => Navigator.of(context).pop(),
                variant: AppButtonVariant.ghost,
              ),
            ],
          ),
        ),
      );
    }

    final pantryItems = ref.watch(pantryProvider).valueOrNull ?? [];

    bool hasIngredient(String id) =>
        pantryItems.any((p) => p.ingredientId == id);

    final missing = recipe.ingredientIds
        .where((id) => !hasIngredient(id))
        .toList();

    Future<void> cookThis() async {
      await ref.read(historyProvider.notifier).logMeal(recipe.id);
      if (context.mounted) Navigator.of(context).pop();
    }

    return ScreenWrapper(
      scroll: true,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Back button ─────────────────────────────────────────
                Align(
                  alignment: Alignment.centerLeft,
                  child: AppButton(
                    label: '← Back',
                    onPress: () => Navigator.of(context).pop(),
                    variant: AppButtonVariant.ghost,
                  ),
                ),

                const SizedBox(height: 12),

                // ── Recipe visual ───────────────────────────────────────
                RecipeVisual(recipe: recipe, compact: false),

                const SizedBox(height: 16),

                // ── Title & subtitle ────────────────────────────────────
                Text(
                  recipe.title,
                  style: const TextStyle(
                    color: AppColors.green,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    height: 1.15,
                  ),
                ),
                if (recipe.subtitle != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    recipe.subtitle!,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 14,
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                // ── Metrics row ─────────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: _MetricBox(
                        value: '${recipe.timeMinutes}',
                        label: 'min',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _MetricBox(
                        value: '${recipe.servings}',
                        label: 'servings',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _MetricBox(
                        value: recipe.difficulty,
                        label: 'difficulty',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ── Ingredients ─────────────────────────────────────────
                const SectionTitle(title: 'Ingredients'),
                const SizedBox(height: 10),

                ...recipe.ingredientIds.map((id) {
                  final ingredient = getIngredient(id);
                  final owned = hasIngredient(id);
                  return _IngredientRow(
                    ingredient: ingredient,
                    ingredientId: id,
                    owned: owned,
                  );
                }),

                if (missing.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  AppButton(
                    label: 'Add Missing',
                    onPress: () => context.go('/app/add-ingredients'),
                    variant: AppButtonVariant.red,
                  ),
                ],

                const SizedBox(height: 16),

                // ── Waste note ───────────────────────────────────────────
                if (recipe.wasteNote != null)
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF5DE),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.green.withAlpha(60),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '♻',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            recipe.wasteNote!,
                            style: const TextStyle(
                              color: AppColors.green,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 20),

                // ── Cooking steps ────────────────────────────────────────
                const SectionTitle(title: 'Cooking steps'),
                const SizedBox(height: 10),

                ...recipe.steps.asMap().entries.map((entry) {
                  final idx = entry.key + 1;
                  final step = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.paper,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.line),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              color: AppColors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '$idx',
                                style: const TextStyle(
                                  color: AppColors.cream,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                step,
                                style: const TextStyle(
                                  color: AppColors.ink,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 20),

                // ── Cook button ──────────────────────────────────────────
                AppButton(
                  label: 'Cook This Recipe',
                  onPress: cookThis,
                  variant: AppButtonVariant.primary,
                ),

                const SizedBox(height: 34),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Private widgets ──────────────────────────────────────────────────────────

class _MetricBox extends StatelessWidget {
  const _MetricBox({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: AppColors.ink,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _IngredientRow extends StatelessWidget {
  const _IngredientRow({
    required this.ingredient,
    required this.ingredientId,
    required this.owned,
  });

  final Ingredient? ingredient;
  final String ingredientId;
  final bool owned;

  @override
  Widget build(BuildContext context) {
    final name = ingredient?.name ?? ingredientId;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: owned ? const Color(0xFFEEF5DE) : AppColors.paper,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: owned ? AppColors.green.withAlpha(80) : AppColors.line,
          ),
        ),
        child: Row(
          children: [
            if (ingredient != null)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IngredientGlyph(ingredient: ingredient!, size: 32),
              ),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  color: owned ? AppColors.green : AppColors.ink,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: owned ? AppColors.green : AppColors.paper,
                borderRadius: BorderRadius.circular(20),
                border: owned
                    ? null
                    : Border.all(color: AppColors.muted.withAlpha(80)),
              ),
              child: Text(
                owned ? 'Ready' : 'Missing',
                style: TextStyle(
                  color: owned ? AppColors.cream : AppColors.muted,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
