import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pediatrack/core/providers/database_providers.dart';
import 'package:pediatrack/core/services/who_growth_service.dart';
import 'package:pediatrack/data/database/app_database.dart';

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
    final mockDefinition = VaccineDefinition(
      id: 1,
      name: 'BCG',
      recommendedAgeMonths: 0,
      doseNumber: 1,
      totalDoses: 1,
      category: 'BCG',
    );

    ChildVaccine buildChildVaccine({required int id, int defId = 1}) {
      return ChildVaccine(
        id: id,
        childId: 1,
        vaccineDefinitionId: defId,
        appliedDate: DateTime.now(),
        createdAt: DateTime.now(),
      );
    }

    test('creates item with completed vaccine', () {
      final item = VaccineScheduleItem(
        definition: mockDefinition,
        appliedVaccines: [buildChildVaccine(id: 1)],
        dueDate: DateTime(2024, 1, 1),
        isOverdue: false,
        isCompleted: true,
      );

      expect(item.isCompleted, isTrue);
      expect(item.isOverdue, isFalse);
      expect(item.appliedVaccines, hasLength(1));
      expect(item.mostRecentApplied, isNotNull);
    });

    test('creates item with pending vaccine', () {
      final item = VaccineScheduleItem(
        definition: mockDefinition,
        appliedVaccines: const [],
        dueDate: DateTime.now().add(const Duration(days: 30)),
        isOverdue: false,
        isCompleted: false,
      );

      expect(item.isCompleted, isFalse);
      expect(item.isOverdue, isFalse);
      expect(item.appliedVaccines, isEmpty);
      expect(item.mostRecentApplied, isNull);
    });

    test('creates item with overdue vaccine', () {
      final item = VaccineScheduleItem(
        definition: mockDefinition,
        appliedVaccines: const [],
        dueDate: DateTime.now().subtract(const Duration(days: 7)),
        isOverdue: true,
        isCompleted: false,
      );

      expect(item.isOverdue, isTrue);
      expect(item.isCompleted, isFalse);
    });
  });
}
