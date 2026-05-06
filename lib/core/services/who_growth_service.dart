import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum GrowthType { weight, height }

class LmsParameters {
  final int ageMonths;
  final double L;
  final double M;
  final double S;

  const LmsParameters({
    required this.ageMonths,
    required this.L,
    required this.M,
    required this.S,
  });
}

class GrowthClassification {
  final double zScore;
  final String category;
  final double percentile;

  const GrowthClassification({
    required this.zScore,
    required this.category,
    required this.percentile,
  });
}

class WhoGrowthService {
  WhoGrowthService();

  List<LmsParameters> _weightMale = [];
  List<LmsParameters> _weightFemale = [];
  List<LmsParameters> _heightMale = [];
  List<LmsParameters> _heightFemale = [];
  bool _isLoaded = false;

  Future<void> loadData() async {
    if (_isLoaded) return;
    _weightMale = await _loadFromAsset('assets/who/weight_male.json');
    _weightFemale = await _loadFromAsset('assets/who/weight_female.json');
    _heightMale = await _loadFromAsset('assets/who/height_male.json');
    _heightFemale = await _loadFromAsset('assets/who/height_female.json');
    _isLoaded = true;
  }

  Future<List<LmsParameters>> _loadFromAsset(String path) async {
    final String jsonString = await rootBundle.loadString(path);
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((item) => LmsParameters(
      ageMonths: item['ageMonths'] as int,
      L: (item['L'] as num).toDouble(),
      M: (item['M'] as num).toDouble(),
      S: (item['S'] as num).toDouble(),
    )).toList();
  }

  double calculateZScore({required double value, required double L, required double M, required double S}) {
    if (L == 0) return log(value / M) / S;
    return (pow(value / M, L) - 1) / (L * S);
  }

  double percentileToZScore(double percentile) {
    return _inverseNormalCDF(percentile / 100);
  }

  double zScoreToPercentile(double z) {
    return _normalCDF(z) * 100;
  }

  double _normalCDF(double z) {
    return 0.5 * (1 + _erf(z / sqrt(2)));
  }

  double _inverseNormalCDF(double p) {
    if (p <= 0) return -3.5;
    if (p >= 1) return 3.5;
    if (p == 0.5) return 0;
    final t = sqrt(-2 * log(p < 0.5 ? p : 1 - p));
    final c0 = 2.515517;
    final c1 = 0.802853;
    final c2 = 0.010328;
    final d1 = 1.432788;
    final d2 = 0.189269;
    final d3 = 0.001308;
    return (p < 0.5 ? -1 : 1) * (t - ((t * c0 + c1) * t + c2) / (((t * d1 + d2) * t + d3) * t + 1));
  }

  double _erf(double x) {
    final t = 1.0 / (1.0 + 0.5 * x.abs());
    final tau = t * exp(-x * x - 1.26551223 +
        t * (1.00002368 +
            t * (0.37409196 +
                t * (0.09678418 +
                    t * (-0.18628806 +
                        t * (0.27886807 +
                            t * (-1.13520398 +
                                t * (1.48851587 +
                                    t * (-0.82215223 + t * 0.17087277)))))))));
    return x >= 0 ? 1 - tau : tau - 1;
  }

  LmsParameters _interpolateParameters(List<LmsParameters> data, double ageMonths) {
    if (ageMonths <= 0) return data.first;
    if (ageMonths >= 60) return data.last;
    final lowerAge = ageMonths.floor();
    final upperAge = lowerAge + 1;
    final lowerData = data.firstWhere((p) => p.ageMonths == lowerAge, orElse: () => data.first);
    final upperData = data.firstWhere((p) => p.ageMonths == upperAge, orElse: () => data.last);
    final fraction = ageMonths - lowerAge;
    return LmsParameters(
      ageMonths: ageMonths.round(),
      L: lowerData.L + (upperData.L - lowerData.L) * fraction,
      M: lowerData.M + (upperData.M - lowerData.M) * fraction,
      S: lowerData.S + (upperData.S - lowerData.S) * fraction,
    );
  }

