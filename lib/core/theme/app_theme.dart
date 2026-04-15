import 'package:flutter/material.dart';

/// Chứa toàn bộ các màu sắc được convert chính xác từ hệ oklch sang HEX
class AppColors {
  AppColors._();

  // ── Dark mode (oklch-converted) ──────────────────────────────────────────

  // Nền và chữ cơ bản
  static const Color background = Color(0xFF1B1B1B); // oklch(0.145 0 0)
  static const Color foreground = Color(0xFFFAFAFA); // oklch(0.985 0 0)

  // Card & Popover (trùng với background theo CSS gốc)
  static const Color card = Color(0xFF1B1B1B);
  static const Color cardForeground = Color(0xFFFAFAFA);
  static const Color popover = Color(0xFF1B1B1B);
  static const Color popoverForeground = Color(0xFFFAFAFA);

  // Primary & Secondary
  static const Color primary = Color(0xFFFAFAFA); // oklch(0.985 0 0)
  static const Color primaryForeground = Color(0xFF292929); // oklch(0.205 0 0)
  static const Color secondary = Color(0xFF3A3A3A); // oklch(0.269 0 0)
  static const Color secondaryForeground = Color(0xFFFAFAFA);

  // Muted & Accent
  static const Color muted = Color(0xFF3A3A3A);
  static const Color mutedForeground = Color(0xFFACACAC); // oklch(0.708 0 0)
  static const Color accent = Color(0xFF3A3A3A);
  static const Color accentForeground = Color(0xFFFAFAFA);

  // Destructive (Đỏ)
  static const Color destructive = Color(
    0xFF7C2025,
  ); // oklch(0.396 0.141 25.723)
  static const Color destructiveForeground = Color(
    0xFFD15A5A,
  ); // oklch(0.637 0.237 25.331)

  // Border, Input, Ring
  static const Color border = Color(0xFF3A3A3A);
  static const Color input = Color(0xFF3A3A3A);
  static const Color ring = Color(0xFF636363); // oklch(0.439 0 0)

  // Bán kính bo góc (0.625rem ~ 10px)
  static const double radius = 10.0;

  // ── Light mode ───────────────────────────────────────────────────────────

  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color borderLight = Color(0xFFE2E8F0);

  // Brand (shared)
  static const Color brandPrimary = Color(0xFF4F46E5); // Indigo 600
  static const Color brandSecondary = Color(0xFF0EA5E9); // Sky 500

  // Semantic (shared)
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
}

/// Typography
class AppTextStyles {
  AppTextStyles._();

  static const String fontFamily = 'Roboto';

  static const TextStyle headlineLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle titleLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle labelSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.4,
  );
}

/// ThemeExtension giúp bạn lưu trữ những thuộc tính custom không có sẵn trong Material Theme (Chart, Sidebar)
class CustomAppTheme extends ThemeExtension<CustomAppTheme> {
  final Color chart1;
  final Color chart2;
  final Color chart3;
  final Color chart4;
  final Color chart5;
  final Color sidebar;
  final Color sidebarForeground;
  final Color sidebarPrimary;
  final Color sidebarPrimaryForeground;
  final Color sidebarAccent;
  final Color sidebarAccentForeground;
  final Color sidebarBorder;
  final Color sidebarRing;

  const CustomAppTheme({
    required this.chart1,
    required this.chart2,
    required this.chart3,
    required this.chart4,
    required this.chart5,
    required this.sidebar,
    required this.sidebarForeground,
    required this.sidebarPrimary,
    required this.sidebarPrimaryForeground,
    required this.sidebarAccent,
    required this.sidebarAccentForeground,
    required this.sidebarBorder,
    required this.sidebarRing,
  });

  @override
  ThemeExtension<CustomAppTheme> copyWith() => this;

  @override
  ThemeExtension<CustomAppTheme> lerp(
    ThemeExtension<CustomAppTheme>? other,
    double t,
  ) => this;
}

class AppTheme {
  AppTheme._();

