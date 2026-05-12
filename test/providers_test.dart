import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pediatrack/core/providers/database_providers.dart';

void main() {
  group('themeModeProvider', () {
    test('initial value is light mode', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final themeMode = container.read(themeModeProvider);
      expect(themeMode, equals(ThemeMode.light));
    });

    test('can be updated to dark mode', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(themeModeProvider.notifier).state = ThemeMode.dark;
      expect(container.read(themeModeProvider), equals(ThemeMode.dark));
    });
  });

  group('selectedChildIdProvider', () {
    test('initial value is null', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final selectedId = container.read(selectedChildIdProvider);
      expect(selectedId, isNull);
    });

    test('can be set to a child ID', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(selectedChildIdProvider.notifier).state = 1;
      expect(container.read(selectedChildIdProvider), equals(1));
    });
  });

  group('navigationIndexProvider', () {
    test('initial value is 0', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final index = container.read(navigationIndexProvider);
      expect(index, equals(0));
    });

    test('can be updated', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(navigationIndexProvider.notifier).state = 2;
      expect(container.read(navigationIndexProvider), equals(2));
    });
  });

  group('AppAlert', () {
    test('creates alert with all properties', () {
      final alert = AppAlert(
        type: AppAlertType.vaccineOverdue,
        childId: 1,
        childName: 'Test Child',
        title: 'Vacuna atrasada',
        message: 'La vacuna BCG debía aplicarse el 01/01/2024.',
        createdAt: DateTime(2024, 1, 1),
      );

      expect(alert.type, equals(AppAlertType.vaccineOverdue));
      expect(alert.childId, equals(1));
      expect(alert.childName, equals('Test Child'));
      expect(alert.title, equals('Vacuna atrasada'));
      expect(alert.message, contains('BCG'));
      expect(alert.createdAt, equals(DateTime(2024, 1, 1)));
    });
  });

  group('AppAlertType', () {
    test('has all expected values', () {
      expect(AppAlertType.values.length, equals(3));
      expect(AppAlertType.values.contains(AppAlertType.vaccineOverdue), isTrue);
      expect(AppAlertType.values.contains(AppAlertType.vaccineUpcoming), isTrue);
      expect(AppAlertType.values.contains(AppAlertType.growthOutOfRange), isTrue);
    });
  });

  group('GrowthEvaluationParams', () {
    test('creates params with all properties', () {
      const params = GrowthEvaluationParams(
        value: 10.5,
        ageMonths: 12,
        gender: 0,
        type: GrowthType.weight,
      );

      expect(params.value, equals(10.5));
      expect(params.ageMonths, equals(12));
      expect(params.gender, equals(0));
      expect(params.type, equals(GrowthType.weight));
    });
  });

  group('GrowthEvaluationResult', () {
    test('creates result with all properties', () {
      const result = GrowthEvaluationResult(
        zScore: 0.5,
        category: 'Normal',
        percentile: 69.0,
      );

      expect(result.zScore, equals(0.5));
      expect(result.category, equals('Normal'));
      expect(result.percentile, equals(69.0));
    });
  });

  group('VaccineScheduleItem', () {
    test('creates item with completed vaccine', () {
      final item = VaccineScheduleItem(
        definition: _createMockDefinition(),
        appliedVaccine: _createMockVaccine(),
        dueDate: DateTime(2024, 1, 1),
        isOverdue: false,
        isCompleted: true,
      );

      expect(item.isCompleted, isTrue);
      expect(item.isOverdue, isFalse);
      expect(item.appliedVaccine, isNotNull);
    });

    test('creates item with pending vaccine', () {
      final item = VaccineScheduleItem(
        definition: _createMockDefinition(),
        appliedVaccine: null,
        dueDate: DateTime.now().add(const Duration(days: 30)),
        isOverdue: false,
        isCompleted: false,
      );

      expect(item.isCompleted, isFalse);
      expect(item.isOverdue, isFalse);
      expect(item.appliedVaccine, isNull);
    });

    test('creates item with overdue vaccine', () {
      final item = VaccineScheduleItem(
        definition: _createMockDefinition(),
        appliedVaccine: null,
        dueDate: DateTime.now().subtract(const Duration(days: 7)),
        isOverdue: true,
        isCompleted: false,
      );

      expect(item.isOverdue, isTrue);
      expect(item.isCompleted, isFalse);
    });
  });
}

// Mock classes para tests
class _MockDefinition {
  final int id = 1;
  final String name = 'BCG';
  final int recommendedAgeMonths = 0;
  final int doseNumber = 1;
  final int totalDoses = 1;
}

_MockDefinition _createMockDefinition() => _MockDefinition();

class _MockVaccine {
  final int id = 1;
  final int vaccineDefinitionId = 1;
  final DateTime appliedDate = DateTime.now();
}

_MockVaccine _createMockVaccine() => _MockVaccine();

// Placeholder for GrowthType - need to import
enum GrowthType { weight, height }