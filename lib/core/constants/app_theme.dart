import 'package:flutter/material.dart';

// â”€â”€ Brand Palette â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF1E6FD9);
  static const Color primaryLight = Color(0xFF4A8FE8);
  static const Color primaryDark = Color(0xFF1254A8);
  static const Color primaryContainer = Color(0xFFD6E4FA);

  static const Color secondary = Color(0xFF00BFA5);
  static const Color secondaryContainer = Color(0xFFCCF5F0);

  static const Color error = Color(0xFFD32F2F);
  static const Color errorContainer = Color(0xFFFFDAD6);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningContainer = Color(0xFFFEF3C7);

  static const Color success = Color(0xFF10B981);
  static const Color successContainer = Color(0xFFD1FAE5);

  // Pipeline stage colours
  static const Color stageApplied = Color(0xFF64748B);
  static const Color stageShortlisted = Color(0xFF3B82F6);
  static const Color stageInterview = Color(0xFFF59E0B);
  static const Color stageHired = Color(0xFF10B981);
  static const Color stageRejected = Color(0xFFEF4444);

  // Light surface tones
  static const Color surfaceLight = Color(0xFFF8FAFC);
  static const Color surfaceVariantLight = Color(0xFFEFF3FB);
  static const Color onSurfaceLight = Color(0xFF0F172A);
  static const Color outlineLight = Color(0xFFCBD5E1);

  // Dark surface tones
  static const Color surfaceDark = Color(0xFF0F172A);
  static const Color surfaceVariantDark = Color(0xFF1E293B);
  static const Color onSurfaceDark = Color(0xFFF1F5F9);
  static const Color outlineDark = Color(0xFF334155);
}

// â”€â”€ Text Styles â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class AppTextStyles {
  AppTextStyles._();

  static const String _displayFont = 'SpaceGrotesk';
  static const String _bodyFont = 'DMSans';

  static const TextStyle displayLarge = TextStyle(
    fontFamily: _displayFont,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: _displayFont,
    fontSize: 26,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontFamily: _displayFont,
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: _displayFont,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: _displayFont,
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _bodyFont,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _bodyFont,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: _bodyFont,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: _bodyFont,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: _bodyFont,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: _bodyFont,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );
}

