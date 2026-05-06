import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pediatrack/core/services/who_growth_service.dart';

class WhoGrowthChart extends StatelessWidget {
  const WhoGrowthChart({
    super.key,
    required this.childId,
    required this.gender,
    required this.records,
    required this.type,
    required this.birthDate,
  });

  final int childId;
  final int gender;
  final List<WhoGrowthRecord> records;
  final GrowthType type;
  final DateTime birthDate;

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return const SizedBox.shrink();
    }

    final chartData = <FlSpot>[];
    for (final record in records) {
      final ageMonths = _calculateAgeMonths(record.date);
      if (ageMonths >= 0 && ageMonths <= 60) {
        double value = type == GrowthType.weight ? record.weight! : record.height!;
        if (type == GrowthType.weight) {
          value = value * 2.20462;
        }
        chartData.add(FlSpot(ageMonths.toDouble(), value));
      }
    }

    if (chartData.isEmpty) {
      return const SizedBox.shrink();
    }

    chartData.sort((a, b) => a.x.compareTo(b.x));

    records.sort((a, b) => a.date.compareTo(b.date));
    final latestRecord = records.last;
    final latestAgeMonths = _calculateAgeMonths(latestRecord.date).clamp(0, 60);
    final latestValue = type == GrowthType.weight ? latestRecord.weight : latestRecord.height;
    final latestEvaluation = latestValue == null
        ? null
        : whoGrowthService.evaluate(
            value: latestValue,
            ageMonths: latestAgeMonths,
            gender: gender,
            type: type,
          );

    final whoService = whoGrowthService;
    final percentileCurves = <String, List<FlSpot>>{};
    final curveColors = {
      'P3': Colors.orange,
      'P15': Colors.yellow[700]!,
      'P50': Colors.green,
      'P85': Colors.yellow[700]!,
      'P97': Colors.orange,
    };

    for (final curve in whoService.getAllPercentileCurves(gender: gender, type: type)) {
      final points = whoService.getPercentileCurve(gender: gender, type: type, percentile: curve.percentile);
      percentileCurves[curve.label] = points
          .map((p) => FlSpot(p.ageMonths, type == GrowthType.weight ? p.value * 2.20462 : p.value))
          .toList();
    }

    final minAge = chartData.first.x.clamp(0.0, 60.0);
    final maxAge = chartData.last.x.clamp(0.0, 60.0);
    final allValues = [...chartData.map((p) => p.y), ...percentileCurves.values.expand((p) => p.map((sp) => sp.y))];
    final rawMinValue = allValues.reduce((a, b) => a < b ? a : b);
    final rawMaxValue = allValues.reduce((a, b) => a > b ? a : b);
    final minValue = (rawMinValue * 0.85).floorToDouble();
    final maxValue = (rawMaxValue * 1.15).ceilToDouble();
    final yInterval = type == GrowthType.weight ? 2.0 : 10.0;

    final lineBarsData = <LineChartBarData>[];

    for (final entry in percentileCurves.entries) {
      lineBarsData.add(LineChartBarData(
        spots: entry.value.where((p) => p.x >= minAge && p.x <= maxAge).toList(),
        isCurved: true,
        color: curveColors[entry.key]!.withValues(alpha: 0.6),
        barWidth: 1.5,
        dotData: const FlDotData(show: false),
        dashArray: entry.key == 'P50' ? null : [5, 5],
      ));
    }

    final dataColor = type == GrowthType.weight ? Colors.blue : Colors.green;
    lineBarsData.add(LineChartBarData(
      spots: chartData,
      isCurved: true,
      color: dataColor,
      barWidth: 3,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
          radius: 2.2,
          color: dataColor,
          strokeWidth: 1.2,
          strokeColor: Colors.white,
        ),
      ),
    ));

    final unit = type == GrowthType.weight ? 'lb' : 'cm';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Unidad: $unit',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem('P3/P97', Colors.orange),
            const SizedBox(width: 16),
            _buildLegendItem('P50', Colors.green),
            const SizedBox(width: 16),
            _buildLegendItem(type == GrowthType.weight ? 'Peso' : 'Estatura', dataColor),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 250,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                horizontalInterval: yInterval,
                verticalInterval: 12,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.grey.withValues(alpha: 0.2),
                  strokeWidth: 1,
                ),
                getDrawingVerticalLine: (value) => FlLine(
                  color: Colors.grey.withValues(alpha: 0.2),
                  strokeWidth: 1,
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 50,
                    interval: yInterval,
                    getTitlesWidget: (value, meta) => SideTitleWidget(
                      axisSide: meta.axisSide,
                      space: 8,
                      child: Text(
                        value.toStringAsFixed(type == GrowthType.weight ? 1 : 0),
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: 12,
                    getTitlesWidget: (value, meta) => Text(
                      '${value.toInt()}m',
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
              ),
              minX: minAge,
              maxX: maxAge,
              minY: minValue,
              maxY: maxValue,
              lineBarsData: lineBarsData,
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  tooltipBgColor: Colors.black87,
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      final isData = spot.barIndex == lineBarsData.length - 1;
                      final label = isData ? (type == GrowthType.weight ? 'Peso' : 'Estatura') : 'Percentil';
                      final value = spot.y.toStringAsFixed(2);
                      return LineTooltipItem(
                        '$label: $value $unit\n${spot.x.toInt()} meses',
                        TextStyle(color: isData ? dataColor : spot.bar.color, fontSize: 12),
                      );
                    }).toList();
                  },
                ),
              ),
            ),
          ),
        ),
        if (latestEvaluation != null) ...[
          const SizedBox(height: 10),
          _GrowthSummaryCard(
            type: type,
            percentile: latestEvaluation.percentile,
            category: latestEvaluation.category,
          ),
        ],
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  int _calculateAgeMonths(DateTime recordDate) {
    return (recordDate.year - birthDate.year) * 12 + (recordDate.month - birthDate.month);
  }
}

class _GrowthSummaryCard extends StatelessWidget {
  const _GrowthSummaryCard({
    required this.type,
    required this.percentile,
    required this.category,
  });

  final GrowthType type;
  final double percentile;
  final String category;

  @override
  Widget build(BuildContext context) {
    final isInRange = percentile >= 3 && percentile <= 97;
    final isWarning = percentile < 3 || percentile > 97;
    final color = isWarning ? Colors.orange : Colors.green;
    final metric = type == GrowthType.weight ? 'peso' : 'estatura';

    final message = isInRange
        ? 'Dentro de la curva esperada para $metric (P${percentile.toStringAsFixed(0)}).'
        : 'Fuera de la curva esperada para $metric (P${percentile.toStringAsFixed(0)}). Conviene revisar.';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Icon(isInRange ? Icons.check_circle : Icons.warning_amber_rounded, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$message Categoría: $category.',
              style: TextStyle(
                color: color.withValues(alpha: 0.95),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WhoGrowthRecord {
  final int id;
  final int childId;
  final double? weight;
  final double? height;
  final double? headCircumference;
  final DateTime date;

  const WhoGrowthRecord({
    required this.id,
    required this.childId,
    this.weight,
    this.height,
    this.headCircumference,
    required this.date,
  });
}
