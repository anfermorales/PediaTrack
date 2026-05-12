import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pediatrack/core/providers/database_providers.dart';
import 'package:pediatrack/data/database/app_database.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/common_widgets.dart';

/// Pantalla de hábitos
class HabitsScreen extends ConsumerWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedChildId = ref.watch(selectedChildIdProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (selectedChildId == null) {
      return Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : null,
        appBar: AppBar(
          title: const Text('Hábitos'),
          backgroundColor: isDark ? AppColors.darkSurface : null,
        ),
        body: Center(
          child: Text(
            'Selecciona un niño para ver sus hábitos',
            style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.grey100),
          ),
        ),
      );
    }

    return _HabitsContent(childId: selectedChildId);
  }
}

class _HabitsContent extends ConsumerStatefulWidget {
  final int childId;

  const _HabitsContent({required this.childId});

  @override
  ConsumerState<_HabitsContent> createState() => _HabitsContentState();
}

class _HabitsContentState extends ConsumerState<_HabitsContent> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : null,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkSurface : null,
        foregroundColor: isDark ? AppColors.darkTextPrimary : null,
        title: const Text('Hábitos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => _showHistorySheet(context, ref),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _TodayProgress(childId: widget.childId),
          const SizedBox(height: 24),
          _HabitSection(title: 'Alimentación', icon: Icons.restaurant, color: AppColors.warning, childId: widget.childId, habitType: 0),
          const SizedBox(height: 16),
          _HabitSection(title: 'Sueño', icon: Icons.bedtime, color: AppColors.purpleMid, childId: widget.childId, habitType: 1),
          const SizedBox(height: 16),
          _HabitSection(title: 'Higiene', icon: Icons.bathtub, color: AppColors.primaryMid, childId: widget.childId, habitType: 2),
          const SizedBox(height: 16),
          _HabitSection(title: 'Evacuación', icon: Icons.baby_changing_station, color: AppColors.secondaryMid, childId: widget.childId, habitType: 3),
          const SizedBox(height: 100),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddHabitSheet(context),
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
      ),
    );
  }

  void _showHistorySheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _HabitHistorySheet(childId: widget.childId),
    );
  }

  void _showAddHabitSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddHabitSheet(childId: widget.childId),
    );
  }
}

/// Barra de progreso del día - Con soporte modo oscuro
class _TodayProgress extends ConsumerWidget {
  final int childId;

  const _TodayProgress({required this.childId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(todayHabitsProvider(childId));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.secondaryLight.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: isDark ? null : [
          BoxShadow(color: AppColors.secondaryMid.withValues(alpha: 0.1), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: habitsAsync.when(
        data: (habits) {
          final completed = habits.where((h) => h.recordedAt != null).length;
          final total = habits.length;
          final progress = total > 0 ? completed / total : 0.0;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryMid.withValues(alpha: isDark ? 0.2 : 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.today, color: AppColors.secondaryMid, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Resumen de Hoy',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.darkTextPrimary : null,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          total > 0 ? '$completed de $total hábitos completados' : 'Sin hábitos programados',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.grey100,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (total > 0) ...[
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: isDark ? AppColors.darkBorder : AppColors.grey20,
                    valueColor: AlwaysStoppedAnimation(progress == 1.0 ? AppColors.success : AppColors.secondaryMid),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: progress == 1.0 ? AppColors.success : AppColors.secondaryMid,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Text(
          'Error cargando hábitos',
          style: TextStyle(color: isDark ? AppColors.darkTextSecondary : null),
        ),
      ),
    );
  }
}

/// Sección de hábito con items
class _HabitSection extends ConsumerWidget {
  final String title;
  final IconData icon;
  final Color color;
  final int childId;
  final int habitType;

  const _HabitSection({required this.title, required this.icon, required this.color, required this.childId, required this.habitType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(todayHabitsProvider(childId));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.grey30.withValues(alpha: 0.3), width: 1),
        boxShadow: isDark ? null : [BoxShadow(color: AppColors.grey500.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: isDark ? 0.15 : 0.08),
              borderRadius: BorderRadius.circular(20).copyWith(bottomRight: Radius.zero, bottomLeft: Radius.zero),
            ),
            child: Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : null),
                ),
              ],
            ),
          ),
          habitsAsync.when(
            data: (habits) {
              final filtered = habits.where((h) => h.type == habitType).toList();
              if (filtered.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Sin registros de $title',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: isDark ? AppColors.darkTextTertiary : AppColors.grey100),
                  ),
                );
              }
              return Column(
                children: filtered.map((habit) => _HabitTile(habit: habit, color: color, isDark: isDark, childId: childId)).toList(),
              );
            },
            loading: () => const Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()),
            error: (_, __) => const Padding(padding: EdgeInsets.all(24), child: Text('Error')),
          ),
        ],
      ),
    );
  }
}

class _HabitTile extends ConsumerWidget {
  final HabitRecord habit;
  final Color color;
  final bool isDark;
  final int childId;

