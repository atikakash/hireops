import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_theme.dart';

class PipelineBarChart extends StatelessWidget {
  final Map<String, int> data;

  const PipelineBarChart({super.key, required this.data});

  static const _stageColors = {
    'Applied': AppColors.stageApplied,
    'Shortlisted': AppColors.stageShortlisted,
    'Interview': AppColors.stageInterview,
    'Hired': AppColors.stageHired,
    'Rejected': AppColors.stageRejected,
  };

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();

    final stages = _stageColors.keys.toList();
    final maxVal = data.values.fold<int>(0, (p, e) => e > p ? e : p).toDouble();

    return SizedBox(
      height: 160,
      child: BarChart(
        BarChartData(
          maxY: (maxVal * 1.25).ceilToDouble() + 1,
          gridData: FlGridData(
            drawVerticalLine: false,
            horizontalInterval: (maxVal / 4).ceilToDouble().clamp(1, 9999),
            getDrawingHorizontalLine: (v) => FlLine(
              color:
                  Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            topTitles: const AxisTitles(),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (val, _) {
                  final idx = val.toInt();
                  if (idx < 0 || idx >= stages.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      stages[idx].substring(0, 3),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: _stageColors[stages[idx]],
                      ),
                    ),
                  );
                },
                reservedSize: 24,
              ),
            ),
          ),
          barGroups: stages.asMap().entries.map((e) {
            final count = (data[e.value] ?? 0).toDouble();
            final color = _stageColors[e.value]!;
            return BarChartGroupData(
              x: e.key,
              barRods: [
                BarChartRodData(
                  toY: count,
                  color: color,
                  width: 28,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(6),
                  ),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: (maxVal * 1.25).ceilToDouble() + 1,
                    color: color.withValues(alpha: 0.07),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
