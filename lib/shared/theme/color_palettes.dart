import 'package:flutter/material.dart';

/// Paletas de colores alternativas para PediaTrack
/// Cada opción tiene un nombre descriptivo y propósito específico
class ColorPalettes {
  ColorPalettes._();

  // ═══════════════════════════════════════════════════════════
  // PALETA 1: "Sunrise Warmth" - Cálida y amigable
  // Ideal para: Apps de salud infantil, ambiente hospitalario
  // ═══════════════════════════════════════════════════════════

  static const sunrisePalette = ColorPalette(
    name: 'Sunrise Warmth',
    description: 'Colores cálidos y acogedores para apps pediátricas',
    primary: Color(0xFFFF7043),        // Naranja coral
    secondary: Color(0xFFFFCA28),      // Ámbar brillante
    tertiary: Color(0xFF66BB6A),       // Verde esmeralda
    background: Color(0xFFFFF8F0),      // Crema suave
    surface: Color(0xFFFFFFFF),
    text: Color(0xFF4A2C2A),
    textSecondary: Color(0xFF8B7355),
    accent: Color(0xFFFFAB91),
  );

  // ═══════════════════════════════════════════════════════════
  // PALETA 2: "Ocean Breeze" - Fresca y profesional
  // Ideal para: Clínicas, tableros de salud
  // ═══════════════════════════════════════════════════════════

  static const oceanPalette = ColorPalette(
    name: 'Ocean Breeze',
    description: 'Azules refrescantes con toques verdes para salud',
    primary: Color(0xFF00897B),        // Teal
    secondary: Color(0xFF4FC3F7),      // Cyan claro
    tertiary: Color(0xFF7986CB),        // Índigo
    background: Color(0xFFF0F7F7),
    surface: Color(0xFFFFFFFF),
    text: Color(0xFF1A3C40),
    textSecondary: Color(0xFF5D8A8F),
    accent: Color(0xFF80CBC4),
  );

  // ═══════════════════════════════════════════════════════════
  // PALETA 3: "Forest Harmony" - Natural y orgánica
  // Ideal para: Apps wellness, seguimiento natural
  // ═══════════════════════════════════════════════════════════

  static const forestPalette = ColorPalette(
    name: 'Forest Harmony',
    description: 'Verdes naturales con tonos tierra para bienestar',
    primary: Color(0xFF388E3C),        // Verde bosque
    secondary: Color(0xFF8BC34A),      // Verde lima
    tertiary: Color(0xFFFF9800),       // Naranja
    background: Color(0xFFF5FAF5),
    surface: Color(0xFFFFFFFF),
    text: Color(0xFF1B4D1B),
    textSecondary: Color(0xFF6B8E6B),
    accent: Color(0xFFA5D6A7),
  );

  // ═══════════════════════════════════════════════════════════
  // PALETA 4: "Lavender Dreams" - Suave y diferencial
  // Ideal para: Diferenciarse, genérico infantil
  // ═══════════════════════════════════════════════════════════

  static const lavenderPalette = ColorPalette(
    name: 'Lavender Dreams',
    description: 'Púrpuras suaves y lavanda para diferenciación',
    primary: Color(0xFF7E57C2),        // Púrpura
    secondary: Color(0xFFEC407A),       // Rosa
    tertiary: Color(0xFF26A69A),       // Teal
    background: Color(0xFFFAF5FF),
    surface: Color(0xFFFFFFFF),
    text: Color(0xFF3D3050),
    textSecondary: Color(0xFF7A6B8A),
    accent: Color(0xFFB39DDB),
  );

  // ═══════════════════════════════════════════════════════════
  // PALETA 5: "Midnight Medical" - Profesional y oscura
  // Ideal para: Dashboard médico, modo oscuro premium
  // ═══════════════════════════════════════════════════════════

