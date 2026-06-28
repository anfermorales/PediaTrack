// =============================================================================
// ARCHIVO NO UTILIZADO EN LA APP ACTIVA.
// -----------------------------------------------------------------------------
// La version que se renderiza en `MainNavigation` esta definida inline en
// `lib/app.dart` (clase `HomeScreen` dentro del archivo `app.dart`). Este
// archivo fue un intento previo de modularizar pantallas que no llego a
// activarse.
//
// Mantener este archivo aqui (en lugar de eliminarlo) conserva:
//   * Las mejoras aplicadas (centralizacion de `VaccineStatusCalculator`,
//     tipos corregidos, l10n, etc.) como punto de referencia para cuando se
//     haga la migracion final.
//   * Cobertura parcial del codigo de features.
//
// TODO: Mover la clase `HomeScreen` desde `app.dart` a este archivo y
// actualizar `MainNavigation` para que importe desde `features/home/screens/`.
// =============================================================================

import 'dart:math' as math;

import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pediatrack/core/providers/database_providers.dart';
import 'package:pediatrack/core/utils/age_calculator.dart';
import 'package:pediatrack/data/database/app_database.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/animations_widgets.dart';
import '../../../shared/widgets/common_widgets.dart';

/// Pantalla principal de inicio
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fabController;
  late Animation<double> _fabAnimation;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _fabAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _fabController, curve: Curves.easeOutBack));
    _fabController.forward();
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  void _showSettingsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SettingsSheet(),
    );
  }

  void _showAddChildDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddChildSheet(),
    );
  }

  void _showEditChildDialog(BuildContext context, ChildrenData child) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddChildSheet(child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final childrenAsync = ref.watch(childrenStreamProvider);
    final selectedChildId = ref.watch(selectedChildIdProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkSurface : null,
        foregroundColor: isDark ? AppColors.darkTextPrimary : null,
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
                color: AppColors.primaryLight.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.child_care, color: AppColors.primaryMid),
            ),
            const SizedBox(width: 12),
            Text('PediaTrack', style: TextStyle(color: isDark ? AppColors.darkTextPrimary : null)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.settings_outlined), onPressed: () => _showSettingsSheet(context)),
          IconButton(icon: const Icon(Icons.person_add_outlined), onPressed: () => _showAddChildDialog(context)),
        ],
      ),
      body: childrenAsync.when(
        data: (children) {
          if (children.isEmpty) {
            return _buildEmptyState(context);
          }
          return RefreshIndicator(
            onRefresh: () async {
              HapticFeedback.mediumImpact();
              ref.invalidate(childrenStreamProvider);
            },
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                SliverToBoxAdapter(
                  child: AnimatedBuilder(
                    animation: _fabAnimation,
                    builder: (context, child) => Transform.scale(
                      scale: _fabAnimation.value,
                      child: _ChildSelector(
                        children: children,
                        selectedChildId: selectedChildId,
                        onChildSelected: (id) => ref.read(selectedChildIdProvider.notifier).state = id,
                        onChildEdit: (child) => _showEditChildDialog(context, child),
                      ),
                    ),
                  ),
                ),
                if (selectedChildId != null) ..._buildSelectedChildContent(context, ref, selectedChildId),
                if (selectedChildId == null)
                  SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'Selecciona un niño para ver su información',
                        style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.grey100),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
        loading: () => _buildLoadingState(),
        error: (e, _) => Center(child: Text('Error: $e', style: TextStyle(color: isDark ? AppColors.darkTextSecondary : null))),
      ),
      floatingActionButton: selectedChildId != null
          ? ScaleTransition(
              scale: _fabAnimation,
              child: FloatingActionButton.extended(
                onPressed: () => _showQuickRecordSheet(context, ref, selectedChildId),
                icon: const Icon(Icons.straighten),
                label: const Text('Medir'),
                backgroundColor: AppColors.primaryMid,
              ),
            )
          : null,
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const ShimmerLoading(height: 80, borderRadius: 16),
          const SizedBox(height: 16),
          const ShimmerLoading(height: 200, borderRadius: 20),
          const SizedBox(height: 16),
          Row(
            children: const [
              Expanded(child: ShimmerLoading(height: 150, borderRadius: 16)),
              SizedBox(width: 16),
              Expanded(child: ShimmerLoading(height: 150, borderRadius: 16)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.child_care, size: 64, color: AppColors.primaryMid),
            ),
            const SizedBox(height: 24),
            Text(
              '¡Bienvenido a PediaTrack!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : null),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Agrega a tu primer niño para comenzar a hacer seguimiento de su crecimiento, vacunas y hábitos.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: isDark ? AppColors.darkTextSecondary : AppColors.grey100),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => _showAddChildDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Agregar Primer Niño'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSelectedChildContent(BuildContext context, WidgetRef ref, int childId) {
    return [
      SliverToBoxAdapter(child: AnimatedListItem(index: 0, child: _QuickStatsSection(childId: childId))),
      SliverToBoxAdapter(child: AnimatedListItem(index: 1, child: _BirthDataCard(childId: childId))),
      SliverToBoxAdapter(child: AnimatedListItem(index: 2, child: _RecentGrowthCard(childId: childId))),
      SliverToBoxAdapter(child: AnimatedListItem(index: 3, child: _TodayHabitsCard(childId: childId))),
      SliverToBoxAdapter(child: AnimatedListItem(index: 4, child: _VaccineSummaryCard(childId: childId))),
      const SliverToBoxAdapter(child: SizedBox(height: 100)),
    ];
  }

  void _showQuickRecordSheet(BuildContext context, WidgetRef ref, int childId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => QuickRecordSheet(childId: childId),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// CHILD SELECTOR - Selector horizontal de niños
// ═══════════════════════════════════════════════════════════════

class _ChildSelector extends StatelessWidget {
  final List<ChildrenData> children;
  final int? selectedChildId;
  final Function(int) onChildSelected;
  final Function(ChildrenData) onChildEdit;

  const _ChildSelector({required this.children, this.selectedChildId, required this.onChildSelected, required this.onChildEdit});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: children.length,
        itemBuilder: (context, index) {
          final child = children[index];
          final isSelected = child.id == selectedChildId;
          return AnimatedListItem(
            index: index,
            child: GestureDetector(
              onLongPress: () => onChildEdit(child),
              onTap: () {
                HapticFeedback.selectionClick();
                onChildSelected(child.id);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryLight.withValues(alpha: isDark ? 0.2 : 0.15)
                      : (isDark ? AppColors.darkCard : Colors.white),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? AppColors.primaryMid : (isDark ? AppColors.darkBorder : AppColors.grey30),
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected ? [
                    BoxShadow(color: AppColors.primaryMid.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 2)),
                  ] : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ColorfulAvatar(name: child.name, size: 40),
                    const SizedBox(height: 8),
                    Text(
                      child.name.split(' ').first,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        fontSize: 13,
                        color: isDark ? AppColors.darkTextPrimary : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// QUICK STATS - Estadísticas rápidas del niño seleccionado
// ═══════════════════════════════════════════════════════════════

class _QuickStatsSection extends ConsumerWidget {
  final int childId;
  const _QuickStatsSection({required this.childId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final childAsync = ref.watch(childProvider(childId));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return childAsync.when(
      data: (child) {
        final age = _calculateAge(child.birthDate);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryMid, AppColors.primaryDeep],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: AppColors.primaryMid.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
            ),
            child: Row(
              children: [
                ColorfulAvatar(name: child.name, size: 56),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(child.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text(age, style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 14)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      Icon(child.gender == 0 ? Icons.male : Icons.female, color: Colors.white, size: 18),
                      const SizedBox(width: 4),
                      Text(child.gender == 0 ? 'Niño' : 'Niña', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const ShimmerLoading(height: 100, borderRadius: 20),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  String _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    final months = AgeCalculator.completedMonths(birthDate, reference: now);
    if (months < 1) return '${now.difference(birthDate).inDays} días';
    if (months < 12) return '$months meses';
    final years = months ~/ 12;
    final remainingMonths = months % 12;
    return remainingMonths > 0 ? '$years años, $remainingMonths meses' : '$years años';
  }
}

// ═══════════════════════════════════════════════════════════════
// BIRTH DATA CARD - Tarjeta de datos de nacimiento
// ═══════════════════════════════════════════════════════════════

class _BirthDataCard extends ConsumerStatefulWidget {
  final int childId;
  const _BirthDataCard({required this.childId});

  @override
  ConsumerState<_BirthDataCard> createState() => _BirthDataCardState();
}

class _BirthDataCardState extends ConsumerState<_BirthDataCard> {
  void _showEditDialog(BuildContext context, ChildrenData child) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddChildSheet(child: child),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final childAsync = ref.watch(childProvider(widget.childId));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return childAsync.when(
      data: (child) {
        final hasData = child.birthWeight != null || child.birthHeight != null;
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
          child: GestureDetector(
            onTap: () => _showEditDialog(context, child),
            child: Container(
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
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.cake, color: AppColors.warning, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Datos de Nacimiento', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : null)),
                            Text(DateFormat('dd MMM yyyy').format(child.birthDate), style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.grey100)),
                          ],
                        ),
                      ),
                      Icon(Icons.edit, color: isDark ? AppColors.darkTextTertiary : AppColors.grey100, size: 20),
                    ],
                  ),
                  if (hasData) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _StatBox(label: 'Peso', value: '${child.birthWeight} kg', icon: Icons.monitor_weight_outlined, color: AppColors.primaryMid)),
                        const SizedBox(width: 12),
                        Expanded(child: _StatBox(label: 'Altura', value: '${child.birthHeight} cm', icon: Icons.height, color: AppColors.secondaryMid)),
                      ],
                    ),
                  ] else
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline, color: AppColors.warning, size: 20),
                            const SizedBox(width: 8),
                            Text('Toca para agregar datos', style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.grey200)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Padding(padding: EdgeInsets.fromLTRB(16, 24, 16, 0), child: ShimmerLoading(height: 150, borderRadius: 20)),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatBox({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardElevated : AppColors.grey10,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.grey30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Icon(icon, size: 16, color: color), const SizedBox(width: 6), Text(label, style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.grey100))]),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: isDark ? Colors.white : AppColors.grey500)),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// GROWTH CARD - Tarjeta de crecimiento reciente
// ═══════════════════════════════════════════════════════════════

class _RecentGrowthCard extends ConsumerWidget {
  final int childId;
  const _RecentGrowthCard({required this.childId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final growthAsync = ref.watch(growthRecordsStreamProvider(childId));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
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
                Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.secondaryMid.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.trending_up, color: AppColors.secondaryMid, size: 24)),
                const SizedBox(width: 12),
                Text('Crecimiento Reciente', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : null)),
              ],
            ),
            const SizedBox(height: 16),
            growthAsync.when(
              data: (records) {
                if (records.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(color: isDark ? AppColors.darkCardElevated : AppColors.grey10, borderRadius: BorderRadius.circular(14)),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: isDark ? AppColors.darkTextTertiary : AppColors.grey100),
                        const SizedBox(width: 12),
                        Expanded(child: Text('Sin registros de crecimiento', style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.grey100))),
                      ],
                    ),
                  );
                }
                final latest = records.first;
                return Row(
                  children: [
                    Expanded(child: _GrowthValue(label: 'Peso', value: '${latest.weight} kg', icon: Icons.monitor_weight_outlined, color: AppColors.primaryMid)),
                    const SizedBox(width: 12),
                    Expanded(child: _GrowthValue(label: 'Altura', value: '${latest.height} cm', icon: Icons.height, color: AppColors.secondaryMid)),
                  ],
                );
              },
              loading: () => const ShimmerLoading(height: 80, borderRadius: 14),
              error: (_, __) => Text('Error al cargar', style: TextStyle(color: isDark ? AppColors.darkTextSecondary : null)),
            ),
          ],
        ),
      ),
    );
  }
}

