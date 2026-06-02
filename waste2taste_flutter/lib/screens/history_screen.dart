import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/catalog.dart';
import '../providers/history_provider.dart';
import '../theme.dart';
import '../widgets/food_visual.dart';
import '../widgets/metric_pill.dart';
import '../widgets/screen_wrapper.dart';
import '../widgets/section_title.dart';

/// History tab screen — port of app/(tabs)/history.tsx.
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyProvider);
    final historyCount = historyAsync.valueOrNull?.length ?? 0;

    return ScreenWrapper(
      scroll: true,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Cooking History',
            style: TextStyle(
              color: AppColors.green,
              fontSize: 32,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Track the meals you\'ve cooked and the waste you\'ve saved.',
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),

          // Metric pills
          Row(
            children: [
              Expanded(
                child: MetricPill(
                  label: 'meals cooked',
                  value: historyCount.toString(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MetricPill(
                  label: 'items saved',
                  value: historyCount.toString(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          const SectionTitle(title: 'Recent meals'),
          const SizedBox(height: 12),

          // History list
          historyAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (_, __) => const Text(
              'Failed to load history',
              style: TextStyle(color: AppColors.muted),
            ),
            data: (meals) {
              if (meals.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: Text(
                      'No meals cooked yet.',
                      style: TextStyle(color: AppColors.muted, fontSize: 14),
                    ),
                  ),
                );
              }
              return Column(
                children: meals.map((meal) {
                  final recipe = getRecipe(meal.recipeId);
                  if (recipe == null) return const SizedBox.shrink();

                  final dateStr = _formatDate(meal.cookedAt);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.paper,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.line),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          RecipeVisual(recipe: recipe, compact: true),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      recipe.title,
                                      style: const TextStyle(
                                        color: AppColors.ink,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      dateStr,
                                      style: const TextStyle(
                                        color: AppColors.muted,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (meal.saved == true)
                                const Text(
                                  'Saved ✓',
                                  style: TextStyle(
                                    color: AppColors.green,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),

          // Bottom padding for nav bar
          const SizedBox(height: 104),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final local = dt.toLocal();
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[local.month - 1]} ${local.day}';
  }
}
