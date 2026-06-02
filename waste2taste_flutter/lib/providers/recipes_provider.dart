import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/catalog.dart';
import '../models/recipe.dart';
import 'pantry_provider.dart';
import 'providers.dart';

class RecipesNotifier extends AsyncNotifier<List<Recipe>> {
  @override
  Future<List<Recipe>> build() async {
    final api = ref.read(apiClientProvider);
    try {
      final response = await api.get('/recipes');
      return (response.data as List)
          .map((j) => Recipe.fromJson(j as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return catalogRecipes;
    }
  }
}

final recipesProvider =
    AsyncNotifierProvider<RecipesNotifier, List<Recipe>>(RecipesNotifier.new);

class RecommendationsNotifier extends AsyncNotifier<List<Recipe>> {
  @override
  Future<List<Recipe>> build() async {
    ref.watch(pantryProvider);
    final api = ref.read(apiClientProvider);
    try {
      final response = await api.get('/recipes/recommend');
      final list = (response.data['recipes'] as List?) ?? [];
      return list
          .map((j) => Recipe.fromJson(j as Map<String, dynamic>))
          .toList();
    } catch (_) {
      final pantry = ref.read(pantryProvider).valueOrNull ?? [];
      final pantryIds = pantry.map((p) => p.ingredientId).toSet();
      return catalogRecipes
          .map((r) => (
                r,
                r.ingredientIds.isEmpty
                    ? 0.0
                    : r.ingredientIds.where(pantryIds.contains).length /
                        r.ingredientIds.length
              ))
          .where((t) => t.$2 > 0)
          .sorted((a, b) => b.$2.compareTo(a.$2))
          .map((t) => t.$1)
          .toList();
    }
  }
}

final recommendationsProvider =
    AsyncNotifierProvider<RecommendationsNotifier, List<Recipe>>(
        RecommendationsNotifier.new);
