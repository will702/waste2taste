import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Colors from existing design system (data/theme.ts):
// yellow: #F6D695  (warm background)
// red: #AB2A02     (PRIMARY seed — rust red)
// cream: #FFDC9D
// green: #2D5016   (sustainability CTAs)
// ink: #351609     (dark text)
// muted: #8B5A35
// paper: #FFF6DF
// line: rgba(171,42,2,0.18)

class AppColors {
  const AppColors._();

  static const Color yellow = Color(0xFFF6D695);
  static const Color red = Color(0xFFAB2A02);
  static const Color cream = Color(0xFFFFDC9D);
  static const Color green = Color(0xFF2D5016);
  static const Color ink = Color(0xFF351609);
  static const Color muted = Color(0xFF8B5A35);
  static const Color paper = Color(0xFFFFF6DF);
  static const Color line = Color(0x2FAB2A02); // rgba(171,42,2,0.18)
}

/// ThemeExtension for brand colors not in M3 palette.
@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
    required this.sustainabilityGreen,
    required this.warmYellow,
  });

  final Color sustainabilityGreen;
  final Color warmYellow;

  @override
  AppThemeExtension copyWith({
    Color? sustainabilityGreen,
    Color? warmYellow,
  }) {
    return AppThemeExtension(
      sustainabilityGreen: sustainabilityGreen ?? this.sustainabilityGreen,
      warmYellow: warmYellow ?? this.warmYellow,
    );
  }

  @override
  AppThemeExtension lerp(AppThemeExtension? other, double t) {
    if (other == null) return this;
    return AppThemeExtension(
      sustainabilityGreen:
          Color.lerp(sustainabilityGreen, other.sustainabilityGreen, t)!,
      warmYellow: Color.lerp(warmYellow, other.warmYellow, t)!,
    );
  }
}

abstract final class AppTheme {
  static ThemeData light() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFAB2A02),
      ),
      useMaterial3: true,
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData().textTheme),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      extensions: const [
        AppThemeExtension(
          sustainabilityGreen: AppColors.green,
          warmYellow: AppColors.yellow,
        ),
      ],
    );
  }

  static ThemeData dark() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFAB2A02),
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
      textTheme: GoogleFonts.poppinsTextTheme(
        ThemeData(brightness: Brightness.dark).textTheme,
      ),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      extensions: const [
        AppThemeExtension(
          sustainabilityGreen: AppColors.green,
          warmYellow: AppColors.yellow,
        ),
      ],
    );
  }
}
