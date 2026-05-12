import 'package:drift/drift.dart' as drift;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pediatrack/core/providers/database_providers.dart';
import 'package:pediatrack/data/database/app_database.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/animations_widgets.dart';
import '../../../shared/widgets/common_widgets.dart';

/// Pantalla de crecimiento con gráfico interactivo
class GrowthScreen extends ConsumerWidget {
  const GrowthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedChildId = ref.watch(selectedChildIdProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (selectedChildId == null) {
      return Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : null,
        appBar: AppBar(title: const Text('Crecimiento'), backgroundColor: isDark ? AppColors.darkSurface : null),
        body: EmptyStateCard(
          icon: Icons.child_care,
          title: 'Selecciona un niño',
          subtitle: 'Elige un niño para ver su seguimiento de crecimiento',
          iconColor: AppColors.primaryMid,
        ),
      );
    }

    return _GrowthContent(childId: selectedChildId);
  }
}

class _GrowthContent extends ConsumerStatefulWidget {
  final int childId;
  const _GrowthContent({required this.childId});

  @override
  ConsumerState<_GrowthContent> createState() => _GrowthContentState();
}

class _GrowthContentState extends ConsumerState<_GrowthContent> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int? _touchedIndex;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : null,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkSurface : null,
        foregroundColor: isDark ? AppColors.darkTextPrimary : null,
        title: const Text('Crecimiento'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primaryMid,
          labelColor: AppColors.primaryMid,
          unselectedLabelColor: isDark ? AppColors.darkTextSecondary : AppColors.grey100,
          tabs: const [
            Tab(text: '📊 Peso'),
            Tab(text: '📏 Altura'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _GrowthChartTab(childId: widget.childId, metric: 'weight', touchedIndex: _touchedIndex, onTouch: (i) => setState(() => _touchedIndex = i)),
          _GrowthChartTab(childId: widget.childId, metric: 'height', touchedIndex: _touchedIndex, onTouch: (i) => setState(() => _touchedIndex = i)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddGrowthSheet(context),
        backgroundColor: AppColors.primaryMid,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddGrowthSheet(BuildContext context) {
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (context) => _AddGrowthSheet(childId: widget.childId));
  }
}

class _GrowthChartTab extends ConsumerWidget {
  final int childId;
  final String metric;
  final int? touchedIndex;
  final Function(int?) onTouch;

  const _GrowthChartTab({required this.childId, required this.metric, this.touchedIndex, required this.onTouch});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final growthAsync = ref.watch(growthRecordsProvider(childId));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return RefreshIndicator(
      onRefresh: () async {
        HapticFeedback.mediumImpact();
        ref.invalidate(growthRecordsProvider(childId));
      },
      child: growthAsync.when(
        data: (records) {
          if (records.isEmpty) {
            return EmptyStateCard(
              icon: Icons.show_chart,
              title: 'Sin registros de ${metric == 'weight' ? 'peso' : 'altura'}',
              subtitle: 'Agrega la primera medición para comenzar el seguimiento',
              buttonText: 'Agregar Medición',
              onButtonPressed: () => showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (context) => _AddGrowthSheet(childId: childId)),
              iconColor: metric == 'weight' ? AppColors.primaryMid : AppColors.secondaryMid,
            );
          }

          final filteredRecords = records.where((r) => metric == 'weight' ? r.weight != null : r.height != null).toList();
          if (filteredRecords.isEmpty) {
            return EmptyStateCard(icon: Icons.show_chart, title: 'Sin datos', subtitle: 'No hay registros de ${metric == 'weight' ? 'peso' : 'altura'}', iconColor: metric == 'weight' ? AppColors.primaryMid : AppColors.secondaryMid);
          }

          final latest = filteredRecords.first;
          final latestValue = metric == 'weight' ? latest.weight! : latest.height!;
          final latestDate = latest.date;
          final ageInMonths = _calculateAgeInMonths(ref, childId);

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Stats Cards
                Row(
                  children: [
                    Expanded(child: _StatCard(label: metric == 'weight' ? 'Peso Actual' : 'Altura Actual', value: '${latestValue.toStringAsFixed(1)} ${metric == 'weight' ? 'kg' : 'cm'}', icon: metric == 'weight' ? Icons.monitor_weight : Icons.height, color: metric == 'weight' ? AppColors.primaryMid : AppColors.secondaryMid, isDark: isDark)),
                    const SizedBox(width: 12),
                    Expanded(child: _StatCard(label: 'Última Fecha', value: DateFormat('dd/MM/yy').format(latestDate), icon: Icons.calendar_today, color: AppColors.warning, isDark: isDark)),
                  ],
                ),
                const SizedBox(height: 16),
                // WHO Evaluation
                _WHEvaluationCard(childId: childId, metric: metric, value: latestValue, isDark: isDark),
                const SizedBox(height: 24),
                // Interactive Chart
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.grey30),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(metric == 'weight' ? 'Curva de Peso' : 'Curva de Altura', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : null)),
                          const Spacer(),
                          if (touchedIndex != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: AppColors.primaryMid.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                              child: Text('Tocando punto', style: TextStyle(fontSize: 12, color: AppColors.primaryMid)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 250,
                        child: _InteractiveGrowthChart(records: filteredRecords, metric: metric, touchedIndex: touchedIndex, onTouch: onTouch, isDark: isDark),
                      ),
                      const SizedBox(height: 16),
                      // Legend
                      _ChartLegend(metric: metric, isDark: isDark),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Recent Records
                _RecentRecordsList(records: filteredRecords, metric: metric, childId: childId, isDark: isDark),
                const SizedBox(height: 100),
              ],
            ),
          );
        },
        loading: () => _buildLoadingState(),
        error: (e, _) => Center(child: Text('Error: $e', style: TextStyle(color: isDark ? AppColors.darkTextSecondary : null))),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(children: const [Expanded(child: ShimmerLoading(height: 100, borderRadius: 16)), SizedBox(width: 12), Expanded(child: ShimmerLoading(height: 100, borderRadius: 16))]),
          const SizedBox(height: 16),
          const ShimmerLoading(height: 300, borderRadius: 20),
        ],
      ),
    );
  }

  double _calculateAgeInMonths(WidgetRef ref, int childId) {
    final childAsync = ref.read(childProvider(childId));
    return childAsync.whenOrNull(data: (child) {
      final now = DateTime.now();
      return (now.year - child.birthDate.year) * 12 + now.month - child.birthDate.month + (now.day - child.birthDate.day) / 30.0;
    }) ?? 0;
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool isDark;

  const _StatCard({required this.label, required this.value, required this.icon, required this.color, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.grey30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Icon(icon, size: 18, color: color), const SizedBox(width: 8), Text(label, style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextSecondary : AppColors.grey100))]),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: isDark ? Colors.white : AppColors.grey500)),
        ],
      ),
    );
  }
}

