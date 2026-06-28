import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pediatrack/core/providers/database_providers.dart';
import 'package:pediatrack/data/database/app_database.dart';

class EnhancedVaccinesScreen extends ConsumerStatefulWidget {
  const EnhancedVaccinesScreen({super.key});

  @override
  ConsumerState<EnhancedVaccinesScreen> createState() => _EnhancedVaccinesScreenState();
}

class _EnhancedVaccinesScreenState extends ConsumerState<EnhancedVaccinesScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 3, vsync: this);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final selectedChildId = ref.watch(selectedChildIdProvider);
    if (selectedChildId == null) {
      return Scaffold(
        key: ValueKey('vaccines-empty-${brightness.name}'),
        appBar: AppBar(title: const Text('Vacunas')),
        body: const Center(child: Text('Selecciona un niño para ver sus vacunas')),
      );
    }

    final scheduleAsync = ref.watch(vaccineScheduleProvider(selectedChildId));

    return Scaffold(
      key: ValueKey('vaccines-screen-${brightness.name}'),
      appBar: AppBar(
        title: const Text('Vacunas'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pendientes'),
            Tab(text: 'Completadas'),
            Tab(text: 'Todas'),
          ],
        ),
      ),
      body: scheduleAsync.when(
        data: (schedule) {
          final pending = schedule.where((s) => !s.isCompleted).toList();
          final completed = schedule.where((s) => s.isCompleted).toList();
          return TabBarView(
            key: ValueKey('vaccines-tabs-${brightness.name}'),
            controller: _tabController,
            children: [
              _VaccineList(items: pending, childId: selectedChildId),
              _VaccineList(items: completed, childId: selectedChildId),
              _VaccineList(items: schedule, childId: selectedChildId),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _VaccineList extends ConsumerWidget {
  const _VaccineList({required this.items, required this.childId});

  final List<VaccineScheduleItem> items;
  final int childId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items.isEmpty) return const Center(child: Text('Sin registros'));
    final brightness = Theme.of(context).brightness;

    return ListView.builder(
      key: ValueKey('vaccines-list-${childId}-${brightness.name}'),
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final item = items[i];
        final isCompleted = item.isCompleted;
        final isOverdue = item.isOverdue;
        final statusColor = isCompleted ? Colors.green : (isOverdue ? Colors.red : Colors.orange);
        final statusText = isCompleted ? 'Completada' : (isOverdue ? 'Atrasada' : 'Pendiente');

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: statusColor.withValues(alpha: 0.28), width: 1.2),
            color: Theme.of(context).colorScheme.surface,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => _openSheet(context, item),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(Icons.vaccines_outlined, color: statusColor),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.definition.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 34 / 2, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text('Dosis ${item.definition.doseNumber}/${item.definition.totalDoses}', style: const TextStyle(fontSize: 12)),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: statusColor.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(isCompleted ? Icons.check_circle : Icons.warning_amber_rounded, size: 14, color: statusColor),
                                      const SizedBox(width: 4),
                                      Text(statusText, style: TextStyle(color: statusColor, fontWeight: FontWeight.w700, fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(isCompleted ? Icons.edit : Icons.check, color: statusColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Divider(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.25), height: 1),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 20),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Fecha recomendada', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.outline)),
                          Text(DateFormat('dd MMM yyyy', 'es').format(item.dueDate), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                        ],
                      ),
                      const Spacer(),
                      if (item.mostRecentApplied != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Aplicada', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.outline)),
                            Text(DateFormat('dd/MM/yy').format(item.mostRecentApplied!.appliedDate), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                          ],
                        )
                      else
                        Text('Toca para registrar', style: TextStyle(color: statusColor, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _openSheet(BuildContext context, VaccineScheduleItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _VaccineSheet(item: item, childId: childId),
    );
  }
}

class _VaccineSheet extends ConsumerStatefulWidget {
  const _VaccineSheet({required this.item, required this.childId});

  final VaccineScheduleItem item;
  final int childId;

  @override
  ConsumerState<_VaccineSheet> createState() => _VaccineSheetState();
}

class _VaccineSheetState extends ConsumerState<_VaccineSheet> {
  late DateTime _date;
  late final TextEditingController _batch;
  late final TextEditingController _notes;

  @override
  void initState() {
    super.initState();
    _date = widget.item.mostRecentApplied?.appliedDate ?? DateTime.now();
    _batch = TextEditingController(text: widget.item.mostRecentApplied?.batch ?? '');
    _notes = TextEditingController(text: widget.item.mostRecentApplied?.notes ?? '');
  }

  @override
  void dispose() {
    _batch.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = widget.item.mostRecentApplied != null;
    final keyboard = MediaQuery.of(context).viewInsets.bottom;
    final bottomSafe = MediaQuery.of(context).viewPadding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 0),
              child: Text(
                isCompleted ? 'Editar Vacuna' : 'Registrar Vacuna',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(22, 18, 22, 14 + keyboard),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      initialValue: '${widget.item.definition.name} (${widget.item.definition.doseNumber}/${widget.item.definition.totalDoses})',
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Vacuna',
                        prefixIcon: Icon(Icons.vaccines_outlined),
                      ),
                    ),
                    const SizedBox(height: 14),
                    InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _date,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) setState(() => _date = date);
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3)),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_month_outlined),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text('Fecha: ${DateFormat('dd MMM yyyy', 'es').format(_date)}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                            ),
                            const Icon(Icons.edit_calendar_outlined),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _batch,
                      decoration: const InputDecoration(
                        labelText: 'Lote (opcional)',
                        prefixIcon: Icon(Icons.qr_code_2_outlined),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _notes,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Observaciones (opcional)',
                        prefixIcon: Icon(Icons.notes_outlined),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(22, 0, 22, 10 + bottomSafe),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _save,
                    child: const Text('Guardar'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final db = ref.read(databaseProvider);
    if (widget.item.mostRecentApplied != null) {
      await db.updateChildVaccine(
        widget.item.mostRecentApplied!.id,
        appliedDate: _date,
        batch: _batch.text.trim().isEmpty ? null : _batch.text.trim(),
        notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
      );
    } else {
      await db.insertChildVaccine(ChildVaccinesCompanion.insert(
        childId: widget.childId,
        vaccineDefinitionId: widget.item.definition.id,
        appliedDate: _date,
        batch: _batch.text.trim().isEmpty ? const drift.Value(null) : drift.Value(_batch.text.trim()),
        notes: _notes.text.trim().isEmpty ? const drift.Value(null) : drift.Value(_notes.text.trim()),
      ));
    }
    ref.invalidate(vaccineScheduleProvider(widget.childId));
    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(widget.item.mostRecentApplied != null ? 'Vacuna actualizada' : 'Vacuna registrada')),
    );
  }
}

