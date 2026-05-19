import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pediatrack/core/constants/app_constants.dart';
import 'package:pediatrack/core/theme/app_theme.dart';
import 'package:pediatrack/core/providers/database_providers.dart';
import 'package:pediatrack/core/services/who_growth_service.dart';
import 'package:pediatrack/core/services/backup_export_service.dart';
import 'package:pediatrack/core/services/auto_backup_scheduler.dart';
import 'package:pediatrack/core/widgets/who_growth_chart.dart';
import 'package:pediatrack/data/database/app_database.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pediatrack/enhanced_vaccines_screen.dart';

double _sheetBottomSpace(BuildContext context) => 10 + MediaQuery.of(context).viewPadding.bottom;

class PediaTrackApp extends ConsumerStatefulWidget {
  const PediaTrackApp({super.key, required this.initialTheme});

  final ThemeMode initialTheme;

  @override
  ConsumerState<PediaTrackApp> createState() => _PediaTrackAppState();
}

class _PediaTrackAppState extends ConsumerState<PediaTrackApp> {
  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [Locale('es', 'MX')],
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
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

  void _showSettingsSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SettingsSheet(database: ref.read(databaseProvider)),
    );
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
            EnhancedVaccinesScreen(),
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

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  void _showSettingsSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SettingsSheet(database: ref.read(databaseProvider)),
    );
  }

  void _showEditChildSheet(BuildContext context, WidgetRef ref, ChildrenData child) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddChildSheet(child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final childrenAsync = ref.watch(childrenStreamProvider);
    final selectedChildId = ref.watch(selectedChildIdProvider);

    return Scaffold(
appBar: AppBar(
        leading: IconButton(
          icon: Icon(ref.watch(themeModeProvider) == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
          onPressed: () {
            ref.read(themeModeProvider.notifier).toggleTheme();
          },
        ),
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
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => _showSettingsSheet(context, ref),
          ),
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
                  onChildEdit: (child) => _showEditChildSheet(context, ref, child),
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
        child: _HomeGuidanceCard(childId: childId),
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
      builder: (context) => QuickRecordSheet(childId: childId, initialTab: 0, enableHabitTab: true),
    );
  }
}

class _HomeGuidanceCard extends ConsumerWidget {
  const _HomeGuidanceCard({required this.childId});

  final int childId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: _InfoCard(
        icon: Icons.lightbulb_outline,
        title: 'Sugerencia rápida',
        subtitle: 'Para registrar más fácil',
        color: Colors.amber,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Usa el botón "Registrar" para guardar Consulta o Hábito desde cualquier pantalla principal.'),
          ],
        ),
      ),
    );
  }
}

class _ChildSelector extends StatelessWidget {
  const _ChildSelector({
    required this.children,
    required this.selectedChildId,
    required this.onChildSelected,
    this.onChildEdit,
  });

