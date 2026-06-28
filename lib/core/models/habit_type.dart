import 'package:flutter/material.dart';

/// Tipos de habitos registrados en la aplicacion.
/// Usar en lugar de ints magicos (0, 1, 2, 10, 11, 12, 13).
enum AppHabitType {
  // Intestinales
  normal(0, 'Evacuación normal', Icons.check_circle, Color(0xFF66BB6A)),
  constipation(1, 'Estreñimiento', Icons.warning, Color(0xFFFFA726)),
  diarrhea(2, 'Diarrea', Icons.water_drop, Color(0xFFEF5350)),

  // Generales
  feeding(10, 'Alimentación', Icons.restaurant, Color(0xFF26A69A)),
  sleep(11, 'Sueño', Icons.nightlight_round, Color(0xFF5C6BC0)),
  hydration(12, 'Hidratación', Icons.local_drink, Color(0xFF29B6F6)),
  medication(13, 'Medicación', Icons.medication, Color(0xFF7E57C2));

  const HabitType(this.value, this.label, this.icon, this.color);

  final int value;
  final String label;
  final IconData icon;
  final Color color;

  /// Busca un HabitType por su valor entero.
  static HabitType? fromValue(int value) {
    for (final type in HabitType.values) {
      if (type.value == value) return type;
    }
    return null;
  }

  /// Retorna true si es un hábito intestinal (no general).
  bool get isBowel => value < 10;
}

/// Extensión para usar en widgets de forma directa.
extension HabitTypeX on HabitType {
  IconData get iconData => icon;
  Color get colorValue => color;
  String get displayLabel => label;
}