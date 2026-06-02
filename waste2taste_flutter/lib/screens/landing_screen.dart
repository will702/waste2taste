import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/catalog.dart';
import '../theme.dart';
import '../widgets/app_button.dart';
import '../widgets/brand_mark.dart';
import '../widgets/food_visual.dart';

/// Landing screen — port of app/index.tsx.
/// Yellow top section with BrandMark, red bottom panel with RecipeVisual + CTA.
class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.yellow,
      body: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // ── Top section: BrandMark ────────────────────────────────────
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24)
                    .copyWith(top: 42),
                child: const Center(child: BrandMark()),
              ),
            ),
            // ── Bottom panel: red, rounded top corners ────────────────────
            Container(
              decoration: const BoxDecoration(
                color: AppColors.red,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(44),
                  topRight: Radius.circular(44),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(24, 34, 24, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RecipeVisual(recipe: catalogRecipes[0]),
                  const SizedBox(height: 16),
                  const Text(
                    'Sustainable bites,\ndelightful flavors.',
                    style: TextStyle(
                      color: AppColors.cream,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Turn pantry leftovers into delicious, '
                    'waste-reducing meals — powered by AI.',
                    style: TextStyle(
                      color: Color(0xC7FFDC9D), // cream @ 0.78 opacity
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    label: 'Get Started',
                    variant: AppButtonVariant.cream,
                    onPress: () => context.go('/login'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
