import 'package:flutter/material.dart';
import '../models/stat_model.dart';
import 'stat_card.dart';

class StatCardsRow extends StatelessWidget {
  final List<StatModel> stats;
  const StatCardsRow({super.key, required this.stats});

  static const _gradients = [
    [Color(0xFF7C6FCD), Color(0xFFE9A0BE)],
    [Color(0xFFE9A0BE), Color(0xFF7C6FCD)],
    [Color(0xFF9B8FE0), Color(0xFF7C6FCD)],
    [Color(0xFF7C6FCD), Color(0xFF9B8FE0)],
    [Color(0xFFE9A0BE), Color(0xFF9B8FE0)],
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: stats.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) => StatCard(
          stat: stats[i],
          gradient: _gradients[i % _gradients.length],
        ),
      ),
    );
  }
}
