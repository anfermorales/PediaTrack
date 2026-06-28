import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Widgets comunes reutilizables para PediaTrack
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
            ? LinearGradient(
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
// CHIP DE ESTADO MODERNO
// ═══════════════════════════════════════════════════════════════

class StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;
  final bool outlined;

  const StatusChip({
    super.key,
    required this.label,
    required this.color,
    this.icon,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: outlined
            ? Colors.transparent
            : color.withValues(alpha: isDark ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(20),
        border: outlined
            ? Border.all(
                color: color.withValues(alpha: isDark ? 0.6 : 0.5),
                width: 1.5,
              )
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
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

  const InitialsAvatar({
    super.key,
    required this.name,
    this.size = 40,
    this.backgroundColor,
    this.textColor,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  Color get _bgColor {
    final colors = [
      AppColors.primaryLight,
      AppColors.secondaryMid,
      AppColors.accentMid,
      AppColors.purpleMid,
    ];
    return backgroundColor ?? colors[name.hashCode.abs() % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _bgColor.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: textColor ?? _bgColor,
            fontWeight: FontWeight.w700,
            fontSize: size * 0.4,
          ),
        ),
      ),
    );
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
      decoration: BoxDecoration(
        color: color ?? AppColors.error,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        count > 99 ? '99+' : '$count',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
