import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pediatrack/core/constants/app_constants.dart';
import 'package:pediatrack/core/theme/app_theme.dart';
import 'package:pediatrack/core/providers/database_providers.dart';
import 'package:pediatrack/data/database/app_database.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class PediaTrackApp extends ConsumerWidget {
  const PediaTrackApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [Locale('es', 'MX')],
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends ConsumerStatefulWidget {
  const MainNavigation({super.key});

  @override
  ConsumerState<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends ConsumerState<MainNavigation> {
  bool _handlingBack = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(navigationIndexProvider.notifier).state = 0;
    });
  }

  Future<void> _handleBackPressed() async {
    if (_handlingBack || !mounted) return;
    _handlingBack = true;
    try {
      final currentIndex = ref.read(navigationIndexProvider);
      if (currentIndex != 0) {
        ref.read(navigationIndexProvider.notifier).state = 0;
        return;
      }

      final shouldPop = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Salir'),
          content: const Text('¿Estás seguro de que quieres salir de PediaTrack?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Salir'),
            ),
          ],
        ),
      );

      if (shouldPop == true && mounted) {
        try {
          await SystemNavigator.pop();
        } catch (e) {
          debugPrint('Error calling SystemNavigator.pop(): $e');
        }
      }
    } finally {
      _handlingBack = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final alertsCount = ref.watch(unprocessedAlertsCountProvider);
    final currentIndex = ref.watch(navigationIndexProvider);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBackPressed();
      },
      child: Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: const [
            HomeScreen(),
            GrowthScreen(),
            HabitsScreen(),
            VaccinesScreen(),
            AlertsScreen(),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (index) => ref.read(navigationIndexProvider.notifier).state = index,
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Inicio',
            ),
            const NavigationDestination(
              icon: Icon(Icons.show_chart_outlined),
              selectedIcon: Icon(Icons.show_chart),
              label: 'Crecimiento',
            ),
            const NavigationDestination(
              icon: Icon(Icons.bathroom_outlined),
              selectedIcon: Icon(Icons.bathroom),
              label: 'Hábitos',
            ),
            const NavigationDestination(
              icon: Icon(Icons.vaccines_outlined),
              selectedIcon: Icon(Icons.vaccines),
              label: 'Vacunas',
            ),
            NavigationDestination(
              icon: Badge(
                isLabelVisible: alertsCount > 0,
                label: Text('$alertsCount'),
                child: const Icon(Icons.notifications_outlined),
              ),
              selectedIcon: Badge(
                isLabelVisible: alertsCount > 0,
                label: Text('$alertsCount'),
                child: const Icon(Icons.notifications),
              ),
              label: 'Alertas',
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final childrenAsync = ref.watch(childrenStreamProvider);
    final selectedChildId = ref.watch(selectedChildIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.child_care,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            const Text('PediaTrack'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_outlined),
            onPressed: () => _showAddChildDialog(context, ref),
          ),
        ],
      ),
      body: childrenAsync.when(
        data: (children) {
          if (children.isEmpty) {
            return _buildEmptyState(context, ref);
          }
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _ChildSelector(
                  children: children,
                  selectedChildId: selectedChildId,
                  onChildSelected: (id) {
                    ref.read(selectedChildIdProvider.notifier).state = id;
                  },
                ),
              ),
              if (selectedChildId != null)
                ..._buildSelectedChildContent(context, ref, selectedChildId),
              if (selectedChildId == null)
                const SliverFillRemaining(
                  child: Center(child: Text('Selecciona un niño para ver su información')),
                ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: selectedChildId != null
          ? FloatingActionButton.extended(
              onPressed: () => _showQuickRecordSheet(context, ref, selectedChildId),
              icon: const Icon(Icons.add),
              label: const Text('Registrar'),
            )
          : null,
    );
  }

  List<Widget> _buildSelectedChildContent(BuildContext context, WidgetRef ref, int childId) {
    return [
      SliverToBoxAdapter(
        child: _QuickStatsSection(childId: childId),
      ),
      SliverToBoxAdapter(
        child: _BirthDataCard(childId: childId),
      ),
      SliverToBoxAdapter(
        child: _RecentGrowthCard(childId: childId),
      ),
      SliverToBoxAdapter(
        child: _TodayHabitsCard(childId: childId),
      ),
      SliverToBoxAdapter(
        child: _VaccineSummaryCard(childId: childId),
      ),
      SliverToBoxAdapter(
        child: _QuickActionsCard(childId),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: 80)),
    ];
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.child_care,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              '¡Bienvenido a PediaTrack!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Registra a tu primer niño para comenzar a monitorear su crecimiento y Hábitos.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => _showAddChildDialog(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('Agregar Primer niño'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddChildDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const AddChildSheet(),
    );
  }

  void _showQuickRecordSheet(BuildContext context, WidgetRef ref, int childId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => QuickRecordSheet(childId: childId),
    );
  }
}

class _ChildSelector extends StatelessWidget {
  const _ChildSelector({
    required this.children,
    required this.selectedChildId,
    required this.onChildSelected,
  });