  const _HabitTile({required this.habit, required this.color, required this.isDark, required this.childId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCompleted = habit.recordedAt != null;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isCompleted ? AppColors.success.withValues(alpha: 0.1) : (isDark ? AppColors.darkCardElevated : AppColors.grey10),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          isCompleted ? Icons.check_circle : Icons.schedule,
          color: isCompleted ? AppColors.success : (isDark ? AppColors.darkTextTertiary : AppColors.grey100),
          size: 22,
        ),
      ),
      title: Text(
        _getTypeName(habit.type),
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.darkTextPrimary : null,
        ),
      ),
      subtitle: Text(
        habit.recordedAt != null ? DateFormat('HH:mm').format(habit.recordedAt!) : 'Sin registrar',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: isDark ? AppColors.darkTextSecondary : AppColors.grey100,
        ),
      ),
      trailing: isCompleted
          ?? const Icon(Icons.check, color: AppColors.success)
          : IconButton(
              icon: Icon(Icons.add_circle_outline, color: color),
              onPressed: () => _completeHabit(context, ref),
            ),
    );
  }

  String _getTypeName(int type) {
    switch (type) {
      case 0: return 'Alimentación';
      case 1: return 'Sueño';
      case 2: return 'Higiene';
      case 3: return 'Evacuación';
      default: return 'Hábito';
    }
  }

  void _completeHabit(BuildContext context, WidgetRef ref) async {
    final db = ref.read(databaseProvider);
    final now = DateTime.now();
    await db.updateHabitRecord(habit.id, now);
    ref.invalidate(todayHabitsProvider(childId));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${_getTypeName(habit.type)} completado')),
      );
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// BOTTOM SHEET: AGREGAR HÁBITO
// ═══════════════════════════════════════════════════════════════

class _AddHabitSheet extends ConsumerStatefulWidget {
  final int childId;

  const _AddHabitSheet({required this.childId});

  @override
  ConsumerState<_AddHabitSheet> createState() => _AddHabitSheetState();
}

class _AddHabitSheetState extends ConsumerState<_AddHabitSheet> {
  int _selectedType = 0;
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final typeOptions = ['Alimentación', 'Sueño', 'Higiene', 'Evacuación'];
    final typeIcons = [Icons.restaurant, Icons.bedtime, Icons.bathtub, Icons.baby_changing_station];
    final typeColors = [AppColors.warning, AppColors.purpleMid, AppColors.primaryMid, AppColors.secondaryMid];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkBorder : AppColors.grey50,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Agregar Hábito',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: 24 + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Tipo de hábito',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.grey200,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(4, (i) => GestureDetector(
                      onTap: () => setState(() => _selectedType = i),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: _selectedType == i
                              ?? typeColors[i].withValues(alpha: isDark ? 0.2 : 0.15)
                              : (isDark ? AppColors.darkCardElevated : AppColors.grey10),
                          borderRadius: BorderRadius.circular(12),
                          border: _selectedType == i ? Border.all(color: typeColors[i], width: 2) : null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              typeIcons[i],
                              color: _selectedType == i ? typeColors[i] : (isDark ? AppColors.darkTextTertiary : AppColors.grey100),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              typeOptions[i],
                              style: TextStyle(
                                color: _selectedType == i ? typeColors[i] : (isDark ? AppColors.darkTextSecondary : AppColors.grey200),
                                fontWeight: _selectedType == i ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Notas (opcional)',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.grey200,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _notesController,
                    maxLines: 3,
                    style: TextStyle(color: isDark ? AppColors.darkTextPrimary : null),
                    decoration: InputDecoration(
                      hintText: 'Agregar notas...',
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
              padding: EdgeInsets.fromLTRB(24, 0, 24, 24 + MediaQuery.of(context).viewPadding.bottom),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton.icon(
                  onPressed: _saveHabit,
                  icon: const Icon(Icons.add, size: 22),
                  label: const Text(
                    'Agregar Hábito',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: typeColors[_selectedType],
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

  void _saveHabit() async {
    final db = ref.read(databaseProvider);
    final now = DateTime.now();

    await db.insertHabitRecord(HabitRecordsCompanion.insert(
      childId: widget.childId,
      type: _selectedType,
      recordedAt: now,
      notes: _notesController.text.isEmpty ? const drift.Value(null) : drift.Value(_notesController.text),
    ));

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Hábito agregado')));
    }
  }
}

/// Sheet de historial de hábitos
class _HabitHistorySheet extends ConsumerWidget {
  final int childId;

  const _HabitHistorySheet({required this.childId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(todayHabitsProvider(childId));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBorder : AppColors.grey50,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Historial de Hábitos',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : null,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: habitsAsync.when(
              data: (habits) {
                if (habits.isEmpty) {
                  return Center(
                    child: Text(
                      'Sin historial',
                      style: TextStyle(color: isDark ? AppColors.darkTextTertiary : AppColors.grey100),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: habits.length,
                  itemBuilder: (context, index) {
                    final habit = habits[index];
                    return ListTile(
                      leading: Icon(_getTypeIcon(habit.type), color: _getTypeColor(habit.type)),
                      title: Text(
                        _getTypeName(habit.type),
                        style: TextStyle(color: isDark ? AppColors.darkTextPrimary : null),
                      ),
                      subtitle: Text(
                        habit.recordedAt != null ? DateFormat('dd/MM/yyyy HH:mm').format(habit.recordedAt!) : 'Sin registrar',
                        style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.grey100),
                      ),
                      trailing: habit.recordedAt != null
                          ?? const Icon(Icons.check_circle, color: AppColors.success)
                          : const Icon(Icons.schedule, color: AppColors.warning),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => Center(
                child: Text('Error', style: TextStyle(color: isDark ? AppColors.darkTextSecondary : null)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTypeName(int type) {
    switch (type) {
      case 0: return 'Alimentación';
      case 1: return 'Sueño';
      case 2: return 'Higiene';
      case 3: return 'Evacuación';
      default: return 'Otro';
    }
  }

  IconData _getTypeIcon(int type) {
    switch (type) {
      case 0: return Icons.restaurant;
      case 1: return Icons.bedtime;
      case 2: return Icons.bathtub;
      case 3: return Icons.baby_changing_station;
      default: return Icons.check;
    }
  }

  Color _getTypeColor(int type) {
    switch (type) {
      case 0: return AppColors.warning;
      case 1: return AppColors.purpleMid;
      case 2: return AppColors.primaryMid;
      case 3: return AppColors.secondaryMid;
      default: return AppColors.grey100;
    }
  }
}
