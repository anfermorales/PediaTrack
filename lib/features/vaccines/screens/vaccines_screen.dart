import 'dart:math' as math;

import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pediatrack/core/providers/database_providers.dart';
import 'package:pediatrack/data/database/app_database.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/animations_widgets.dart';
import '../../../shared/widgets/common_widgets.dart';

/// Pantalla de vacunas con animaciones y swipe
class VaccinesScreen extends ConsumerWidget {
  const VaccinesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedChildId = ref.watch(selectedChildIdProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (selectedChildId == null) {
      return Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : null,
        appBar: AppBar(title: const Text('Vacunas'), backgroundColor: isDark ? AppColors.darkSurface : null),
        body: EmptyStateCard(icon: Icons.vaccines, title: 'Selecciona un niño', subtitle: 'Elige un niño para ver sus vacunas', iconColor: AppColors.warning),
      );
    }

    return _VaccinesContent(childId: selectedChildId);
  }
}

class _VaccinesContent extends ConsumerStatefulWidget {
  final int childId;
  const _VaccinesContent({required this.childId});

  @override
  ConsumerState<_VaccinesContent> createState() => _VaccinesContentState();
}

class _VaccinesContentState extends ConsumerState<_VaccinesContent> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showConfetti = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _triggerConfetti() {
    setState(() => _showConfetti = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showConfetti = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final vaccinesAsync = ref.watch(childVaccinesWithDefinitionsProvider(widget.childId));

    return ConfettiOverlay(
      trigger: _showConfetti,
      onComplete: () => setState(() => _showConfetti = false),
      child: Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : null,
        appBar: AppBar(
          backgroundColor: isDark ? AppColors.darkSurface : null,
          foregroundColor: isDark ? AppColors.darkTextPrimary : null,
          title: const Text('Vacunas'),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: AppColors.warning,
            labelColor: AppColors.warning,
            unselectedLabelColor: isDark ? AppColors.darkTextSecondary : AppColors.grey100,
            tabs: const [
              Tab(text: '⏳ Pendientes'),
              Tab(text: '✅ Completadas'),
              Tab(text: '📋 Todas'),
            ],
          ),
        ),
        body: vaccinesAsync.when(
          data: (vaccines) {
            if (vaccines.isEmpty) {
              return EmptyStateCard(icon: Icons.vaccines, title: 'Sin vacunas registradas', subtitle: 'Agrega las primeras vacunas para hacer seguimiento', buttonText: 'Agregar Vacuna', onButtonPressed: () => _showAddVaccineSheet(context), iconColor: AppColors.warning);
            }

            final pending = vaccines.where((v) => v.appliedVaccine == null && !_isOverdue(v.definition.recommendedAgeMonths)).toList();
            final completed = vaccines.where((v) => v.appliedVaccine != null).toList();
            final overdue = vaccines.where((v) => v.appliedVaccine == null && _isOverdue(v.definition.recommendedAgeMonths)).toList();

            return TabBarView(
              controller: _tabController,
              children: [
                _VaccineList(vaccines: [...overdue, ...pending], emptyMessage: '¡No hay vacunas pendientes! 🎉', emptyIcon: Icons.check_circle, childId: widget.childId, onComplete: _triggerConfetti),
                _VaccineList(vaccines: completed, emptyMessage: 'Aún no hay vacunas completadas', emptyIcon: Icons.schedule, childId: widget.childId, onComplete: _triggerConfetti),
                _VaccineList(vaccines: vaccines, emptyMessage: 'Sin vacunas registradas', emptyIcon: Icons.vaccines, childId: widget.childId, onComplete: _triggerConfetti),
              ],
            );
          },
          loading: () => _buildLoadingState(),
          error: (e, _) => Center(child: Text('Error: $e', style: TextStyle(color: isDark ? AppColors.darkTextSecondary : null))),
        ),
        floatingActionButton: FloatingActionButton.extended(onPressed: () => _showAddVaccineSheet(context), icon: const Icon(Icons.add), label: const Text('Agregar'), backgroundColor: AppColors.warning),
      ),
    );
  }

  bool _isOverdue(int recommendedAgeMonths) {
    final childAsync = ref.read(childProvider(widget.childId));
    return childAsync.whenOrNull(data: (child) {
      final now = DateTime.now();
      final ageMonths = (now.year - child.birthDate.year) * 12 + now.month - child.birthDate.month;
      return ageMonths > recommendedAgeMonths;
    }) ?? false;
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(children: [for (int i = 0; i < 4; i++) ...[const ShimmerLoading(height: 100, borderRadius: 16), const SizedBox(height: 12)]]),
    );
  }

  void _showAddVaccineSheet(BuildContext context) {
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (context) => _AddVaccineSheet(childId: widget.childId));
  }
}

