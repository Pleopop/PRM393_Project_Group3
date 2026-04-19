import 'stat_model.dart';
import 'chart_point_model.dart';

class OverviewModel {
  final List<StatModel> stats;
  final List<ChartPointModel> monthlyChart;
  final List<ChartPointModel> yearlyChart;

  const OverviewModel({
    required this.stats,
    required this.monthlyChart,
    required this.yearlyChart,
  });
}