class _GrowthValue extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _GrowthValue({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardElevated : AppColors.grey10,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.grey30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Icon(icon, size: 16, color: color), const SizedBox(width: 6), Text(label, style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.grey100))]),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: isDark ? Colors.white : AppColors.grey500)),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// HABITS CARD - Tarjeta de hábitos del día
// ═══════════════════════════════════════════════════════════════

class _TodayHabitsCard extends ConsumerWidget {
  final int childId;
  const _TodayHabitsCard({required this.childId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(todayHabitsProvider(childId));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
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
                Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.purpleMid.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.schedule, color: AppColors.purpleMid, size: 24)),
                const SizedBox(width: 12),
                Text('Hábitos de Hoy', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : null)),
              ],
            ),
            const SizedBox(height: 16),
            habitsAsync.when(
              data: (habits) {
                final completed = habits.where((h) => h.recordedAt != null).length;
                final total = habits.length;
                final progress = total > 0 ? completed / total : 0.0;
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('$completed de $total completados', style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.grey100)),
                        Text('${(progress * 100).toInt()}%', style: TextStyle(fontWeight: FontWeight.w700, color: progress == 1.0 ? AppColors.success : AppColors.purpleMid)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: isDark ? AppColors.darkBorder : AppColors.grey20,
                        valueColor: AlwaysStoppedAnimation(progress == 1.0 ? AppColors.success : AppColors.purpleMid),
                      ),
                    ),
                  ],
                );
              },
              loading: () => const ShimmerLoading(height: 50, borderRadius: 14),
              error: (_, __) => Text('Error al cargar', style: TextStyle(color: isDark ? AppColors.darkTextSecondary : null)),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// VACCINES SUMMARY CARD - Resumen de vacunas
