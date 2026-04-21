library policies_screen;

import 'package:flutter/material.dart';
import 'package:project_group3/features/dashboard/widgets/dashboard_colors.dart';

part 'policies_screen/data.dart';
part 'policies_screen/theme.dart';
part 'policies_screen/hero_header.dart';
part 'policies_screen/intro_paragraph.dart';
part 'policies_screen/rule_card.dart';

class PoliciesScreen extends StatelessWidget {
  const PoliciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: CustomScrollView(
        slivers: [
          // ── Hero header ──
          SliverToBoxAdapter(child: _HeroHeader()),

          // ── Intro paragraph ──
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 4),
              child: _IntroParagraph(),
            ),
          ),

          // ── Rule sections ──
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _RuleCard(section: _sections[i]),
                ),
                childCount: _sections.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}