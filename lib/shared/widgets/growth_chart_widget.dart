import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import '../../shared/theme/app_colors.dart';

/// Gráfica de crecimiento infantil con estilo moderno
class GrowthChartWidget extends StatelessWidget {
  final List<GrowthDataPoint> dataPoints;
  final Map<double, Color> percentileLines;
  final String title;
  final String unit;
  final double? minY;
  final double? maxY;

  GrowthChartWidget({
    super.key,
    required this.dataPoints,
    Map<double, Color>? percentileLines,
    this.title = 'Crecimiento',
    this.unit = '',
    this.minY,
    this.maxY,
  }) : percentileLines = percentileLines ?? _defaultPercentileLines;

  static final Map<double, Color> _defaultPercentileLines = <double, Color>{
    3: AppColors.chartP3,
    15: AppColors.chartP15,
    50: AppColors.chartP50,
    85: AppColors.chartP85,
    97: AppColors.chartP97,
  };

  @override
  Widget build(BuildContext context) {
    if (dataPoints.isEmpty) {
      return const Center(
        child: Text('No hay datos para mostrar'),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.grey30.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.grey500,
                ),
              ),
              _buildLegend(),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: CustomPaint(
              size: Size.infinite,
              painter: _GrowthChartPainter(
                dataPoints: dataPoints,
                percentileLines: percentileLines,
                minY: minY,
                maxY: maxY,
                unit: unit,
                isDark: Theme.of(context).brightness == Brightness.dark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 12,
      children: [
        _LegendItem(color: AppColors.chartP3, label: 'P3'),
        _LegendItem(color: AppColors.chartP50, label: 'P50', isBold: true),
        _LegendItem(color: AppColors.chartP97, label: 'P97'),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final bool isBold;

  const _LegendItem({
    required this.color,
    required this.label,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: AppColors.grey100,
          ),
        ),
      ],
    );
  }
}

/// Punto de datos de crecimiento
class GrowthDataPoint {
  final DateTime date;
  final double value;
  final double? ageMonths;

  const GrowthDataPoint({
    required this.date,
    required this.value,
    this.ageMonths,
  });
}

class _GrowthChartPainter extends CustomPainter {
  final List<GrowthDataPoint> dataPoints;
  final Map<double, Color> percentileLines;
  final double? minY;
  final double? maxY;
  final String unit;
  final bool isDark;

  _GrowthChartPainter({
    required this.dataPoints,
    required this.percentileLines,
    this.minY,
    this.maxY,
    required this.unit,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (dataPoints.isEmpty) return;

    final leftPadding = 50.0;
    final bottomPadding = 40.0;
    final chartWidth = size.width - leftPadding - 20;
    final chartHeight = size.height - bottomPadding - 20;

    // Encontrar rangos
    double minValue = minY ?? dataPoints.map((e) => e.value).reduce((a, b) => a < b ? a : b);
    double maxValue = maxY ?? dataPoints.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    
    // Agregar margen
    final valueRange = maxValue - minValue;
    minValue -= valueRange * 0.1;
    maxValue += valueRange * 0.1;

    // Encontrar rango de fechas
    final dates = dataPoints.map((e) => e.date).toList()..sort();
    final minDate = dates.first;
    final maxDate = dates.last;
    final daysRange = maxDate.difference(minDate).inDays.toDouble().clamp(1.0, double.infinity);

    // Dibujar grid
    _drawGrid(canvas, size, leftPadding, chartWidth, chartHeight, minValue, maxValue, minDate, daysRange);

    // Dibujar líneas de percentiles (simulado)
    _drawPercentileCurves(canvas, leftPadding, chartWidth, chartHeight, minValue, maxValue);

    // Dibujar puntos de datos
    _drawDataPoints(canvas, leftPadding, chartWidth, chartHeight, minDate, daysRange, minValue, maxValue);
  }

  void _drawGrid(
    Canvas canvas,
    Size size,
    double leftPadding,
    double chartWidth,
    double chartHeight,
    double minValue,
    double maxValue,
    DateTime minDate,
    double daysRange,
  ) {
    final gridPaint = Paint()
      ..color = (isDark ? Colors.white : AppColors.grey20).withValues(alpha: 0.5)
      ..strokeWidth = 1;

    final textColor = isDark ? AppColors.darkTextSecondary : AppColors.grey100;
    
    // Líneas horizontales
    final valueSteps = 5;
    final valueRange = maxValue - minValue;
    for (int i = 0; i <= valueSteps; i++) {
      final y = 10 + chartHeight * (1 - i / valueSteps);
      canvas.drawLine(
        Offset(leftPadding, y),
        Offset(leftPadding + chartWidth, y),
        gridPaint,
      );

      // Label
      final value = minValue + (valueRange * i / valueSteps);
      final textSpan = TextSpan(
        text: value.toStringAsFixed(1),
        style: TextStyle(color: textColor, fontSize: 10),
      );
      final textPainter = TextPainter(
          text: textSpan,
          textDirection: ui.TextDirection.ltr,
        )..layout();
      textPainter.paint(canvas, Offset(5, y - 6));
    }

    // Líneas verticales (meses)
    final months = (daysRange / 30).ceil().clamp(1, 24);
    for (int i = 0; i <= months; i++) {
      final x = leftPadding + (chartWidth * i / months);
      canvas.drawLine(
        Offset(x, 10),
        Offset(x, 10 + chartHeight),
        gridPaint,
      );

      if (i > 0) {
        final textSpan = TextSpan(
          text: '${i}m',
          style: TextStyle(color: textColor, fontSize: 10),
        );
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: ui.TextDirection.ltr,
        )..layout();
        textPainter.paint(canvas, Offset(x - 8, 10 + chartHeight + 8));
      }
    }
  }

