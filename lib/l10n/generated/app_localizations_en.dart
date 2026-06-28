// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'PediaTrack';

  @override
  String get start => 'Home';

  @override
  String get growth => 'Growth';

  @override
  String get habits => 'Habits';

  @override
  String get vaccines => 'Vaccines';

  @override
  String get alerts => 'Alerts';

  @override
  String get exit => 'Exit';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get register => 'Register';

  @override
  String get confirm => 'Confirm';

  @override
  String get exitConfirm => 'Are you sure you want to exit PediaTrack?';

  @override
  String get childName => 'Name';

  @override
  String get birthDate => 'Birth Date';

  @override
  String get gender => 'Gender';

  @override
  String get selectChild => 'Select a child to view their information';

  @override
  String get selectChildForGrowth => 'Select a child to view their growth';

  @override
  String get selectChildForHabits => 'Select a child to view their habits';

  @override
  String get selectChildForAlerts =>
      'Select a child to view their health alerts';

  @override
  String get selectChildForVaccines => 'Select a child to view their vaccines';

  @override
  String get welcomeToPediaTrack => 'Welcome to PediaTrack!';

  @override
  String get welcomeSubtitle =>
      'Register your first child to start monitoring their growth and habits.';

  @override
  String get addFirstChild => 'Add First Child';

  @override
  String get selectChildTitle => 'Select Child';

  @override
  String get noChildSelected => 'Select a child to view their information';

  @override
  String get quickSuggestion => 'Quick suggestion';

  @override
  String get quickSuggestionSubtitle => 'For easier registration';

  @override
  String get quickSuggestionHint =>
      'Use the \"Register\" button to save Consultation or Habit from any main screen.';

  @override
  String get noData => 'No data';

  @override
  String get withoutData => 'No data';

  @override
  String get error => 'Error';

  @override
  String get age => 'Age';

  @override
  String get weight => 'Weight';

  @override
  String get height => 'Height';

  @override
  String get birthWeight => 'Birth weight';

  @override
  String get birthHeight => 'Birth height';

  @override
  String get birthData => 'Birth Data';

  @override
  String get birthDataSubtitle => 'Initial record';

  @override
  String get birthRecord => 'Initial record';

  @override
  String get recentGrowth => 'Recent Growth';

  @override
  String lastRecord(String date) {
    return 'Last record: $date';
  }

  @override
  String get noGrowthRecords => 'No growth records';

  @override
  String get addRecord => 'Add record';

  @override
  String get showRecords => 'Show:';

  @override
  String get fiveRecords => '5 records';

  @override
  String get tenRecords => '10 records';

  @override
  String get twentyRecords => '20 records';

  @override
  String get allRecords => 'All';

  @override
  String get recentRecords => 'Recent Records';

  @override
  String get whoGrowthCurves => 'WHO Growth Curves';

  @override
  String get weightCurve => 'Weight Curve';

  @override
  String get heightCurve => 'Height Curve';

  @override
  String get compareWithWHO => 'Comparison with WHO curves';

  @override
  String get growthHistory => 'Growth History';

  @override
  String monthsOfAge(int months) {
    return '$months months of age';
  }

  @override
  String get deleteRecord => 'Delete record';

  @override
  String get deleteRecordConfirm =>
      'Are you sure you want to delete this growth record?';

  @override
  String get habitsOfToday => 'Today\'s Habits';

  @override
  String get noRecordsToday => 'No records today';

  @override
  String todayRecords(int count) {
    return '$count records';
  }

  @override
  String get registerIntestinalHabits => 'Register today\'s intestinal habits.';

  @override
  String get vaccineTitle => 'Vaccines';

  @override
  String vaccinesCompleted(int completed, int upcoming, int overdue) {
    return '$completed completed, $upcoming upcoming, $overdue overdue';
  }

  @override
  String overdueVaccines(int count) {
    return '$count overdue vaccine(s)';
  }

  @override
  String upcomingVaccines(int count) {
    return '$count upcoming vaccine(s) this month';
  }

  @override
  String get measureRecord => 'Record Measures';

  @override
  String get heightCm => 'Height (cm)';

  @override
  String get headCircumference => 'Head circumference (cm)';

  @override
  String get bothFieldsOptional => 'Both fields are optional';

  @override
  String get enterAtLeastOneMeasure => 'Enter at least one measure';

  @override
  String get measuresRegistered => 'Measures registered';

  @override
  String get measureUnit => 'cm';

  @override
  String get weightUnit => 'lb';

  @override
  String get date => 'Date';

  @override
  String get settings => 'Settings';

  @override
  String get autoBackup => 'Automatic Backup';

  @override
  String get autoBackupTitle => 'Automatic backup';

  @override
  String get autoBackupSubtitle => 'Create backup daily';

  @override
  String get backupTime => 'Backup time';

  @override
  String get backupFolder => 'Backup folder';

  @override
  String get folderName => 'Folder name';

  @override
  String get folderHint => 'e.g., PediaTrack';

  @override
  String get nextBackup => 'Next backup';

  @override
  String get runNow => 'Run now';

  @override
  String get runNowSubtitle => 'Generate backup manually';

  @override
  String get forceAutoBackup => 'Force automatic backup';

  @override
  String get forceAutoBackupSubtitle => 'Backup system test';

  @override
  String get lastBackup => 'Last backup';

  @override
  String get lastBackupAuto => 'Last automatic';

  @override
  String get lastBackupManual => 'Last manual';

  @override
  String get automaticLabel => 'Automatic';

  @override
  String get manualLabel => 'Manual';

  @override
  String get generatingBackup => 'Generating backup...';

  @override
  String backupGenerated(String path) {
    return 'Backup saved at: $path';
  }

  @override
  String nextBackupScheduled(String datetime) {
    return 'Next backup: $datetime';
  }

  @override
  String get exportImport => 'Export / Import';

  @override
  String get exportData => 'Export data';

  @override
  String get exportDataSubtitle => 'Share or download JSON and Excel backup';

  @override
  String get importBackup => 'Import backup';

  @override
  String get importBackupSubtitle => 'Load a JSON backup file';

  @override
  String get importBackupConfirm =>
      'This will replace all current data. Continue?';

  @override
  String get importSuccess => 'Backup imported successfully';

  @override
  String get shareJson => 'Share JSON';

  @override
  String get shareJsonSubtitle => 'Send via email or WhatsApp';

  @override
  String get downloadJson => 'Download JSON';

  @override
  String get downloadJsonSubtitle => 'Save file locally';

  @override
  String get shareExcel => 'Share Excel';

  @override
  String get shareExcelSubtitle => 'Send via email or WhatsApp';

  @override
  String get downloadExcel => 'Download Excel';

  @override
  String get downloadExcelSubtitle => 'Save file locally';

  @override
  String get backupReadyToShare => 'JSON backup ready to share';

  @override
  String get backupReadyToShareExcel => 'Excel backup ready to share';

  @override
  String exportError(String error) {
    return 'Could not export: $error';
  }

  @override
  String get saveBackup => 'Save backup';

  @override
  String jsonBackupSaved(String path) {
    return 'Backup saved at: $path';
  }

  @override
  String excelSaved(String path) {
    return 'Excel saved at: $path';
  }

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get versionNumber => '1.0.0';

  @override
  String get developedWith => 'Developed with';

  @override
  String get developedWithValue => 'Flutter + Riverpod';

  @override
  String get child => 'child';

  @override
  String get childNotFound => 'child not found';

  @override
  String get masculine => 'Male';

  @override
  String get femenine => 'Female';

  @override
  String get boy => 'Boy';

  @override
  String get girl => 'Girl';

  @override
  String get habitType => 'Habit type';

  @override
  String get normalEvacuation => 'Normal evacuation';

  @override
  String get constipation => 'Constipation';

  @override
  String get diarrhea => 'Diarrhea';

  @override
  String get feeding => 'Feeding';

  @override
  String get sleep => 'Sleep';

  @override
  String get hydration => 'Hydration';

  @override
  String get medication => 'Medication';

  @override
  String get otherHabit => 'Other habit';

  @override
  String get observations => 'Observations (optional)';

  @override
  String get observationsOptional => 'Observations (optional)';

  @override
  String get addChild => 'Add child';

  @override
  String get editChild => 'Edit child';

  @override
  String get enterChildName => 'Enter the child\'s name';

  @override
  String childAdded(String name) {
    return '$name added successfully';
  }

  @override
  String childUpdated(String name) {
    return '$name updated successfully';
  }

  @override
  String get consultationRecord => 'Consultation Record';

  @override
  String get weightHeightHead => 'Weight, Height and Head Circumference';

  @override
  String get enterAtLeastOneValue =>
      'Enter at least one value. Others are optional.';

  @override
  String get recordSaved => 'Record saved successfully';

  @override
  String get registerHabit => 'Register Habit';

  @override
  String get selectHabit => 'Select habit';

  @override
  String get habitRegistered => 'Habit registered successfully';

  @override
  String get stats => 'Statistics';

  @override
  String get noEnoughData => 'Not enough data';

  @override
  String get registerDaysForStats =>
      'Register at least 3 days to see statistics';

  @override
  String get frequency => 'Frequency';

  @override
  String get total => 'Total';

  @override
  String get constipationDays => 'Constipation';

  @override
  String get timesPerWeek => 'times/week';

  @override
  String get records => 'records';

  @override
  String get days => 'days';

  @override
  String get distribution => 'Distribution:';

  @override
  String get normal => 'Normal';

  @override
  String get evaluating => 'Evaluating...';

  @override
  String get noPreviousData => 'No previous data';

  @override
  String get improving => 'Improving';

  @override
  String get worsening => 'Worsening';

  @override
  String get noChanges => 'No changes';

  @override
  String get historyOfDefecations => 'Defecation History';

  @override
  String get historySubtitle => 'Complete record';

  @override
  String get noRecords => 'No records';

  @override
  String recordsCount(int count) {
    return '$count record(s)';
  }

  @override
  String get deleteHabit => 'Delete habit';

  @override
  String get deleteHabitConfirm =>
      'Are you sure you want to delete this habit record?';

  @override
  String get editHabit => 'Edit habit';

  @override
  String get dateAndTime => 'Date and time';

  @override
  String get emptyAlerts => 'No Alerts!';

  @override
  String get noPendingNotifications => 'No pending notifications';

  @override
  String get noAlertsForSelectedChild => 'No alerts for the selected child';

  @override
  String dose(int current, int total) {
    return 'Dose $current/$total';
  }

  @override
  String get pending => 'Pending';

  @override
  String get completed => 'Completed';

  @override
  String get all => 'All';

  @override
  String get completedStatus => 'Completed';

  @override
  String get overdueStatus => 'Overdue';

  @override
  String get pendingStatus => 'Pending';

  @override
  String get recommendedDate => 'Recommended date';

  @override
  String get applied => 'Applied';

  @override
  String get touchToRegister => 'Tap to register';

  @override
  String get editVaccine => 'Edit Vaccine';

  @override
  String get registerVaccine => 'Register Vaccine';

  @override
  String get vaccine => 'Vaccine';

  @override
  String get batchOptional => 'Batch (optional)';

  @override
  String get batchNumber => 'Batch number (optional)';

  @override
  String get vaccineUpdated => 'Vaccine updated';

  @override
  String get vaccineRegistered => 'Vaccine registered';

  @override
  String get recordsTitle => 'Records';

  @override
  String get currentWeight => 'Current weight';

  @override
  String get currentHeight => 'Current height';

  @override
  String currentRecords(int count) {
    return '$count records';
  }

  @override
  String get atBirth => 'at birth';

  @override
  String get atMonth => 'at 1 month';

  @override
  String atMonths(int months) {
    return 'at $months months';
  }

  @override
  String get atYear => 'at 1 year';

  @override
  String atYears(int years) {
    return 'at $years years';
  }

  @override
  String atYearsAndMonths(int years, int months) {
    return 'at $years years and $months months';
  }

  @override
  String atYearsAndOneMonth(int years) {
    return 'at $years years and 1 month';
  }

  @override
  String get intestinalHabitControl => 'Intestinal Habits Control';

  @override
  String recommendedAtMonths(int months) {
    return 'Recommended at $months months';
  }

  @override
  String get vaccineAdded => 'Vaccine registered!';

  @override
  String get addVaccine => 'Add';

  @override
  String get addVaccineTitle => 'Add Vaccine';

  @override
  String get selectVaccine => 'Select a vaccine';

  @override
  String get vaccineAddedSuccess => 'Vaccine added';

  @override
  String get vaccineDeleted => 'Vaccine deleted';

  @override
  String deleteVaccineConfirm(String name) {
    return 'Delete the record for $name?';
  }

  @override
  String get noVaccinesPending => 'No pending vaccines!';

  @override
  String get noCompletedVaccines => 'No completed vaccines yet';

  @override
  String get noVaccinesRegistered => 'No vaccines registered';

  @override
  String get addFirstVaccines => 'Add the first vaccines to start tracking';

  @override
  String get loading => 'Loading...';

  @override
  String get searchingChild => 'Searching child...';

  @override
  String get years => 'years';

  @override
  String get year => 'year';

  @override
  String get months => 'months';

  @override
  String get month => 'month';

  @override
  String get lb => 'lb';

  @override
  String get cm => 'cm';
}