  static const midnightPalette = ColorPalette(
    name: 'Midnight Medical',
    description: 'Tonos oscuros profesionales para interfaz médica',
    primary: Color(0xFF5C6BC0),         // Azul indigo
    secondary: Color(0xFF26A69A),       // Teal
    tertiary: Color(0xFFFFCA28),       // Ámbar
    background: Color(0xFF0D1117),
    surface: Color(0xFF161B22),
    text: Color(0xFFE6EDF3),
    textSecondary: Color(0xFF8B949E),
    accent: Color(0xFF79C0FF),
  );

  // ═══════════════════════════════════════════════════════════
  // PALETA 6: "Soft Pastels" - Gentil y accesible
  // Ideal para: Accesibilidad, primera infancia
  // ═══════════════════════════════════════════════════════════

  static const pastelsPalette = ColorPalette(
    name: 'Soft Pastels',
    description: 'Pasteles suaves para máxima accesibilidad',
    primary: Color(0xFF90CAF9),         // Azul pastel
    secondary: Color(0xFFA5D6A7),       // Verde pastel
    tertiary: Color(0xFFFFCC80),       // Naranja pastel
    background: Color(0xFFFAFAFA),
    surface: Color(0xFFFFFFFF),
    text: Color(0xFF424242),
    textSecondary: Color(0xFF757575),
    accent: Color(0xFFF48FB1),
  );

  // ═══════════════════════════════════════════════════════════
  // PALETA ACTUAL (Referencia)
  // ═══════════════════════════════════════════════════════════

  static const currentPalette = ColorPalette(
    name: 'Current - Soft Gradient',
    description: 'La paleta actual implementada',
    primary: Color(0xFF4A8BEF),
    secondary: Color(0xFF5FC88A),
    tertiary: Color(0xFFFF6B5B),
    background: Color(0xFFF8FAFC),
    surface: Color(0xFFFFFFFF),
    text: Color(0xFF1E293B),
    textSecondary: Color(0xFF64748B),
    accent: Color(0xFFB8A9FF),
  );
}

/// Modelo de paleta de colores
class ColorPalette {
  final String name;
  final String description;
  final Color primary;
  final Color secondary;
  final Color tertiary;
  final Color background;
  final Color surface;
  final Color text;
  final Color textSecondary;
  final Color accent;

  const ColorPalette({
    required this.name,
    required this.description,
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.background,
    required this.surface,
    required this.text,
    required this.textSecondary,
    required this.accent,
  });

  /// Genera el ColorScheme para Flutter
  ColorScheme toColorScheme({Brightness brightness = Brightness.light}) {
    if (brightness == Brightness.dark) {
      return ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        tertiary: tertiary,
        surface: surface,
        onSurface: text,
        primaryContainer: primary.withValues(alpha: 0.3),
        secondaryContainer: secondary.withValues(alpha: 0.3),
        tertiaryContainer: tertiary.withValues(alpha: 0.3),
      );
    }
    return ColorScheme.light(
      primary: primary,
      secondary: secondary,
      tertiary: tertiary,
      surface: surface,
      onSurface: text,
      primaryContainer: primary.withValues(alpha: 0.1),
      secondaryContainer: secondary.withValues(alpha: 0.1),
      tertiaryContainer: tertiary.withValues(alpha: 0.1),
    );
  }
}

/// Utilidad para generar gradientes desde una paleta
class PaletteGradients {
  final ColorPalette palette;

  const PaletteGradients(this.palette);

  LinearGradient get primary => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      palette.primary,
      palette.primary.withValues(alpha: 0.8),
    ],
  );

  LinearGradient get secondary => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      palette.secondary,
      palette.secondary.withValues(alpha: 0.8),
    ],
  );

  LinearGradient get soft => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      palette.primary.withValues(alpha: 0.05),
      palette.secondary.withValues(alpha: 0.05),
    ],
  );

  LinearGradient get card => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Colors.white,
      palette.background,
    ],
  );

  LinearGradient get header => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      palette.primary.withValues(alpha: 0.15),
      palette.secondary.withValues(alpha: 0.1),
    ],
  );
}