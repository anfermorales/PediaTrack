import 'package:flutter_test/flutter_test.dart';
import 'package:pediatrack/core/utils/vaccine_status_calculator.dart';

void main() {
  group('VaccineStatusCalculator.dueDateFor', () {
    test('returns birthDate when recommendedAgeMonths is zero', () {
      final birth = DateTime(2024, 1, 1);
      final due = VaccineStatusCalculator.dueDateFor(
        birthDate: birth,
        recommendedAgeMonths: 0,
      );
      expect(due, equals(birth));
    });

    test('adds 30 days per month for the recommended age', () {
      final birth = DateTime(2024, 1, 1);
      final due = VaccineStatusCalculator.dueDateFor(
        birthDate: birth,
        recommendedAgeMonths: 2,
      );
      // 30 days * 2 = 60 days from 2024-01-01 = 2024-03-01 (2024 is leap year)
      expect(due, equals(DateTime(2024, 3, 1)));
    });

    test('handles a 12-month recommendation as 360 days', () {
      final birth = DateTime(2024, 1, 1);
      final due = VaccineStatusCalculator.dueDateFor(
        birthDate: birth,
        recommendedAgeMonths: 12,
      );
      // 30 days * 12 = 360 days from 2024-01-01 = 2024-12-26
      expect(due, equals(DateTime(2024, 12, 26)));
    });
  });

  group('VaccineStatusCalculator.isOverdue', () {
    final birth = DateTime(2024, 1, 1);
    const months = 2;

    test('is false when vaccine is completed regardless of date', () {
      final result = VaccineStatusCalculator.isOverdue(
        birthDate: birth,
        recommendedAgeMonths: months,
        isCompleted: true,
        now: DateTime(2026, 6, 1),
      );
      expect(result, isFalse);
    });

    test('is false when current date is on or before the due date', () {
      final onDueDate = VaccineStatusCalculator.isOverdue(
        birthDate: birth,
        recommendedAgeMonths: months,
        isCompleted: false,
        now: DateTime(2024, 3, 1, 12, 0),
      );
      final beforeDue = VaccineStatusCalculator.isOverdue(
        birthDate: birth,
        recommendedAgeMonths: months,
        isCompleted: false,
        now: DateTime(2024, 2, 28),
      );
      expect(onDueDate, isFalse);
      expect(beforeDue, isFalse);
    });

    test('is true when current date is strictly after the due date', () {
      final result = VaccineStatusCalculator.isOverdue(
        birthDate: birth,
        recommendedAgeMonths: months,
        isCompleted: false,
        now: DateTime(2024, 3, 2),
      );
      expect(result, isTrue);
    });
  });

  group('VaccineStatusCalculator.isDueReached', () {
    test('uses completed months from AgeCalculator (strict >=)', () {
      final birth = DateTime(2024, 1, 1);
      expect(
        VaccineStatusCalculator.isDueReached(
          birthDate: birth,
          recommendedAgeMonths: 2,
          now: DateTime(2024, 3, 1),
        ),
        isTrue,
      );
      expect(
        VaccineStatusCalculator.isDueReached(
          birthDate: birth,
          recommendedAgeMonths: 2,
          now: DateTime(2024, 2, 29),
        ),
        isFalse,
      );
    });

    test('respects day-of-month boundary (born on 31st)', () {
      final birth = DateTime(2024, 1, 31);
      final beforeAnniversary = VaccineStatusCalculator.isDueReached(
        birthDate: birth,
        recommendedAgeMonths: 1,
        now: DateTime(2024, 2, 29),
      );
      final afterAnniversary = VaccineStatusCalculator.isDueReached(
        birthDate: birth,
        recommendedAgeMonths: 1,
        now: DateTime(2024, 3, 30),
      );
      expect(beforeAnniversary, isFalse);
      expect(afterAnniversary, isTrue);
    });
  });

  group('VaccineStatusCalculator.computeStatus', () {
    final birth = DateTime(2024, 1, 1);
    const months = 2;

    test('returns completed when isCompleted is true', () {
      final status = VaccineStatusCalculator.computeStatus(
        birthDate: birth,
        recommendedAgeMonths: months,
        isCompleted: true,
        now: DateTime(2026, 6, 1),
      );
      expect(status, equals(VaccineStatus.completed));
    });

    test('returns overdue when past due date and not completed', () {
      final status = VaccineStatusCalculator.computeStatus(
        birthDate: birth,
        recommendedAgeMonths: months,
        isCompleted: false,
        now: DateTime(2024, 3, 15),
      );
      expect(status, equals(VaccineStatus.overdue));
    });

    test('returns due when age reached but still on/before due date', () {
      final status = VaccineStatusCalculator.computeStatus(
        birthDate: birth,
        recommendedAgeMonths: months,
        isCompleted: false,
        now: DateTime(2024, 3, 1, 8, 0),
      );
      expect(status, equals(VaccineStatus.due));
    });

    test('returns pending when age not yet reached', () {
      final status = VaccineStatusCalculator.computeStatus(
        birthDate: birth,
        recommendedAgeMonths: months,
        isCompleted: false,
        now: DateTime(2024, 2, 1),
      );
      expect(status, equals(VaccineStatus.pending));
    });
  });

  group('VaccineStatusX helpers', () {
    test('isOverdue / isCompleted / isPending getters', () {
      expect(VaccineStatus.overdue.isOverdue, isTrue);
      expect(VaccineStatus.overdue.isCompleted, isFalse);
      expect(VaccineStatus.completed.isCompleted, isTrue);
      expect(VaccineStatus.completed.isOverdue, isFalse);
      expect(VaccineStatus.pending.isPending, isTrue);
      expect(VaccineStatus.due.isPending, isTrue);
      expect(VaccineStatus.completed.isPending, isFalse);
    });

    test('label returns human-readable string', () {
      expect(VaccineStatus.completed.label, equals('Completada'));
      expect(VaccineStatus.overdue.label, equals('Atrasada'));
      expect(VaccineStatus.due.label, equals('Pendiente hoy'));
      expect(VaccineStatus.pending.label, equals('Pendiente'));
    });
  });
}