import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class StatCard extends StatelessWidget {
  final String label;
  final double rawValue;
  final String suffix;
  final IconData icon;
  final List<Color> gradientColors;
  final double trendValue; // Thêm % biến động

  const StatCard({
    Key? key, required this.label, required this.rawValue, 
    required this.suffix, required this.icon, required this.gradientColors,
    required this.trendValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isPositive = trendValue >= 0;
    // Lấy màu trend từ custom theme (hoặc dùng mặc định nếu chưa có)
    final customTheme = Theme.of(context).extension<CustomAppTheme>();
    final p1 = customTheme?.chart1 ?? const Color(0xFF7C3AED); // Màu tăng
    final p2 = customTheme?.chart5 ?? const Color(0xFFF472B6); // Màu giảm

    return Container(
      padding: const EdgeInsets.all(12), // Giảm padding một chút cho màn hình mobile
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppColors.radius),
        border: Border.all(color: Colors.white.withOpacity(0.03)), // Viền sáng rất mờ giống Figma
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Tự động dãn đều trên/dưới
        children: [
          // Row 1: Label & Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.mutedForeground)),
              Container(
                width: 28, height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle, // Trong Figma icon nằm trong hình tròn
                  gradient: LinearGradient(colors: gradientColors),
                ),
                child: Icon(icon, size: 14, color: Colors.white),
              ),
            ],
          ),
          
          // Row 2: Large Number
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                rawValue.toStringAsFixed(suffix == 'h' ? 1 : 0), 
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)
              ),
              const SizedBox(width: 4),
              Text(suffix, style: const TextStyle(fontSize: 12, color: AppColors.mutedForeground)),
            ],
          ),

          // Row 3: Trend (Mũi tên + % phần trăm)
          Row(
            children: [
              Icon(isPositive ? Icons.trending_up : Icons.trending_down, size: 14, color: isPositive ? p1 : p2),
              const SizedBox(width: 4),
              Text(
                '${isPositive ? '+' : ''}${trendValue.toStringAsFixed(1)}%',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isPositive ? p1 : p2),
              ),
            ],
          )
        ],
      ),
    );
  }
}