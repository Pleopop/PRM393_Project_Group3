class ChartPointModel {
  final String label;
  final String shortLabel;
  final double hours;
  final double ma7;
  final bool isGain;
  final double change;

  const ChartPointModel({
    required this.label,
    required this.shortLabel,
    required this.hours,
    required this.ma7,
    required this.isGain,
    required this.change,
  });
}
