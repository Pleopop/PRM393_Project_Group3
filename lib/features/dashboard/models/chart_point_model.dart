class ChartPointModel {
  final String id;
  final String label;
  final String shortLabel;
  final double hours;
  final double open;
  final double close;
  final double high;
  final double low;
  final double ma7;
  final bool isGain;
  final double change;
  final double volume;

  const ChartPointModel({
    required this.id,
    required this.label,
    required this.shortLabel,
    required this.hours,
    required this.open,
    required this.close,
    required this.high,
    required this.low,
    required this.ma7,
    required this.isGain,
    required this.change,
    required this.volume,
  });

  factory ChartPointModel.fromJson(Map<String, dynamic> json) {
    return ChartPointModel(
      id: (json['id'] ?? '').toString(),
      label: (json['label'] ?? '').toString(),
      shortLabel: (json['shortLabel'] ?? '').toString(),
      hours: _toDouble(json['hours']),
      open: _toDouble(json['open']),
      close: _toDouble(json['close']),
      high: _toDouble(json['high']),
      low: _toDouble(json['low']),
      ma7: _toDouble(json['ma7']),
      isGain: json['isGain'] == true,
      change: _toDouble(json['change']),
      volume: _toDouble(json['volume']),
    );
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}
