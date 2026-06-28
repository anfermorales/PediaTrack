import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/providers/database_providers.dart';
import '../../../core/models/habit_type.dart' as models;
import '../../../data/database/app_database.dart';

double _sheetBottomSpace(BuildContext context) => 10 + MediaQuery.of(context).viewPadding.bottom;

/// Quick record sheet for growth and habit records
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
  int _selectedHabitType = models.AppHabitType.feeding.value;
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

    await db.insertGrowthRecord(GrowthRecordsCompanion.insert(
      childId: widget.childId,
      weight: weightValue != null && weightValue > 0
          ? drift.Value(weightValue / 2.20462)
          : const drift.Value.absent(),
      height: heightValue != null && heightValue > 0
          ? drift.Value(heightValue)
          : const drift.Value.absent(),
      headCircumference: headValue != null && headValue > 0
          ? drift.Value(headValue)
          : const drift.Value.absent(),
      date: _selectedDate,
      notes: _consultNotesController.text.trim().isEmpty
          ? const drift.Value.absent()
          : drift.Value(_consultNotesController.text.trim()),
    ));

    ref.invalidate(growthRecordsStreamProvider(widget.childId));

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro guardado exitosamente')),
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
          initialValue: _selectedHabitType,
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

// Helper provider for habits history (defined here for convenience)
final _habitHistoryProvider = FutureProvider.family<List<HabitRecord>, int>((ref, childId) async {
  final db = ref.watch(databaseProvider);
  return db.getHabitRecordsForChild(childId);
});