import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/helpers.dart';

class StatHeaderCard extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  final bool isEditing;
  final VoidCallback onEditToggle;

  const StatHeaderCard({required this.name, this.avatarUrl, required this.isEditing, required this.onEditToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFA594F9).withOpacity(0.12)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: const Color(0xFFA594F9),
            backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
            child: avatarUrl == null ? Text(getInitials(name), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)) : null,
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white))),
        ],
      ),
    );
  }
}