// ═══════════════════════════════════════════════════════════════

class _VaccineSummaryCard extends ConsumerWidget {
  final int childId;
  const _VaccineSummaryCard({required this.childId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vaccinesAsync = ref.watch(vaccineScheduleProvider(childId));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
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
                Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.vaccines, color: AppColors.warning, size: 24)),
                const SizedBox(width: 12),
                Text('Vacunas', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : null)),
              ],
            ),
            const SizedBox(height: 16),
            vaccinesAsync.when(
              data: (vaccines) {
                final completed = vaccines.where((v) => v.mostRecentApplied != null).length;
                final total = vaccines.length;
                return Row(
                  children: [
                    Expanded(child: _VaccineStatBox(label: 'Completadas', value: '$completed', color: AppColors.success, isDark: isDark)),
                    const SizedBox(width: 12),
                    Expanded(child: _VaccineStatBox(label: 'Pendientes', value: '${total - completed}', color: total - completed > 0 ? AppColors.warning : AppColors.success, isDark: isDark)),
                  ],
                );
              },
              loading: () => const ShimmerLoading(height: 80, borderRadius: 14),
              error: (_, __) => Text('Error al cargar', style: TextStyle(color: isDark ? AppColors.darkTextSecondary : null)),
            ),
          ],
        ),
      ),
    );
  }
}

