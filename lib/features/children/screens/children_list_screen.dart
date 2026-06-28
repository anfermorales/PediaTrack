import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/database_providers.dart';
import '../../../core/utils/age_calculator.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/common_widgets.dart';
import '../models/child_model.dart';

/// Pantalla de lista de niños con diseño moderno
class ChildrenListScreen extends ConsumerWidget {
  const ChildrenListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final childrenAsync = ref.watch(childrenStreamProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Mis Hijos',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              centerTitle: true,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primaryLight.withValues(alpha: 0.1),
                      AppColors.secondaryLight.withValues(alpha: 0.1),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.person_add_outlined),
                onPressed: () => _showAddChildDialog(context, ref),
              ),
            ],
          ),
          childrenAsync.when(
            data: (children) {
              if (children.isEmpty) {
                return SliverFillRemaining(
                  child: _buildEmptyState(context),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildChildCard(context, ref, children[index]),
                    childCount: children.length,
                  ),
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => SliverFillRemaining(
              child: Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddChildDialog(context, ref),
        icon: const Icon(Icons.person_add),
        label: const Text('Agregar'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.child_care,
            size: 80,
            color: AppColors.grey50,
          ),
          const SizedBox(height: 16),
          Text(
            'Sin hijos registrados',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.grey100,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Agrega tu primer hijo para comenzar',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.grey100,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildCard(BuildContext context, WidgetRef ref, dynamic childData) {
    final child = childData;
    final birthDate = child.birthDate as DateTime;
    final ageMonths = AgeCalculator.completedMonths(birthDate).clamp(0, 60);
    final ageDisplay = _formatAge(ageMonths);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey500.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            ref.read(selectedChildIdProvider.notifier).state = child.id;
            // Navegar a detalle del niño
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                InitialsAvatar(
                  name: child.name,
                  size: 56,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        child.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _buildInfoChip(
                            icon: Icons.cake_outlined,
                            label: ageDisplay,
                          ),
                          const SizedBox(width: 8),
                          _buildInfoChip(
                            icon: child.gender == 0 ? Icons.male : Icons.female,
                            label: child.gender == 0 ? 'Niño' : 'Niña',
                            color: child.gender == 0 ? AppColors.primaryMid : AppColors.accentMid,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.chevron_right,
                    color: AppColors.primaryMid,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label, Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (color ?? AppColors.grey100).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color ?? AppColors.grey100),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color ?? AppColors.grey100,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatAge(int months) {
    if (months < 12) return '$months meses';
    final years = months ~/ 12;
    final remainingMonths = months % 12;
    if (remainingMonths == 0) return '$years año${years > 1 ? 's' : ''}';
    return '$years año${years > 1 ? 's' : ''}, $remainingMonths mes${remainingMonths > 1 ? 'es' : ''}';
  }

  void _showAddChildDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddChildBottomSheet(),
    );
  }
}

/// Bottom sheet para agregar niño
class AddChildBottomSheet extends ConsumerStatefulWidget {
  const AddChildBottomSheet({super.key});

  @override
  ConsumerState<AddChildBottomSheet> createState() => _AddChildBottomSheetState();
}

class _AddChildBottomSheetState extends ConsumerState<AddChildBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  DateTime _birthDate = DateTime.now();
  int _gender = 0;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: math.max(0, MediaQuery.of(context).viewInsets.bottom - MediaQuery.of(context).viewPadding.bottom),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + math.max(0, MediaQuery.of(context).viewPadding.bottom - MediaQuery.of(context).viewInsets.bottom)),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grey50,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Agregar Hijo',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre completo',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa el nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.cake_outlined),
                title: const Text('Fecha de nacimiento'),
                subtitle: Text(DateFormat('dd MMMM yyyy', 'es').format(_birthDate)),
                trailing: const Icon(Icons.calendar_today),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(color: AppColors.grey50),
                ),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _birthDate,
                    firstDate: DateTime(2015),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() => _birthDate = date);
                  }
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Género',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.grey200,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _GenderButton(
                      icon: Icons.male,
                      label: 'Niño',
                      isSelected: _gender == 0,
                      onTap: () => setState(() => _gender = 0),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _GenderButton(
                      icon: Icons.female,
                      label: 'Niña',
                      isSelected: _gender == 1,
                      onTap: () => setState(() => _gender = 1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _submitForm,
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Aquí se insertaría en la base de datos
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hijo agregado correctamente')),
      );
    }
  }
}

class _GenderButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.primaryMid : AppColors.grey100;
    
    return Material(
      color: isSelected ? AppColors.primaryLight.withValues(alpha: 0.1) : AppColors.grey20,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? AppColors.primaryMid : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