  void _drawPercentileCurves(
    Canvas canvas,
    double leftPadding,
    double chartWidth,
    double chartHeight,
    double minValue,
    double maxValue,
  ) {
    // Simular curvas de percentiles
    for (final entry in percentileLines.entries) {
      final paint = Paint()
        ..color = entry.value.withValues(alpha: 0.4)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;

      final path = Path();
      final valueRange = maxValue - minValue;
      final months = 12;

      for (int i = 0; i <= months; i++) {
        final x = leftPadding + (chartWidth * i / months);
        // Curva simulada basada en percentil
        final factor = (entry.key - 50) / 50; // -1 a 1
        final baseValue = minValue + valueRange * 0.5 + factor * valueRange * 0.3 * (i / months);
        final y = 10 + chartHeight * (1 - (baseValue - minValue) / valueRange);
        
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      canvas.drawPath(path, paint);
    }
  }

  void _drawDataPoints(
    Canvas canvas,
    double leftPadding,
    double chartWidth,
    double chartHeight,
    DateTime minDate,
    double daysRange,
    double minValue,
    double maxValue,
  ) {
    final pointPaint = Paint()
      ..color = AppColors.primaryMid
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = AppColors.primaryLight.withValues(alpha: 0.6)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final valueRange = maxValue - minValue;

    for (int i = 0; i < dataPoints.length; i++) {
      final point = dataPoints[i];
      final daysSinceStart = point.date.difference(minDate).inDays.toDouble();
      final x = leftPadding + (chartWidth * daysSinceStart / daysRange);
      final y = 10 + chartHeight * (1 - (point.value - minValue) / valueRange);

      // Línea
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }

      // Punto
      canvas.drawCircle(Offset(x, y), 5, pointPaint);
      
      // Borde blanco
      final borderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawCircle(Offset(x, y), 5, borderPaint);
    }

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _GrowthChartPainter oldDelegate) {
    return oldDelegate.dataPoints != dataPoints ||
        oldDelegate.percentileLines != percentileLines;
  }
}

/// Widget deprecado: usa `GrowthValueCard` de `common_widgets.dart`
/// Esta versión con clasificación fue reemplazada por la versión más rica
/// (con soporte de tema oscuro) que vive en `common_widgets.dart`.
@Deprecated('Usa GrowthValueCard de common_widgets.dart')
class GrowthValueCard extends StatelessWidget {
  final String label;
  final double value;
  final String unit;
  final double? percentile;
  final String? classification;
  final Color? accentColor;

  const GrowthValueCard({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    this.percentile,
    this.classification,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? AppColors.primaryMid;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  label.toLowerCase().contains('peso')
                      ? Icons.monitor_weight_outlined
                      : Icons.straighten,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.grey100,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value.toStringAsFixed(1),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.grey500,
                    ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  unit,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.grey100,
                      ),
                ),
              ),
            ],
          ),
          if (percentile != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                _buildPercentileBadge(context),
                if (classification != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    classification!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _getClassificationColor(),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPercentileBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _getPercentileColor().withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'P${percentile!.toStringAsFixed(0)}',
        style: TextStyle(
          color: _getPercentileColor(),
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Color _getPercentileColor() {
    if (percentile! < 15) return AppColors.warning;
    if (percentile! > 85) return AppColors.warning;
    return AppColors.success;
  }

  Color _getClassificationColor() {
    switch (classification?.toLowerCase()) {
      case 'normal':
        return AppColors.success;
      case 'bajo':
        return AppColors.warning;
      case 'alto':
        return AppColors.warning;
      default:
        return AppColors.grey100;
    }
  }
}