  final List<ChildrenData> children;
  final int? selectedChildId;
  final void Function(int) onChildSelected;
  final void Function(ChildrenData)? onChildEdit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text(
            'Seleccionar Hijo',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(
          height: 118,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: children.length,
            itemBuilder: (context, index) {
              final child = children[index];
              final isSelected = child.id == selectedChildId;
              final firstName = child.name.split(' ').first;
              final initials = child.name
                  .split(' ')
                  .where((p) => p.trim().isNotEmpty)
                  .take(2)
                  .map((p) => p[0].toUpperCase())
                  .join();
              final accent = child.gender == 0 ? Colors.blue : Colors.pink;

              return GestureDetector(
                onTap: () => onChildSelected(child.id),
                onLongPress: onChildEdit != null ? () => onChildEdit!(child) : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 96,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primaryContainer
                        : Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outline.withValues(alpha: 0.22),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: accent.withValues(alpha: isSelected ? 0.25 : 0.15),
                        child: Text(
                          initials,
                          style: TextStyle(
                            color: accent,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        firstName,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
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
          child: growthAsync.when(
            data: (records) {
              final lastWeight = records.isNotEmpty ? records.first.weight : null;
              final lastHeight = records.isNotEmpty ? records.first.height : null;
              return Column(
                children: [
                  Row(
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
                        child: _StatCard(
                          icon: child.gender == 0 ? Icons.boy_outlined : Icons.girl_outlined,
                          label: 'Género',
                          value: child.gender == 0 ? 'Niño' : 'Niña',
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.monitor_weight_outlined,
                          label: 'Peso',
                          value: lastWeight != null ? '${(lastWeight * 2.20462).toStringAsFixed(1)} lb' : 'Sin dato',
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.height_outlined,
                          label: 'Estatura',
                          value: lastHeight != null ? '${lastHeight.toStringAsFixed(1)} cm' : 'Sin dato',
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
            loading: () => Column(
              children: const [
                Row(
                  children: [
                    Expanded(child: _StatCard(icon: Icons.cake_outlined, label: 'Edad', value: '...', color: Colors.pink)),
                    SizedBox(width: 12),
                    Expanded(child: _StatCard(icon: Icons.person_outline, label: 'Género', value: '...', color: Colors.orange)),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _StatCard(icon: Icons.monitor_weight_outlined, label: 'Peso', value: '...', color: Colors.blue)),
                    SizedBox(width: 12),
                    Expanded(child: _StatCard(icon: Icons.height_outlined, label: 'Estatura', value: '...', color: Colors.green)),
                  ],
                ),
              ],
            ),
            error: (_, __) => const SizedBox.shrink(),
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
    if (ageMonths < 12) return ageMonths == 1 ? '1 mes' : '$ageMonths meses';
    final years = ageMonths ~/ 12;
    final months = ageMonths % 12;
    final yearLabel = years == 1 ? 'año' : 'años';
    if (months == 0) return '$years $yearLabel';
    final monthLabel = months == 1 ? 'mes' : 'meses';
    return '$years $yearLabel $months $monthLabel';
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

class _RecentGrowthCard extends ConsumerStatefulWidget {
  const _RecentGrowthCard({required this.childId});

  final int childId;

  @override
  ConsumerState<_RecentGrowthCard> createState() => _RecentGrowthCardState();
}

class _RecentGrowthCardState extends ConsumerState<_RecentGrowthCard> {
  int _selectedRecords = 0;

  @override
  Widget build(BuildContext context) {
    final growthAsync = ref.watch(growthRecordsStreamProvider(widget.childId));

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
                onPressed: () => _showGrowthEntrySheet(context, widget.childId),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Mostrar:', style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(width: 8),
                    DropdownButton<int>(
                      value: _selectedRecords,
                      underline: const SizedBox(),
                      items: [
                        const DropdownMenuItem(value: 5, child: Text('5 registros')),
                        const DropdownMenuItem(value: 10, child: Text('10 registros')),
                        const DropdownMenuItem(value: 20, child: Text('20 registros')),
                        const DropdownMenuItem(value: 0, child: Text('Todos')),
                      ],
                      onChanged: (value) {
                        setState(() => _selectedRecords = value ?? 0);
                      },
                    ),
                  ],
                ),
                _GrowthChart(records: _selectedRecords == 0
                    ? records.reversed.toList()
                    : records.take(_selectedRecords).toList().reversed.toList()),
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

  IconData _habitIcon(int type) => switch (type) {
        0 => Icons.check_circle,
        1 => Icons.warning,
        2 => Icons.water_drop,
        10 => Icons.restaurant,
        11 => Icons.nightlight_round,
        12 => Icons.local_drink,
        13 => Icons.medication,
        _ => Icons.event_note,
      };
  Color _habitColor(int type) => switch (type) {
        0 => Colors.green,
        1 => Colors.orange,
        2 => Colors.red,
        10 => Colors.teal,
        11 => Colors.indigo,
        12 => Colors.cyan,
        13 => Colors.deepPurple,
        _ => Colors.blueGrey,
      };
  String _habitLabel(int type) => switch (type) {
        0 => 'Evacuación normal',
        1 => 'Estreñimiento',
        2 => 'Diarrea',
        10 => 'Alimentación',
        11 => 'Sueño',
        12 => 'Hidratación',
        13 => 'Medicación',
        _ => 'Otro hábito',
      };
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
              onTap: () => _showQuickRecord(context, ref, 1),
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
    final habitOnly = tab == 1;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => QuickRecordSheet(
        childId: childId,
        initialTab: tab,
        habitOnly: habitOnly,
      ),
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
    final keyboard = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: keyboard),
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 16, 16, _sheetBottomSpace(context)),
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
            Text('Ambos campos son opcionales', style: Theme.of(context).textTheme.bodySmall),
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

class GrowthScreen extends ConsumerStatefulWidget {
  const GrowthScreen({super.key});

  @override
  ConsumerState<GrowthScreen> createState() => _GrowthScreenState();
}

class _GrowthScreenState extends ConsumerState<GrowthScreen> {
  int _selectedRecords = 0;

  @override
  Widget build(BuildContext context) {
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
            padding: EdgeInsets.fromLTRB(16, 16, 16, 120 + MediaQuery.of(context).viewPadding.bottom),
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
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                growthAsync.when(
                  data: (records) {
                    if (records.isEmpty) {
                      return _InfoCard(
                        icon: Icons.show_chart,
                        title: 'Curvas de Crecimiento OMS',
                        subtitle: 'Sin registros de crecimiento',
                        color: Colors.green,
                        child: const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text('Agrega registros de peso y estatura para ver las curvas de crecimiento'),
                        ),
                      );
                    }

                    final displayRecords = _selectedRecords == 0
                        ? records
                        : records.take(_selectedRecords).toList();

                    final weightRecords = displayRecords.where((r) => r.weight != null).toList();
                    final heightRecords = displayRecords.where((r) => r.height != null).toList();
                    final latest = records.isNotEmpty ? records.first : null;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _GrowthMetricChip(
                              label: 'Registros',
                              value: '${records.length}',
                              color: Colors.indigo,
                            ),
                            _GrowthMetricChip(
                              label: 'Peso actual',
                              value: latest?.weight != null ? '${(latest!.weight! * 2.20462).toStringAsFixed(1)} lb' : 'Sin dato',
                              color: Colors.blue,
                            ),
                            _GrowthMetricChip(
                              label: 'Estatura actual',
                              value: latest?.height != null ? '${latest!.height!.toStringAsFixed(1)} cm' : 'Sin dato',
                              color: Colors.green,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('Mostrar:', style: Theme.of(context).textTheme.bodySmall),
                            const SizedBox(width: 8),
                            DropdownButton<int>(
                              value: _selectedRecords,
                              underline: const SizedBox(),
                              items: const [
                                DropdownMenuItem(value: 5, child: Text('5 registros')),
                                DropdownMenuItem(value: 10, child: Text('10 registros')),
                                DropdownMenuItem(value: 20, child: Text('20 registros')),
                                DropdownMenuItem(value: 0, child: Text('Todos')),
                              ],
                              onChanged: (value) {
                                setState(() => _selectedRecords = value ?? 0);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (weightRecords.isNotEmpty) ...[
                          _InfoCard(
                            icon: Icons.monitor_weight,
                            title: 'Curva de Peso',
                            subtitle: 'Comparación con curvas OMS',
                            color: Colors.blue,
                            child: WhoGrowthChart(
                              childId: selectedChildId,
                              gender: child.gender,
                              records: weightRecords.map((r) => WhoGrowthRecord(
                                id: r.id,
                                childId: r.childId,
                                weight: r.weight,
                                height: r.height,
                                headCircumference: r.headCircumference,
                                date: r.date,
                              )).toList(),
                              type: GrowthType.weight,
                              birthDate: child.birthDate,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        if (heightRecords.isNotEmpty) ...[
                          _InfoCard(
                            icon: Icons.height,
                            title: 'Curva de Estatura',
                            subtitle: 'Comparación con curvas OMS',
                            color: Colors.green,
                            child: WhoGrowthChart(
                              childId: selectedChildId,
                              gender: child.gender,
                              records: heightRecords.map((r) => WhoGrowthRecord(
                                id: r.id,
                                childId: r.childId,
                                weight: r.weight,
                                height: r.height,
                                headCircumference: r.headCircumference,
                                date: r.date,
                              )).toList(),
                              type: GrowthType.height,
                              birthDate: child.birthDate,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        _InfoCard(
                          icon: Icons.analytics,
                          title: 'Historial de Crecimiento',
                          subtitle: '$ageMonths meses de edad',
                          color: Colors.purple,
                          child: Column(
                            children: [
                              const SizedBox(height: 16),
                              const Text('Registros Recientes', style: TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              ...displayRecords.map((r) => Dismissible(
                                    key: Key(r.id.toString()),
                                    direction: DismissDirection.endToStart,
                                    background: Container(
                                      color: Colors.red,
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.only(right: 16),
                                      child: const Icon(Icons.delete, color: Colors.white),
                                    ),
                                    confirmDismiss: (_) => _confirmDeleteGrowthRecord(context),
                                    onDismissed: (_) => _deleteGrowthRecord(ref, r.id, selectedChildId),
                                    child: ListTile(
                                      leading: const Icon(Icons.show_chart),
                                      title: Text('Peso: ${r.weight != null ? (r.weight! * 2.20462).toStringAsFixed(1) : "-"} lb | Estatura: ${r.height?.toStringAsFixed(1) ?? "-"} cm'),
                                      subtitle: Text(DateFormat('dd MMM yyyy', 'es').format(r.date)),
                                      dense: true,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('Error: $e'),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => QuickRecordSheet(childId: selectedChildId, initialTab: 0),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Registrar'),
      ),
    );
  }

  int _calculateAgeMonths(DateTime birthDate) {
    final now = DateTime.now();
    return (now.year - birthDate.year) * 12 + (now.month - birthDate.month);
  }

  Future<bool> _confirmDeleteGrowthRecord(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar registro'),
        content: const Text('¿Seguro que deseas eliminar este registro de crecimiento?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    return shouldDelete ?? false;
  }

  String _formatAgeFull(int ageMonths) {
    if (ageMonths < 12) return '$ageMonths meses';
    final years = ageMonths ~/ 12;
    final months = ageMonths % 12;
    if (months == 0) return '$years años';
    return '$years años $months meses';
  }

  Future<void> _deleteGrowthRecord(WidgetRef ref, int id, int childId) async {
    final db = ref.read(databaseProvider);
    await db.deleteGrowthRecord(id);
    ref.invalidate(growthRecordsStreamProvider(childId));
  }
}

class SettingsSheet extends ConsumerStatefulWidget {
  const SettingsSheet({super.key, required this.database});

  final AppDatabase database;

  @override
  ConsumerState<SettingsSheet> createState() => _SettingsSheetState();
}

enum _ExportAction { shareJson, downloadJson, shareExcel, downloadExcel }

class _SettingsSheetState extends ConsumerState<SettingsSheet> {
  bool _autoBackupEnabled = false;
  int _backupHour = 23;
  int _backupMinute = 30;
  String _backupFolder = 'PediaTrack';
  String? _lastBackupAt;
  String? _lastBackupStatus;
  String? _lastBackupTrigger;
  String? _lastAutoRunAt;
  String? _lastAutoStatus;
  String? _lastManualRunAt;
  String? _lastManualStatus;
  String? _nextRunAt;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final db = widget.database;
    final enabled = await db.getSetting('auto_backup_enabled');
    final hour = await db.getSetting('auto_backup_hour');
    final minute = await db.getSetting('auto_backup_minute');
    final folder = await db.getSetting('backup_folder');
    final lastRun = await db.getSetting('backup_last_run_at');
    final lastStatus = await db.getSetting('backup_last_status');
    final lastTrigger = await db.getSetting('backup_last_trigger');
    final lastAutoRun = await db.getSetting('backup_last_auto_run_at');
    final lastAutoStatus = await db.getSetting('backup_last_auto_status');
    final lastManualRun = await db.getSetting('backup_last_manual_run_at');
    final lastManualStatus = await db.getSetting('backup_last_manual_status');
    final nextRun = await db.getSetting('backup_next_run_at');

    setState(() {
      _autoBackupEnabled = enabled == 'true';
      _backupHour = int.tryParse(hour ?? '23') ?? 23;
      _backupMinute = int.tryParse(minute ?? '30') ?? 30;
      _backupFolder = folder ?? 'PediaTrack';
      _lastBackupAt = lastRun;
      _lastBackupStatus = lastStatus;
      _lastBackupTrigger = lastTrigger;
      _lastAutoRunAt = lastAutoRun;
      _lastAutoStatus = lastAutoStatus;
      _lastManualRunAt = lastManualRun;
      _lastManualStatus = lastManualStatus;
      _nextRunAt = nextRun;
      _isLoading = false;
    });
  }

  Future<void> _saveSetting(String key, String value) async {
    final db = widget.database;
    await db.setSetting(key, value);
  }

  Future<void> _editNextRun() async {
    if (_nextRunAt == null) return;
    final currentDate = DateTime.tryParse(_nextRunAt!) ?? DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(currentDate),
    );

    if (time == null || !mounted) return;

    final newDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);

    await widget.database.setSetting('backup_next_run_at', newDateTime.toIso8601String());
    await AutoBackupScheduler.syncFromDatabase(overrideNextRunAt: newDateTime);
    await _loadSettings();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Próximo respaldo: ${DateFormat('dd MMM yyyy HH:mm', 'es').format(newDateTime)}')),
      );
    }
  }

  Future<void> _runBackupNow({bool forceAuto = false}) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Generando respaldo...')),
    );

    try {
      final trigger = forceAuto ? 'auto' : 'manual';
      final files = await BackupExportService.saveBackupFilesLocally(_backupFolder);
      await BackupRunLogService.markRun(
        db: widget.database,
        status: 'OK',
        trigger: trigger,
        details: 'Respaldo guardado: ${files.jsonFileName}',
      );
      await _loadSettings();
      await AutoBackupScheduler.syncFromDatabase();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Respaldo guardado en: ${files.jsonFilePath}')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _showExportOptions(BuildContext context) async {
    final action = await showModalBottomSheet<_ExportAction>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(margin: const EdgeInsets.only(top: 12), width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                      child: Icon(Icons.cloud_upload, color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(width: 12),
                    const Text('Exportar datos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.blue.withValues(alpha: 0.1), borderRadius: const BorderRadius.all(Radius.circular(8))), child: const Icon(Icons.share, color: Colors.blue, size: 20)),
                title: const Text('Compartir JSON'),
                subtitle: const Text('Enviar por correo o WhatsApp'),
                onTap: () => Navigator.pop(context, _ExportAction.shareJson),
              ),
              ListTile(
                leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), borderRadius: const BorderRadius.all(Radius.circular(8))), child: const Icon(Icons.download, color: Colors.green, size: 20)),
                title: const Text('Descargar JSON'),
                subtitle: const Text('Guardar archivo localmente'),
                onTap: () => Navigator.pop(context, _ExportAction.downloadJson),
              ),
              const Divider(height: 1),
              ListTile(
                leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.1), borderRadius: const BorderRadius.all(Radius.circular(8))), child: const Icon(Icons.share, color: Colors.orange, size: 20)),
                title: const Text('Compartir Excel'),
                subtitle: const Text('Enviar por correo o WhatsApp'),
                onTap: () => Navigator.pop(context, _ExportAction.shareExcel),
              ),
              ListTile(
                leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.teal.withValues(alpha: 0.1), borderRadius: const BorderRadius.all(Radius.circular(8))), child: const Icon(Icons.download, color: Colors.teal, size: 20)),
                title: const Text('Descargar Excel'),
                subtitle: const Text('Guardar archivo localmente'),
                onTap: () => Navigator.pop(context, _ExportAction.downloadExcel),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );

    if (action == null) return;
    await _exportData(action);
  }

  Future<void> _exportData(_ExportAction action) async {
    try {
      if (action == _ExportAction.shareJson || action == _ExportAction.downloadJson) {
        final bytes = await BackupExportService.buildBackupJsonBytes();

        if (action == _ExportAction.shareJson) {
          await _shareBackupFile(bytes: bytes, extension: 'json', mimeType: 'application/json', label: 'Respaldo PediaTrack (JSON)');
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Respaldo JSON listo para compartir')));
          return;
        }

        final savedPath = await _saveBackupFile(bytes: bytes, extension: 'json');
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Respaldo guardado en: $savedPath')));
        return;
      }

      final bytes = await BackupExportService.buildBackupExcelBytes();

      if (action == _ExportAction.shareExcel) {
        await _shareBackupFile(bytes: bytes, extension: 'xlsx', mimeType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', label: 'Respaldo PediaTrack (Excel)');
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Respaldo Excel listo para compartir')));
        return;
      }

      final savedPath = await _saveBackupFile(bytes: bytes, extension: 'xlsx');
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Excel guardado en: $savedPath')));
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo exportar: $error'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _shareBackupFile({required Uint8List bytes, required String extension, required String mimeType, required String label}) async {
    final tempDir = await getTemporaryDirectory();
    final fileName = 'pediatrack_backup_${DateTime.now().millisecondsSinceEpoch}.$extension';
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    await Share.shareXFiles([XFile(file.path, mimeType: mimeType)], text: label, subject: label);
  }

  Future<String> _saveBackupFile({required Uint8List bytes, required String extension}) async {
    final fileName = 'pediatrack_backup_${DateTime.now().millisecondsSinceEpoch}.$extension';
    final pickedPath = await FilePicker.platform.saveFile(
      dialogTitle: 'Guardar respaldo',
      fileName: fileName,
      type: FileType.custom,
      allowedExtensions: [extension],
      bytes: bytes,
    );

    if (pickedPath != null && pickedPath.trim().isNotEmpty) return pickedPath;

    final downloadsDir = await getDownloadsDirectory();
    if (downloadsDir != null) {
      final file = File('${downloadsDir.path}/$fileName');
      await file.writeAsBytes(bytes, flush: true);
      return file.path;
    }

    if (Platform.isAndroid) {
      final file = File('/storage/emulated/0/Download/$fileName');
      await file.writeAsBytes(bytes, flush: true);
      return file.path;
    }

    throw Exception('No se encontró una ruta para guardar el respaldo');
  }

  Future<void> _importBackup() async {
    final selected = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    final path = selected?.files.single.path;
    if (path == null) return;

    if (!mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Importar respaldo'),
        content: const Text(
          'Esto reemplazará todos los datos actuales. ¿Deseas continuar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Importar'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final content = await File(path).readAsString();
      final decoded = jsonDecode(content);

      if (decoded is! Map<String, dynamic>) {
        throw Exception('Formato de respaldo inválido');
      }

      final db = ref.read(databaseProvider);
      await db.importBackupData(decoded);

      ref.invalidate(childrenStreamProvider);
      ref.invalidate(selectedChildIdProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Respaldo importado correctamente')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Configuración',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView(
                        controller: scrollController,
                        children: [
                          _buildSection(
                            title: 'Respaldo Automático',
                            children: [
                              SwitchListTile(
                                title: const Text('Respaldo automático'),
                                subtitle: const Text('Crear backup cada día'),
                                value: _autoBackupEnabled,
                                onChanged: (value) async {
                                  setState(() => _autoBackupEnabled = value);
                                  await _saveSetting('auto_backup_enabled', value.toString());
                                  await AutoBackupScheduler.syncFromDatabase();
                                  await _loadSettings();
                                },
                              ),
                              ListTile(
                                title: const Text('Hora del respaldo'),
                                subtitle: Text(
                                  '${_backupHour.toString().padLeft(2, '0')}:${_backupMinute.toString().padLeft(2, '0')}',
                                ),
                                trailing: const Icon(Icons.schedule),
                                onTap: () async {
                                  final time = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay(hour: _backupHour, minute: _backupMinute),
                                  );
                                  if (time != null) {
                                    setState(() {
                                      _backupHour = time.hour;
                                      _backupMinute = time.minute;
                                    });
                                    await _saveSetting('auto_backup_hour', time.hour.toString());
                                    await _saveSetting('auto_backup_minute', time.minute.toString());
                                    await AutoBackupScheduler.syncFromDatabase();
                                    await _loadSettings();
                                  }
                                },
                              ),
                              ListTile(
                                title: const Text('Carpeta de respaldo'),
                                subtitle: Text(_backupFolder),
                                trailing: const Icon(Icons.folder_outlined),
                                onTap: () async {
                                  final controller = TextEditingController(text: _backupFolder);
                                  final result = await showDialog<String>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Carpeta de respaldo'),
                                      content: TextField(
                                        controller: controller,
                                        decoration: const InputDecoration(
                                          labelText: 'Nombre de carpeta',
                                          hintText: 'Ej: PediaTrack',
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text('Cancelar'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () => Navigator.pop(context, controller.text),
                                          child: const Text('Guardar'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (result != null && result.isNotEmpty) {
                                    setState(() => _backupFolder = result);
                                    await _saveSetting('backup_folder', result);
                                    await _loadSettings();
                                  }
                                },
                              ),
                              if (_nextRunAt != null && _autoBackupEnabled)
                                ListTile(
                                  title: const Text('Próximo respaldo'),
                                  subtitle: Text(
                                    DateFormat('dd MMM yyyy HH:mm', 'es').format(
                                      DateTime.tryParse(_nextRunAt!) ?? DateTime.now(),
                                    ),
                                  ),
                                  trailing: const Icon(Icons.edit_calendar),
                                  onTap: () => _editNextRun(),
                                ),
                              ListTile(
                                title: const Text('Ejecutar ahora'),
                                subtitle: const Text('Generar backup manualmente'),
                                trailing: const Icon(Icons.play_arrow),
                                onTap: () => _runBackupNow(),
                              ),
                              if (_autoBackupEnabled)
                                ListTile(
                                  title: const Text('Forzar respaldo automático'),
                                  subtitle: const Text('Prueba del sistema de respaldo'),
                                  trailing: const Icon(Icons.flash_on),
                                  onTap: () => _runBackupNow(forceAuto: true),
                                ),
                              if (_lastBackupAt != null)
                                ListTile(
                                  title: Text('Último respaldo${_lastBackupTrigger != null ? ' (${_lastBackupTrigger == 'auto' ? 'Automático' : 'Manual'})' : ''}'),
                                  subtitle: Text(
                                    '${DateFormat('dd MMM yyyy HH:mm', 'es').format(DateTime.tryParse(_lastBackupAt!) ?? DateTime.now())}\n${_lastBackupStatus ?? ""}',
                                  ),
                                  isThreeLine: true,
                                ),
                              if (_lastAutoRunAt != null)
                                ListTile(
                                  title: const Text('Último automático'),
                                  subtitle: Text(
                                    '${DateFormat('dd MMM yyyy HH:mm', 'es').format(DateTime.tryParse(_lastAutoRunAt!) ?? DateTime.now())}\n${_lastAutoStatus ?? ""}',
                                  ),
                                  isThreeLine: true,
                                ),
                              if (_lastManualRunAt != null)
                                ListTile(
                                  title: const Text('Último manual'),
                                  subtitle: Text(
                                    '${DateFormat('dd MMM yyyy HH:mm', 'es').format(DateTime.tryParse(_lastManualRunAt!) ?? DateTime.now())}\n${_lastManualStatus ?? ""}',
                                  ),
                                  isThreeLine: true,
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildSection(
                            title: 'Exportar / Importar',
                            children: [
                              ListTile(
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(Icons.cloud_upload, color: Theme.of(context).colorScheme.primary, size: 20),
                                ),
                                title: const Text('Exportar datos'),
                                subtitle: const Text('Compartir o descargar respaldo JSON y Excel'),
                                onTap: () => _showExportOptions(context),
                              ),
                              const Divider(height: 1),
                              ListTile(
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.download, color: Colors.green, size: 20),
                                ),
                                title: const Text('Importar respaldo'),
                                subtitle: const Text('Cargar un archivo JSON de respaldo'),
                                onTap: _importBackup,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildSection(
                            title: 'Acerca de',
                            children: [
                              const ListTile(
                                title: Text('Versión'),
                                subtitle: Text('1.0.0'),
                              ),
                              const ListTile(
                                title: Text('Desarrollado con'),
                                subtitle: Text('Flutter + Riverpod'),
                              ),
                              const SizedBox(height: 10),
                              const _TorogozBrandCard(),
                            ],
                          ),
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _TorogozBrandCard extends StatelessWidget {
  const _TorogozBrandCard();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final textColor = isDark ? Colors.white70 : const Color(0xFF263238);
    final borderColor = isDark ? const Color(0xFF334155) : Theme.of(context).colorScheme.outline.withValues(alpha: 0.35);
    final logoBgColor = isDark ? Colors.white : Theme.of(context).colorScheme.primary.withValues(alpha: 0.1);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: logoBgColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark ? const Color(0xFFE2E8F0) : Colors.transparent,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: SvgPicture.asset(
                'assets/icon/logo-torogoz.svg',
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '© 2026 TOROGOZ TECH S.A.S. DE C.V.',
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
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
        padding: EdgeInsets.fromLTRB(16, 16, 16, 120 + MediaQuery.of(context).viewPadding.bottom),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => QuickRecordSheet(
              childId: selectedChildId,
              initialTab: 1,
              habitOnly: false,
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Registrar'),
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

        final bowelHabits = habits.where((h) => h.type == 0 || h.type == 1 || h.type == 2).toList();
        final daysSinceFirst = habits.last.recordedAt.difference(habits.first.recordedAt).inDays + 1;
        final totalDays = bowelHabits.where((h) => h.type != 2).length;
        final constipationDays = bowelHabits.where((h) => h.type == 1).length;
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
              _buildFrequencyIndicator(context, bowelHabits, daysSinceFirst),
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
    final bowelHabits = habits.where((h) => h.type == 0 || h.type == 1 || h.type == 2).toList();
    final recentWeek = bowelHabits.take(7).where((h) => h.type != 2).length;
    final previousWeek = bowelHabits.skip(7).take(7).where((h) => h.type != 2).length;
    if (previousWeek == 0) return 'Sin datos previos';
    if (recentWeek > previousWeek) return 'Mejorando âœ“';
    if (recentWeek < previousWeek) return 'Empeorando âœ—';
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
                confirmDismiss: (_) => _confirmDeleteHabit(context),
                onDismissed: (_) => _deleteHabit(ref, h.id),
                child: ListTile(
                  dense: true,
                  leading: Icon(_habitIcon(h.type), color: _habitColor(h.type), size: 20),
                  title: Text(_habitLabel(h.type)),
                  subtitle: h.notes != null && h.notes!.trim().isNotEmpty ? Text(h.notes!) : null,
                  trailing: Text(DateFormat('HH:mm').format(h.recordedAt), style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color)),
                  onTap: () => _editHabit(context, ref, h),
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

  IconData _habitIcon(int type) => switch (type) {
        0 => Icons.check_circle,
        1 => Icons.warning,
        2 => Icons.water_drop,
        10 => Icons.restaurant,
        11 => Icons.nightlight_round,
        12 => Icons.local_drink,
        13 => Icons.medication,
        _ => Icons.event_note,
      };
  Color _habitColor(int type) => switch (type) {
        0 => Colors.green,
        1 => Colors.orange,
        2 => Colors.red,
        10 => Colors.teal,
        11 => Colors.indigo,
        12 => Colors.cyan,
        13 => Colors.deepPurple,
        _ => Colors.blueGrey,
      };
  String _habitLabel(int type) => switch (type) {
        0 => 'Evacuación normal',
        1 => 'Estreñimiento',
        2 => 'Diarrea',
        10 => 'Alimentación',
        11 => 'Sueño',
        12 => 'Hidratación',
        13 => 'Medicación',
        _ => 'Otro hábito',
      };

  Future<void> _deleteHabit(WidgetRef ref, int id) async {
    final db = ref.read(databaseProvider);
    await db.deleteHabitRecord(id);
    ref.invalidate(_habitHistoryProvider(childId));
    ref.invalidate(todayHabitsProvider(childId));
    ref.invalidate(growthRecordsStreamProvider(childId));
  }

  Future<bool> _confirmDeleteHabit(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar hábito'),
        content: const Text('¿Seguro que deseas eliminar este registro de hábito?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _editHabit(BuildContext context, WidgetRef ref, HabitRecord habit) async {
    int selectedType = habit.type;
    DateTime selectedDate = habit.recordedAt;
    final notesController = TextEditingController(text: habit.notes ?? '');

    await showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Editar hábito'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<int>(
                  value: selectedType,
                  decoration: const InputDecoration(labelText: 'Tipo de hábito'),
                  items: const [
                    DropdownMenuItem(value: 0, child: Text('Evacuación normal')),
                    DropdownMenuItem(value: 1, child: Text('Estreñimiento')),
                    DropdownMenuItem(value: 2, child: Text('Diarrea')),
                    DropdownMenuItem(value: 10, child: Text('Alimentación')),
                    DropdownMenuItem(value: 11, child: Text('Sueño')),
                    DropdownMenuItem(value: 12, child: Text('Hidratación')),
                    DropdownMenuItem(value: 13, child: Text('Medicación')),
                  ],
                  onChanged: (v) => setState(() => selectedType = v ?? selectedType),
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Fecha y hora'),
                  subtitle: Text(DateFormat('dd MMM yyyy HH:mm', 'es').format(selectedDate)),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (date == null) return;
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(selectedDate),
                    );
                    if (time == null) return;
                    setState(() {
                      selectedDate = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                    });
                  },
                ),
                TextField(
                  controller: notesController,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'Observaciones (opcional)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () async {
                final db = ref.read(databaseProvider);
                await db.deleteHabitRecord(habit.id);
                await db.insertHabitRecord(HabitRecordsCompanion.insert(
                  childId: habit.childId,
                  type: selectedType,
                  recordedAt: selectedDate,
                  notes: notesController.text.trim().isEmpty
                      ? const drift.Value.absent()
                      : drift.Value(notesController.text.trim()),
                ));
                if (dialogContext.mounted) Navigator.pop(dialogContext);
                ref.invalidate(_habitHistoryProvider(childId));
                ref.invalidate(todayHabitsProvider(childId));
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
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

class _GrowthMetricChip extends StatelessWidget {
  const _GrowthMetricChip({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelSmall),
          Text(
            value,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color,
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
    final alertsAsync = ref.watch(alertsProvider);
    final selectedChildId = ref.watch(selectedChildIdProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Alertas')),
      body: alertsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (alerts) {
          if (alerts.isEmpty) {
            return Center(
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
            );
          }

          final visibleAlerts = selectedChildId == null
              ? alerts
              : alerts.where((a) => a.childId == selectedChildId).toList();

          if (visibleAlerts.isEmpty) {
            return const Center(
              child: Text('No hay alertas para el niño seleccionado'),
            );
          }

          final grouped = <String, List<AppAlert>>{};
          for (final alert in visibleAlerts) {
            grouped.putIfAbsent(alert.childName, () => []).add(alert);
          }
          final childNames = grouped.keys.toList()..sort();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: childNames.length,
            itemBuilder: (context, childIndex) {
              final childName = childNames[childIndex];
              final childAlerts = grouped[childName]!;
              const headerBg = Color(0xFFE3F2FD);
              const headerText = Color(0xFF0D47A1);

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: headerBg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: headerText.withValues(alpha: 0.28),
                              ),
                            ),
                            child: Text(
                              childName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: headerText,
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: headerBg,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: headerText.withValues(alpha: 0.28)),
                          ),
                          child: Text(
                            '${childAlerts.length}',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: headerText,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...childAlerts.map((alert) {
                      final (icon, color) = switch (alert.type) {
                        AppAlertType.vaccineOverdue => (Icons.warning_amber_rounded, Colors.red),
                        AppAlertType.vaccineUpcoming => (Icons.schedule, Colors.orange),
                        AppAlertType.growthOutOfRange => (Icons.monitor_heart_outlined, Colors.deepPurple),
                      };

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: color.withValues(alpha: 0.15),
                              child: Icon(icon, color: color),
                            ),
                            title: Text(alert.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(alert.message),
                            isThreeLine: false,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class AddChildSheet extends ConsumerStatefulWidget {
  const AddChildSheet({super.key, this.child});

  final ChildrenData? child;

  @override
  ConsumerState<AddChildSheet> createState() => _AddChildSheetState();
}

class _AddChildSheetState extends ConsumerState<AddChildSheet> {
  final _nameController = TextEditingController();
  final _birthWeightController = TextEditingController();
  final _birthHeightController = TextEditingController();
  final _notesController = TextEditingController();
  late DateTime _birthDate;
  late int _gender;
  bool _isLoading = false;

  bool get _isEditing => widget.child != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _nameController.text = widget.child!.name;
      _birthDate = widget.child!.birthDate;
      _gender = widget.child!.gender;
      if (widget.child!.birthWeight != null) {
        _birthWeightController.text = (widget.child!.birthWeight! * 2.20462).toStringAsFixed(2);
      }
      if (widget.child!.birthHeight != null) {
        _birthHeightController.text = widget.child!.birthHeight!.toStringAsFixed(1);
      }
      _notesController.text = widget.child!.notes ?? '';
    } else {
      _birthDate = DateTime.now().subtract(const Duration(days: 365));
      _gender = 0;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthWeightController.dispose();
    _birthHeightController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboard = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(
        bottom: keyboard,
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(24, 24, 24, _sheetBottomSpace(context)),
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
              Text(
                _isEditing ? 'Editar niño' : 'Agregar niño',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
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
                  ButtonSegment(value: 0, icon: Icon(Icons.boy), label: Text('Niño')),
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
              const SizedBox(height: 12),
              TextField(
                controller: _notesController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Observaciones (opcional)',
                  prefixIcon: Icon(Icons.notes_outlined),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _isLoading ? null : _saveChild,
                child: _isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Guardar'),
              ),
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
      final birthWeightKg = birthWeightLb != null ? birthWeightLb / 2.20462 : null;
      final notes = _notesController.text.trim();

      if (_isEditing) {
        final updatedChild = widget.child!.copyWith(
          name: _nameController.text.trim(),
          birthDate: _birthDate,
          gender: _gender,
          birthWeight: birthWeightKg != null ? drift.Value(birthWeightKg) : const drift.Value.absent(),
          birthHeight: birthHeightCm != null ? drift.Value(birthHeightCm) : const drift.Value.absent(),
          notes: notes.isEmpty ? const drift.Value.absent() : drift.Value(notes),
        );
        await db.updateChild(updatedChild);
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${_nameController.text.trim()} actualizado exitosamente')),
          );
        }
      } else {
        final childId = await db.insertChild(ChildrenCompanion.insert(
          name: _nameController.text.trim(),
          birthDate: _birthDate,
          gender: _gender,
          birthWeight: birthWeightKg != null ? drift.Value(birthWeightKg) : const drift.Value.absent(),
          birthHeight: birthHeightCm != null ? drift.Value(birthHeightCm) : const drift.Value.absent(),
          notes: notes.isEmpty ? const drift.Value.absent() : drift.Value(notes),
        ));

        if (birthWeightKg != null || birthHeightCm != null) {
          await db.insertGrowthRecord(GrowthRecordsCompanion.insert(
            childId: childId,
            date: _birthDate,
            weight: birthWeightKg != null ? drift.Value(birthWeightKg) : const drift.Value.absent(),
            height: birthHeightCm != null ? drift.Value(birthHeightCm) : const drift.Value.absent(),
          ));
        }

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${_nameController.text.trim()} agregado exitosamente')),
          );
        }
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
  const QuickRecordSheet({
    super.key,
    required this.childId,
    this.initialTab = 0,
    this.enableHabitTab = true,
    this.habitOnly = false,
  });

  final int childId;
  final int initialTab;
  final bool enableHabitTab;
  final bool habitOnly;

  @override
  ConsumerState<QuickRecordSheet> createState() => _QuickRecordSheetState();
}

class _QuickRecordSheetState extends ConsumerState<QuickRecordSheet> {
  late int _currentTab;
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _headController = TextEditingController();
  final _consultNotesController = TextEditingController();
  final _habitNotesController = TextEditingController();
  int _selectedHabitType = 10;
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
    _headController.dispose();
    _consultNotesController.dispose();
    _habitNotesController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate),
      );
      if (time != null) {
        setState(() {
          _selectedDate = DateTime(date.year, date.month, date.day, time.hour, time.minute);
        });
      } else {
        setState(() {
          _selectedDate = DateTime(date.year, date.month, date.day, _selectedDate.hour, _selectedDate.minute);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboard = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: keyboard),
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 12, 16, _sheetBottomSpace(context)),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
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
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: widget.habitOnly
                    ? const SizedBox.shrink()
                    : SegmentedButton<int>(
                        showSelectedIcon: false,
                        segments: [
                          const ButtonSegment(value: 0, icon: Icon(Icons.straighten), label: Text('Consulta', overflow: TextOverflow.ellipsis)),
                          if (widget.enableHabitTab)
                            const ButtonSegment(value: 1, icon: Icon(Icons.bathroom), label: Text('Hábito', overflow: TextOverflow.ellipsis)),
                        ],
                        selected: {_currentTab},
                        onSelectionChanged: (set) => setState(() => _currentTab = set.first),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: widget.habitOnly || (_currentTab == 1 && widget.enableHabitTab) ? _buildHabitForm() : _buildConsultForm(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8, bottom: keyboard > 0 ? 6 : 0),
                child: widget.habitOnly || (_currentTab == 1 && widget.enableHabitTab)
                    ? FilledButton.icon(
                        onPressed: () => _saveHabit(_selectedHabitType),
                        icon: const Icon(Icons.save),
                        label: const Text('Guardar hábito'),
                      )
                    : FilledButton.icon(
                        onPressed: _saveGrowthRecord,
                        icon: const Icon(Icons.save),
                        label: const Text('Guardar'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConsultForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        Text('Registro de Consulta', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _buildDateSelector(),
        const SizedBox(height: 24),
        Text('Peso, Estatura y Perímetro Craneal', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.outline)),
        const SizedBox(height: 16),
        TextField(
          controller: _weightController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Peso (lb)',
            prefixIcon: Icon(Icons.monitor_weight),
            suffixText: 'lb',
          ),
        ),
        const SizedBox(height: 12),
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
        Text('Ingresa al menos un valor. Los demás son opcionales.', style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 12),
        TextField(
          controller: _consultNotesController,
          maxLines: 2,
          decoration: const InputDecoration(
            labelText: 'Observaciones (opcional)',
            prefixIcon: Icon(Icons.notes_outlined),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Future<void> _saveGrowthRecord() async {
    final weightValue = double.tryParse(_weightController.text);
    final heightValue = double.tryParse(_heightController.text);
    final headValue = double.tryParse(_headController.text);

    if (weightValue == null && heightValue == null && headValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa al menos un valor')),
      );
      return;
    }

    final db = ref.read(databaseProvider);
    int savedCount = 0;

    if (weightValue != null && weightValue > 0) {
      final weightKg = weightValue / 2.20462;
      await db.insertGrowthRecord(GrowthRecordsCompanion.insert(
        childId: widget.childId,
        weight: drift.Value(weightKg),
        date: _selectedDate,
        notes: _consultNotesController.text.trim().isEmpty
            ? const drift.Value.absent()
            : drift.Value(_consultNotesController.text.trim()),
      ));
      savedCount++;
    }

    if (heightValue != null && heightValue > 0) {
      await db.insertGrowthRecord(GrowthRecordsCompanion.insert(
        childId: widget.childId,
        height: drift.Value(heightValue),
        date: _selectedDate,
        notes: _consultNotesController.text.trim().isEmpty
            ? const drift.Value.absent()
            : drift.Value(_consultNotesController.text.trim()),
      ));
      savedCount++;
    }

    if (headValue != null && headValue > 0) {
      await db.insertGrowthRecord(GrowthRecordsCompanion.insert(
        childId: widget.childId,
        headCircumference: drift.Value(headValue),
        date: _selectedDate,
        notes: _consultNotesController.text.trim().isEmpty
            ? const drift.Value.absent()
            : drift.Value(_consultNotesController.text.trim()),
      ));
      savedCount++;
    }

    ref.invalidate(growthRecordsStreamProvider(widget.childId));

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${savedCount > 1 ? "$savedCount registros" : "1 registro"} guardado(s) exitosamente')),
      );
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
        Text('Tipo de hábito', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.outline)),
        const SizedBox(height: 16),
        DropdownButtonFormField<int>(
          value: _selectedHabitType,
          decoration: const InputDecoration(
            labelText: 'Selecciona hábito',
            prefixIcon: Icon(Icons.checklist),
          ),
          items: const [
            DropdownMenuItem(value: 0, child: Text('Evacuación normal')),
            DropdownMenuItem(value: 1, child: Text('Estreñimiento')),
            DropdownMenuItem(value: 2, child: Text('Diarrea')),
            DropdownMenuItem(value: 10, child: Text('Alimentación')),
            DropdownMenuItem(value: 11, child: Text('Sueño')),
            DropdownMenuItem(value: 12, child: Text('Hidratación')),
            DropdownMenuItem(value: 13, child: Text('Medicación')),
          ],
          onChanged: (value) {
            if (value != null) setState(() => _selectedHabitType = value);
          },
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _habitNotesController,
          maxLines: 2,
          decoration: const InputDecoration(
            labelText: 'Observaciones (opcional)',
            prefixIcon: Icon(Icons.notes),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDateSelector() {
    return InkWell(
      onTap: _selectDateTime,
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
              DateFormat('dd MMM yyyy HH:mm', 'es').format(_selectedDate),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Spacer(),
            Icon(Icons.arrow_drop_down, color: Theme.of(context).colorScheme.outline),
          ],
        ),
      ),
    );
  }

  Future<void> _saveHabit(int type) async {
    final db = ref.read(databaseProvider);
    await db.insertHabitRecord(HabitRecordsCompanion.insert(
      childId: widget.childId,
      type: type,
      recordedAt: _selectedDate,
      notes: _habitNotesController.text.trim().isEmpty
          ? const drift.Value.absent()
          : drift.Value(_habitNotesController.text.trim()),
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
    final notesController = TextEditingController();

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
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              Text(
                _formatVaccineAge(item.definition.recommendedAgeMonths),
                style: Theme.of(context).textTheme.bodySmall,
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
              const SizedBox(height: 8),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'Observaciones (opcional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
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
                  notes: notesController.text.isEmpty ? const drift.Value(null) : drift.Value(notesController.text),
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
    final notesController = TextEditingController(text: item.appliedVaccine!.notes ?? '');

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
                  style: Theme.of(context).textTheme.bodyMedium,
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
              const SizedBox(height: 8),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'Observaciones (opcional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
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
                  notes: notesController.text.isEmpty ? const drift.Value(null) : drift.Value(notesController.text),
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
  final _notesController = TextEditingController();

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
            const SizedBox(height: 12),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Observaciones (opcional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _selectedDefinitionId == null ? null : () async {
                final db = ref.read(databaseProvider);
                await db.insertChildVaccine(ChildVaccinesCompanion.insert(
                  childId: widget.childId,
                  vaccineDefinitionId: _selectedDefinitionId!,
                  appliedDate: _selectedDate,
                  batch: _batchController.text.isEmpty ? const drift.Value(null) : drift.Value(_batchController.text),
                  notes: _notesController.text.isEmpty ? const drift.Value(null) : drift.Value(_notesController.text),
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




