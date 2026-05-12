import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Widgets comunes reutilizables para PediaTrack
/// Diseño moderno con bordes redondeados y sombras suaves
/// Optimizado para tema claro y oscuro

// ═══════════════════════════════════════════════════════════════
// TARJETA CON GRADIENTE SUAVE
// ═══════════════════════════════════════════════════════════════

class GradientCard extends StatelessWidget {
  final Widget child;
  final List<Color>? gradientColors;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;

  const GradientCard({
    super.key,
    required this.child,
    this.gradientColors,
    this.margin,
    this.padding,
    this.onTap,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = borderRadius ?? BorderRadius.circular(20);
    final bgColor = isDark ? AppColors.darkCard : Colors.white;
    
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: gradientColors != null
            ?? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors!,
              )
            : null,
        color: gradientColors == null ? bgColor : null,
        borderRadius: radius,
        border: isDark ? Border.all(color: AppColors.darkBorder, width: 1) : null,
        boxShadow: isDark ? null : AppColors.softShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Padding(
            padding: padding ?? const EdgeInsets.all(20),
            child: child,
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// TARJETA DE ESTADÍSTICA - Optimizada para valor en tema oscuro
// ═══════════════════════════════════════════════════════════════

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final Color? backgroundColor;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = backgroundColor ?? (isDark ? AppColors.darkCard : AppColors.grey20);
    final iColor = iconColor ?? AppColors.primaryMid;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.grey500;
    final labelColor = isDark ? AppColors.darkTextSecondary : AppColors.grey100;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: isDark ? Border.all(color: AppColors.darkBorder, width: 1) : null,
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iColor.withValues(alpha: isDark ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iColor, size: 22),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: labelColor, fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800, color: textColor)),
                if (subtitle != null)
                  Text(subtitle!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: labelColor, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// CHIP DE ESTADO MODERNO
// ═══════════════════════════════════════════════════════════════

class StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;
  final bool outlined;

  const StatusChip({super.key, required this.label, required this.color, this.icon, this.outlined = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: outlined 
            ?? (isDark ? Colors.transparent : Colors.transparent)
            : color.withValues(alpha: isDark ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(20),
        border: outlined
            ?? Border.all(color: color.withValues(alpha: isDark ? 0.6 : 0.5), width: 1.5)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 14, color: color), const SizedBox(width: 4)],
          Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// CONTENEDOR CON BORDE GRADIENTE
// ═══════════════════════════════════════════════════════════════

class GradientBorderContainer extends StatelessWidget {
  final Widget child;
  final List<Color> gradientColors;
  final double borderRadius;
  final double borderWidth;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;

  const GradientBorderContainer({
    super.key,
    required this.child,
    required this.gradientColors,
    this.borderRadius = 20,
    this.borderWidth = 2,
    this.padding,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = backgroundColor ?? (isDark ? AppColors.darkCard : Colors.white);
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: gradientColors),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Container(
        margin: EdgeInsets.all(borderWidth),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(borderRadius - borderWidth)),
        padding: padding,
        child: child,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// PROGRESS CIRCULAR ESTILIZADO
// ═══════════════════════════════════════════════════════════════

class CircularProgressStat extends StatelessWidget {
  final double value;
  final double size;
  final Color? progressColor;
  final Color? backgroundColor;
  final Widget? center;

  const CircularProgressStat({super.key, required this.value, this.size = 80, this.progressColor, this.backgroundColor, this.center});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pColor = progressColor ?? AppColors.primaryMid;
    final bgColor = backgroundColor ?? (isDark ? AppColors.darkCard : AppColors.grey20);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: value.clamp(0.0, 1.0),
              strokeWidth: 6,
              backgroundColor: bgColor,
              valueColor: AlwaysStoppedAnimation(pColor),
              strokeCap: StrokeCap.round,
            ),
          ),
          if (center != null) Center(child: center!)
          else Center(
            child: Text(
              '${(value * 100).toInt()}%',
              style: TextStyle(fontSize: size * 0.22, fontWeight: FontWeight.w700, color: pColor),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// AVATAR CON INICIALES
// ═══════════════════════════════════════════════════════════════

class InitialsAvatar extends StatelessWidget {
  final String name;
  final double size;
  final Color? backgroundColor;
  final Color? textColor;

  const InitialsAvatar({super.key, required this.name, this.size = 40, this.backgroundColor, this.textColor});

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '??';
  }

  Color get _bgColor {
    final colors = [AppColors.primaryLight, AppColors.secondaryMid, AppColors.accentMid, AppColors.purpleMid];
    return backgroundColor ?? colors[name.hashCode % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: _bgColor.withValues(alpha: 0.15), shape: BoxShape.circle),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(color: textColor ? _bgColor, fontWeight: FontWeight.w700, fontSize: size * 0.4),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ENCABEZADO DE SECCIÓN
// ═══════════════════════════════════════════════════════════════

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;

  const SectionHeader({super.key, required this.title, this.subtitle, this.trailing});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.grey500;
    final subtitleColor = isDark ? AppColors.darkTextSecondary : AppColors.grey100;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: textColor)),
                if (subtitle != null) Text(subtitle!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: subtitleColor)),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ITEM DE LISTA MODERNO
// ═══════════════════════════════════════════════════════════════

class ListTileModern extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const ListTileModern({super.key, required this.icon, this.iconColor, required this.title, this.subtitle, this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = iconColor ?? AppColors.primaryMid;
    final titleColor = isDark ? AppColors.darkTextPrimary : AppColors.grey500;
    final subtitleColor = isDark ? AppColors.darkTextSecondary : AppColors.grey100;
    final chevronColor = isDark ? AppColors.darkTextTertiary : AppColors.grey50;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: color.withValues(alpha: isDark ? 0.2 : 0.1), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: titleColor)),
      subtitle: subtitle != null ? Text(subtitle!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: subtitleColor)) : null,
      trailing: trailing ?? Icon(Icons.chevron_right, color: chevronColor),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// TARJETA DE VALOR DE CRECIMIENTO - Alta visibilidad en tema oscuro
// ═══════════════════════════════════════════════════════════════

class GrowthValueCard extends StatelessWidget {
  final String label;
  final double value;
  final String unit;
  final int? percentile;
  final Color color;

  const GrowthValueCard({super.key, required this.label, required this.value, required this.unit, this.percentile, required this.color});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final valueColor = isDark ? AppColors.darkValueHighlight : AppColors.grey500;
    final labelColor = isDark ? AppColors.darkTextSecondary : AppColors.grey100;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardElevated : color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: isDark ? Border.all(color: AppColors.darkBorder, width: 1) : null,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: isDark ? 0.25 : 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(label.toLowerCase().contains('peso') ? Icons.monitor_weight_outlined : Icons.straighten, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: labelColor, fontSize: 11)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(value.toStringAsFixed(1), style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, color: valueColor)),
                    const SizedBox(width: 2),
                    Padding(padding: const EdgeInsets.only(bottom: 4), child: Text(unit, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: labelColor))),
                  ],
                ),
              ],
            ),
          ),
          if (percentile != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _percentileColor(percentile!).withValues(alpha: isDark ? 0.25 : 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('P$percentile', style: TextStyle(color: _percentileColor(percentile!), fontWeight: FontWeight.w700, fontSize: 12)),
            ),
        ],
      ),
    );
  }

  Color _percentileColor(int p) {
    if (p >= 15 && p <= 85) return AppColors.success;
    return AppColors.warning;
  }
}

