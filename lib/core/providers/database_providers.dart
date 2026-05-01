import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pediatrack/data/database/app_database.dart';
import 'package:pediatrack/core/services/who_growth_service.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final whoGrowthServiceProvider = Provider<WhoGrowthService>((ref) {
  return whoGrowthService;
});

final childrenStreamProvider = StreamProvider<List<ChildrenData>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAllChildren();
});

final childProvider = FutureProvider.family<ChildrenData?, int>((ref, id) async {
  final db = ref.watch(databaseProvider);
  return db.getChildById(id);
});

final growthRecordsStreamProvider =
    StreamProvider.family<List<GrowthRecord>, int>((ref, childId) {
  final db = ref.watch(databaseProvider);
  return db.watchGrowthRecordsForChild(childId);
});

final todayHabitsProvider =
    FutureProvider.family<List<HabitRecord>, int>((ref, childId) async {
  final db = ref.watch(databaseProvider);
  return db.getTodayHabitsForChild(childId);
});

final selectedChildIdProvider = StateProvider<int?>((ref) => null);

final unprocessedAlertsCountProvider = Provider<int>((ref) => 0);

class GrowthEvaluationParams {
  final double value;
  final int ageMonths;
  final int gender;
  final GrowthType type;

  const GrowthEvaluationParams({
    required this.value,
    required this.ageMonths,
    required this.gender,
    required this.type,
  });
}

class GrowthEvaluationResult {
  final double zScore;
  final String category;
  final double percentile;

  const GrowthEvaluationResult({
    required this.zScore,
    required this.category,
    required this.percentile,
  });
}

final growthEvaluationProvider = Provider.family<GrowthEvaluationResult, GrowthEvaluationParams>(
  (ref, params) {
    final service = ref.watch(whoGrowthServiceProvider);
    final result = service.evaluate(
      value: params.value,
      ageMonths: params.ageMonths,
      gender: params.gender,
      type: params.type,
    );
    return GrowthEvaluationResult(
      zScore: result.zScore,
      category: result.category,
      percentile: result.percentile,
    );
  },
);