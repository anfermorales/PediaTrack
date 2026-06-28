import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:pediatrack/data/database/app_database.dart';

/// A metric widget for displaying growth metrics with label, value, icon, and color.
class GrowthMetric extends StatelessWidget {
  const GrowthMetric({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.outline)),
      ],
    );
  }
}

/// A line chart widget for displaying growth records (weight and height).
class GrowthChart extends StatelessWidget {
  const GrowthChart({super.key, required this.records});

  final List<GrowthRecord> records;

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) return const SizedBox.shrink();

    final weightSpots = <FlSpot>[];
    final heightSpots = <FlSpot>[];

    for (int i = 0; i < records.length; i++) {
      final record = records[i];
      if (record.weight != null) {
        weightSpots.add(FlSpot(i.toDouble(), record.weight!));
      }
      if (record.height != null) {
        heightSpots.add(FlSpot(i.toDouble(), record.height!));
      }
    }

    return SizedBox(
      height: 120,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            if (weightSpots.length > 1)
              LineChartBarData(
                spots: weightSpots,
                isCurved: true,
                color: Colors.blue,
                barWidth: 3,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.blue.withValues(alpha: 0.1),
                ),
              ),
            if (heightSpots.length > 1)
              LineChartBarData(
                spots: heightSpots,
                isCurved: true,
                color: Colors.green,
                barWidth: 3,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.green.withValues(alpha: 0.1),
                ),
              ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.black87,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final isWeight = spot.barIndex == 0;
                  final displayValue = isWeight ? (spot.y * 2.20462).toStringAsFixed(1) : spot.y.toStringAsFixed(1);
                  final unit = isWeight ? 'lb' : 'cm';
                  return LineTooltipItem(
                    '${isWeight ? "Peso" : "Estatura"}: $displayValue $unit',
                    const TextStyle(color: Colors.white, fontSize: 12),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }
}