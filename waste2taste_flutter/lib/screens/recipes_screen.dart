import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/pantry_provider.dart';
import '../providers/recipes_provider.dart';
import '../theme.dart';
import '../widgets/recipe_card.dart';
import '../widgets/screen_wrapper.dart';
import '../widgets/section_title.dart';

/// Recipes tab screen — port of app/(tabs)/recipes.tsx.
class RecipesScreen extends ConsumerWidget {
  const RecipesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pantryAsync = ref.watch(pantryProvider);
    final recsAsync = ref.watch(recommendationsProvider);

    final pantryCount = pantryAsync.valueOrNull?.length ?? 0;

    return ScreenWrapper(
      scroll: true,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Recipes',
            style: TextStyle(
              color: AppColors.green,
              fontSize: 32,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Personalized recipes based on what you have.',
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),

          // Pantry match engine info box
          Container(
            decoration: BoxDecoration(
              color: AppColors.red,
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pantry match engine',
                  style: TextStyle(
                    color: AppColors.cream,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$pantryCount ingredients available — ranked by match score',
                  style: const TextStyle(
                    color: Color(0xC7FFDC9D), // cream @ ~0.78
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const SectionTitle(title: 'Recommended now'),
          const SizedBox(height: 12),

          // All recommendations
          recsAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (_, __) => const Text(
              'Failed to load recommendations',
              style: TextStyle(color: AppColors.muted),
            ),
            data: (recs) => LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = (constraints.maxWidth - 12) / 2;
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: recs
                      .map(
                        (r) => SizedBox(
                          width: cardWidth,
                          child: RecipeCard(
                            recipe: r,
                            onTap: () => context.go('/app/recipe/${r.id}'),
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ),

          // Bottom padding for nav bar
          const SizedBox(height: 104),
        ],
      ),
    );
  }
}
