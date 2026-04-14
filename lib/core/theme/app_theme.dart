import 'package:flutter/material.dart';

/// Chứa toàn bộ các màu sắc được convert chính xác từ hệ oklch sang HEX
class AppColors {
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
  static const Color destructive = Color(0xFF7C2025); // oklch(0.396 0.141 25.723)
  static const Color destructiveForeground = Color(0xFFD15A5A); // oklch(0.637 0.237 25.331)
  
  // Border, Input, Ring
  static const Color border = Color(0xFF3A3A3A);
  static const Color input = Color(0xFF3A3A3A);
  static const Color ring = Color(0xFF636363); // oklch(0.439 0 0)

  // Bán kính bo góc (0.625rem ~ 10px)
  static const double radius = 10.0; 
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
  ThemeExtension<CustomAppTheme> lerp(ThemeExtension<CustomAppTheme>? other, double t) => this;
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      
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
        displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, height: 1.5, color: AppColors.foreground), // h1
        displayMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, height: 1.5, color: AppColors.foreground), // h2
        displaySmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, height: 1.5, color: AppColors.foreground), // h3
        headlineMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, height: 1.5, color: AppColors.foreground), // h4
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 1.5, color: AppColors.foreground), // input, body
        labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, height: 1.5, color: AppColors.foreground), // button, label
      ),

      // Custom Input (Dựa trên thẻ input và @apply border-border outline-ring/50)
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
          borderSide: const BorderSide(color: AppColors.ring, width: 2), // Ring outline
        ),
      ),

      // Custom Checkbox (Khớp chính xác CSS input[type="checkbox"])
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)), // 0.25rem
        side: const BorderSide(color: Color(0xFFCBD5E1), width: 2), // Giữ màu border light của bạn vì CSS gốc fix cứng màu này
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return const Color(0xFF7C65C1).withOpacity(0.6); 
          }
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF7C65C1);
          }
          return Colors.transparent; // Nền trong suốt khi chưa check ở Dark mode
        }),
      ),

      // Đăng ký ThemeExtension đã tạo ở trên
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
}