class _WHEvaluationCard extends ConsumerWidget {
  final int childId;
  final String metric;
  final double value;
  final bool isDark;

  const _WHEvaluationCard({required this.childId, required this.metric, required this.value, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final evalAsync = metric == 'weight' ? ref.watch(weightEvaluationProvider(childId, value)) : ref.watch(heightEvaluationProvider(childId, value));

    return evalAsync.when(
      data: (eval) {
        final color = switch (eval.classification) {
          'Bajo' => AppColors.error,
          'Alto' => AppColors.warning,
          _ => AppColors.success,
        };
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.grey30),
          ),
          child: Row(
            children: [
              _StatBadge(label: 'Z-Score', value: eval.zScore.toStringAsFixed(2), color: color, isDark: isDark),
              const SizedBox(width: 16),
              _StatBadge(label: 'Percentil', value: '${eval.percentile.toInt()}%', color: color, isDark: isDark),
              const SizedBox(width: 16),
              _StatBadge(label: 'Clasificación', value: eval.classification, color: color, isDark: isDark),
            ],
          ),
        );
      },
      loading: () => const ShimmerLoading(height: 80, borderRadius: 20),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool isDark;

  const _StatBadge({required this.label, required this.value, required this.color, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: color.withValues(alpha: isDark ? 0.15 : 0.1), borderRadius: BorderRadius.circular(14), border: Border.all(color: color.withValues(alpha: 0.3))),
        child: Column(
          children: [
            Text(label, style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.grey100)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: isDark ? Colors.white : color)),
          ],
        ),
      ),
    );
  }
}

class _InteractiveGrowthChart extends StatelessWidget {
  final List<GrowthRecord> records;
  final String metric;
  final int? touchedIndex;
  final Function(int?) onTouch;
  final bool isDark;