class _VaccineList extends StatelessWidget {
  final List<VaccineWithDefinition> vaccines;
  final String emptyMessage;
  final IconData emptyIcon;
  final int childId;
  final VoidCallback onComplete;

  const _VaccineList({required this.vaccines, required this.emptyMessage, required this.emptyIcon, required this.childId, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (vaccines.isEmpty) {
      return EmptyStateCard(icon: emptyIcon, title: emptyMessage.split(' ').first, subtitle: emptyMessage, iconColor: AppColors.success);
    }

    return RefreshIndicator(
      onRefresh: () async {
        HapticFeedback.mediumImpact();
        // Refresh logic
      },
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: vaccines.length,
        itemBuilder: (context, index) {
          final item = vaccines[index];
          final isOverdue = item.appliedVaccine == null && _checkOverdue(item.definition.recommendedAgeMonths, context);
          final isCompleted = item.appliedVaccine != null;

          return AnimatedListItem(
            index: index,
            child: SwipeToDeleteItem(
              onDelete: () async {
                if (item.appliedVaccine != null) {
                  final db = context.read<databaseProvider>();
                  await db.deleteChildVaccine(item.appliedVaccine!.id);
                  if (context.mounted) {
                    HapticFeedback.mediumImpact();
                    showUndoSnackbar(context, 'Vacuna eliminada', () {
                      // Undo would re-insert
                    });
                  }
                }
              },
              deleteMessage: '¿Eliminar el registro de ${item.definition.name}?',
              child: _VaccineCard(
                item: item,
                isOverdue: isOverdue,
                isCompleted: isCompleted,
                onTap: () => _showCompleteSheet(context, item),
                isDark: isDark,
              ),
            ),
          );
        },
      ),
    );
  }

  bool _checkOverdue(int recommendedAgeMonths, BuildContext context) {
    final container = ProviderScope.containerOf(context);
    final childAsync = container.read(childProvider(childId));
    return childAsync.whenOrNull(data: (child) {
      final now = DateTime.now();
      final ageMonths = (now.year - child.birthDate.year) * 12 + now.month - child.birthDate.month;
      return ageMonths > recommendedAgeMonths;
    }) ?? false;
  }
}

class _VaccineCard extends StatelessWidget {
  final VaccineWithDefinition item;
  final bool isOverdue;
  final bool isCompleted;
  final VoidCallback onTap;
  final bool isDark;

  const _VaccineCard({required this.item, required this.isOverdue, required this.isCompleted, required this.onTap, required this.isDark});

  Color get _statusColor => isCompleted ? AppColors.success : (isOverdue ? AppColors.error : AppColors.warning);
  IconData get _statusIcon => isCompleted ? Icons.check_circle : (isOverdue ? Icons.warning : Icons.schedule);
  String get _statusText => isCompleted ? 'Completada' : (isOverdue ? 'Atrasada' : 'Pendiente');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isCompleted ? null : onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.grey30),
          boxShadow: [BoxShadow(color: _statusColor.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: _statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: Icon(_statusIcon, color: _statusColor, size: 24)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(item.definition.name, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: isDark ? AppColors.darkTextPrimary : null)),
                    if (item.definition.description != null) Text(item.definition.description!, style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.grey100)),
                  ]),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: _statusColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                  child: Text(_statusText, style: TextStyle(color: _statusColor, fontWeight: FontWeight.w600, fontSize: 12)),
                ),
              ],
            ),
            if (isCompleted && item.appliedVaccine != null) ...[
              const SizedBox(height: 12),
              Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: isDark ? AppColors.darkCardElevated : AppColors.grey10, borderRadius: BorderRadius.circular(12)), child: Row(children: [
                Icon(Icons.calendar_today, size: 16, color: isDark ? AppColors.darkTextTertiary : AppColors.grey100),
                const SizedBox(width: 8),
                Text(DateFormat('dd MMM yyyy').format(item.appliedVaccine!.appliedDate), style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.grey100)),
                if (item.appliedVaccine!.batch != null) ...[const SizedBox(width: 16), Icon(Icons.qr_code, size: 16, color: isDark ? AppColors.darkTextTertiary : AppColors.grey100), const SizedBox(width: 4), Text('Lote: ${item.appliedVaccine!.batch}', style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.grey100))],
                if (item.appliedVaccine!.notes != null && item.appliedVaccine!.notes!.isNotEmpty) ...[const SizedBox(width: 16), Icon(Icons.notes, size: 16, color: isDark ? AppColors.darkTextTertiary : AppColors.grey100), const SizedBox(width: 4), Expanded(child: Text(item.appliedVaccine!.notes!, style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.grey100), overflow: TextOverflow.ellipsis))],
              ])),
            ],
            if (!isCompleted) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.schedule, size: 14, color: isDark ? AppColors.darkTextTertiary : AppColors.grey100),
                  const SizedBox(width: 4),
                  Text('Recomendada a los ${item.definition.recommendedAgeMonths} meses', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextTertiary : AppColors.grey100)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// COMPLETE VACCINE SHEET