  // ── Light theme ───────────────────────────────────────────────────────────
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    fontFamily: AppTextStyles.fontFamily,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.brandPrimary,
      primary: AppColors.brandPrimary,
      secondary: AppColors.brandSecondary,
      error: AppColors.error,
      surface: AppColors.surfaceLight,
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surfaceLight,
      foregroundColor: AppColors.textPrimaryLight,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: AppColors.textPrimaryLight,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.brandPrimary,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColors.radius),
        ),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceLight,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppColors.radius),
        borderSide: const BorderSide(color: AppColors.borderLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppColors.radius),
        borderSide: const BorderSide(color: AppColors.borderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppColors.radius),
        borderSide: const BorderSide(color: AppColors.brandPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppColors.radius),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      hintStyle: const TextStyle(color: AppColors.textSecondaryLight),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surfaceLight,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.borderLight),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.borderLight,
      thickness: 1,
    ),
    textTheme:
        const TextTheme(
          headlineLarge: AppTextStyles.headlineLarge,
          headlineMedium: AppTextStyles.headlineMedium,
          titleLarge: AppTextStyles.titleLarge,
          bodyLarge: AppTextStyles.bodyLarge,
          bodyMedium: AppTextStyles.bodyMedium,
          labelSmall: AppTextStyles.labelSmall,
        ).apply(
          bodyColor: AppColors.textPrimaryLight,
          displayColor: AppColors.textPrimaryLight,
        ),
  );

  // ── Dark theme ────────────────────────────────────────────────────────────
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    fontFamily: AppTextStyles.fontFamily,

    // Ánh xạ màu sắc chuẩn vào ColorScheme
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: AppColors.primaryForeground,
      secondary: AppColors.secondary,
      onSecondary: AppColors.secondaryForeground,
      surface: AppColors.card,
      onSurface: AppColors.foreground,
      error: AppColors.destructive,
      onError: AppColors.destructiveForeground,
      outline: AppColors.border,
    ),

    // Typography (Dựa trên --font-size: 16px và các thẻ h1-h4, p)
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        height: 1.5,
        color: AppColors.foreground,
      ), // h1
      displayMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        height: 1.5,
        color: AppColors.foreground,
      ), // h2
      displaySmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        height: 1.5,
        color: AppColors.foreground,
      ), // h3
      headlineMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.5,
        color: AppColors.foreground,
      ), // h4
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.foreground,
      ),
      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.5,
        color: AppColors.foreground,
      ),
    ),

    // Custom Input
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.input,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppColors.radius),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppColors.radius),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppColors.radius),
        borderSide: const BorderSide(color: AppColors.ring, width: 2),
      ),
    ),

    // Custom Checkbox
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      side: const BorderSide(color: Color(0xFFCBD5E1), width: 2),
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return const Color(0xFF7C65C1).withOpacity(0.6);
        }
        if (states.contains(WidgetState.selected)) {
          return const Color(0xFF7C65C1);
        }
        return Colors.transparent;
      }),
    ),

    extensions: const [
      CustomAppTheme(
        chart1: Color(0xFF3B58DB), // oklch(0.488 0.243 264.376)
        chart2: Color(0xFF2EAA8E), // oklch(0.696 0.17 162.48)
        chart3: Color(0xFFD79133), // oklch(0.769 0.188 70.08)
        chart4: Color(0xFFBD4EB0), // oklch(0.627 0.265 303.9)
        chart5: Color(0xFFE14856), // oklch(0.645 0.246 16.439)
        sidebar: Color(0xFF292929), // oklch(0.205 0 0)
        sidebarForeground: Color(0xFFFAFAFA),
        sidebarPrimary: Color(0xFF3B58DB),
        sidebarPrimaryForeground: Color(0xFFFAFAFA),
        sidebarAccent: Color(0xFF3A3A3A),
        sidebarAccentForeground: Color(0xFFFAFAFA),
        sidebarBorder: Color(0xFF3A3A3A),
        sidebarRing: Color(0xFF636363),
      ),
    ],
  );
}
