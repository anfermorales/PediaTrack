import 'package:pediatrack/data/database/app_database.dart';

enum AppAlertType { vaccineOverdue, vaccineUpcoming, growthOutOfRange }
enum AppAlertPriority { high, medium, low }

class AppAlert {
  final AppAlertType type;
  final int childId;
  final String childName;
  final String title;
  final String message;
  final DateTime createdAt;
  final AppAlertPriority priority;

  const AppAlert({
    required this.type,
    required this.childId,
    required this.childName,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.priority,
  });
}

class VaccineScheduleItem {
  final VaccineDefinition definition;
  final ChildVaccine? appliedVaccine;
  final DateTime dueDate;
  final bool isOverdue;
  final bool isCompleted;

  VaccineScheduleItem({
    required this.definition,
    this.appliedVaccine,
    required this.dueDate,
    required this.isOverdue,
    required this.isCompleted,
  });
}
