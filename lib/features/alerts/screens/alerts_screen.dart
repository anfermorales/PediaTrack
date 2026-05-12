import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pediatrack/core/providers/database_providers.dart';
import 'package:pediatrack/data/database/app_database.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/animations_widgets.dart';
import '../../../shared/widgets/common_widgets.dart';

/// Pantalla de alertas con badge animado
class AlertsScreen extends ConsumerWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedChildId = ref.watch(selectedChildIdProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (selectedChildId == null) {
      return Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : null,
        appBar: AppBar(title: const Text('Alertas'), backgroundColor: isDark ? AppColors.darkSurface : null),
        body: EmptyStateCard(
          icon: Icons.notifications_none,
          title: 'Selecciona un niño',
          subtitle: 'Elige un niño para ver sus alertas de salud',
          iconColor: AppColors.primaryMid,
        ),
      );
    }

    return _AlertsContent(childId: selectedChildId);
  }
}

class _AlertsContent extends ConsumerStatefulWidget {
  final int childId;
  const _AlertsContent({required this.childId});

  @override
  ConsumerState<_AlertsContent> createState() => _AlertsContentState();
}

class _AlertsContentState extends ConsumerState<_AlertsContent> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final alertsAsync = ref.watch(childAlertsProvider(widget.childId));

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : null,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkSurface : null,
        foregroundColor: isDark ? AppColors.darkTextPrimary : null,
        title: Row(
          children: [
            const Text('Alertas'),
            const SizedBox(width: 8),
            alertsAsync.whenOrNull(
              data: (alerts) {
                if (alerts.isEmpty) return const SizedBox.shrink();
                return AnimatedBadge(
                  count: alerts.length,
                  backgroundColor: AppColors.error,
                  size: 22,
                );
              },
            ) ?? const SizedBox.shrink(),
          ],
        ),
      ),
      body: alertsAsync.when(
        data: (alerts) {
          if (alerts.isEmpty) {
            return _buildEmptyState(context, isDark);
          }

          return RefreshIndicator(
            onRefresh: () async {
              HapticFeedback.mediumImpact();
              ref.invalidate(childAlertsProvider(widget.childId));
            },
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: alerts.length,
              itemBuilder: (context, index) {
                final alert = alerts[index];
                return AnimatedListItem(
                  index: index,
                  child: _AlertCard(alert: alert, isDark: isDark),
                );
              },
            ),
          );
        },
        loading: () => _buildLoadingState(),
        error: (e, _) => Center(child: Text('Error: $e', style: TextStyle(color: isDark ? AppColors.darkTextSecondary : null))),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle, size: 80, color: AppColors.success),
            ),
            const SizedBox(height: 24),
            Text(
              '¡Todo al día! 🎉',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextPrimary : null,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'No hay alertas pendientes.\nTu hijo está al día con sus vacunas y seguimiento.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.grey100,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          for (int i = 0; i < 4; i++) ...[
            const ShimmerLoading(height: 100, borderRadius: 16),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  final AppAlert alert;
  final bool isDark;

  const _AlertCard({required this.alert, required this.isDark});

  IconData get _icon {
    switch (alert.type) {
      case AppAlertType.vaccine:
        return Icons.vaccines;
      case AppAlertType.growth:
        return Icons.trending_down;
      case AppAlertType.habit:
        return Icons.schedule;
      default:
        return Icons.info;
    }
  }

  Color get _color {
    switch (alert.severity) {
      case 'high':
        return AppColors.error;
      case 'medium':
        return AppColors.warning;
      default:
        return AppColors.primaryMid;
    }
  }

  String get _severityLabel {
    switch (alert.severity) {
      case 'high':
        return '🔴 Urgente';
      case 'medium':
        return '🟡 Pendiente';
      default:
        return '🔵 Recordatorio';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.grey30),
        boxShadow: [
          BoxShadow(
            color: _color.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_icon, color: _color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alert.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: isDark ? AppColors.darkTextPrimary : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      alert.message,
                      style: TextStyle(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.grey100,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _severityLabel,
                  style: TextStyle(
                    color: _color,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          if (alert.actionRequired) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      // Navigate to action
                    },
                    icon: const Icon(Icons.arrow_forward, size: 18),
                    label: const Text('Ver detalle'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _color,
                      side: BorderSide(color: _color),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    // Dismiss alert
                  },
                  icon: Icon(Icons.close, color: isDark ? AppColors.darkTextTertiary : AppColors.grey100),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}