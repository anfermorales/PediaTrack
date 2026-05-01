class GrowthPercentiles {
  static const Map<int, WeightHeightPercentiles> boysWeight = {
    0: WeightHeightPercentiles(p3: 2.5, p50: 3.3, p97: 4.4),
    1: WeightHeightPercentiles(p3: 3.4, p50: 4.3, p97: 5.6),
    2: WeightHeightPercentiles(p3: 4.3, p50: 5.5, p97: 7.0),
    3: WeightHeightPercentiles(p3: 5.0, p50: 6.4, p97: 8.0),
    4: WeightHeightPercentiles(p3: 5.6, p50: 7.0, p97: 8.7),
    5: WeightHeightPercentiles(p3: 6.0, p50: 7.5, p97: 9.3),
    6: WeightHeightPercentiles(p3: 6.4, p50: 7.9, p97: 9.8),
    7: WeightHeightPercentiles(p3: 6.7, p50: 8.3, p97: 10.3),
    8: WeightHeightPercentiles(p3: 6.9, p50: 8.6, p97: 10.7),
    9: WeightHeightPercentiles(p3: 7.1, p50: 8.9, p97: 11.1),
    10: WeightHeightPercentiles(p3: 7.4, p50: 9.2, p97: 11.4),
    11: WeightHeightPercentiles(p3: 7.6, p50: 9.4, p97: 11.7),
    12: WeightHeightPercentiles(p3: 7.7, p50: 9.6, p97: 12.0),
  };

  static const Map<int, WeightHeightPercentiles> boysHeight = {
    0: WeightHeightPercentiles(p3: 46.3, p50: 49.9, p97: 53.4),
    1: WeightHeightPercentiles(p3: 50.8, p50: 54.7, p97: 58.6),
    2: WeightHeightPercentiles(p3: 54.4, p50: 58.4, p97: 62.4),
    3: WeightHeightPercentiles(p3: 57.3, p50: 61.4, p97: 65.5),
    4: WeightHeightPercentiles(p3: 59.7, p50: 63.9, p97: 68.0),
    5: WeightHeightPercentiles(p3: 61.7, p50: 65.9, p97: 70.1),
    6: WeightHeightPercentiles(p3: 63.3, p50: 67.6, p97: 71.9),
    7: WeightHeightPercentiles(p3: 64.8, p50: 69.2, p97: 73.5),
    8: WeightHeightPercentiles(p3: 66.2, p50: 70.6, p97: 75.0),
    9: WeightHeightPercentiles(p3: 67.5, p50: 72.0, p97: 76.5),
    10: WeightHeightPercentiles(p3: 68.7, p50: 73.3, p97: 78.0),
    11: WeightHeightPercentiles(p3: 69.9, p50: 74.5, p97: 79.2),
    12: WeightHeightPercentiles(p3: 71.0, p50: 75.7, p97: 80.5),
  };

  static const Map<int, WeightHeightPercentiles> girlsWeight = {
    0: WeightHeightPercentiles(p3: 2.4, p50: 3.2, p97: 4.2),
    1: WeightHeightPercentiles(p3: 3.2, p50: 4.0, p97: 5.3),
    2: WeightHeightPercentiles(p3: 3.9, p50: 5.0, p97: 6.4),
    3: WeightHeightPercentiles(p3: 4.5, p50: 5.7, p97: 7.3),
    4: WeightHeightPercentiles(p3: 5.0, p50: 6.4, p97: 8.1),
    5: WeightHeightPercentiles(p3: 5.4, p50: 6.9, p97: 8.8),
    6: WeightHeightPercentiles(p3: 5.7, p50: 7.3, p97: 9.4),
    7: WeightHeightPercentiles(p3: 6.0, p50: 7.6, p97: 9.9),
    8: WeightHeightPercentiles(p3: 6.3, p50: 8.0, p97: 10.3),
    9: WeightHeightPercentiles(p3: 6.5, p50: 8.3, p97: 10.8),
    10: WeightHeightPercentiles(p3: 6.7, p50: 8.5, p97: 11.2),
    11: WeightHeightPercentiles(p3: 6.9, p50: 8.8, p97: 11.6),
    12: WeightHeightPercentiles(p3: 7.0, p50: 9.0, p97: 12.0),
  };

  static const Map<int, WeightHeightPercentiles> girlsHeight = {
    0: WeightHeightPercentiles(p3: 45.6, p50: 49.1, p97: 52.5),
    1: WeightHeightPercentiles(p3: 49.8, p50: 53.7, p97: 57.5),
    2: WeightHeightPercentiles(p3: 53.0, p50: 57.1, p97: 61.1),
    3: WeightHeightPercentiles(p3: 55.6, p50: 59.8, p97: 63.9),
    4: WeightHeightPercentiles(p3: 57.8, p50: 62.1, p97: 66.3),
    5: WeightHeightPercentiles(p3: 59.6, p50: 64.0, p97: 68.3),
    6: WeightHeightPercentiles(p3: 61.2, p50: 65.7, p97: 70.1),
    7: WeightHeightPercentiles(p3: 62.7, p50: 67.3, p97: 71.8),
    8: WeightHeightPercentiles(p3: 64.0, p50: 68.7, p97: 73.5),
    9: WeightHeightPercentiles(p3: 65.3, p50: 70.1, p97: 75.0),
    10: WeightHeightPercentiles(p3: 66.5, p50: 71.5, p97: 76.4),
    11: WeightHeightPercentiles(p3: 67.7, p50: 72.8, p97: 77.8),
    12: WeightHeightPercentiles(p3: 68.9, p50: 74.0, p97: 79.2),
  };
}

class WeightHeightPercentiles {
  final double p3;
  final double p50;
  final double p97;

  const WeightHeightPercentiles({
    required this.p3,
    required this.p50,
    required this.p97,
  });
}
