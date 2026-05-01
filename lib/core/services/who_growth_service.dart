import 'dart:convert';
import 'dart:math';
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

  String classifyZScore(double z) => z < -2 ? 'Bajo' : (z <= 2 ? 'Normal' : 'Alto');

  double zScoreToPercentile(double z) {
    return _normalCDF(z) * 100;
  }

  double _normalCDF(double z) {
    return 0.5 * (1 + _erf(z / sqrt(2)));
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
}

final whoGrowthService = WhoGrowthService();