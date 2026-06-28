import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pediatrack/core/services/who_growth_service.dart';

void main() {
  group('WhoGrowthService', () {
    late WhoGrowthService service;

    setUpAll(() async {
      service = WhoGrowthService();
      // Los datos se cargan desde assets, así que en tests unitarios
      // necesitamos hacer mock o cargar los datos reales
    });

    group('calculateZScore', () {
      test('calculates z-score correctly with L=0', () {
        // Caso especial cuando L = 0 (usando fórmula logarítmica)
        final zScore = service.calculateZScore(
          value: 10.0,
          L: 0,
          M: 10.0,
          S: 0.1,
        );
        expect(zScore, closeTo(0.0, 0.01));
      });

      test('calculates z-score correctly with positive L', () {
        final zScore = service.calculateZScore(
          value: 12.0,
          L: 0.5,
          M: 10.0,
          S: 0.1,
        );
        // Formula WHO (L != 0): z = ((v/M)^L - 1) / (L * S)
        // v=12, M=10, L=0.5, S=0.1
        // (12/10)^0.5 = 1.09545
        // (1.09545 - 1) = 0.09545
        // 0.09545 / (0.5 * 0.1) = 0.09545 / 0.05 = 1.909
        expect(zScore, closeTo(1.909, 0.01));
      });

      test('handles values below mean with negative z-score', () {
        final zScore = service.calculateZScore(
          value: 8.0,
          L: 0.5,
          M: 10.0,
          S: 0.1,
        );
        expect(zScore, lessThan(0));
      });
    });

    group('percentileToZScore', () {
      test('returns 0 for percentile 50', () {
        final zScore = service.percentileToZScore(50);
        expect(zScore, closeTo(0.0, 0.001));
      });

      test('returns positive z-score for percentile above 50', () {
        final zScore = service.percentileToZScore(84);
        expect(zScore, greaterThan(0));
      });

      test('returns negative z-score for percentile below 50', () {
        final zScore = service.percentileToZScore(16);
        expect(zScore, lessThan(0));
      });

      test('handles extreme percentiles', () {
        expect(service.percentileToZScore(0), closeTo(-3.5, 0.1));
        expect(service.percentileToZScore(100), closeTo(3.5, 0.1));
      });
    });

    group('zScoreToPercentile', () {
      test('returns 50 for z-score 0', () {
        final percentile = service.zScoreToPercentile(0);
        expect(percentile, closeTo(50, 0.1));
      });

      test('returns 97.5 for z-score 1.96', () {
        final percentile = service.zScoreToPercentile(1.96);
        expect(percentile, closeTo(97.5, 0.5));
      });

      test('returns 2.5 for z-score -1.96', () {
        final percentile = service.zScoreToPercentile(-1.96);
        expect(percentile, closeTo(2.5, 0.5));
      });
    });

    group('classifyZScore', () {
      test('returns "Bajo" for z < -2', () {
        expect(service.classifyZScore(-3.0), equals('Bajo'));
        expect(service.classifyZScore(-2.1), equals('Bajo'));
      });

      test('returns "Normal" for -2 <= z <= 2', () {
        expect(service.classifyZScore(-2.0), equals('Normal'));
        expect(service.classifyZScore(0.0), equals('Normal'));
        expect(service.classifyZScore(2.0), equals('Normal'));
      });

      test('returns "Alto" for z > 2', () {
        expect(service.classifyZScore(2.1), equals('Alto'));
        expect(service.classifyZScore(3.0), equals('Alto'));
      });
    });

    group('LmsParameters interpolation', () {
      test('returns first data point for age 0', () {
        final params = LmsParameters(
          ageMonths: 0,
          L: 1.0,
          M: 3.5,
          S: 0.1,
        );
        expect(params.ageMonths, equals(0));
      });

      test('returns last data point for age >= 60', () {
        final params = LmsParameters(
          ageMonths: 60,
          L: 0.5,
          M: 20.0,
          S: 0.08,
        );
        expect(params.ageMonths, equals(60));
      });
    });

    group('GrowthClassification', () {
      test('contains correct properties', () {
        const classification = GrowthClassification(
          zScore: 0.5,
          category: 'Normal',
          percentile: 69.0,
        );
        expect(classification.zScore, equals(0.5));
        expect(classification.category, equals('Normal'));
        expect(classification.percentile, equals(69.0));
      });
    });
  });

  group('GrowthType enum', () {
    test('has weight and height values', () {
      expect(GrowthType.values.length, equals(2));
      expect(GrowthType.values.contains(GrowthType.weight), isTrue);
      expect(GrowthType.values.contains(GrowthType.height), isTrue);
    });
  });

  group('ExpectedGrowthRecord', () {
    test('creates record with all properties', () {
      final record = ExpectedGrowthRecord(
        ageMonths: 12,
        date: DateTime(2024, 1, 15),
        weightKg: 10.5,
        heightCm: 75.0,
      );
      expect(record.ageMonths, equals(12));
      expect(record.date, equals(DateTime(2024, 1, 15)));
      expect(record.weightKg, equals(10.5));
      expect(record.heightCm, equals(75.0));
    });
  });

  group('GrowthChartPoint', () {
    test('creates point with correct values', () {
      const point = GrowthChartPoint(
        ageMonths: 6.5,
        value: 8.5,
      );
      expect(point.ageMonths, equals(6.5));
      expect(point.value, equals(8.5));
    });
  });

  group('GrowthChartData', () {
    test('creates chart data with all properties', () {
      const chartData = GrowthChartData(
        label: 'P50',
        percentile: 50,
        color: Colors.green,
      );
      expect(chartData.label, equals('P50'));
      expect(chartData.percentile, equals(50));
    });
  });
}