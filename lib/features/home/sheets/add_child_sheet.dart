import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/providers/database_providers.dart';
import '../../../data/database/app_database.dart';

/// Add/Edit child sheet
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

  double _sheetBottomSpace(BuildContext context) => 10 + MediaQuery.of(context).viewPadding.bottom;

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
        ref.invalidate(childrenStreamProvider);
        ref.invalidate(childProvider(widget.child!.id));
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
}