  double valueFromPercentile({required double percentile, required int ageMonths, required int gender, required GrowthType type}) {
    final data = _getDataForTypeAndGender(type, gender);
    final params = _interpolateParameters(data, ageMonths.toDouble());
    final zScore = percentileToZScore(percentile);
    return _zScoreToValue(zScore: zScore, L: params.L, M: params.M, S: params.S);
  }

  double _zScoreToValue({required double zScore, required double L, required double M, required double S}) {
    if (L == 0) return M * exp(S * zScore);
    return M * pow(1 + L * S * zScore, 1 / L);
  }

  GrowthClassification evaluate({required double value, required int ageMonths, required int gender, required GrowthType type}) {
    final data = _getDataForTypeAndGender(type, gender);
    final params = _interpolateParameters(data, ageMonths.toDouble());
    final zScore = calculateZScore(value: value, L: params.L, M: params.M, S: params.S);
    return GrowthClassification(
      zScore: zScore,
      category: classifyZScore(zScore),
      percentile: zScoreToPercentile(zScore).clamp(0, 100),
    );
  }

  List<LmsParameters> _getDataForTypeAndGender(GrowthType type, int gender) {
    if (type == GrowthType.weight) {
      return gender == 0 ? _weightMale : _weightFemale;
    } else {
      return gender == 0 ? _heightMale : _heightFemale;
    }
  }

  String classifyZScore(double z) => z < -2 ? 'Bajo' : (z <= 2 ? 'Normal' : 'Alto');

  List<GrowthChartPoint> getPercentileCurve({required int gender, required GrowthType type, required double percentile}) {
    final data = _getDataForTypeAndGender(type, gender);
    final List<GrowthChartPoint> points = [];
    for (int ageMonths = 0; ageMonths <= 60; ageMonths++) {
      final params = _interpolateParameters(data, ageMonths.toDouble());
      final zScore = percentileToZScore(percentile);
      final value = _zScoreToValue(zScore: zScore, L: params.L, M: params.M, S: params.S);
      points.add(GrowthChartPoint(ageMonths: ageMonths.toDouble(), value: value));
    }
    return points;
  }

  List<GrowthChartData> getAllPercentileCurves({required int gender, required GrowthType type}) {
    return [
      GrowthChartData(label: 'P3', percentile: 3, color: Colors.orange),
      GrowthChartData(label: 'P15', percentile: 15, color: Colors.yellow[700]!),
      GrowthChartData(label: 'P50', percentile: 50, color: Colors.green),
      GrowthChartData(label: 'P85', percentile: 85, color: Colors.yellow[700]!),
      GrowthChartData(label: 'P97', percentile: 97, color: Colors.orange),
    ];
  }

  List<ExpectedGrowthRecord> getExpectedRecordsAtMonth({
    required DateTime birthDate,
    required int gender,
    required int fromMonth,
    required int toMonth,
  }) {
    final List<ExpectedGrowthRecord> records = [];
    for (int month = fromMonth; month <= toMonth; month++) {
      final weight = valueFromPercentile(percentile: 50, ageMonths: month, gender: gender, type: GrowthType.weight);
      final height = valueFromPercentile(percentile: 50, ageMonths: month, gender: gender, type: GrowthType.height);
      final date = DateTime(birthDate.year, birthDate.month + month, birthDate.day);
      records.add(ExpectedGrowthRecord(
        ageMonths: month,
        date: date,
        weightKg: weight,
        heightCm: height,
      ));
    }
    return records;
  }
}

class ExpectedGrowthRecord {
  final int ageMonths;
  final DateTime date;
  final double weightKg;
  final double heightCm;

  const ExpectedGrowthRecord({
    required this.ageMonths,
    required this.date,
    required this.weightKg,
    required this.heightCm,
  });
}

class GrowthChartPoint {
  final double ageMonths;
  final double value;

  const GrowthChartPoint({required this.ageMonths, required this.value});
}

class GrowthChartData {
  final String label;
  final double percentile;
  final Color color;

  const GrowthChartData({required this.label, required this.percentile, required this.color});
}

final whoGrowthService = WhoGrowthService();