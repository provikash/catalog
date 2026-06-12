import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────
//  Colors
// ─────────────────────────────────────────
class AppColors {
  AppColors._();

  // Primary
  static const primary      = Color(0xFF5C6BC0);
  static const primaryLight = Color(0xFF8E99F3);
  static const primaryDark  = Color(0xFF26418F);

  // Accent
  static const accent = Color(0xFFFF6F61);

  // Light surface
  static const backgroundLight    = Color(0xFFF6F7FB);
  static const surfaceLight       = Color(0xFFFFFFFF);
  static const surfaceVariantLight = Color(0xFFEEEFF5);
  static const onBackgroundLight  = Color(0xFF1A1C2E);
  static const onSurfaceLight     = Color(0xFF2D2F45);

  // Dark surface
  static const backgroundDark    = Color(0xFF12131C);
  static const surfaceDark       = Color(0xFF1E2030);
  static const surfaceVariantDark = Color(0xFF2A2D3E);
  static const onBackgroundDark  = Color(0xFFF0F1FA);
  static const onSurfaceDark     = Color(0xFFDEDFF0);

  // Semantic
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFFC107);
  static const error   = Color(0xFFEF5350);
}

// ─────────────────────────────────────────
//  Text Styles
// ─────────────────────────────────────────
class AppTextStyles {
  AppTextStyles._();

  static const heading = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const title = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
  );

  static const subtitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static const body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  static const caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Color(0xFF9B9DB8),
  );

  static const price = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.3,
  );

  static const button = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
  );
}

// ─────────────────────────────────────────
//  Theme
// ─────────────────────────────────────────
class AppTheme {
  AppTheme._();

  // ── Light ────────────────────────────
  static ThemeData get light {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primaryLight,
      onPrimaryContainer: AppColors.primaryDark,
      secondary: AppColors.accent,
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFFFE0DC),
      onSecondaryContainer: Color(0xFF8B1A10),
      surface: AppColors.surfaceLight,
      onSurface: AppColors.onSurfaceLight,
      surfaceVariant: AppColors.surfaceVariantLight,
      onSurfaceVariant: Color(0xFF5A5C72),
      background: AppColors.backgroundLight,
      onBackground: AppColors.onBackgroundLight,
      error: AppColors.error,
      onError: Colors.white,
      outline: Color(0xFFD0D1E0),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.backgroundLight,

      // ── AppBar ──
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.onBackgroundLight),
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.onBackgroundLight,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),

      // ── Card ──
      cardTheme: CardThemeData(
        color: AppColors.surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.zero,
      ),

      // ── ElevatedButton ──
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: AppTextStyles.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),

      // ── TextButton ──
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.subtitle,
        ),
      ),

      // ── OutlinedButton ──
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),

      // ── Input ──
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariantLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintStyle: const TextStyle(
          color: Color(0xFFAAABBE),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),

      // ── BottomSheet ──
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surfaceLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        elevation: 0,
      ),

      // ── Chip ──
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceVariantLight,
        selectedColor: AppColors.primary,
        labelStyle: AppTextStyles.caption,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: BorderSide.none,
      ),

      // ── Divider ──
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE8E9F2),
        thickness: 1,
        space: 1,
      ),

      // ── SnackBar ──
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.onBackgroundLight,
        contentTextStyle: AppTextStyles.body.copyWith(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),

      // ── Text ──
      textTheme: const TextTheme(
        headlineLarge:  AppTextStyles.heading,
        titleLarge:     AppTextStyles.title,
        titleMedium:    AppTextStyles.subtitle,
        bodyLarge:      AppTextStyles.body,
        bodySmall:      AppTextStyles.caption,
        labelLarge:     AppTextStyles.button,
      ),
    );
  }

  // ── Dark ─────────────────────────────
  static ThemeData get dark {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primaryLight,
      onPrimary: AppColors.primaryDark,
      primaryContainer: AppColors.primaryDark,
      onPrimaryContainer: AppColors.primaryLight,
      secondary: AppColors.accent,
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFF5C1A10),
      onSecondaryContainer: Color(0xFFFFCDC9),
      surface: AppColors.surfaceDark,
      onSurface: AppColors.onSurfaceDark,
      surfaceVariant: AppColors.surfaceVariantDark,
      onSurfaceVariant: Color(0xFF9B9DB8),
      background: AppColors.backgroundDark,
      onBackground: AppColors.onBackgroundDark,
      error: AppColors.error,
      onError: Colors.white,
      outline: Color(0xFF3A3D55),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.backgroundDark,

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.onBackgroundDark),
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.onBackgroundDark,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),

      cardTheme: CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.zero,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: AppColors.primaryDark,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: AppTextStyles.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryLight,
          textStyle: AppTextStyles.subtitle,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariantDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: AppColors.primaryLight, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintStyle: const TextStyle(
          color: Color(0xFF6B6D88),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        elevation: 0,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceVariantDark,
        selectedColor: AppColors.primaryLight,
        labelStyle: AppTextStyles.caption,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: BorderSide.none,
      ),

      dividerTheme: const DividerThemeData(
        color: Color(0xFF2E3048),
        thickness: 1,
        space: 1,
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceVariantDark,
        contentTextStyle:
            AppTextStyles.body.copyWith(color: AppColors.onSurfaceDark),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),

      textTheme: const TextTheme(
        headlineLarge: AppTextStyles.heading,
        titleLarge:    AppTextStyles.title,
        titleMedium:   AppTextStyles.subtitle,
        bodyLarge:     AppTextStyles.body,
        bodySmall:     AppTextStyles.caption,
        labelLarge:    AppTextStyles.button,
      ),
    );
  }
}