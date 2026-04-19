import 'package:flutter/material.dart';

import '../models/overview_model.dart';
import '../services/dashboard_service.dart';
import '../widgets/chart_card.dart';
import '../widgets/dashboard_colors.dart';
import '../widgets/right_col.dart';
import '../widgets/stat_cards_row.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  OverviewModel? _vm;
  bool _loading = true;
  String _timeframe = 'month'; // 'month' | 'year'

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final vm = await DashboardService().fetchOverview();
    if (mounted) {
      setState(() {
        _vm = vm;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DashboardColors.bg,
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: DashboardColors.primary))
          : _buildBody(),
    );
  }

  Widget _buildBody() {
    final vm = _vm!;
    final chart = _timeframe == 'month' ? vm.monthlyChart : vm.yearlyChart;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            _buildHeader(),
            const SizedBox(height: 16),

            // ── Stat cards ──
            StatCardsRow(stats: vm.stats),
            const SizedBox(height: 16),

            // ── Chart card ──
            ChartCard(
              chart: chart,
              timeframe: _timeframe,
              onToggle: (tf) => setState(() => _timeframe = tf),
            ),
            const SizedBox(height: 16),

            // ── Insights section (right_col) ──
            _buildInsightsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightsSection() {
    return SizedBox(
      height: 520,
      child: const SidebarInsights(),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [DashboardColors.primary, DashboardColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.auto_stories_rounded,
              color: Colors.white, size: 18),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'StudyBloom',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: DashboardColors.textMain,
              ),
            ),
            const Text(
              'Tổng quan học tập',
              style: TextStyle(
                fontSize: 11,
                color: DashboardColors.textSub,
              ),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.notifications_none_rounded,
              color: DashboardColors.textSub),
          onPressed: () {},
        ),
      ],
    );
  }
}