class _VaccineStatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool isDark;
  const _VaccineStatBox({required this.label, required this.value, required this.color, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardElevated : AppColors.grey10,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.grey30),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: color)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.grey100)),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SETTINGS SHEET - Configuración
// ═══════════════════════════════════════════════════════════════

class SettingsSheet extends StatelessWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
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
                  Text('Configuración', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : null)),
                ],
              ),
            ),
          ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(24),
              children: [
                _SettingsItem(icon: Icons.backup_outlined, title: 'Respaldar datos', subtitle: 'Guardar en archivo JSON', isDark: isDark, onTap: () {}),
                _SettingsItem(icon: Icons.restore, title: 'Restaurar datos', subtitle: 'Cargar desde archivo', isDark: isDark, onTap: () {}),
                _SettingsItem(icon: Icons.table_chart_outlined, title: 'Exportar a Excel', subtitle: 'Generar reporte', isDark: isDark, onTap: () {}),
                _SettingsItem(icon: Icons.info_outline, title: 'Acerca de', subtitle: 'Versión 1.0.0', isDark: isDark, onTap: () {}),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDark;
  final VoidCallback onTap;
  const _SettingsItem({required this.icon, required this.title, required this.subtitle, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppColors.primaryLight.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: AppColors.primaryMid),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextPrimary : null)),
      subtitle: Text(subtitle, style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.grey100)),
      trailing: Icon(Icons.chevron_right, color: isDark ? AppColors.darkTextTertiary : AppColors.grey100),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ADD CHILD SHEET - Agregar/Editar niño
// ═══════════════════════════════════════════════════════════════

class AddChildSheet extends ConsumerStatefulWidget {
  final ChildrenData? child;
  const AddChildSheet({super.key, this.child});

  @override
  ConsumerState<AddChildSheet> createState() => _AddChildSheetState();
}

class _AddChildSheetState extends ConsumerState<AddChildSheet> {
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _birthDate = DateTime.now();
  int _gender = 0;
  bool get _isEditing => widget.child != null;

