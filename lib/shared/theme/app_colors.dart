import 'package:flutter/material.dart';

/// Paleta de colores moderna y accesible para PediaTrack
/// Diseñada para máxima legibilidad en tema claro y oscuro
class AppColors {
  AppColors._();

  // ═══════════════════════════════════════════════════════════════
  // COLORES PRIMARIOS - Tonos vibrantes para mejor visibilidad
  // ═══════════════════════════════════════════════════════════════

  // Azul - acciones principales, navegación
  static const Color primaryLight = Color(0xFF93C5FD);
  static const Color primaryMid = Color(0xFF4A8BEF);
  static const Color primaryDeep = Color(0xFF2563EB);
  static const Color primarySurface = Color(0xFFEFF6FF);

  // Verde - estados saludables, éxito
  static const Color secondaryLight = Color(0xFF86EFAC);
  static const Color secondaryMid = Color(0xFF5FC88A);
  static const Color secondaryDeep = Color(0xFF16A34A);
  static const Color secondarySurface = Color(0xFFF0FDF4);

  // Coral - acentos, alertas de peso
  static const Color accentLight = Color(0xFFFCA5A5);
  static const Color accentMid = Color(0xFFFF9580);
  static const Color accentDeep = Color(0xFFEF4444);
  static const Color accentSurface = Color(0xFFFFF1F0);

  // Púrpura - elementos creativos, hábitos
  static const Color purpleLight = Color(0xFFC4B5FD);
  static const Color purpleMid = Color(0xFFA78BFA);
  static const Color purpleDeep = Color(0xFF7C3AED);
  static const Color purpleSurface = Color(0xFFF5F3FF);

  // ═══════════════════════════════════════════════════════════════
  // GRISES Y NEUTROS - Sistema de escala de grises
  // ═══════════════════════════════════════════════════════════════

  // Tema claro - fondos y contenedores
  static const Color grey10 = Color(0xFFF8FAFC);
  static const Color grey20 = Color(0xFFF1F5F9);
  static const Color grey30 = Color(0xFFE2E8F0);
  static const Color grey50 = Color(0xFFCBD5E1);
  
  // Tema claro - texto e iconos
  static const Color grey100 = Color(0xFF94A3B8);
  static const Color grey200 = Color(0xFF64748B);
  static const Color grey300 = Color(0xFF475569);
  static const Color grey400 = Color(0xFF334155);
  static const Color grey500 = Color(0xFF1E293B);

  // ═══════════════════════════════════════════════════════════════
  // COLORES SEMÁNTICOS - Estados y categorías
  // ═══════════════════════════════════════════════════════════════

  // Éxito / saludable
  static const Color success = Color(0xFF22C55E);
  static const Color successLight = Color(0xFFDCFCE7);
  static const Color successDark = Color(0xFF16A34A);

  // Alerta / precaución
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color warningDark = Color(0xFFD97706);

  // Error / crítico
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color errorDark = Color(0xFFDC2626);

  // Información
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);

  // ═══════════════════════════════════════════════════════════════
  // COLORES PARA GRÁFICAS DE CRECIMIENTO OMS
  // ═══════════════════════════════════════════════════════════════

  static const Color chartP3 = Color(0xFF94A3B8);   // Percentil 3 (bajo)
  static const Color chartP15 = Color(0xFF60A5FA); // Percentil 15
  static const Color chartP50 = Color(0xFF22C55E); // Percentil 50 (mediana)
  static const Color chartP85 = Color(0xFF60A5FA); // Percentil 85
  static const Color chartP97 = Color(0xFF94A3B8); // Percentil 97 (alto)

  static const Color chartWeightLine = accentDeep;  // Coral para peso
  static const Color chartHeightLine = primaryDeep;  // Azul para altura

  // ═══════════════════════════════════════════════════════════════
  // COLORES POR ESTADO DE VACUNA
  // ═══════════════════════════════════════════════════════════════

  static const Color vaccineCompleted = success;
  static const Color vaccinePending = warning;
  static const Color vaccineOverdue = error;
  static const Color vaccineUpcoming = info;

  // ═══════════════════════════════════════════════════════════════
  // GRADIENTES
  // ═══════════════════════════════════════════════════════════════

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryLight, primaryDeep],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondaryLight, secondaryDeep],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentLight, accentDeep],
  );

  static const LinearGradient softGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFE0F2FE), Color(0xFFF0FDF4)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
  );

  // ═══════════════════════════════════════════════════════════════
  // SOMBRAS
  // ═══════════════════════════════════════════════════════════════

  static List<BoxShadow> get softShadow => [
    BoxShadow(color: grey500.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 2)),
    BoxShadow(color: grey500.withValues(alpha: 0.04), blurRadius: 24, offset: const Offset(0, 8)),
  ];

  static List<BoxShadow> get mediumShadow => [
    BoxShadow(color: grey500.withValues(alpha: 0.12), blurRadius: 16, offset: const Offset(0, 4)),
    BoxShadow(color: grey500.withValues(alpha: 0.06), blurRadius: 32, offset: const Offset(0, 16)),
  ];

  static List<BoxShadow> get glowPrimary => [
    BoxShadow(color: primaryLight.withValues(alpha: 0.4), blurRadius: 20, spreadRadius: 2),
  ];

  // ═══════════════════════════════════════════════════════════════
  // COLORES OSCUROS (Para modo oscuro)
  // ═══════════════════════════════════════════════════════════════

  // Fondos y superficies
  static const Color darkBackground = Color(0xFF0F1219);
  static const Color darkSurface = Color(0xFF1A1F2E);
  static const Color darkCard = Color(0xFF1E2535);
  static const Color darkCardElevated = Color(0xFF252D3D);
  static const Color darkBorder = Color(0xFF2E3748);
  static const Color darkBorderLight = Color(0xFF3A4559);

  // Textos - diseñados para máxima legibilidad
  static const Color darkTextPrimary = Color(0xFFFFFFFF);      // Texto principal (blanco puro)
  static const Color darkTextSecondary = Color(0xFFB8C5D6);    // Texto secundario
  static const Color darkTextTertiary = Color(0xFF7A8BA3);     // Texto terciario
  static const Color darkTextMuted = Color(0xFF5A6B80);        // Texto deshabilitado

  // Valores numéricos destacados (peso, altura, percentiles)
  static const Color darkValueHighlight = Color(0xFFFFFFFF);   // Blanco puro para valores
  static const Color darkValueLabel = Color(0xFFB8C5D6);       // Etiquetas de valores

  // Colores semánticos adaptados a tema oscuro
  static const Color darkSuccess = Color(0xFF4ADE80);
  static const Color darkWarning = Color(0xFFFBBF24);
  static const Color darkError = Color(0xFFF87171);
  static const Color darkInfo = Color(0xFF60A5FA);

  // Colores de gráfico para tema oscuro (más vibrantes)
  static const Color darkChartP3 = Color(0xFF9CA3AF);
  static const Color darkChartP15 = Color(0xFF93C5FD);
  static const Color darkChartP50 = Color(0xFF4ADE80);
  static const Color darkChartP85 = Color(0xFF93C5FD);
  static const Color darkChartP97 = Color(0xFF9CA3AF);
  static const Color darkChartWeight = Color(0xFFF87171);
  static const Color darkChartHeight = Color(0xFF60A5FA);
}