  final List<ChildrenData> children;
  final int? selectedChildId;
  final void Function(int) onChildSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: children.length,
        itemBuilder: (context, index) {
          final child = children[index];
          final isSelected = child.id == selectedChildId;
          return GestureDetector(
            onTap: () => onChildSelected(child.id),
            child: Container(
              width: 80,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
                border: isSelected
                    ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2)
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline,
                    child: Icon(
                      child.gender == 0 ? Icons.boy : Icons.girl,
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.surface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    child.name.split(' ').first,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: isSelected ? FontWeight.bold : null,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _QuickStatsSection extends ConsumerWidget {
  const _QuickStatsSection({required this.childId});

  final int childId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final childAsync = ref.watch(childProvider(childId));
    final growthAsync = ref.watch(growthRecordsStreamProvider(childId));

    return childAsync.when(
      data: (child) {
        if (child == null) return const SizedBox.shrink();
        final ageMonths = _calculateAgeMonths(child.birthDate);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.cake_outlined,
                  label: 'Edad',
                  value: _formatAge(ageMonths),
                  color: Colors.pink,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: growthAsync.when(
                  data: (records) {
                    final lastWeight = records.isNotEmpty ? records.first.weight : null;
                    return _StatCard(
                      icon: Icons.monitor_weight_outlined,
                      label: 'Peso',
                      value: lastWeight != null ? '${(lastWeight * 2.20462).toStringAsFixed(1)} lb' : 'Sin dato',
                      color: Colors.blue,
                    );
                  },
                  loading: () => const _StatCard(
                    icon: Icons.monitor_weight_outlined,
                    label: 'Peso',
                    value: '...',
                    color: Colors.blue,
                  ),
                  error: (_, __) => const _StatCard(
                    icon: Icons.monitor_weight_outlined,
                    label: 'Peso',
                    value: 'Error',
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: growthAsync.when(
                  data: (records) {
                    final lastHeight = records.isNotEmpty ? records.first.height : null;
                    return _StatCard(
                      icon: Icons.height_outlined,
                      label: 'Estatura',
                      value: lastHeight != null ? '${lastHeight.toStringAsFixed(1)} cm' : 'Sin dato',
                      color: Colors.green,
                    );
                  },
                  loading: () => const _StatCard(
                    icon: Icons.height_outlined,
                    label: 'Estatura',
                    value: '...',
                    color: Colors.green,
                  ),
                  error: (_, __) => const _StatCard(
                    icon: Icons.height_outlined,
                    label: 'Estatura',
                    value: 'Error',
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  int _calculateAgeMonths(DateTime birthDate) {
    final now = DateTime.now();
    return (now.year - birthDate.year) * 12 + (now.month - birthDate.month);
  }

  String _formatAge(int ageMonths) {
    if (ageMonths < 12) return '$ageMonths m';
    final years = ageMonths ~/ 12;
    final months = ageMonths % 12;
    return months > 0 ? '$years a $months m' : '$years a';
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

class _BirthDataCard extends ConsumerWidget {
  const _BirthDataCard({required this.childId});

  final int childId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final childAsync = ref.watch(childProvider(childId));

    return childAsync.when(
      data: (child) {
        if (child == null) return const SizedBox.shrink();
        if (child.birthWeight == null && child.birthHeight == null) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: _InfoCard(
            icon: Icons.baby_changing_station,
            title: 'Datos al Nacer',
            subtitle: 'Registro inicial',
            color: Colors.purple,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (child.birthWeight != null)
                  _BirthMetric(
                    icon: Icons.monitor_weight,
                    label: 'Peso',
                    value: '${(child.birthWeight! * 2.20462).toStringAsFixed(1)} lb',
                    color: Colors.purple,
                  ),
                if (child.birthWeight != null && child.birthHeight != null)
                  Container(height: 40, width: 1, color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3)),
                if (child.birthHeight != null)
                  _BirthMetric(
                    icon: Icons.height,
                    label: 'Estatura',
                    value: '${child.birthHeight!.toStringAsFixed(1)} cm',
                    color: Colors.teal,
                  ),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _BirthMetric extends StatelessWidget {
  const _BirthMetric({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
        ),
      ],
    );
  }
}

class _RecentGrowthCard extends ConsumerWidget {
  const _RecentGrowthCard({required this.childId});

  final int childId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final growthAsync = ref.watch(growthRecordsStreamProvider(childId));

    return growthAsync.when(
      data: (records) {
        if (records.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: _InfoCard(
              icon: Icons.show_chart,
              title: 'Crecimiento',
              subtitle: 'Sin registros de crecimiento',
              color: Colors.blue,
              child: FilledButton.tonal(
                onPressed: () => _showGrowthEntrySheet(context, childId),
                child: const Text('Agregar registro'),
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: _InfoCard(
            icon: Icons.show_chart,
            title: 'Crecimiento Reciente',
            subtitle: 'Último registro: ${_formatDate(records.first.date)}',
            color: Colors.blue,
            child: Column(
              children: [
                _GrowthChart(records: records.take(10).toList().reversed.toList()),
                const SizedBox(height: 12),
                if (records.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _GrowthMetric(
                        label: 'Peso',
                        value: records.first.weight != null ? '${(records.first.weight! * 2.20462).toStringAsFixed(1)} lb' : '-',
                        icon: Icons.monitor_weight,
                        color: Colors.blue,
                      ),
                      Container(height: 40, width: 1, color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3)),
                      _GrowthMetric(
                        label: 'Estatura',
                        value: records.first.height != null ? '${records.first.height!.toStringAsFixed(1)} cm' : '-',
                        icon: Icons.height,
                        color: Colors.green,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Padding(
        padding: const EdgeInsets.all(16),
        child: Text('Error: $e'),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy', 'es').format(date);
  }

  void _showGrowthEntrySheet(BuildContext context, int childId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => QuickRecordSheet(childId: childId),
    );
  }
}

class _GrowthChart extends StatelessWidget {
  const _GrowthChart({required this.records});

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

class _GrowthMetric extends StatelessWidget {
  const _GrowthMetric({
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

class _TodayHabitsCard extends ConsumerWidget {
  const _TodayHabitsCard({required this.childId});

  final int childId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(todayHabitsProvider(childId));

    return habitsAsync.when(
      data: (habits) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _InfoCard(
            icon: Icons.bathroom,
            title: 'Hábitos de Hoy',
            subtitle: habits.isEmpty ? 'Sin registros hoy' : '${habits.length} registros',
            color: Colors.orange,
            child: habits.isEmpty
                ? const Text('Registra los Hábitos intestinales del día.')
                : Wrap(
                    spacing: 8,
                    children: habits.map((h) => Chip(
                          avatar: Icon(_habitIcon(h.type), size: 18, color: _habitColor(h.type)),
                          label: Text(_habitLabel(h.type)),
                          backgroundColor: _habitColor(h.type).withValues(alpha: 0.1),
                        )).toList(),
                  ),
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Padding(
        padding: const EdgeInsets.all(16),
        child: Text('Error: $e'),
      ),
    );
  }

  IconData _habitIcon(int type) => switch (type) { 0 => Icons.check_circle, 1 => Icons.warning, _ => Icons.water_drop };
  Color _habitColor(int type) => switch (type) { 0 => Colors.green, 1 => Colors.orange, _ => Colors.red };
  String _habitLabel(int type) => switch (type) { 0 => 'Normal', 1 => 'Estreñimiento', _ => 'Diarrea' };
}

String _formatVaccineAge(int months) {
  if (months == 0) return 'al nacer';
  if (months == 1) return 'al mes';
  if (months < 12) return 'a los $months meses';
  if (months == 12) return 'al año';
  final years = months ~/ 12;
  final remainingMonths = months % 12;
  if (remainingMonths == 0) return 'a los $years años';
  if (remainingMonths == 1) return 'a los $years años y 1 mes';
  return 'a los $years años y $remainingMonths meses';
}

class _VaccineSummaryCard extends ConsumerWidget {
  const _VaccineSummaryCard({required this.childId});

  final int childId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleAsync = ref.watch(vaccineScheduleProvider(childId));

    return scheduleAsync.when(
      data: (schedule) {
        final overdue = schedule.where((s) => s.isOverdue).length;
        final upcoming = schedule.where((s) => !s.isCompleted && !s.isOverdue).length;
        final completed = schedule.where((s) => s.isCompleted).length;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _InfoCard(
            icon: Icons.vaccines,
            title: 'Vacunas',
            subtitle: '$completed completadas, $upcoming próximas, $overdue atrasadas',
            color: Colors.teal,
            onTap: () => ref.read(navigationIndexProvider.notifier).state = 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (overdue > 0)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning, color: Colors.red, size: 20),
                        const SizedBox(width: 8),
                        Text('$overdue vacuna(s) atrasada(s)', style: const TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                if (upcoming > 0)
                  Text(
                    '$upcoming vacuna(s) próxima(s) en el mes',
                    style: TextStyle(color: Colors.orange[700]),
                  ),
                const SizedBox(height: 8),
                ...schedule.take(3).where((s) => !s.isCompleted).map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Icon(
                            item.isOverdue ? Icons.warning : Icons.schedule,
                            size: 16,
                            color: item.isOverdue ? Colors.red : Colors.orange,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${item.definition.name} ${item.definition.totalDoses > 1 ? "(${item.definition.doseNumber}/${item.definition.totalDoses})" : ""} - ${item.definition.description ?? ""}',
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '${DateFormat('dd MMM', 'es').format(item.dueDate)} (${_formatVaccineAge(item.definition.recommendedAgeMonths)})',
                            style: TextStyle(fontSize: 11, color: item.isOverdue ? Colors.red : Colors.grey),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Padding(
        padding: const EdgeInsets.all(16),
        child: Text('Error: $e'),
      ),
    );
  }
}

class _QuickActionsCard extends ConsumerWidget {
  const _QuickActionsCard(this.childId);

  final int childId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: _InfoCard(
        icon: Icons.flash_on,
        title: 'Acciones Rápidas',
        subtitle: 'Registra rápidamente',
        color: Colors.purple,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _QuickActionButton(
              icon: Icons.monitor_weight,
              label: 'Peso',
              color: Colors.blue,
              onTap: () => _showQuickRecord(context, ref, 0),
            ),
            _QuickActionButton(
              icon: Icons.straighten,
              label: 'Medidas',
              color: Colors.green,
              onTap: () => _showQuickRecordMeasures(context, ref),
            ),
            _QuickActionButton(
              icon: Icons.bathroom,
              label: 'Hábito',
              color: Colors.orange,
              onTap: () => _showQuickRecord(context, ref, 2),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickRecordMeasures(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _MeasureRecordSheet(childId: childId),
    );
  }

  void _showQuickRecord(BuildContext context, WidgetRef ref, int tab) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => QuickRecordSheet(childId: childId, initialTab: tab),
    );
  }
}

class _MeasureRecordSheet extends ConsumerStatefulWidget {
  const _MeasureRecordSheet({required this.childId});

  final int childId;

  @override
  ConsumerState<_MeasureRecordSheet> createState() => _MeasureRecordSheetState();
}

class _MeasureRecordSheetState extends ConsumerState<_MeasureRecordSheet> {
  final _heightController = TextEditingController();
  final _headController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            ),
            const SizedBox(height: 16),
            Text('Registrar Medidas', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildDateSelector(),
            const SizedBox(height: 16),
            TextField(
              controller: _heightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Estatura (cm)',
                prefixIcon: Icon(Icons.height),
                suffixText: 'cm',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _headController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Perímetro craneal (cm)',
                prefixIcon: Icon(Icons.circle_outlined),
                suffixText: 'cm',
              ),
            ),
            const SizedBox(height: 8),
            Text('Ambos campos son opcionales', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saveMeasures,
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return ListTile(
      title: const Text('Fecha'),
      subtitle: Text(DateFormat('dd MMM yyyy', 'es').format(_selectedDate)),
      trailing: const Icon(Icons.calendar_today),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: Colors.grey[300]!)),
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
        );
        if (date != null) setState(() => _selectedDate = date);
      },
    );
  }

  Future<void> _saveMeasures() async {
    final heightValue = double.tryParse(_heightController.text);
    final headValue = double.tryParse(_headController.text);

    if (heightValue == null && headValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa al menos una medida')),
      );
      return;
    }

    final db = ref.read(databaseProvider);

    if (heightValue != null && heightValue > 0) {
      await db.insertGrowthRecord(GrowthRecordsCompanion.insert(
        childId: widget.childId,
        height: drift.Value(heightValue),
        date: _selectedDate,
      ));
    }

    if (headValue != null && headValue > 0) {
      await db.insertGrowthRecord(GrowthRecordsCompanion.insert(
        childId: widget.childId,
        headCircumference: drift.Value(headValue),
        date: _selectedDate,
      ));
    }

    ref.invalidate(growthRecordsStreamProvider(widget.childId));

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Medidas registradas')));
    }
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.child,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2)),
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
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.outline)),
                    ],
                  ),
                ),
                if (onTap != null)
                  Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.outline),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class GrowthScreen extends ConsumerWidget {
  const GrowthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedChildId = ref.watch(selectedChildIdProvider);

    if (selectedChildId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Crecimiento')),
        body: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.show_chart, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('Selecciona un niño para ver su crecimiento'),
            ],
          ),
        ),
      );
    }

    final childAsync = ref.watch(childProvider(selectedChildId));
    final growthAsync = ref.watch(growthRecordsStreamProvider(selectedChildId));

    return Scaffold(
      appBar: AppBar(title: const Text('Crecimiento')),
      body: childAsync.when(
        data: (child) {
          if (child == null) return const Center(child: Text('niño no encontrado'));

          final ageMonths = _calculateAgeMonths(child.birthDate);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoCard(
                  icon: Icons.child_care,
                  title: child.name,
                  subtitle: _formatAgeFull(ageMonths),
                  color: Colors.blue,
                  child: Row(
                    children: [
                      Icon(child.gender == 0 ? Icons.boy : Icons.girl, size: 48, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 16),
                      Text(
                        child.gender == 0 ? 'Masculino' : 'Femenino',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showEditBirthDataDialog(context, ref, child),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _InfoCard(
                  icon: Icons.analytics,
                  title: 'Historial de Crecimiento',
                  subtitle: '$ageMonths meses de edad',
                  color: Colors.green,
                  child: growthAsync.when(
                    data: (records) {
                      if (records.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text('Sin registros de crecimiento'),
                        );
                      }
                      return Column(
                        children: [
                          _GrowthChart(records: records.take(20).toList().reversed.toList()),
                          const SizedBox(height: 16),
                          const Text('Registros Recientes', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          ...records.take(10).map((r) => Dismissible(
                                key: Key(r.id.toString()),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 16),
                                  child: const Icon(Icons.delete, color: Colors.white),
                                ),
                                onDismissed: (_) => _deleteGrowthRecord(ref, r.id, selectedChildId),
                                child: ListTile(
                                  leading: const Icon(Icons.show_chart),
                                  title: Text('Peso: ${r.weight != null ? (r.weight! * 2.20462).toStringAsFixed(1) : "-"} lb | Estatura: ${r.height?.toStringAsFixed(1) ?? "-"} cm'),
                                  subtitle: Text(DateFormat('dd MMM yyyy', 'es').format(r.date)),
                                  dense: true,
                                ),
                              )),
                        ],
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Text('Error: $e'),
),
              ),
            ],
          ),
        );
      },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  int _calculateAgeMonths(DateTime birthDate) {
    final now = DateTime.now();
    return (now.year - birthDate.year) * 12 + (now.month - birthDate.month);
  }

  String _formatAgeFull(int ageMonths) {
    if (ageMonths < 12) return '$ageMonths meses';
    final years = ageMonths ~/ 12;
    final months = ageMonths % 12;
    if (months == 0) return '$years años';
    return '$years años $months meses';
  }

  void _showEditBirthDataDialog(BuildContext context, WidgetRef ref, ChildrenData child) {
    final db = ref.read(databaseProvider);
    final weightController = TextEditingController(
      text: child.birthWeight != null ? (child.birthWeight! * 2.20462).toStringAsFixed(1) : '',
    );
    final heightController = TextEditingController(
      text: child.birthHeight != null ? child.birthHeight!.toStringAsFixed(1) : '',
    );

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Editar Datos al Nacer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: weightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Peso al nacer',
                prefixIcon: Icon(Icons.monitor_weight),
                suffixText: 'lb',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: heightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Estatura al nacer',
                prefixIcon: Icon(Icons.height),
                suffixText: 'cm',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              try {
                final birthWeightLb = double.tryParse(weightController.text);
                final birthHeightCm = double.tryParse(heightController.text);
                final birthWeight = birthWeightLb != null ? birthWeightLb / 2.20462 : null;

                await db.updateChildBirthData(child.id, birthWeight, birthHeightCm);

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Datos actualizados')),
                  );
                }
              } catch (e) {
                if (dialogContext.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteGrowthRecord(WidgetRef ref, int id, int childId) async {
    final db = ref.read(databaseProvider);
    await db.deleteGrowthRecord(id);
    ref.invalidate(growthRecordsStreamProvider(childId));
  }
}

class HabitsScreen extends ConsumerWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedChildId = ref.watch(selectedChildIdProvider);

    if (selectedChildId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Hábitos')),
        body: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.bathroom, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('Selecciona un niño para ver sus Hábitos'),
            ],
          ),
        ),
      );
    }

    final childAsync = ref.watch(childProvider(selectedChildId));

    return Scaffold(
      appBar: AppBar(title: const Text('Hábitos')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            childAsync.when(
              data: (child) => _InfoCard(
                icon: Icons.child_care,
                title: child?.name ?? 'niño',
                subtitle: 'Control de Hábitos intestinales',
                color: Colors.orange,
                child: const SizedBox.shrink(),
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 16),
            _HabitStatsCard(childId: selectedChildId),
            const SizedBox(height: 16),
            _InfoCard(
              icon: Icons.calendar_month,
              title: 'Historial de Defecaciones',
              subtitle: 'Registro completo',
              color: Colors.blue,
              child: _HabitHistoryList(childId: selectedChildId),
            ),
          ],
        ),
      ),
    );
  }
}

class _HabitStatsCard extends ConsumerWidget {
  const _HabitStatsCard({required this.childId});

  final int childId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(_habitHistoryProvider(childId));

    return habitsAsync.when(
      data: (habits) {
        if (habits.isEmpty) {
          return _InfoCard(
            icon: Icons.analytics,
            title: 'Estadísticas',
            subtitle: 'Sin datos suficientes',
            color: Colors.purple,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Registra al menos 3 días para ver Estadísticas'),
            ),
          );
        }

        final daysSinceFirst = habits.last.recordedAt.difference(habits.first.recordedAt).inDays + 1;
        final totalDays = habits.where((h) => h.type != 2).length;
        final constipationDays = habits.where((h) => h.type == 1).length;
        final avgFrequency = daysSinceFirst > 0 ? (totalDays / (daysSinceFirst / 7)).toStringAsFixed(1) : '0';

        return _InfoCard(
          icon: Icons.analytics,
          title: 'Estadísticas (Últimos $daysSinceFirst días)',
          subtitle: _getTrendMessage(habits),
          color: Colors.purple,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _HabitStatCard(
                    label: 'Frecuencia',
                    value: '$avgFrequency',
                    unit: 'veces/semana',
                    color: Colors.blue,
                  ),
                  _HabitStatCard(
                    label: 'Total',
                    value: '${habits.length}',
                    unit: 'registros',
                    color: Colors.green,
                  ),
                  _HabitStatCard(
                    label: 'Estreñimiento',
                    value: '$constipationDays',
                    unit: 'días',
                    color: constipationDays > totalDays / 3 ? Colors.red : Colors.orange,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildFrequencyIndicator(context, habits, daysSinceFirst),
            ],
          ),
        );
      },
      error: (e, _) => _InfoCard(
        icon: Icons.analytics,
        title: 'Estadísticas',
        subtitle: 'Error',
        color: Colors.purple,
        child: Padding(padding: const EdgeInsets.all(16), child: Text('Error: $e')),
      ),
      loading: () => _InfoCard(
        icon: Icons.analytics,
        title: 'Estadísticas',
        subtitle: 'Cargando...',
        color: Colors.purple,
        child: const Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()),
      ),
    );
  }

  String _getTrendMessage(List<HabitRecord> habits) {
    if (habits.length < 7) return 'Evaluando...';
    final recentWeek = habits.take(7).where((h) => h.type != 2).length;
    final previousWeek = habits.skip(7).take(7).where((h) => h.type != 2).length;
    if (previousWeek == 0) return 'Sin datos previos';
    if (recentWeek > previousWeek) return 'Mejorando ✓';
    if (recentWeek < previousWeek) return 'Empeorando ✗';
    return 'Sin cambios';
  }

  Widget _buildFrequencyIndicator(BuildContext context, List<HabitRecord> habits, int totalDays) {
    final normalDays = habits.where((h) => h.type == 0).length;
    final constipationDays = habits.where((h) => h.type == 1).length;
    final total = habits.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Distribución:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            height: 8,
            child: Row(
              children: [
                if (normalDays > 0)
                  Expanded(flex: normalDays, child: Container(color: Colors.green)),
                if (constipationDays > 0)
                  Expanded(flex: constipationDays, child: Container(color: Colors.orange)),
                if (total - normalDays - constipationDays > 0)
                  Expanded(flex: total - normalDays - constipationDays, child: Container(color: Colors.red)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Normal: $normalDays', style: const TextStyle(fontSize: 10, color: Colors.green)),
            Text('Estreñimiento: $constipationDays', style: const TextStyle(fontSize: 10, color: Colors.orange)),
          ],
        ),
      ],
    );
  }
}

final _habitHistoryProvider = FutureProvider.family<List<HabitRecord>, int>((ref, childId) async {
  final db = ref.watch(databaseProvider);
  return db.getHabitRecordsForChild(childId);
});

class _HabitHistoryList extends ConsumerWidget {
  const _HabitHistoryList({required this.childId});