// ═══════════════════════════════════════════════════════════════

class _CompleteVaccineSheet extends ConsumerStatefulWidget {
  final VaccineWithDefinition item;
  final int childId;
  const _CompleteVaccineSheet({required this.item, required this.childId});

  @override
  ConsumerState<_CompleteVaccineSheet> createState() => _CompleteVaccineSheetState();
}

class _CompleteVaccineSheetState extends ConsumerState<_CompleteVaccineSheet> {
  late DateTime _selectedDate;
  final _batchController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    _batchController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime(2020), lastDate: DateTime.now());
    if (date != null) setState(() => _selectedDate = date);
  }

  Future<void> _saveVaccine() async {
    try {
      final db = ref.read(databaseProvider);
      await db.insertChildVaccine(ChildVaccinesCompanion.insert(childId: widget.childId, vaccineDefinitionId: widget.item.definition.id, appliedDate: _selectedDate, batch: _batchController.text.isEmpty ? const drift.Value(null) : drift.Value(_batchController.text), notes: _notesController.text.isEmpty ? const drift.Value(null) : drift.Value(_notesController.text)));
      ref.invalidate(childVaccinesWithDefinitionsProvider(widget.childId));
      if (mounted) {
        Navigator.pop(context);
        HapticFeedback.mediumImpact();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('¡Vacuna registrada! 🎉')));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
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
              child: Column(children: [Container(width: 40, height: 4, decoration: BoxDecoration(color: isDark ? AppColors.darkBorder : AppColors.grey50, borderRadius: BorderRadius.circular(2))), const SizedBox(height: 16), Text('Registrar ${widget.item.definition.name}', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : null))]),
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
                    child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: isDark ? AppColors.darkCardElevated : AppColors.grey10, borderRadius: BorderRadius.circular(14), border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.grey30)), child: Row(children: [const Icon(Icons.calendar_today), const SizedBox(width: 12), Text(DateFormat('dd MMM yyyy').format(_selectedDate), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextPrimary : null)), const Spacer(), Icon(Icons.edit, color: isDark ? AppColors.darkTextTertiary : null)])),
                  ),
                  const SizedBox(height: 20),
                  TextField(controller: _batchController, style: TextStyle(color: isDark ? AppColors.darkTextPrimary : null), decoration: InputDecoration(labelText: 'Número de lote (opcional)', prefixIcon: const Icon(Icons.qr_code), filled: true, fillColor: isDark ? AppColors.darkCardElevated : AppColors.grey10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none))),
                  const SizedBox(height: 20),
                  Text('Observaciones (opcional)', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextSecondary : AppColors.grey200)),
                  const SizedBox(height: 8),
                  TextField(controller: _notesController, maxLines: 3, style: TextStyle(color: isDark ? AppColors.darkTextPrimary : null), decoration: InputDecoration(hintText: 'Ej: Reacción leve, fiebre leve...', prefixIcon: const Icon(Icons.notes), filled: true, fillColor: isDark ? AppColors.darkCardElevated : AppColors.grey10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none))),
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
                  onPressed: _saveVaccine,
                  icon: const Icon(Icons.check, size: 22),
                  label: const Text('Registrar Vacuna', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  style: FilledButton.styleFrom(backgroundColor: AppColors.success, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ADD VACCINE SHEET
// ═══════════════════════════════════════════════════════════════

class _AddVaccineSheet extends ConsumerStatefulWidget {
  final int childId;
  const _AddVaccineSheet({required this.childId});

  @override
  ConsumerState<_AddVaccineSheet> createState() => _AddVaccineSheetState();
}

class _AddVaccineSheetState extends ConsumerState<_AddVaccineSheet> {
  int? _selectedDefinitionId;
  DateTime _selectedDate = DateTime.now();
  final _batchController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _batchController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime(2020), lastDate: DateTime.now());
    if (date != null) setState(() => _selectedDate = date);
  }

  void _saveVaccine() async {
    if (_selectedDefinitionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecciona una vacuna')));
      return;
    }
    final db = ref.read(databaseProvider);
    await db.insertChildVaccine(ChildVaccinesCompanion.insert(childId: widget.childId, vaccineDefinitionId: _selectedDefinitionId!, appliedDate: _selectedDate, batch: _batchController.text.isEmpty ? const drift.Value(null) : drift.Value(_batchController.text), notes: _notesController.text.isEmpty ? const drift.Value(null) : drift.Value(_notesController.text)));
    ref.invalidate(childVaccinesWithDefinitionsProvider(widget.childId));
    if (mounted) {
      Navigator.pop(context);
      HapticFeedback.mediumImpact();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vacuna agregada')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final definitionsAsync = ref.watch(vaccineDefinitionsProvider);

    return Container(
      decoration: BoxDecoration(color: isDark ? AppColors.darkCard : Colors.white, borderRadius: const BorderRadius.vertical(top: Radius.circular(24))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(24, 16, 24, 0), child: Column(children: [Container(width: 40, height: 4, decoration: BoxDecoration(color: isDark ? AppColors.darkBorder : AppColors.grey50, borderRadius: BorderRadius.circular(2))), const SizedBox(height: 16), Text('Agregar Vacuna', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : null))]))),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 24 + math.max(0, MediaQuery.of(context).viewInsets.bottom - MediaQuery.of(context).viewPadding.bottom)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  definitionsAsync.when(
                    data: (definitions) => DropdownButtonFormField<int>(
                      value: _selectedDefinitionId,
                      decoration: InputDecoration(labelText: 'Selecciona una vacuna', prefixIcon: const Icon(Icons.vaccines), filled: true, fillColor: isDark ? AppColors.darkCardElevated : AppColors.grey10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none)),
                      items: definitions.map((d) => DropdownMenuItem(value: d.id, child: Text('${d.name} - ${d.description ?? ""}'))).toList(),
                      onChanged: (v) => setState(() => _selectedDefinitionId = v),
                    ),
                    loading: () => const ShimmerLoading(height: 60, borderRadius: 14),
                    error: (_, __) => const Text('Error cargando vacunas'),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: _selectDate,
                    borderRadius: BorderRadius.circular(14),
                    child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: isDark ? AppColors.darkCardElevated : AppColors.grey10, borderRadius: BorderRadius.circular(14), border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.grey30)), child: Row(children: [const Icon(Icons.calendar_today), const SizedBox(width: 12), Text(DateFormat('dd MMM yyyy').format(_selectedDate), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextPrimary : null)), const Spacer(), Icon(Icons.edit, color: isDark ? AppColors.darkTextTertiary : null)])),
                  ),
                  const SizedBox(height: 16),
                  TextField(controller: _batchController, style: TextStyle(color: isDark ? AppColors.darkTextPrimary : null), decoration: InputDecoration(labelText: 'Número de lote (opcional)', prefixIcon: const Icon(Icons.qr_code), filled: true, fillColor: isDark ? AppColors.darkCardElevated : AppColors.grey10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none))),
                  const SizedBox(height: 16),
                  TextField(controller: _notesController, maxLines: 3, style: TextStyle(color: isDark ? AppColors.darkTextPrimary : null), decoration: InputDecoration(hintText: 'Observaciones...', prefixIcon: const Icon(Icons.notes), filled: true, fillColor: isDark ? AppColors.darkCardElevated : AppColors.grey10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none))),
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
                  onPressed: _saveVaccine,
                  icon: const Icon(Icons.add, size: 22),
                  label: const Text('Agregar', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  style: FilledButton.styleFrom(backgroundColor: AppColors.warning, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _showCompleteSheet(BuildContext context, VaccineWithDefinition item) {
  final container = ProviderScope.containerOf(context);
  final childId = container.read(selectedChildIdProvider);
  if (childId == null) return;
  showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (context) => _CompleteVaccineSheet(item: item, childId: childId));
}