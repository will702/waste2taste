import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/catalog.dart';
import '../models/ingredient.dart';
import '../providers/pantry_provider.dart';
import '../theme.dart';
import '../widgets/app_button.dart';
import '../widgets/ingredient_chip.dart';
import '../widgets/screen_wrapper.dart';
import '../widgets/section_title.dart';

/// Add Ingredients screen — port of app/add-ingredients.tsx.
/// Search + multi-select ingredient picker.
class AddIngredientsScreen extends ConsumerStatefulWidget {
  const AddIngredientsScreen({super.key});

  @override
  ConsumerState<AddIngredientsScreen> createState() =>
      _AddIngredientsScreenState();
}

class _AddIngredientsScreenState
    extends ConsumerState<AddIngredientsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _selected = {};
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _query = _searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Ingredient> get _filtered {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return catalogIngredients;
    return catalogIngredients
        .where((i) => i.name.toLowerCase().contains(q))
        .toList();
  }

  Future<void> _addToList() async {
    if (_selected.isEmpty) return;
    await ref
        .read(pantryProvider.notifier)
        .addIngredients(_selected.toList());
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return ScreenWrapper(
      scroll: true,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header ────────────────────────────────────────────────────────
          _Header(onBack: () => Navigator.of(context).pop()),

          // ── Body ─────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),

                // Search field
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.paper,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.line),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search ingredient...',
                      hintStyle: TextStyle(color: AppColors.muted, fontSize: 14),
                      prefixIcon: Icon(Icons.search, color: AppColors.muted),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    style: const TextStyle(color: AppColors.ink, fontSize: 14),
                  ),
                ),

                const SizedBox(height: 20),
                const SectionTitle(title: 'Popular ingredients'),
                const SizedBox(height: 12),

                // Ingredient chips grid
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: filtered.map((ingredient) {
                    final isSelected = _selected.contains(ingredient.id);
                    return IngredientChip(
                      ingredient: ingredient,
                      selected: isSelected,
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selected.remove(ingredient.id);
                          } else {
                            _selected.add(ingredient.id);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                // Selected count
                if (_selected.isNotEmpty)
                  Text(
                    'Selected: ${_selected.length} ingredient(s)',
                    style: const TextStyle(
                      color: AppColors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),

                const SizedBox(height: 16),

                // Add button
                AppButton(
                  label: 'Add to My List',
                  onPress: _selected.isEmpty ? () {} : _addToList,
                  variant: AppButtonVariant.primary,
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Private widgets ──────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.red,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.cream.withAlpha(46),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: AppColors.cream,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Add Ingredients',
            style: TextStyle(
              color: AppColors.cream,
              fontSize: 20,
              fontWeight: FontWeight.w900,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