  final int childId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(_habitHistoryProvider(childId));

    return habitsAsync.when(
      data: (habits) {
        if (habits.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: Text('Sin registros')),
          );
        }

        final grouped = <String, List<HabitRecord>>{};
        for (final habit in habits) {
          final dateKey = DateFormat('yyyy-MM-dd').format(habit.recordedAt);
          grouped.putIfAbsent(dateKey, () => []).add(habit);
        }

        final sortedDates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

        return Column(
          children: sortedDates.take(14).map((dateKey) {
            final dayHabits = grouped[dateKey]!;
            final date = DateTime.parse(dateKey);
            final dayName = _getDayName(date);

            return ExpansionTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getDayColor(dayHabits).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(_getDayIcon(dayHabits), color: _getDayColor(dayHabits)),
              ),
              title: Text('$dayName (${DateFormat('dd MMM').format(date)})'),
              subtitle: Text('${dayHabits.length} registro(s)'),
              children: dayHabits.map((h) => Dismissible(
                key: Key(h.id.toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) => _deleteHabit(ref, h.id),
                child: ListTile(
                  dense: true,
                  leading: Icon(_habitIcon(h.type), color: _habitColor(h.type), size: 20),
                  title: Text(_habitLabel(h.type)),
                  trailing: Text(DateFormat('HH:mm').format(h.recordedAt), style: const TextStyle(color: Colors.grey)),
                ),
              )).toList(),
            );
          }).toList(),
        );
      },
      error: (e, _) => Center(child: Text('Error: $e')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  String _getDayName(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) return 'Hoy';
    if (dateOnly == yesterday) return 'Ayer';
    return DateFormat('EEEE', 'es').format(date);
  }

  Color _getDayColor(List<HabitRecord> habits) {
    if (habits.any((h) => h.type == 1)) return Colors.orange;
    if (habits.any((h) => h.type == 2)) return Colors.red;
    return Colors.green;
  }

  IconData _getDayIcon(List<HabitRecord> habits) {
    if (habits.any((h) => h.type == 1)) return Icons.warning;
    if (habits.any((h) => h.type == 2)) return Icons.water_drop;
    return Icons.check_circle;
  }

  IconData _habitIcon(int type) => switch (type) { 0 => Icons.check_circle, 1 => Icons.warning, _ => Icons.water_drop };
  Color _habitColor(int type) => switch (type) { 0 => Colors.green, 1 => Colors.orange, _ => Colors.red };
  String _habitLabel(int type) => switch (type) { 0 => 'Normal', 1 => 'Estreñimiento', _ => 'Diarrea' };

  Future<void> _deleteHabit(WidgetRef ref, int id) async {
    final db = ref.read(databaseProvider);
    await db.deleteHabitRecord(id);
    ref.invalidate(_habitHistoryProvider(childId));
    ref.invalidate(todayHabitsProvider(childId));
    ref.invalidate(growthRecordsStreamProvider(childId));
  }
}

