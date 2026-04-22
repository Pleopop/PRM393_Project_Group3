import 'package:flutter/material.dart';
import '../models/stat_model.dart';
import 'dashboard_colors.dart';

class StatCard extends StatefulWidget {
  final StatModel stat;
  final List<Color> gradient;
  const StatCard({super.key, required this.stat, required this.gradient});

  @override
  State<StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<StatCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _anim = Tween<double>(begin: 0, end: widget.stat.rawValue)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final st = widget.stat;
    final isUp = st.trend == 'up';
    final isDown = st.trend == 'down';
    final trendColor = isUp ? DashboardColors.primary : isDown ? DashboardColors.secondary : DashboardColors.textSub;
    final trendBg = isUp
        ? DashboardColors.primary.withOpacity(0.1)
        : isDown
            ? DashboardColors.secondary.withOpacity(0.1)
            : Colors.grey.withOpacity(0.08);

    return Container(
      width: 130,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: DashboardColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: DashboardColors.border),
        boxShadow: [
          BoxShadow(
            color: DashboardColors.primary.withOpacity(0.06),
            blurRadius: 8, offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 28, height: 28,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: widget.gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(st.icon, size: 14, color: Colors.white),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: trendBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isUp ? Icons.keyboard_arrow_up_rounded
                           : isDown ? Icons.keyboard_arrow_down_rounded
                                    : Icons.remove_rounded,
                      size: 10,
                      color: trendColor,
                    ),
                    Text(
                      st.trend != 'flat'
                          ? '${st.change.toStringAsFixed(1)}%'
                          : '–',
                      style: TextStyle(
                        fontSize: 9, fontWeight: FontWeight.w700,
                        color: DashboardColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          AnimatedBuilder(
            animation: _anim,
            builder: (_, __) {
              final usesServerValue = !_isNumeric(st.value);
              final val = usesServerValue
                  ? st.value
                  : st.suffix.isEmpty
                      ? _anim.value.round().toString()
                      : _anim.value.toStringAsFixed(
                          st.rawValue.toString().contains('.') &&
                                  st.rawValue.toString().split('.')[1].isNotEmpty
                              ? 1
                              : 0);
              return RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: val,
                      style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w800,
                        color: DashboardColors.textMain,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                    if (st.suffix.isNotEmpty)
                      TextSpan(
                        text: ' ${st.suffix}',
                        style: TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w600,
                          color: widget.gradient[0],
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 2),
          Text(st.labelVi,
            style: const TextStyle(fontSize: 12, color: DashboardColors.textSub),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  bool _isNumeric(String value) => double.tryParse(value) != null;
}
