import 'package:flutter/material.dart';

class StatModel {
  final String id;
  final String label;
  final String labelVi;
  final String value;
  final double rawValue;
  final String suffix;
  final String trend; // 'up' | 'down' | 'flat'
  final double change;
  final IconData icon;

  const StatModel({
    required this.id,
    required this.label,
    required this.labelVi,
    required this.value,
    required this.rawValue,
    required this.suffix,
    required this.trend,
    required this.change,
    required this.icon,
  });
}