class _HabitStatCard extends StatelessWidget {
  const _HabitStatCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  final String label;
  final String value;
  final String unit;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            unit,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}

class AlertsScreen extends ConsumerWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alertas')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                size: 64,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '¡Sin Alertas!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'No hay notificaciones pendientes',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddChildSheet extends ConsumerStatefulWidget {
  const AddChildSheet({super.key});

  @override
  ConsumerState<AddChildSheet> createState() => _AddChildSheetState();
}

class _AddChildSheetState extends ConsumerState<AddChildSheet> {
  final _nameController = TextEditingController();
  final _birthWeightController = TextEditingController();
  final _birthHeightController = TextEditingController();
  DateTime _birthDate = DateTime.now().subtract(const Duration(days: 365));
  int _gender = 0;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _birthWeightController.dispose();
    _birthHeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('Agregar niño', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  prefixIcon: Icon(Icons.person),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.cake),
                title: const Text('Fecha de Nacimiento'),
                subtitle: Text(DateFormat('dd MMMM yyyy', 'es').format(_birthDate)),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _birthDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) setState(() => _birthDate = date);
                },
              ),
              const SizedBox(height: 16),
              SegmentedButton<int>(
                segments: const [
                  ButtonSegment(value: 0, icon: Icon(Icons.boy), label: Text('niño')),
                  ButtonSegment(value: 1, icon: Icon(Icons.girl), label: Text('Niña')),
                ],
                selected: {_gender},
                onSelectionChanged: (set) => setState(() => _gender = set.first),
              ),
              const SizedBox(height: 24),
              Text('Datos al Nacer', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextField(
                controller: _birthWeightController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Peso al nacer',
                  prefixIcon: Icon(Icons.monitor_weight),
                  suffixText: 'lb',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _birthHeightController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Estatura al nacer',
                  prefixIcon: Icon(Icons.height),
                  suffixText: 'cm',
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _isLoading ? null : _saveChild,
                child: _isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Guardar'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveChild() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa el nombre del niño')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final db = ref.read(databaseProvider);
      final birthWeightLb = double.tryParse(_birthWeightController.text);
      final birthHeightCm = double.tryParse(_birthHeightController.text);

      await db.insertChild(ChildrenCompanion.insert(
        name: _nameController.text.trim(),
        birthDate: _birthDate,
        gender: _gender,
        birthWeight: birthWeightLb != null ? drift.Value(birthWeightLb / 2.20462) : const drift.Value.absent(),
        birthHeight: birthHeightCm != null ? drift.Value(birthHeightCm) : const drift.Value.absent(),
      ));

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${_nameController.text.trim()} agregado exitosamente')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

class QuickRecordSheet extends ConsumerStatefulWidget {
  const QuickRecordSheet({super.key, required this.childId, this.initialTab = 0});

  final int childId;
  final int initialTab;

  @override
  ConsumerState<QuickRecordSheet> createState() => _QuickRecordSheetState();
}

class _QuickRecordSheetState extends ConsumerState<QuickRecordSheet> {
  late int _currentTab;
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _headController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _currentTab = widget.initialTab;
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SegmentedButton<int>(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(value: 0, icon: Icon(Icons.monitor_weight), label: Text('Peso', overflow: TextOverflow.ellipsis)),
                    ButtonSegment(value: 1, icon: Icon(Icons.straighten), label: Text('Medidas', overflow: TextOverflow.ellipsis)),
                    ButtonSegment(value: 2, icon: Icon(Icons.bathroom), label: Text('Hábito', overflow: TextOverflow.ellipsis)),
                  ],
                  selected: {_currentTab},
                  onSelectionChanged: (set) => setState(() => _currentTab = set.first),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: switch (_currentTab) {
                    0 => _buildWeightForm(),
                    1 => _buildMeasuresForm(),
                    2 => _buildHabitForm(),
                    _ => const SizedBox(),
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWeightForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        Text('Registrar Peso', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _buildDateSelector(),
        const SizedBox(height: 16),
        TextField(
          controller: _weightController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Peso (lb)',
            prefixIcon: Icon(Icons.monitor_weight),
            suffixText: 'lb',
          ),
          autofocus: true,
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: () => _saveGrowth(true),
          icon: const Icon(Icons.save),
          label: const Text('Guardar Peso'),
        ),
      ],
    );
  }

  Widget _buildMeasuresForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        Text('Registrar Medidas', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _buildDateSelector(),
        const SizedBox(height: 16),
        TextField(
          controller: _heightController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Estatura (cm)',
            prefixIcon: Icon(Icons.height),
            suffixText: 'cm',
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _headController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Perímetro craneal (cm)',
            prefixIcon: Icon(Icons.circle_outlined),
            suffixText: 'cm',
          ),
        ),
        const SizedBox(height: 8),
        Text('Ambos campos son opcionales', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: _saveMeasuresCombined,
          icon: const Icon(Icons.save),
          label: const Text('Guardar'),
        ),
      ],
    );
  }

  Future<void> _saveMeasuresCombined() async {
    final heightValue = double.tryParse(_heightController.text);
    final headValue = double.tryParse(_headController.text);

    if (heightValue == null && headValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa al menos una medida')),
      );
      return;
    }

    final db = ref.read(databaseProvider);

    if (heightValue != null && heightValue > 0) {
      await db.insertGrowthRecord(GrowthRecordsCompanion.insert(
        childId: widget.childId,
        height: drift.Value(heightValue),
        date: _selectedDate,
      ));
    }

    if (headValue != null && headValue > 0) {
      await db.insertGrowthRecord(GrowthRecordsCompanion.insert(
        childId: widget.childId,
        headCircumference: drift.Value(headValue),
        date: _selectedDate,
      ));
    }

    ref.invalidate(growthRecordsStreamProvider(widget.childId));

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Medidas registradas')));
    }
  }

  Widget _buildHabitForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        Text('Registrar Hábito', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _buildDateSelector(),
        const SizedBox(height: 24),
        Text('¿Cómo fue el Hábito intestinal?', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.outline)),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _HabitOptionCard(
                type: 0,
                icon: Icons.check_circle,
                label: 'Normal',
                description: 'Evacuación regular',
                color: Colors.green,
                onTap: () => _saveHabit(0),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _HabitOptionCard(
                type: 1,
                icon: Icons.warning,
                label: 'Estreñimiento',
                description: 'Dificultad para evacuar',
                color: Colors.orange,
                onTap: () => _saveHabit(1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _HabitOptionCard(
                type: 2,
                icon: Icons.water_drop,
                label: 'Diarrea',
                description: 'Evacuación líquida',
                color: Colors.red,
                onTap: () => _saveHabit(2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Container()),
          ],
        ),
      ],
    );
  }

  Widget _buildDateSelector() {
    return InkWell(
      onTap: _selectDate,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.outline),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Text(
              DateFormat('dd MMM yyyy', 'es').format(_selectedDate),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Spacer(),
            Icon(Icons.arrow_drop_down, color: Theme.of(context).colorScheme.outline),
          ],
        ),
      ),
    );
  }

  Future<void> _saveGrowth(bool isWeight) async {
    final controller = isWeight ? _weightController : _heightController;
    final value = double.tryParse(controller.text);

    if (value == null || value <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa un valor válido')),
      );
      return;
    }

    final db = ref.read(databaseProvider);
    await db.insertGrowthRecord(GrowthRecordsCompanion.insert(
      childId: widget.childId,
      weight: isWeight ? drift.Value(value) : const drift.Value.absent(),
      height: isWeight ? const drift.Value.absent() : drift.Value(value),
      date: _selectedDate,
    ));

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${isWeight ? "Peso" : "Estatura"} registrado exitosamente')),
      );
    }
  }

  Future<void> _saveGrowthHead() async {
    final value = double.tryParse(_headController.text);

    if (value == null || value <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa un valor válido')),
      );
      return;
    }

    final db = ref.read(databaseProvider);
    await db.insertGrowthRecord(GrowthRecordsCompanion.insert(
      childId: widget.childId,
      headCircumference: drift.Value(value),
      date: _selectedDate,
    ));

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perímetro craneal registrado exitosamente')),
      );
    }
  }

  Future<void> _saveHabit(int type) async {
    final db = ref.read(databaseProvider);
    await db.insertHabitRecord(HabitRecordsCompanion.insert(
      childId: widget.childId,
      type: type,
      recordedAt: _selectedDate,
    ));

    ref.invalidate(_habitHistoryProvider(widget.childId));
    ref.invalidate(todayHabitsProvider(widget.childId));

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hábito registrado exitosamente')),
      );
    }
  }
}

