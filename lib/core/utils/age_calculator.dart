import 'package:flutter/foundation.dart';

/// Cálculos de edad pediátrica basados en **meses/años cumplidos**.
///
/// Se usan en lugar de operaciones con `Duration` porque el conteo debe
/// respetar el aniversario mensual exacto (OMS, esquemas de vacunación,
/// percentiles de crecimiento).
@immutable
class AgeCalculator {
  const AgeCalculator._();

  /// Meses cumplidos entre [birthDate] y [reference] (por defecto, ahora).
  ///
  /// Ejemplos:
  /// - Nacido 17 mar 2025, hoy 6 jun 2026  -> 14 (cumple 15 el 17 jun).
  /// - Nacido 28 nov 2022, hoy 6 jun 2026  -> 42 (cumple 43 el 28 jun).
  /// - Nacido 1 jun 2026,  hoy 1 jun 2026   -> 0.
  static int completedMonths(DateTime birthDate, {DateTime? reference}) {
    final now = reference ?? DateTime.now();
    var months = (now.year - birthDate.year) * 12 + (now.month - birthDate.month);
    if (now.day < birthDate.day) {
      months -= 1;
    }
    return months < 0 ? 0 : months;
  }

  /// Años y meses cumplidos entre [birthDate] y [reference].
  static ({int years, int months}) completedYearsMonths(
    DateTime birthDate, {
    DateTime? reference,
  }) {
    final total = completedMonths(birthDate, reference: reference);
    return (years: total ~/ 12, months: total % 12);
  }

  /// Edad en meses con decimales (útil para gráficas de crecimiento).
  static double exactMonths(DateTime birthDate, {DateTime? reference}) {
    final now = reference ?? DateTime.now();
    return now.difference(birthDate).inDays / 30.4375;
  }
}
