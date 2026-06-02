import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../theme.dart';
import '../widgets/app_button.dart';
import '../widgets/brand_mark.dart';
import '../widgets/metric_pill.dart';
import '../widgets/screen_wrapper.dart';
import '../widgets/section_title.dart';

/// Profile tab screen — port of app/(tabs)/profile.tsx.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authProvider);
    final email = authAsync.valueOrNull?.email ?? '';

    return ScreenWrapper(
      scroll: true,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Profile card
          Container(
            decoration: BoxDecoration(
              color: AppColors.red,
              borderRadius: BorderRadius.circular(32),
            ),
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BrandMark(compact: true, light: true),
                const SizedBox(height: 16),
                Text(
                  email,
                  style: const TextStyle(
                    color: AppColors.cream,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                const Text(
                  'Home cook • Waste saver • Jakarta',
                  style: TextStyle(
                    color: Color(0xC7FFDC9D), // cream @ ~0.78
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Metric pills
          const Row(
            children: [
              Expanded(
                child: MetricPill(label: 'weekly saves', value: '5'),
              ),
              SizedBox(width: 12),
              Expanded(
                child: MetricPill(label: 'favorite', value: 'Rice'),
              ),
            ],
          ),

          const SizedBox(height: 20),
          const SectionTitle(title: 'Preferences'),
          const SizedBox(height: 12),

          // Preference items
          _PreferenceItem(
            icon: Icons.eco_outlined,
            title: 'Dietary preferences',
            subtitle: 'No restrictions set',
            onTap: () {},
          ),
          const SizedBox(height: 8),
          _PreferenceItem(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Daily meal reminders',
            onTap: () {},
          ),
          const SizedBox(height: 8),
          _PreferenceItem(
            icon: Icons.language_outlined,
            title: 'Language',
            subtitle: 'English',
            onTap: () {},
          ),

          const SizedBox(height: 24),

          AppButton(
            label: 'Log out',
            variant: AppButtonVariant.ghost,
            onPress: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) context.go('/login');
            },
          ),

          // Bottom padding for nav bar
          const SizedBox(height: 104),
        ],
      ),
    );
  }
}

class _PreferenceItem extends StatelessWidget {
  const _PreferenceItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.paper,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.line),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: AppColors.red, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.muted, size: 18),
          ],
        ),
      ),
    );
  }
}