// â”€â”€ Theme Builder â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class AppTheme {
  AppTheme._();

  static ThemeData light() => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          primaryContainer: AppColors.primaryContainer,
          secondary: AppColors.secondary,
          secondaryContainer: AppColors.secondaryContainer,
          error: AppColors.error,
          errorContainer: AppColors.errorContainer,
          surface: AppColors.surfaceLight,
          onSurface: AppColors.onSurfaceLight,
          outline: AppColors.outlineLight,
        ),
        scaffoldBackgroundColor: AppColors.surfaceLight,
        fontFamily: 'DMSans',
        textTheme: _buildTextTheme(AppColors.onSurfaceLight),
        appBarTheme: _appBarTheme(
          background: AppColors.surfaceLight,
          foreground: AppColors.onSurfaceLight,
          shadowColor: AppColors.outlineLight,
        ),
        cardTheme: _cardTheme(AppColors.surfaceLight),
        inputDecorationTheme: _inputTheme(
          fill: AppColors.surfaceVariantLight,
          border: AppColors.outlineLight,
          focus: AppColors.primary,
          label: AppColors.onSurfaceLight.withValues(alpha: 0.6),
        ),
        elevatedButtonTheme: _elevatedButtonTheme(),
        outlinedButtonTheme: _outlinedButtonTheme(),
        textButtonTheme: _textButtonTheme(),
        chipTheme: _chipTheme(AppColors.primaryContainer, AppColors.primary),
        bottomNavigationBarTheme: _bottomNavTheme(
          bg: AppColors.surfaceLight,
          selected: AppColors.primary,
          unselected: AppColors.onSurfaceLight.withValues(alpha: 0.5),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.outlineLight,
          space: 1,
          thickness: 1,
        ),
        snackBarTheme: _snackBarTheme(),
      );

  static ThemeData dark() => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
          primary: AppColors.primaryLight,
          primaryContainer: AppColors.primaryDark,
          secondary: AppColors.secondary,
          secondaryContainer: const Color(0xFF004D45),
          error: const Color(0xFFFF8A80),
          surface: AppColors.surfaceDark,
          onSurface: AppColors.onSurfaceDark,
          outline: AppColors.outlineDark,
        ),
        scaffoldBackgroundColor: AppColors.surfaceDark,
        fontFamily: 'DMSans',
        textTheme: _buildTextTheme(AppColors.onSurfaceDark),
        appBarTheme: _appBarTheme(
          background: AppColors.surfaceDark,
          foreground: AppColors.onSurfaceDark,
          shadowColor: Colors.transparent,
        ),
        cardTheme: _cardTheme(AppColors.surfaceVariantDark),
        inputDecorationTheme: _inputTheme(
          fill: AppColors.surfaceVariantDark,
          border: AppColors.outlineDark,
          focus: AppColors.primaryLight,
          label: AppColors.onSurfaceDark.withValues(alpha: 0.6),
        ),
        elevatedButtonTheme: _elevatedButtonTheme(isDark: true),
        outlinedButtonTheme: _outlinedButtonTheme(isDark: true),
        textButtonTheme: _textButtonTheme(isDark: true),
        chipTheme: _chipTheme(AppColors.primaryDark, AppColors.primaryLight),
        bottomNavigationBarTheme: _bottomNavTheme(
          bg: AppColors.surfaceVariantDark,
          selected: AppColors.primaryLight,
          unselected: AppColors.onSurfaceDark.withValues(alpha: 0.4),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.outlineDark,
          space: 1,
          thickness: 1,
        ),
        snackBarTheme: _snackBarTheme(isDark: true),
      );

  // â”€â”€ Private builders â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  static TextTheme _buildTextTheme(Color color) => TextTheme(
        displayLarge: AppTextStyles.displayLarge.copyWith(color: color),
        displayMedium: AppTextStyles.displayMedium.copyWith(color: color),
        headlineLarge: AppTextStyles.headlineLarge.copyWith(color: color),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(color: color),
        headlineSmall: AppTextStyles.headlineSmall.copyWith(color: color),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: color),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(color: color),
        bodySmall: AppTextStyles.bodySmall
            .copyWith(color: color.withValues(alpha: 0.7)),
        labelLarge: AppTextStyles.labelLarge.copyWith(color: color),
        labelMedium: AppTextStyles.labelMedium.copyWith(color: color),
        labelSmall: AppTextStyles.labelSmall.copyWith(color: color),
      );

  static AppBarTheme _appBarTheme({
    required Color background,
    required Color foreground,
    required Color shadowColor,
  }) =>
      AppBarTheme(
        backgroundColor: background,
        foregroundColor: foreground,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: shadowColor,
        centerTitle: false,
        titleTextStyle: AppTextStyles.headlineMedium.copyWith(
          color: foreground,
        ),
        iconTheme: IconThemeData(color: foreground),
      );

  static CardThemeData _cardTheme(Color surface) => CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.outlineLight),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      );

  static InputDecorationTheme _inputTheme({
    required Color fill,
    required Color border,
    required Color focus,
    required Color label,
  }) =>
      InputDecorationTheme(
        filled: true,
        fillColor: fill,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: label),
        labelStyle: AppTextStyles.bodyMedium.copyWith(color: label),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: focus, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
      );

  static ElevatedButtonThemeData _elevatedButtonTheme({bool isDark = false}) =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? AppColors.primaryLight : AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.labelLarge,
          elevation: 0,
        ),
      );

  static OutlinedButtonThemeData _outlinedButtonTheme({bool isDark = false}) =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: isDark ? AppColors.primaryLight : AppColors.primary,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(
            color: isDark ? AppColors.primaryLight : AppColors.primary,
            width: 1.5,
          ),
          textStyle: AppTextStyles.labelLarge,
        ),
      );

  static TextButtonThemeData _textButtonTheme({bool isDark = false}) =>
      TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: isDark ? AppColors.primaryLight : AppColors.primary,
          textStyle: AppTextStyles.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );

  static ChipThemeData _chipTheme(Color container, Color label) =>
      ChipThemeData(
        backgroundColor: container,
        labelStyle: AppTextStyles.labelSmall.copyWith(color: label),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      );

  static BottomNavigationBarThemeData _bottomNavTheme({
    required Color bg,
    required Color selected,
    required Color unselected,
  }) =>
      BottomNavigationBarThemeData(
        backgroundColor: bg,
        selectedItemColor: selected,
        unselectedItemColor: unselected,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: AppTextStyles.labelSmall,
        unselectedLabelStyle: AppTextStyles.labelSmall,
      );

  static SnackBarThemeData _snackBarTheme({bool isDark = false}) =>
      SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor:
            isDark ? AppColors.surfaceVariantDark : AppColors.onSurfaceLight,
      );
}
