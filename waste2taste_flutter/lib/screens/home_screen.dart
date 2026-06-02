import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../providers/pantry_provider.dart';
import '../providers/recipes_provider.dart';
import '../theme.dart';
import '../widgets/app_button.dart';
import '../widgets/metric_pill.dart';
import '../widgets/pantry_row.dart';
import '../widgets/recipe_card.dart';
import '../widgets/screen_wrapper.dart';
import '../widgets/section_title.dart';

/// Home tab screen — port of app/(tabs)/home.tsx.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authProvider);
    final pantryAsync = ref.watch(pantryProvider);
    final recsAsync = ref.watch(recommendationsProvider);

    final email = authAsync.valueOrNull?.email ?? 'there';
    final pantryCount = pantryAsync.valueOrNull?.length ?? 0;
    final recsCount = recsAsync.valueOrNull?.length ?? 0;

    return ScreenWrapper(
      scroll: true,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header ─────────────────────────────────────────────────────────
          _Header(email: email),

          // ── Body content with horizontal padding ───────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),

                // Metric pills
                Row(
                  children: [
                    Expanded(
                      child: MetricPill(
                        label: 'ingredients ready',
                        value: pantryCount.toString(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: MetricPill(
                        label: 'recipe matches',
                        value: recsCount.toString(),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                const SectionTitle(title: 'Choose your ingredients'),
                const SizedBox(height: 12),

                // Action cards
                Row(
                  children: [
                    Expanded(
                      child: _ActionCard(
                        label: 'Add Ingredients',
                        detail: 'Search pantry items',
                        icon: Icons.add_circle_outline,
                        onTap: () => context.go('/app/add-ingredients'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ActionCard(
                        label: 'Scan Ingredients',
                        detail: 'Use camera scan',
                        icon: Icons.camera_alt_outlined,
                        onTap: () => context.go('/app/scan'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                const SectionTitle(title: 'My ingredients list'),
                const SizedBox(height: 12),

                // Pantry list
                pantryAsync.when(
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (_, __) => const Text(
                    'Failed to load pantry',
                    style: TextStyle(color: AppColors.muted),
                  ),
                  data: (items) => Column(
                    children: [
                      ...items.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: PantryRow(
                            item: item,
                            onDecrease: () => ref
                                .read(pantryProvider.notifier)
                                .changeQuantity(item.ingredientId, -1),
                            onIncrease: () => ref
                                .read(pantryProvider.notifier)
                                .changeQuantity(item.ingredientId, 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                AppButton(
                  label: 'Start Cook',
                  onPress: () => context.go('/app/recipes'),
                ),

                const SizedBox(height: 20),
                SectionTitle(
                  title: 'Recipe for you',
                  action: GestureDetector(
                    onTap: () => context.go('/app/recipes'),
                    child: const Text(
                      'Show more',
                      style: TextStyle(
                        color: AppColors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Top 4 recipe recommendations
                recsAsync.when(
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (_, __) => const Text(
                    'Failed to load recommendations',
                    style: TextStyle(color: AppColors.muted),
                  ),
                  data: (recs) {
                    final top4 = recs.take(4).toList();
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final cardWidth =
                            (constraints.maxWidth - 12) / 2;
                        return Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: top4
                              .map(
                                (r) => SizedBox(
                                  width: cardWidth,
                                  child: RecipeCard(
                                    recipe: r,
                                    onTap: () => context
                                        .go('/app/recipe/${r.id}'),
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      },
                    );
                  },
                ),

                // Bottom padding for nav bar
                const SizedBox(height: 104),
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
  const _Header({required this.email});

  final String email;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Good morning,',
            style: TextStyle(
              color: Color(0xC7FFDC9D), // cream @ ~0.78
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Hello, $email',
            style: const TextStyle(
              color: AppColors.cream,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              height: 1.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          const Text(
            "What's in your pantry today?",
            style: TextStyle(
              color: Color(0xC7FFDC9D),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatefulWidget {
  const _ActionCard({
    required this.label,
    required this.detail,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String detail;
  final IconData icon;
  final VoidCallback onTap;

  @override
  State<_ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<_ActionCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 80),
        child: Container(
          constraints: const BoxConstraints(minHeight: 122),
          decoration: BoxDecoration(
            color: AppColors.red,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.cream.withAlpha(46), // ~18% opacity
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  widget.icon,
                  color: AppColors.cream,
                  size: 20,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.label,
                style: const TextStyle(
                  color: AppColors.cream,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                widget.detail,
                style: const TextStyle(
                  color: Color(0xC7FFDC9D),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