class _HabitOptionCard extends StatelessWidget {
  const _HabitOptionCard({
    required this.type,
    required this.icon,
    required this.label,
    required this.description,
    required this.color,
    required this.onTap,
  });

  final int type;
  final IconData icon;
  final String label;
  final String description;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(icon, color: color, size: 40),
              const SizedBox(height: 12),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: color.withValues(alpha: 0.8),
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VaccinesScreen extends ConsumerWidget {
  const VaccinesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedChildId = ref.watch(selectedChildIdProvider);

    if (selectedChildId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Vacunas')),
        body: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.vaccines, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('Selecciona un niño para ver sus vacunas'),
            ],
          ),
        ),
      );
    }

    final childAsync = ref.watch(childProvider(selectedChildId));
    final scheduleAsync = ref.watch(vaccineScheduleProvider(selectedChildId));

    return Scaffold(
      appBar: AppBar(title: const Text('Vacunas')),
      body: childAsync.when(
        data: (child) {
          if (child == null) return const Center(child: Text('niño no encontrado'));

          return scheduleAsync.when(
            data: (schedule) {
              final overdue = schedule.where((s) => s.isOverdue).toList()
                ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
              final upcoming = schedule.where((s) => !s.isCompleted && !s.isOverdue).toList()
                ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
              final completed = schedule.where((s) => s.isCompleted).toList();

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (overdue.isNotEmpty) ...[
                    _SectionHeader(title: 'Atrasadas', color: Colors.red, count: overdue.length),
                    ...overdue.map((item) => _VaccineCard(item: item, childId: selectedChildId)),
                    const SizedBox(height: 16),
                  ],
                  _SectionHeader(title: 'próximas', color: Colors.orange, count: upcoming.length),
                  ...upcoming.take(5).map((item) => _VaccineCard(item: item, childId: selectedChildId)),
                  const SizedBox(height: 16),
                  _SectionHeader(title: 'Completadas', color: Colors.green, count: completed.length),
                  ...completed.take(10).map((item) => _VaccineCard(item: item, childId: selectedChildId)),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: selectedChildId != null
          ? FloatingActionButton.extended(
              onPressed: () => _showAddVaccineDialog(context, ref, selectedChildId),
              icon: const Icon(Icons.add),
              label: const Text('Registrar'),
            )
          : null,
    );
  }

  void _showAddVaccineDialog(BuildContext context, WidgetRef ref, int childId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _AddVaccineSheet(childId: childId),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.color, required this.count});

  final String title;
  final Color color;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(width: 8, height: 24, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
          const SizedBox(width: 8),
          Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
            child: Text('$count', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

class _VaccineCard extends ConsumerWidget {
  const _VaccineCard({required this.item, required this.childId});

  final VaccineScheduleItem item;
  final int childId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusColor = item.isCompleted ? Colors.green : (item.isOverdue ? Colors.red : Colors.orange);
    final statusIcon = item.isCompleted ? Icons.check_circle : (item.isOverdue ? Icons.warning : Icons.schedule);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => item.isCompleted ? _showEditAppliedDialog(context, ref) : _showMarkAppliedDialog(context, ref),
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          leading: CircleAvatar(backgroundColor: statusColor.withValues(alpha: 0.2), child: Icon(statusIcon, color: statusColor)),
          title: Text(
                item.definition.totalDoses > 1
                    ? '${item.definition.name} (${item.definition.doseNumber}/${item.definition.totalDoses})'
                    : item.definition.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item.definition.description != null) Text(item.definition.description!, style: const TextStyle(fontSize: 12)),
              Text(
                item.isCompleted
                    ? 'Aplicada: ${DateFormat('dd MMM yyyy', 'es').format(item.appliedVaccine!.appliedDate)}'
                    : 'Fecha: ${DateFormat('dd MMM yyyy', 'es').format(item.dueDate)} (${_formatVaccineAge(item.definition.recommendedAgeMonths)})',
                style: TextStyle(fontSize: 11, color: statusColor),
              ),
            ],
          ),
          trailing: item.isCompleted
              ? IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => _deleteVaccine(context, ref))
              : IconButton(icon: const Icon(Icons.check, color: Colors.green), onPressed: () => _showMarkAppliedDialog(context, ref)),
          isThreeLine: true,
        ),
      ),
    );
  }

  void _showMarkAppliedDialog(BuildContext context, WidgetRef ref) {
    DateTime selectedDate = DateTime.now();
    final batchController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Registrar ${item.definition.name}'),
              if (item.definition.totalDoses > 1)
                Text(
                  item.definition.description ?? 'Dosis ${item.definition.doseNumber}/${item.definition.totalDoses}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.normal),
                ),
              Text(
                _formatVaccineAge(item.definition.recommendedAgeMonths),
                style: TextStyle(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.normal),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Fecha de aplicación'),
                subtitle: Text(DateFormat('dd MMM yyyy', 'es').format(selectedDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime(2020), lastDate: DateTime.now());
                  if (date != null) setState(() => selectedDate = date);
                },
              ),
              const SizedBox(height: 8),
              TextField(controller: batchController, decoration: const InputDecoration(labelText: 'Lote (opcional)', border: OutlineInputBorder())),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancelar')),
            FilledButton(
              onPressed: () async {
                final db = ref.read(databaseProvider);
                await db.insertChildVaccine(ChildVaccinesCompanion.insert(
                  childId: childId,
                  vaccineDefinitionId: item.definition.id,
                  appliedDate: selectedDate,
                  batch: batchController.text.isEmpty ? const drift.Value(null) : drift.Value(batchController.text),
                ));
                ref.invalidate(vaccineScheduleProvider(childId));
                if (dialogContext.mounted) Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vacuna registrada')));
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteVaccine(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar registro'),
        content: const Text('¿Estás seguro de eliminar esta vacuna aplicada?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancelar')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              final db = ref.read(databaseProvider);
              await db.deleteChildVaccine(item.appliedVaccine!.id);
              ref.invalidate(vaccineScheduleProvider(childId));
              if (dialogContext.mounted) Navigator.pop(dialogContext);
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _showEditAppliedDialog(BuildContext context, WidgetRef ref) {
    DateTime selectedDate = item.appliedVaccine!.appliedDate;
    final batchController = TextEditingController(text: item.appliedVaccine!.batch ?? '');

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Editar ${item.definition.name}'),
              if (item.definition.totalDoses > 1)
                Text(
                  item.definition.description ?? 'Dosis ${item.definition.doseNumber}/${item.definition.totalDoses}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.normal),
                ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Fecha de aplicación'),
                subtitle: Text(DateFormat('dd MMM yyyy', 'es').format(selectedDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime(2020), lastDate: DateTime.now());
                  if (date != null) setState(() => selectedDate = date);
                },
              ),
              const SizedBox(height: 8),
              TextField(controller: batchController, decoration: const InputDecoration(labelText: 'Lote (opcional)', border: OutlineInputBorder())),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancelar')),
            FilledButton(
              onPressed: () async {
                final db = ref.read(databaseProvider);
                await db.deleteChildVaccine(item.appliedVaccine!.id);
                await db.insertChildVaccine(ChildVaccinesCompanion.insert(
                  childId: childId,
                  vaccineDefinitionId: item.definition.id,
                  appliedDate: selectedDate,
                  batch: batchController.text.isEmpty ? const drift.Value(null) : drift.Value(batchController.text),
                ));
                ref.invalidate(vaccineScheduleProvider(childId));
                if (dialogContext.mounted) Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vacuna actualizada')));
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddVaccineSheet extends ConsumerStatefulWidget {
  const _AddVaccineSheet({required this.childId});

  final int childId;

  @override
  ConsumerState<_AddVaccineSheet> createState() => _AddVaccineSheetState();
}

class _AddVaccineSheetState extends ConsumerState<_AddVaccineSheet> {
  int? _selectedDefinitionId;
  DateTime _selectedDate = DateTime.now();
  final _batchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final definitionsAsync = ref.watch(vaccineDefinitionsProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Text('Registrar Vacuna', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            definitionsAsync.when(
              data: (definitions) {
                final sortedDefinitions = List<VaccineDefinition>.from(definitions)
                  ..sort((a, b) => a.name.compareTo(b.name));
                return Autocomplete<VaccineDefinition>(
                  displayStringForOption: (def) {
                    final doseLabel = def.totalDoses == 999 ? '(anual)' : '(${def.doseNumber}/${def.totalDoses})';
                    return '${def.name} $doseLabel';
                  },
                  optionsBuilder: (textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return sortedDefinitions;
                    }
                    return sortedDefinitions.where((def) =>
                      def.name.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                  },
                  onSelected: (def) {
                    setState(() => _selectedDefinitionId = def.id);
                  },
                  fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: const InputDecoration(
                        labelText: 'Buscar vacuna',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                      ),
                    );
                  },
                  optionsViewBuilder: (context, onSelected, options) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 4,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 300, maxWidth: 400),
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: options.length,
                            itemBuilder: (context, index) {
                              final def = options.elementAt(index);
                              final doseLabel = def.totalDoses == 999 ? '(anual)' : '(${def.doseNumber}/${def.totalDoses})';
                              return ListTile(
                                title: Text('${def.name} $doseLabel'),
                                subtitle: def.description != null ? Text(def.description!) : null,
                                onTap: () => onSelected(def),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Error: $e'),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Fecha de aplicación'),
              subtitle: Text(DateFormat('dd MMM yyyy', 'es').format(_selectedDate)),
              trailing: const Icon(Icons.calendar_today),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: Colors.grey[300]!)),
              onTap: () async {
                final date = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime(2020), lastDate: DateTime.now());
                if (date != null) setState(() => _selectedDate = date);
              },
            ),
            const SizedBox(height: 16),
            TextField(controller: _batchController, decoration: const InputDecoration(labelText: 'Lote (opcional)', border: OutlineInputBorder())),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _selectedDefinitionId == null ? null : () async {
                final db = ref.read(databaseProvider);
                await db.insertChildVaccine(ChildVaccinesCompanion.insert(
                  childId: widget.childId,
                  vaccineDefinitionId: _selectedDefinitionId!,
                  appliedDate: _selectedDate,
                  batch: _batchController.text.isEmpty ? const drift.Value(null) : drift.Value(_batchController.text),
                ));
                ref.invalidate(vaccineScheduleProvider(widget.childId));
                if (mounted) Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vacuna registrada')));
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}