  const _InteractiveGrowthChart({required this.records, required this.metric, this.touchedIndex, required this.onTouch, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final sortedRecords = [...records]..sort((a, b) => a.date.compareTo(b.date));
    final spots = sortedRecords.asMap().entries.map((e) {
      final value = metric == 'weight' ? e.value.weight! : e.value.height!;
      return FlSpot(e.key.toDouble(), value);
    }).toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: metric == 'weight' ? 5 : 10,
          getDrawingHorizontalLine: (value) => FlLine(
            color: isDark ? AppColors.darkBorder : AppColors.grey30.withValues(alpha: 0.5),
            strokeWidth: 1,
            dashArray: [5, 5],
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 45,
              getTitlesWidget: (value, meta) => Text(value.toInt().toString(), style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.grey100)),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= sortedRecords.length) return const SizedBox.shrink();
                final date = sortedRecords[value.toInt()].date;
                return Text(DateFormat('MMM').format(date), style: TextStyle(fontSize: 10, color: isDark ? AppColors.darkTextTertiary : AppColors.grey100));
              },
            ),
          ),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => isDark ? AppColors.darkCardElevated : Colors.white,
            tooltipRoundedRadius: 12,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final index = spot.x.toInt();
                if (index >= sortedRecords.length) return null;
                final record = sortedRecords[index];
                final value = metric == 'weight' ? record.weight! : record.height!;
                return LineTooltipItem(
                  '${value.toStringAsFixed(1)} ${metric == 'weight' ? 'kg' : 'cm'}\n${DateFormat('dd MMM').format(record.date)}',
                  TextStyle(color: isDark ? Colors.white : AppColors.grey500, fontWeight: FontWeight.w600, fontSize: 12),
                );
              }).toList();
            },
          ),
          touchCallback: (event, response) {
            if (response?.lineBarSpots != null && response!.lineBarSpots!.isNotEmpty) {
              onTouch(response.lineBarSpots!.first.x.toInt());
            } else {
              onTouch(null);
            }
          },
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: metric == 'weight' ? AppColors.primaryMid : AppColors.secondaryMid,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                final isTouched = index == touchedIndex;
                return FlDotCirclePainter(
                  radius: isTouched ? 8 : 4,
                  color: metric == 'weight' ? AppColors.primaryMid : AppColors.secondaryMid,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(show: true, color: (metric == 'weight' ? AppColors.primaryMid : AppColors.secondaryMid).withValues(alpha: 0.15)),
          ),
        ],
        minY: spots.isEmpty ? 0 : (spots.map((s) => s.y).reduce((a, b) => a < b ? a : b) * 0.8),
        maxY: spots.isEmpty ? 100 : (spots.map((s) => s.y).reduce((a, b) => a > b ? a : b) * 1.2),
      ),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}

class _ChartLegend extends StatelessWidget {
  final String metric;
  final bool isDark;

  const _ChartLegend({required this.metric, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LegendItem(color: metric == 'weight' ? AppColors.primaryMid : AppColors.secondaryMid, label: metric == 'weight' ? 'Peso' : 'Altura'),
        const SizedBox(width: 20),
        _LegendItem(color: AppColors.grey100.withValues(alpha: 0.5), label: 'Referencia OMS', isDashed: true),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final bool isDashed;

  const _LegendItem({required this.color, required this.label, this.isDashed = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 3,
          decoration: BoxDecoration(
            color: isDashed ? null : color,
            borderRadius: BorderRadius.circular(2),
            border: isDashed ? Border.all(color: color, width: 1, style: BorderStyle.solid) : null,
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(fontSize: 12, color: isDashed ? AppColors.grey100 : null)),
      ],
    );
  }
}

class _RecentRecordsList extends ConsumerWidget {
  final List<GrowthRecord> records;
  final String metric;
  final int childId;
  final bool isDark;