  @override
  void initState() {
    super.initState();
    if (widget.child != null) {
      _nameController.text = widget.child!.name;
      _birthDate = widget.child!.birthDate;
      _gender = widget.child!.gender;
      if (widget.child!.birthWeight != null) _weightController.text = widget.child!.birthWeight.toString();
      if (widget.child!.birthHeight != null) _heightController.text = widget.child!.birthHeight.toString();
      if (widget.child!.notes != null) _notesController.text = widget.child!.notes!;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(context: context, initialDate: _birthDate, firstDate: DateTime(2000), lastDate: DateTime.now());
    if (date != null) setState(() => _birthDate = date);
  }

  void _submitForm() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ingresa el nombre del niño')));
      return;
    }
    final db = ref.read(databaseProvider);
    if (_isEditing) {
      final updated = widget.child!.copyWith(
        name: _nameController.text.trim(),
        birthDate: _birthDate,
        gender: _gender,
        notes: Value(_notesController.text.trim().isEmpty ? null : _notesController.text.trim()),
      );
      await db.updateChild(updated);
      if (_weightController.text.isNotEmpty || _heightController.text.isNotEmpty) {
        await db.updateChildBirthData(widget.child!.id, double.tryParse(_weightController.text), double.tryParse(_heightController.text));
      }
      ref.invalidate(childrenStreamProvider);
      ref.invalidate(childProvider(widget.child!.id));
    } else {
      await db.insertChild(ChildrenCompanion.insert(
        name: _nameController.text.trim(),
        birthDate: _birthDate,
        gender: _gender,
        birthWeight: Value(_weightController.text.isNotEmpty ? double.tryParse(_weightController.text) : null),
        birthHeight: Value(_heightController.text.isNotEmpty ? double.tryParse(_heightController.text) : null),
        notes: Value(_notesController.text.trim().isEmpty ? null : _notesController.text.trim()),
      ));
      ref.invalidate(childrenStreamProvider);
    }
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_isEditing ? 'Niño actualizado' : 'Niño agregado')));
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
                  Text(_isEditing ? 'Editar Hijo' : 'Agregar Hijo', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : null)),
                ],
              ),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 24 + math.max(0, MediaQuery.of(context).viewInsets.bottom - MediaQuery.of(context).viewPadding.bottom)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _nameController,
                    style: TextStyle(color: isDark ? AppColors.darkTextPrimary : null),
                    decoration: InputDecoration(labelText: 'Nombre completo', prefixIcon: const Icon(Icons.person_outline), filled: true, fillColor: isDark ? AppColors.darkCardElevated : AppColors.grey10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none)),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: _selectDate,
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: isDark ? AppColors.darkCardElevated : AppColors.grey10, borderRadius: BorderRadius.circular(14), border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.grey30)),
                      child: Row(children: [
                        const Icon(Icons.calendar_today),
                        const SizedBox(width: 12),
                        Text(DateFormat('dd MMM yyyy').format(_birthDate), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextPrimary : null)),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Género', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextSecondary : AppColors.grey200)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: _GenderButton(gender: 0, label: 'Niño', icon: Icons.male, isSelected: _gender == 0, onTap: () => setState(() => _gender = 0), isDark: isDark)),
                      const SizedBox(width: 12),
                      Expanded(child: _GenderButton(gender: 1, label: 'Niña', icon: Icons.female, isSelected: _gender == 1, onTap: () => setState(() => _gender = 1), isDark: isDark)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: TextField(controller: _weightController, keyboardType: TextInputType.number, style: TextStyle(color: isDark ? AppColors.darkTextPrimary : null), decoration: InputDecoration(labelText: 'Peso (kg)', prefixIcon: const Icon(Icons.monitor_weight_outlined), filled: true, fillColor: isDark ? AppColors.darkCardElevated : AppColors.grey10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none)))),
                      const SizedBox(width: 12),
                      Expanded(child: TextField(controller: _heightController, keyboardType: TextInputType.number, style: TextStyle(color: isDark ? AppColors.darkTextPrimary : null), decoration: InputDecoration(labelText: 'Altura (cm)', prefixIcon: const Icon(Icons.height), filled: true, fillColor: isDark ? AppColors.darkCardElevated : AppColors.grey10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none)))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Observaciones (opcional)', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextSecondary : AppColors.grey200)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _notesController,
                    maxLines: 3,
                    style: TextStyle(color: isDark ? AppColors.darkTextPrimary : null),
                    decoration: InputDecoration(
                      hintText: 'Alergias, condiciones médicas, notas importantes...',
                      prefixIcon: const Icon(Icons.notes),
                      filled: true,
                      fillColor: isDark ? AppColors.darkCardElevated : AppColors.grey10,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, 0, 24, 24 + math.max(0, MediaQuery.of(context).viewPadding.bottom - MediaQuery.of(context).viewInsets.bottom)),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton.icon(
                  onPressed: _submitForm,
                  icon: Icon(_isEditing ? Icons.check : Icons.add, size: 22),
                  label: Text(_isEditing ? 'Actualizar Datos' : 'Guardar', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  style: FilledButton.styleFrom(
                    backgroundColor: _isEditing ? AppColors.success : (isDark ? AppColors.primaryLight : AppColors.primaryMid),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    shadowColor: _isEditing ? AppColors.success.withValues(alpha: 0.4) : null,
                    elevation: _isEditing ? 4 : 0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GenderButton extends StatelessWidget {
  final String gender;
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;
  const _GenderButton({required this.gender, required this.label, required this.icon, required this.isSelected, required this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? (isDark ? AppColors.primaryLight.withValues(alpha: 0.2) : AppColors.primaryLight.withValues(alpha: 0.15)) : (isDark ? AppColors.darkCardElevated : AppColors.grey10),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isSelected ? AppColors.primaryMid : (isDark ? AppColors.darkBorder : AppColors.grey30), width: isSelected ? 2 : 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? AppColors.primaryMid : (isDark ? AppColors.darkTextTertiary : AppColors.grey100)),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal, color: isSelected ? AppColors.primaryMid : (isDark ? AppColors.darkTextSecondary : AppColors.grey200))),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// QUICK RECORD SHEET - Registrar medición rápida
// ═══════════════════════════════════════════════════════════════

class QuickRecordSheet extends ConsumerStatefulWidget {
  final int childId;
  const QuickRecordSheet({super.key, required this.childId});

  @override
  ConsumerState<QuickRecordSheet> createState() => _QuickRecordSheetState();
}

class _QuickRecordSheetState extends ConsumerState<QuickRecordSheet> {
  DateTime _selectedDate = DateTime.now();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime(2020), lastDate: DateTime.now());
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
                  Text('Registrar Medición', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : null)),
                ],
              ),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 24 + math.max(0, MediaQuery.of(context).viewInsets.bottom - MediaQuery.of(context).viewPadding.bottom)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InkWell(
                    onTap: _selectDate,
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: isDark ? AppColors.darkCardElevated : AppColors.grey10, borderRadius: BorderRadius.circular(14), border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.grey30)),
                      child: Row(children: [
                        const Icon(Icons.calendar_today),
                        const SizedBox(width: 12),
                        Text(DateFormat('dd MMM yyyy').format(_selectedDate), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextPrimary : null)),
                        const Spacer(),
                        Icon(Icons.edit, color: isDark ? AppColors.darkTextTertiary : null),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(controller: _weightController, keyboardType: TextInputType.number, style: TextStyle(color: isDark ? AppColors.darkTextPrimary : null), decoration: InputDecoration(labelText: 'Peso (kg)', prefixIcon: const Icon(Icons.monitor_weight_outlined), filled: true, fillColor: isDark ? AppColors.darkCardElevated : AppColors.grey10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none))),
                  const SizedBox(height: 16),
                  TextField(controller: _heightController, keyboardType: TextInputType.number, style: TextStyle(color: isDark ? AppColors.darkTextPrimary : null), decoration: InputDecoration(labelText: 'Altura (cm)', prefixIcon: const Icon(Icons.height), filled: true, fillColor: isDark ? AppColors.darkCardElevated : AppColors.grey10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none))),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, 0, 24, 24 + math.max(0, MediaQuery.of(context).viewPadding.bottom - MediaQuery.of(context).viewInsets.bottom)),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton.icon(
                  onPressed: _saveRecord,
                  icon: const Icon(Icons.save_outlined, size: 22),
                  label: const Text('Guardar Registro', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  style: FilledButton.styleFrom(
                    backgroundColor: isDark ? AppColors.primaryLight : AppColors.primaryMid,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}