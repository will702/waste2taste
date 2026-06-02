import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/pantry_item.dart';
import 'providers.dart';

class PantryNotifier extends AsyncNotifier<List<PantryItem>> {
  @override
  Future<List<PantryItem>> build() async {
    final api = ref.read(apiClientProvider);
    final response = await api.get('/pantry');
    return (response.data as List)
        .map((j) => PantryItem.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  Future<void> addIngredient(String ingredientId, {int quantity = 1}) async {
    final prev = state;
    state = AsyncData([
      ...state.valueOrNull ?? [],
      PantryItem(id: 'temp', ingredientId: ingredientId, quantity: quantity),
    ]);
    try {
      final api = ref.read(apiClientProvider);
      await api.post(
        '/pantry',
        data: {'ingredient_id': ingredientId, 'quantity': quantity},
      );
      ref.invalidateSelf();
    } catch (e) {
      state = prev;
      rethrow;
    }
  }

  Future<void> addIngredients(List<String> ids) async {
    for (final id in ids) {
      await addIngredient(id);
    }
  }

  Future<void> changeQuantity(String ingredientId, int delta) async {
    final current = state.valueOrNull ?? [];
    final item = current.firstWhereOrNull((i) => i.ingredientId == ingredientId);
    if (item == null) return;
    final newQty = item.quantity + delta;
    if (newQty <= 0) {
      await removeIngredient(ingredientId);
      return;
    }
    final prev = state;
    state = AsyncData(
      current
          .map((i) => i.ingredientId == ingredientId
              ? i.copyWith(quantity: newQty)
              : i)
          .toList(),
    );
    try {
      final api = ref.read(apiClientProvider);
      await api.patch('/pantry/$ingredientId', data: {'quantity': newQty});
    } catch (e) {
      state = prev;
      rethrow;
    }
  }

  Future<void> removeIngredient(String ingredientId) async {
    final prev = state;
    state = AsyncData(
      (state.valueOrNull ?? [])
          .where((i) => i.ingredientId != ingredientId)
          .toList(),
    );
    try {
      final api = ref.read(apiClientProvider);
      await api.delete('/pantry/$ingredientId');
    } catch (e) {
      state = prev;
      rethrow;
    }
  }

  bool hasIngredient(String ingredientId) =>
      (state.valueOrNull ?? []).any((i) => i.ingredientId == ingredientId);
}

final pantryProvider =
    AsyncNotifierProvider<PantryNotifier, List<PantryItem>>(PantryNotifier.new);