  const _RecentRecordsList({required this.records, required this.metric, required this.childId, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.grey30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Registros Recientes', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : null)),
          const SizedBox(height: 16),
          ...records.take(5).map((record) {
            final value = metric == 'weight' ? record.weight! : record.height!;
            return SwipeToDeleteItem(
              onDelete: () async {
                final db = ref.read(databaseProvider);
                await db.deleteGrowthRecord(record.id);
                ref.invalidate(growthRecordsProvider(childId));
                if (context.mounted) {
                  HapticFeedback.mediumImpact();
                  showUndoSnackbar(context, '${metric == 'weight' ? 'Peso' : 'Altura'} eliminado', () async {
                    // Undo logic would re-insert here
                  });
                }
              },
              deleteMessage: '¿Eliminar este registro?',
              child: AnimatedListItem(
                index: records.indexOf(record),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: (metric == 'weight' ? AppColors.primaryMid : AppColors.secondaryMid).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                    child: Icon(metric == 'weight' ? Icons.monitor_weight : Icons.height, color: metric == 'weight' ? AppColors.primaryMid : AppColors.secondaryMid, size: 20),
                  ),
                  title: Text('${value.toStringAsFixed(1)} ${metric == 'weight' ? 'kg' : 'cm'}', style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextPrimary : null)),
                  subtitle: Text(DateFormat('dd MMM yyyy').format(record.date), style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.grey100)),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ADD GROWTH SHEET - Agregar medición
// ═══════════════════════════════════════════════════════════════

class _AddGrowthSheet extends ConsumerStatefulWidget {
  final int childId;
  const _AddGrowthSheet({required this.childId});

  @override
  ConsumerState<_AddGrowthSheet> createState() => _AddGrowthSheetState();
}

class _AddGrowthSheetState extends ConsumerState<_AddGrowthSheet> {
  DateTime _selectedDate = DateTime.now();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final presets = ['Hoy', 'Ayer', 'Hace 1 semana'];
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (date != null) setState(() => _selectedDate = date);
  }

  void _saveRecord() async {
    final weight = double.tryParse(_weightController.text);
    final height = double.tryParse(_heightController.text);
    if (weight == null && height == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ingresa al menos un valor')));
      return;
    }
    final db = ref.read(databaseProvider);
    if (weight != null) {
      await db.insertGrowthRecord(GrowthRecordsCompanion.insert(childId: widget.childId, date: _selectedDate, weight: drift.Value(weight)));
    }
    if (height != null) {
      await db.insertGrowthRecord(GrowthRecordsCompanion.insert(childId: widget.childId, date: _selectedDate, height: drift.Value(height)));
    }
    ref.invalidate(growthRecordsProvider(widget.childId));
    if (mounted) {
      Navigator.pop(context);
      HapticFeedback.mediumImpact();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registro guardado ✓')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(color: isDark ? AppColors.darkCard : Colors.white, borderRadius: const BorderRadius.vertical(top: Radius.circular(24))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Column(
                children: [
                  Container(width: 40, height: 4, decoration: BoxDecoration(color: isDark ? AppColors.darkBorder : AppColors.grey50, borderRadius: BorderRadius.circular(2))),
                  const SizedBox(height: 16),
                  Text('Agregar Medición', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : null)),
                ],
              ),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 24 + MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InkWell(
                    onTap: _selectDate,
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: isDark ? AppColors.darkCardElevated : AppColors.grey10, borderRadius: BorderRadius.circular(14), border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.grey30)),
                      child: Row(children: [const Icon(Icons.calendar_today), const SizedBox(width: 12), Text(DateFormat('dd MMM yyyy').format(_selectedDate), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextPrimary : null)), const Spacer(), Icon(Icons.edit, color: isDark ? AppColors.darkTextTertiary : null)]),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(controller: _weightController, keyboardType: TextInputType.number, style: TextStyle(color: isDark ? AppColors.darkTextPrimary : null), decoration: InputDecoration(labelText: 'Peso (kg)', prefixIcon: const Icon(Icons.monitor_weight_outlined), filled: true, fillColor: isDark ? AppColors.darkCardElevated : AppColors.grey10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none))),
                  const SizedBox(height: 16),
                  TextField(controller: _heightController, keyboardType: TextInputType.number, style: TextStyle(color: isDark ? AppColors.darkTextPrimary : null), decoration: InputDecoration(labelText: 'Altura (cm)', prefixIcon: const Icon(Icons.height), filled: true, fillColor: isDark ? AppColors.darkCardElevated : AppColors.grey10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none))),
                  const SizedBox(height: 20),
                  Text('Observaciones (opcional)', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextSecondary : AppColors.grey200)),
                  const SizedBox(height: 8),
                  TextField(controller: _notesController, maxLines: 2, style: TextStyle(color: isDark ? AppColors.darkTextPrimary : null), decoration: InputDecoration(hintText: 'Ej: Consulta de control, revisión mensual...', prefixIcon: const Icon(Icons.notes), filled: true, fillColor: isDark ? AppColors.darkCardElevated : AppColors.grey10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none))),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton.icon(
                  onPressed: _saveRecord,
                  icon: const Icon(Icons.save_outlined, size: 22),
                  label: const Text('Guardar', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  style: FilledButton.styleFrom(backgroundColor: isDark ? AppColors.primaryLight : AppColors.primaryMid, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}