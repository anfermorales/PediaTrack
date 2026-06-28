import 'dart:math' as math;

import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/providers/database_providers.dart';
import '../../../data/database/app_database.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/animations_widgets.dart';

/// Add vaccine sheet for recording new vaccines
class AddVaccineSheet extends ConsumerStatefulWidget {
  final int childId;
  const AddVaccineSheet({super.key, required this.childId});

  @override
  ConsumerState<AddVaccineSheet> createState() => _AddVaccineSheetState();
}

class _AddVaccineSheetState extends ConsumerState<AddVaccineSheet> {
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
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (date != null) setState(() => _selectedDate = date);
  }

  void _saveVaccine() async {
    if (_selectedDefinitionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecciona una vacuna')));
      return;
    }
    final db = ref.read(databaseProvider);
    await db.insertChildVaccine(ChildVaccinesCompanion.insert(
      childId: widget.childId,
      vaccineDefinitionId: _selectedDefinitionId!,
      appliedDate: _selectedDate,
      batch: _batchController.text.isEmpty ? const drift.Value(null) : drift.Value(_batchController.text),
      notes: _notesController.text.isEmpty ? const drift.Value(null) : drift.Value(_notesController.text),
    ));
    ref.invalidate(vaccineScheduleProvider(widget.childId));
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vacuna agregada')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final definitionsAsync = ref.watch(vaccineDefinitionsProvider);

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
                    'Agregar Vacuna',
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
                bottom: 24 + math.max(0, MediaQuery.of(context).viewInsets.bottom - MediaQuery.of(context).viewPadding.bottom),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  definitionsAsync.when(
                    data: (definitions) => DropdownButtonFormField<int>(
                      initialValue: _selectedDefinitionId,
                      decoration: InputDecoration(
                        labelText: 'Selecciona una vacuna',
                        prefixIcon: const Icon(Icons.vaccines),
                        filled: true,
                        fillColor: isDark ? AppColors.darkCardElevated : AppColors.grey10,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: definitions.map((d) => DropdownMenuItem(
                        value: d.id,
                        child: Text('${d.name} - ${d.description ?? ""}'),
                      )).toList(),
                      onChanged: (v) => setState(() => _selectedDefinitionId = v),
                    ),
                    loading: () => const ShimmerLoading(height: 60, borderRadius: 14),
                    error: (_, __) => const Text('Error cargando vacunas'),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: _selectDate,
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCardElevated : AppColors.grey10,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder : AppColors.grey30,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today),
                          const SizedBox(width: 12),
                          Text(
                            DateFormat('dd MMM yyyy').format(_selectedDate),
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.darkTextPrimary : null,
                            ),
                          ),
                          const Spacer(),
                          Icon(Icons.edit, color: isDark ? AppColors.darkTextTertiary : null),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _batchController,
                    style: TextStyle(color: isDark ? AppColors.darkTextPrimary : null),
                    decoration: InputDecoration(
                      labelText: 'Número de lote (opcional)',
                      prefixIcon: const Icon(Icons.qr_code),
                      filled: true,
                      fillColor: isDark ? AppColors.darkCardElevated : AppColors.grey10,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _notesController,
                    maxLines: 3,
                    style: TextStyle(color: isDark ? AppColors.darkTextPrimary : null),
                    decoration: InputDecoration(
                      hintText: 'Observaciones...',
                      prefixIcon: const Icon(Icons.notes),
                      filled: true,
                      fillColor: isDark ? AppColors.darkCardElevated : AppColors.grey10,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
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
                  label: const Text(
                    'Agregar',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.warning,
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