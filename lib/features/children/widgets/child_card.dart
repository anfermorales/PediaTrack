import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/common_widgets.dart';

/// Tarjeta de niño moderna para usar en listas y grids
class ChildCard extends StatelessWidget {
  final String name;
  final DateTime birthDate;
  final int gender;
  final double? latestWeight;
  final double? latestHeight;
  final int? weightPercentile;
  final int? heightPercentile;
  final VoidCallback? onTap;

  const ChildCard({
    super.key,
    required this.name,
    required this.birthDate,
    required this.gender,
    this.latestWeight,
    this.latestHeight,
    this.weightPercentile,
    this.heightPercentile,
    this.onTap,
  });

  int get _ageMonths {
    final now = DateTime.now();
    return ((now.year - birthDate.year) * 12 + (now.month - birthDate.month)).clamp(0, 60);
  }

  String get _ageDisplay {
    final months = _ageMonths;
    if (months < 12) return '$months meses';
    final years = months ~/ 12;
    final remaining = months % 12;
    if (remaining == 0) return '$years año${years > 1 ? 's' : ''}';
    return '$years año${years > 1 ? 's' : ''}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.softShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    InitialsAvatar(name: name, size: 52),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          _buildBadges(context),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.chevron_right,
                        color: AppColors.primaryMid,
                      ),
                    ),
                  ],
                ),
                if (_hasGrowthData) ...[
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 16),
                  _buildGrowthStats(context),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool get _hasGrowthData => latestWeight != null || latestHeight != null;

  Widget _buildBadges(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        _buildBadge(
          context,
          icon: Icons.cake_outlined,
          label: _ageDisplay,
        ),
        _buildBadge(
          context,
          icon: gender == 0 ? Icons.male : Icons.female,
          label: gender == 0 ? 'Niño' : 'Niña',
          color: gender == 0 ? AppColors.primaryMid : AppColors.accentMid,
        ),
        _buildBadge(
          context,
          icon: Icons.calendar_today,
          label: DateFormat('dd/MM/yy').format(birthDate),
        ),
      ],
    );
  }

  Widget _buildBadge(
    BuildContext context, {
    required IconData icon,
    required String label,
    Color? color,
  }) {
    final badgeColor = color ?? AppColors.grey100;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: badgeColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: badgeColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrowthStats(BuildContext context) {
    return Row(
      children: [
        if (latestWeight != null)
          Expanded(
            child: _GrowthStatItem(
              icon: Icons.monitor_weight_outlined,
              label: 'Peso',
              value: '${latestWeight!.toStringAsFixed(1)} kg',
              percentile: weightPercentile,
              color: AppColors.accentMid,
            ),
          ),
        if (latestWeight != null && latestHeight != null)
          const SizedBox(width: 12),
        if (latestHeight != null)
          Expanded(
            child: _GrowthStatItem(
              icon: Icons.straighten,
              label: 'Altura',
              value: '${latestHeight!.toStringAsFixed(1)} cm',
              percentile: heightPercentile,
              color: AppColors.primaryMid,
            ),
          ),
      ],
    );
  }
}

class _GrowthStatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final int? percentile;
  final Color color;

  const _GrowthStatItem({
    required this.icon,
    required this.label,
    required this.value,
    this.percentile,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.grey100,
                    fontSize: 11,
                  ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.grey500,
                  ),
                ),
              ],
            ),
          ),
          if (percentile != null)
            _PercentileBadge(percentile: percentile!),
        ],
      ),
    );
  }
}

class _PercentileBadge extends StatelessWidget {
  final int percentile;

  const _PercentileBadge({required this.percentile});

  Color get _color {
    if (percentile < 15 || percentile > 85) return AppColors.warning;
    return AppColors.success;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'P$percentile',
        style: TextStyle(
          color: _color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// Tarjeta pequeña para Quick Actions
class ChildQuickCard extends StatelessWidget {
  final String name;
  final int ageMonths;
  final int gender;
  final VoidCallback? onTap;

  const ChildQuickCard({
    super.key,
    required this.name,
    required this.ageMonths,
    required this.gender,
    this.onTap,
  });

  String get _initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '??';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              gender == 0 ? AppColors.primaryLight : AppColors.accentLight,
              (gender == 0 ? AppColors.primaryLight : AppColors.accentLight).withValues(alpha: 0.7),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  _initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name.split(' ').first,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${ageMonths}m',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}