// ═══════════════════════════════════════════════════════════════
// BADGE DE ALERTA
// ═══════════════════════════════════════════════════════════════

class AlertBadge extends StatelessWidget {
  final int count;
  final Color? color;

  const AlertBadge({super.key, required this.count, this.color});

  @override
  Widget build(BuildContext context) {
    if (count == 0) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color ? AppColors.error, borderRadius: BorderRadius.circular(10)),
      child: Text(count > 99 ? '99+' : '$count', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// TARJETA VACÍA
// ═══════════════════════════════════════════════════════════════

class EmptyStateCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;

  const EmptyStateCard({super.key, required this.icon, required this.title, this.subtitle, this.action});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? AppColors.darkTextTertiary : AppColors.grey100;
    final titleColor = isDark ? AppColors.darkTextSecondary : AppColors.grey300;
    final subtitleColor = isDark ? AppColors.darkTextTertiary : AppColors.grey100;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: isDark ? AppColors.darkCard : AppColors.grey20, shape: BoxShape.circle), child: Icon(icon, size: 40, color: iconColor)),
          const SizedBox(height: 16),
          Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: titleColor), textAlign: TextAlign.center),
          if (subtitle != null) ...[const SizedBox(height: 8), Text(subtitle!, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: subtitleColor), textAlign: TextAlign.center)],
          if (action != null) ...[const SizedBox(height: 24), action!],
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// INDICADOR DE PROGRESO DE ESTADO
// ═══════════════════════════════════════════════════════════════

class ProgressIndicatorStat extends StatelessWidget {
  final int completed;
  final int total;
  final String label;
  final Color? color;

  const ProgressIndicatorStat({super.key, required this.completed, required this.total, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final progress = total > 0 ? completed / total : 0.0;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final c = color ?? AppColors.primaryMid;
    final labelColor = isDark ? AppColors.darkTextSecondary : AppColors.grey100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: labelColor)),
            Text('$completed/$total', style: TextStyle(color: c, fontWeight: FontWeight.w700, fontSize: 13)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: c.withValues(alpha: isDark ? 0.25 : 0.15),
            valueColor: AlwaysStoppedAnimation(c),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// CONTENEDOR DE TARJETA CON SOMBRA
// ═══════════════════════════════════════════════════════════════

class ShadowContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? backgroundColor;

  const ShadowContainer({super.key, required this.child, this.padding, this.margin, this.borderRadius = 20, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = backgroundColor ?? (isDark ? AppColors.darkCard : Colors.white);
    
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(borderRadius),
        border: isDark ? Border.all(color: AppColors.darkBorder, width: 1) : null,
        boxShadow: isDark ? null : AppColors.softShadow,
      ),
      child: child,
    );
  }
}