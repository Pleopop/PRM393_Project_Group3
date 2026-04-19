import 'package:flutter/material.dart';
import 'dashboard_colors.dart';

class TimeframeToggle extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const TimeframeToggle({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFFF0EEFF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _Tab(label: 'Tháng', selected: value == 'month',
               onTap: () => onChanged('month')),
          const SizedBox(width: 4),
          _Tab(label: 'Năm', selected: value == 'year',
               onTap: () => onChanged('year')),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Tab({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(
                  colors: [DashboardColors.primary, DashboardColors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : DashboardColors.textSub,
          ),
        ),
      ),
    );
  }
}
