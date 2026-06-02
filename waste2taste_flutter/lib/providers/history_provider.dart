import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cooked_meal.dart';
import 'providers.dart';

class HistoryNotifier extends AsyncNotifier<List<CookedMeal>> {
  @override
  Future<List<CookedMeal>> build() async {
    final api = ref.read(apiClientProvider);
    final response = await api.get('/history');
    return (response.data as List)
        .map((j) => CookedMeal.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  Future<void> logMeal(String recipeId) async {
    final api = ref.read(apiClientProvider);
    await api.post('/history', data: {'recipe_id': recipeId});
    ref.invalidateSelf();
  }
}

final historyProvider =
    AsyncNotifierProvider<HistoryNotifier, List<CookedMeal>>(HistoryNotifier.new);
