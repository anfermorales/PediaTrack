import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('es'),
    Locale('en')
  ];

  /// The application name
  ///
  /// In es, this message translates to:
  /// **'PediaTrack'**
  String get appName;

  /// No description provided for @start.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get start;

  /// No description provided for @growth.
  ///
  /// In es, this message translates to:
  /// **'Crecimiento'**
  String get growth;

  /// No description provided for @habits.
  ///
  /// In es, this message translates to:
  /// **'Hábitos'**
  String get habits;

  /// No description provided for @vaccines.
  ///
  /// In es, this message translates to:
  /// **'Vacunas'**
  String get vaccines;

  /// No description provided for @alerts.
  ///
  /// In es, this message translates to:
  /// **'Alertas'**
  String get alerts;

  /// No description provided for @exit.
  ///
  /// In es, this message translates to:
  /// **'Salir'**
  String get exit;

  /// No description provided for @cancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In es, this message translates to:
  /// **'Editar'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In es, this message translates to:
  /// **'Agregar'**
  String get add;

  /// No description provided for @register.
  ///
  /// In es, this message translates to:
  /// **'Registrar'**
  String get register;

  /// No description provided for @confirm.
  ///
  /// In es, this message translates to:
  /// **'Confirmar'**
  String get confirm;

  /// No description provided for @exitConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de que quieres salir de PediaTrack?'**
  String get exitConfirm;

  /// No description provided for @pressBackAgainToExit.
  ///
  /// In es, this message translates to:
  /// **'Presiona de nuevo para salir'**
  String get pressBackAgainToExit;

  /// No description provided for @childName.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get childName;

  /// No description provided for @birthDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha de Nacimiento'**
  String get birthDate;

  /// No description provided for @gender.
  ///
  /// In es, this message translates to:
  /// **'Género'**
  String get gender;

  /// No description provided for @selectChild.
  ///
  /// In es, this message translates to:
  /// **'Selecciona un niño para ver su información'**
  String get selectChild;

  /// No description provided for @selectChildForGrowth.
  ///
  /// In es, this message translates to:
  /// **'Selecciona un niño para ver su crecimiento'**
  String get selectChildForGrowth;

  /// No description provided for @selectChildForHabits.
  ///
  /// In es, this message translates to:
  /// **'Selecciona un niño para ver sus Hábitos'**
  String get selectChildForHabits;

  /// No description provided for @selectChildForAlerts.
  ///
  /// In es, this message translates to:
  /// **'Selecciona un niño para ver sus alertas de salud'**
  String get selectChildForAlerts;

  /// No description provided for @selectChildForVaccines.
  ///
  /// In es, this message translates to:
  /// **'Selecciona un niño para ver sus vacunas'**
  String get selectChildForVaccines;

  /// No description provided for @welcomeToPediaTrack.
  ///
  /// In es, this message translates to:
  /// **'¡Bienvenido a PediaTrack!'**
  String get welcomeToPediaTrack;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Registra a tu primer niño para comenzar a monitorear su crecimiento y Hábitos.'**
  String get welcomeSubtitle;

  /// No description provided for @addFirstChild.
  ///
  /// In es, this message translates to:
  /// **'Agregar Primer niño'**
  String get addFirstChild;

  /// No description provided for @selectChildTitle.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar Hijo'**
  String get selectChildTitle;

  /// No description provided for @noChildSelected.
  ///
  /// In es, this message translates to:
  /// **'Selecciona un niño para ver su información'**
  String get noChildSelected;

  /// No description provided for @quickSuggestion.
  ///
  /// In es, this message translates to:
  /// **'Sugerencia rápida'**
  String get quickSuggestion;

  /// No description provided for @quickSuggestionSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Para registrar más fácil'**
  String get quickSuggestionSubtitle;

  /// No description provided for @quickSuggestionHint.
  ///
  /// In es, this message translates to:
  /// **'Usa el botón \"Registrar\" para guardar Consulta o Hábito desde cualquier pantalla principal.'**
  String get quickSuggestionHint;

  /// No description provided for @noData.
  ///
  /// In es, this message translates to:
  /// **'Sin dato'**
  String get noData;

  /// No description provided for @withoutData.
  ///
  /// In es, this message translates to:
  /// **'Sin dato'**
  String get withoutData;

  /// No description provided for @error.
  ///
  /// In es, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @age.
  ///
  /// In es, this message translates to:
  /// **'Edad'**
  String get age;

  /// No description provided for @weight.
  ///
  /// In es, this message translates to:
  /// **'Peso'**
  String get weight;

  /// No description provided for @height.
  ///
  /// In es, this message translates to:
  /// **'Estatura'**
  String get height;

  /// No description provided for @birthWeight.
  ///
  /// In es, this message translates to:
  /// **'Peso al nacer'**
  String get birthWeight;

  /// No description provided for @birthHeight.
  ///
  /// In es, this message translates to:
  /// **'Estatura al nacer'**
  String get birthHeight;

  /// No description provided for @birthData.
  ///
  /// In es, this message translates to:
  /// **'Datos al Nacer'**
  String get birthData;

  /// No description provided for @birthDataSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Registro inicial'**
  String get birthDataSubtitle;

  /// No description provided for @birthRecord.
  ///
  /// In es, this message translates to:
  /// **'Registro inicial'**
  String get birthRecord;

  /// No description provided for @recentGrowth.
  ///
  /// In es, this message translates to:
  /// **'Crecimiento Reciente'**
  String get recentGrowth;

  /// No description provided for @lastRecord.
  ///
  /// In es, this message translates to:
  /// **'Último registro: {date}'**
  String lastRecord(String date);

  /// No description provided for @noGrowthRecords.
  ///
  /// In es, this message translates to:
  /// **'Sin registros de crecimiento'**
  String get noGrowthRecords;

  /// No description provided for @addRecord.
  ///
  /// In es, this message translates to:
  /// **'Agregar registro'**
  String get addRecord;

  /// No description provided for @showRecords.
  ///
  /// In es, this message translates to:
  /// **'Mostrar:'**
  String get showRecords;

  /// No description provided for @fiveRecords.
  ///
  /// In es, this message translates to:
  /// **'5 registros'**
  String get fiveRecords;

  /// No description provided for @tenRecords.
  ///
  /// In es, this message translates to:
  /// **'10 registros'**
  String get tenRecords;

  /// No description provided for @twentyRecords.
  ///
  /// In es, this message translates to:
  /// **'20 registros'**
  String get twentyRecords;

  /// No description provided for @allRecords.
  ///
  /// In es, this message translates to:
  /// **'Todos'**
  String get allRecords;

  /// No description provided for @recentRecords.
  ///
  /// In es, this message translates to:
  /// **'Registros Recientes'**
  String get recentRecords;

  /// No description provided for @whoGrowthCurves.
  ///
  /// In es, this message translates to:
  /// **'Curvas de Crecimiento OMS'**
  String get whoGrowthCurves;

  /// No description provided for @weightCurve.
  ///
  /// In es, this message translates to:
  /// **'Curva de Peso'**
  String get weightCurve;

  /// No description provided for @heightCurve.
  ///
  /// In es, this message translates to:
  /// **'Curva de Estatura'**
  String get heightCurve;

  /// No description provided for @compareWithWHO.
  ///
  /// In es, this message translates to:
  /// **'Comparación con curvas OMS'**
  String get compareWithWHO;

  /// No description provided for @growthHistory.
  ///
  /// In es, this message translates to:
  /// **'Historial de Crecimiento'**
  String get growthHistory;

  /// No description provided for @monthsOfAge.
  ///
  /// In es, this message translates to:
  /// **'{months} meses de edad'**
  String monthsOfAge(int months);

  /// No description provided for @deleteRecord.
  ///
  /// In es, this message translates to:
  /// **'Eliminar registro'**
  String get deleteRecord;

  /// No description provided for @deleteRecordConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Seguro que deseas eliminar este registro de crecimiento?'**
  String get deleteRecordConfirm;

  /// No description provided for @habitsOfToday.
  ///
  /// In es, this message translates to:
  /// **'Hábitos de Hoy'**
  String get habitsOfToday;

  /// No description provided for @noRecordsToday.
  ///
  /// In es, this message translates to:
  /// **'Sin registros hoy'**
  String get noRecordsToday;

  /// No description provided for @todayRecords.
  ///
  /// In es, this message translates to:
  /// **'{count} registros'**
  String todayRecords(int count);

  /// No description provided for @registerIntestinalHabits.
  ///
  /// In es, this message translates to:
  /// **'Registra los Hábitos intestinales del día.'**
  String get registerIntestinalHabits;

  /// No description provided for @vaccineTitle.
  ///
  /// In es, this message translates to:
  /// **'Vacunas'**
  String get vaccineTitle;

  /// No description provided for @vaccinesCompleted.
  ///
  /// In es, this message translates to:
  /// **'{completed} completadas, {upcoming} próximas, {overdue} atrasadas'**
  String vaccinesCompleted(int completed, int upcoming, int overdue);

  /// No description provided for @overdueVaccines.
  ///
  /// In es, this message translates to:
  /// **'{count} vacuna(s) atrasada(s)'**
  String overdueVaccines(int count);

  /// No description provided for @upcomingVaccines.
  ///
  /// In es, this message translates to:
  /// **'{count} vacuna(s) próxima(s) en el mes'**
  String upcomingVaccines(int count);

  /// No description provided for @measureRecord.
  ///
  /// In es, this message translates to:
  /// **'Registrar Medidas'**
  String get measureRecord;

  /// No description provided for @heightCm.
  ///
  /// In es, this message translates to:
  /// **'Estatura (cm)'**
  String get heightCm;

  /// No description provided for @headCircumference.
  ///
  /// In es, this message translates to:
  /// **'Perímetro craneal (cm)'**
  String get headCircumference;

  /// No description provided for @bothFieldsOptional.
  ///
  /// In es, this message translates to:
  /// **'Ambos campos son opcionales'**
  String get bothFieldsOptional;

  /// No description provided for @enterAtLeastOneMeasure.
  ///
  /// In es, this message translates to:
  /// **'Ingresa al menos una medida'**
  String get enterAtLeastOneMeasure;

  /// No description provided for @measuresRegistered.
  ///
  /// In es, this message translates to:
  /// **'Medidas registradas'**
  String get measuresRegistered;

  /// No description provided for @measureUnit.
  ///
  /// In es, this message translates to:
  /// **'cm'**
  String get measureUnit;

  /// No description provided for @weightUnit.
  ///
  /// In es, this message translates to:
  /// **'lb'**
  String get weightUnit;

  /// No description provided for @date.
  ///
  /// In es, this message translates to:
  /// **'Fecha'**
  String get date;

  /// No description provided for @settings.
  ///
  /// In es, this message translates to:
  /// **'Configuración'**
  String get settings;

  /// No description provided for @autoBackup.
  ///
  /// In es, this message translates to:
  /// **'Respaldo Automático'**
  String get autoBackup;

  /// No description provided for @autoBackupTitle.
  ///
  /// In es, this message translates to:
  /// **'Respaldo automático'**
  String get autoBackupTitle;

  /// No description provided for @autoBackupSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Crear backup cada día'**
  String get autoBackupSubtitle;

  /// No description provided for @backupTime.
  ///
  /// In es, this message translates to:
  /// **'Hora del respaldo'**
  String get backupTime;

  /// No description provided for @backupFolder.
  ///
  /// In es, this message translates to:
  /// **'Carpeta de respaldo'**
  String get backupFolder;

  /// No description provided for @folderName.
  ///
  /// In es, this message translates to:
  /// **'Nombre de carpeta'**
  String get folderName;

  /// No description provided for @folderHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: PediaTrack'**
  String get folderHint;

  /// No description provided for @nextBackup.
  ///
  /// In es, this message translates to:
  /// **'Próximo respaldo'**
  String get nextBackup;

  /// No description provided for @runNow.
  ///
  /// In es, this message translates to:
  /// **'Ejecutar ahora'**
  String get runNow;

  /// No description provided for @runNowSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Generar backup manualmente'**
  String get runNowSubtitle;

  /// No description provided for @forceAutoBackup.
  ///
  /// In es, this message translates to:
  /// **'Forzar respaldo automático'**
  String get forceAutoBackup;

  /// No description provided for @forceAutoBackupSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Prueba del sistema de respaldo'**
  String get forceAutoBackupSubtitle;

  /// No description provided for @lastBackup.
  ///
  /// In es, this message translates to:
  /// **'Último respaldo'**
  String get lastBackup;

  /// No description provided for @lastBackupAuto.
  ///
  /// In es, this message translates to:
  /// **'Último automático'**
  String get lastBackupAuto;

  /// No description provided for @lastBackupManual.
  ///
  /// In es, this message translates to:
  /// **'Último manual'**
  String get lastBackupManual;

  /// No description provided for @automaticLabel.
  ///
  /// In es, this message translates to:
  /// **'Automático'**
  String get automaticLabel;

  /// No description provided for @manualLabel.
  ///
  /// In es, this message translates to:
  /// **'Manual'**
  String get manualLabel;

  /// No description provided for @generatingBackup.
  ///
  /// In es, this message translates to:
  /// **'Generando respaldo...'**
  String get generatingBackup;

  /// No description provided for @backupGenerated.
  ///
  /// In es, this message translates to:
  /// **'Respaldo guardado en: {path}'**
  String backupGenerated(String path);

  /// No description provided for @nextBackupScheduled.
  ///
  /// In es, this message translates to:
  /// **'Próximo respaldo: {datetime}'**
  String nextBackupScheduled(String datetime);

  /// No description provided for @exportImport.
  ///
  /// In es, this message translates to:
  /// **'Exportar / Importar'**
  String get exportImport;

  /// No description provided for @exportData.
  ///
  /// In es, this message translates to:
  /// **'Exportar datos'**
  String get exportData;

  /// No description provided for @exportDataSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Compartir o descargar respaldo JSON y Excel'**
  String get exportDataSubtitle;

  /// No description provided for @importBackup.
  ///
  /// In es, this message translates to:
  /// **'Importar respaldo'**
  String get importBackup;

  /// No description provided for @importBackupSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Cargar un archivo JSON de respaldo'**
  String get importBackupSubtitle;

  /// No description provided for @importBackupConfirm.
  ///
  /// In es, this message translates to:
  /// **'Esto reemplazará todos los datos actuales. ¿Deseas continuar?'**
  String get importBackupConfirm;

  /// No description provided for @importSuccess.
  ///
  /// In es, this message translates to:
  /// **'Respaldo importado correctamente'**
  String get importSuccess;

  /// No description provided for @shareJson.
  ///
  /// In es, this message translates to:
  /// **'Compartir JSON'**
  String get shareJson;

  /// No description provided for @shareJsonSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Enviar por correo o WhatsApp'**
  String get shareJsonSubtitle;

  /// No description provided for @downloadJson.
  ///
  /// In es, this message translates to:
  /// **'Descargar JSON'**
  String get downloadJson;

  /// No description provided for @downloadJsonSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Guardar archivo localmente'**
  String get downloadJsonSubtitle;

  /// No description provided for @shareExcel.
  ///
  /// In es, this message translates to:
  /// **'Compartir Excel'**
  String get shareExcel;

  /// No description provided for @shareExcelSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Enviar por correo o WhatsApp'**
  String get shareExcelSubtitle;

  /// No description provided for @downloadExcel.
  ///
  /// In es, this message translates to:
  /// **'Descargar Excel'**
  String get downloadExcel;

  /// No description provided for @downloadExcelSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Guardar archivo localmente'**
  String get downloadExcelSubtitle;

  /// No description provided for @backupReadyToShare.
  ///
  /// In es, this message translates to:
  /// **'Respaldo JSON listo para compartir'**
  String get backupReadyToShare;

  /// No description provided for @backupReadyToShareExcel.
  ///
  /// In es, this message translates to:
  /// **'Respaldo Excel listo para compartir'**
  String get backupReadyToShareExcel;

  /// No description provided for @exportError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo exportar: {error}'**
  String exportError(String error);

  /// No description provided for @saveBackup.
  ///
  /// In es, this message translates to:
  /// **'Guardar respaldo'**
  String get saveBackup;

  /// No description provided for @jsonBackupSaved.
  ///
  /// In es, this message translates to:
  /// **'Respaldo guardado en: {path}'**
  String jsonBackupSaved(String path);

  /// No description provided for @excelSaved.
  ///
  /// In es, this message translates to:
  /// **'Excel guardado en: {path}'**
  String excelSaved(String path);

  /// No description provided for @about.
  ///
  /// In es, this message translates to:
  /// **'Acerca de'**
  String get about;

  /// No description provided for @version.
  ///
  /// In es, this message translates to:
  /// **'Versión'**
  String get version;

  /// No description provided for @versionNumber.
  ///
  /// In es, this message translates to:
  /// **'1.0.0'**
  String get versionNumber;

  /// No description provided for @developedWith.
  ///
  /// In es, this message translates to:
  /// **'Desarrollado con'**
  String get developedWith;

  /// No description provided for @developedWithValue.
  ///
  /// In es, this message translates to:
  /// **'Flutter + Riverpod'**
  String get developedWithValue;

  /// No description provided for @child.
  ///
  /// In es, this message translates to:
  /// **'niño'**
  String get child;

  /// No description provided for @childNotFound.
  ///
  /// In es, this message translates to:
  /// **'niño no encontrado'**
  String get childNotFound;

  /// No description provided for @masculine.
  ///
  /// In es, this message translates to:
  /// **'Masculino'**
  String get masculine;

  /// No description provided for @femenine.
  ///
  /// In es, this message translates to:
  /// **'Femenino'**
  String get femenine;

  /// No description provided for @boy.
  ///
  /// In es, this message translates to:
  /// **'Niño'**
  String get boy;

  /// No description provided for @girl.
  ///
  /// In es, this message translates to:
  /// **'Niña'**
  String get girl;

  /// No description provided for @habitType.
  ///
  /// In es, this message translates to:
  /// **'Tipo de hábito'**
  String get habitType;

  /// No description provided for @normalEvacuation.
  ///
  /// In es, this message translates to:
  /// **'Evacuación normal'**
  String get normalEvacuation;

  /// No description provided for @constipation.
  ///
  /// In es, this message translates to:
  /// **'Estreñimiento'**
  String get constipation;

  /// No description provided for @diarrhea.
  ///
  /// In es, this message translates to:
  /// **'Diarrea'**
  String get diarrhea;

  /// No description provided for @feeding.
  ///
  /// In es, this message translates to:
  /// **'Alimentación'**
  String get feeding;

  /// No description provided for @sleep.
  ///
  /// In es, this message translates to:
  /// **'Sueño'**
  String get sleep;

  /// No description provided for @hydration.
  ///
  /// In es, this message translates to:
  /// **'Hidratación'**
  String get hydration;

  /// No description provided for @medication.
  ///
  /// In es, this message translates to:
  /// **'Medicación'**
  String get medication;

  /// No description provided for @otherHabit.
  ///
  /// In es, this message translates to:
  /// **'Otro habito'**
  String get otherHabit;

  /// No description provided for @observations.
  ///
  /// In es, this message translates to:
  /// **'Observaciones (opcional)'**
  String get observations;

  /// No description provided for @observationsOptional.
  ///
  /// In es, this message translates to:
  /// **'Observaciones (opcional)'**
  String get observationsOptional;

  /// No description provided for @addChild.
  ///
  /// In es, this message translates to:
  /// **'Agregar niño'**
  String get addChild;

  /// No description provided for @editChild.
  ///
  /// In es, this message translates to:
  /// **'Editar niño'**
  String get editChild;

  /// No description provided for @enterChildName.
  ///
  /// In es, this message translates to:
  /// **'Ingresa el nombre del niño'**
  String get enterChildName;

  /// No description provided for @childAdded.
  ///
  /// In es, this message translates to:
  /// **'{name} agregado exitosamente'**
  String childAdded(String name);

  /// No description provided for @childUpdated.
  ///
  /// In es, this message translates to:
  /// **'{name} actualizado exitosamente'**
  String childUpdated(String name);

  /// No description provided for @consultationRecord.
  ///
  /// In es, this message translates to:
  /// **'Registro de Consulta'**
  String get consultationRecord;

  /// No description provided for @weightHeightHead.
  ///
  /// In es, this message translates to:
  /// **'Peso, Estatura y Perímetro Craneal'**
  String get weightHeightHead;

  /// No description provided for @enterAtLeastOneValue.
  ///
  /// In es, this message translates to:
  /// **'Ingresa al menos un valor. Los demás son opcionales.'**
  String get enterAtLeastOneValue;

  /// No description provided for @recordSaved.
  ///
  /// In es, this message translates to:
  /// **'Registro guardado exitosamente'**
  String get recordSaved;

  /// No description provided for @registerHabit.
  ///
  /// In es, this message translates to:
  /// **'Registrar Hábito'**
  String get registerHabit;

  /// No description provided for @selectHabit.
  ///
  /// In es, this message translates to:
  /// **'Selecciona hábito'**
  String get selectHabit;

  /// No description provided for @habitRegistered.
  ///
  /// In es, this message translates to:
  /// **'Hábito registrado exitosamente'**
  String get habitRegistered;

  /// No description provided for @stats.
  ///
  /// In es, this message translates to:
  /// **'Estadísticas'**
  String get stats;

  /// No description provided for @noEnoughData.
  ///
  /// In es, this message translates to:
  /// **'Sin datos suficientes'**
  String get noEnoughData;

  /// No description provided for @registerDaysForStats.
  ///
  /// In es, this message translates to:
  /// **'Registra al menos 3 días para ver Estadísticas'**
  String get registerDaysForStats;

  /// No description provided for @frequency.
  ///
  /// In es, this message translates to:
  /// **'Frecuencia'**
  String get frequency;

  /// No description provided for @total.
  ///
  /// In es, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @constipationDays.
  ///
  /// In es, this message translates to:
  /// **'Estreñimiento'**
  String get constipationDays;

  /// No description provided for @timesPerWeek.
  ///
  /// In es, this message translates to:
  /// **'veces/semana'**
  String get timesPerWeek;

  /// No description provided for @records.
  ///
  /// In es, this message translates to:
  /// **'registros'**
  String get records;

  /// No description provided for @days.
  ///
  /// In es, this message translates to:
  /// **'días'**
  String get days;

  /// No description provided for @distribution.
  ///
  /// In es, this message translates to:
  /// **'Distribución:'**
  String get distribution;

  /// No description provided for @normal.
  ///
  /// In es, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @evaluating.
  ///
  /// In es, this message translates to:
  /// **'Evaluando...'**
  String get evaluating;

  /// No description provided for @noPreviousData.
  ///
  /// In es, this message translates to:
  /// **'Sin datos previos'**
  String get noPreviousData;

  /// No description provided for @improving.
  ///
  /// In es, this message translates to:
  /// **'Mejorando'**
  String get improving;

  /// No description provided for @worsening.
  ///
  /// In es, this message translates to:
  /// **'Empeorando'**
  String get worsening;

  /// No description provided for @noChanges.
  ///
  /// In es, this message translates to:
  /// **'Sin cambios'**
  String get noChanges;

  /// No description provided for @historyOfDefecations.
  ///
  /// In es, this message translates to:
  /// **'Historial de Defecaciones'**
  String get historyOfDefecations;

  /// No description provided for @historySubtitle.
  ///
  /// In es, this message translates to:
  /// **'Registro completo'**
  String get historySubtitle;

  /// No description provided for @noRecords.
  ///
  /// In es, this message translates to:
  /// **'Sin registros'**
  String get noRecords;

  /// No description provided for @recordsCount.
  ///
  /// In es, this message translates to:
  /// **'{count} registro(s)'**
  String recordsCount(int count);

  /// No description provided for @deleteHabit.
  ///
  /// In es, this message translates to:
  /// **'Eliminar hábito'**
  String get deleteHabit;

  /// No description provided for @deleteHabitConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Seguro que deseas eliminar este registro de hábito?'**
  String get deleteHabitConfirm;

  /// No description provided for @editHabit.
  ///
  /// In es, this message translates to:
  /// **'Editar hábito'**
  String get editHabit;

  /// No description provided for @dateAndTime.
  ///
  /// In es, this message translates to:
  /// **'Fecha y hora'**
  String get dateAndTime;

  /// No description provided for @emptyAlerts.
  ///
  /// In es, this message translates to:
  /// **'¡Sin Alertas!'**
  String get emptyAlerts;

  /// No description provided for @noPendingNotifications.
  ///
  /// In es, this message translates to:
  /// **'No hay notificaciones pendientes'**
  String get noPendingNotifications;

  /// No description provided for @noAlertsForSelectedChild.
  ///
  /// In es, this message translates to:
  /// **'No hay alertas para el niño seleccionado'**
  String get noAlertsForSelectedChild;

  /// No description provided for @dose.
  ///
  /// In es, this message translates to:
  /// **'Dosis {current}/{total}'**
  String dose(int current, int total);

  /// No description provided for @pending.
  ///
  /// In es, this message translates to:
  /// **'Pendientes'**
  String get pending;

  /// No description provided for @completed.
  ///
  /// In es, this message translates to:
  /// **'Completadas'**
  String get completed;

  /// No description provided for @all.
  ///
  /// In es, this message translates to:
  /// **'Todas'**
  String get all;

  /// No description provided for @completedStatus.
  ///
  /// In es, this message translates to:
  /// **'Completada'**
  String get completedStatus;

  /// No description provided for @overdueStatus.
  ///
  /// In es, this message translates to:
  /// **'Atrasada'**
  String get overdueStatus;

  /// No description provided for @pendingStatus.
  ///
  /// In es, this message translates to:
  /// **'Pendiente'**
  String get pendingStatus;

  /// No description provided for @recommendedDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha recomendada'**
  String get recommendedDate;

  /// No description provided for @applied.
  ///
  /// In es, this message translates to:
  /// **'Aplicada'**
  String get applied;

  /// No description provided for @touchToRegister.
  ///
  /// In es, this message translates to:
  /// **'Toca para registrar'**
  String get touchToRegister;

  /// No description provided for @editVaccine.
  ///
  /// In es, this message translates to:
  /// **'Editar Vacuna'**
  String get editVaccine;

  /// No description provided for @registerVaccine.
  ///
  /// In es, this message translates to:
  /// **'Registrar Vacuna'**
  String get registerVaccine;

  /// No description provided for @vaccine.
  ///
  /// In es, this message translates to:
  /// **'Vacuna'**
  String get vaccine;

  /// No description provided for @batchOptional.
  ///
  /// In es, this message translates to:
  /// **'Lote (opcional)'**
  String get batchOptional;

  /// No description provided for @batchNumber.
  ///
  /// In es, this message translates to:
  /// **'Número de lote (opcional)'**
  String get batchNumber;

  /// No description provided for @vaccineUpdated.
  ///
  /// In es, this message translates to:
  /// **'Vacuna actualizada'**
  String get vaccineUpdated;

  /// No description provided for @vaccineRegistered.
  ///
  /// In es, this message translates to:
  /// **'Vacuna registrada'**
  String get vaccineRegistered;

  /// No description provided for @recordsTitle.
  ///
  /// In es, this message translates to:
  /// **'Registros'**
  String get recordsTitle;

  /// No description provided for @currentWeight.
  ///
  /// In es, this message translates to:
  /// **'Peso actual'**
  String get currentWeight;

  /// No description provided for @currentHeight.
  ///
  /// In es, this message translates to:
  /// **'Estatura actual'**
  String get currentHeight;

  /// No description provided for @currentRecords.
  ///
  /// In es, this message translates to:
  /// **'{count} registros'**
  String currentRecords(int count);

  /// No description provided for @atBirth.
  ///
  /// In es, this message translates to:
  /// **'al nacer'**
  String get atBirth;

  /// No description provided for @atMonth.
  ///
  /// In es, this message translates to:
  /// **'al mes'**
  String get atMonth;

  /// No description provided for @atMonths.
  ///
  /// In es, this message translates to:
  /// **'a los {months} meses'**
  String atMonths(int months);

  /// No description provided for @atYear.
  ///
  /// In es, this message translates to:
  /// **'al año'**
  String get atYear;

  /// No description provided for @atYears.
  ///
  /// In es, this message translates to:
  /// **'a los {years} años'**
  String atYears(int years);

  /// No description provided for @atYearsAndMonths.
  ///
  /// In es, this message translates to:
  /// **'a los {years} años y {months} meses'**
  String atYearsAndMonths(int years, int months);

  /// No description provided for @atYearsAndOneMonth.
  ///
  /// In es, this message translates to:
  /// **'a los {years} años y 1 mes'**
  String atYearsAndOneMonth(int years);

  /// No description provided for @intestinalHabitControl.
  ///
  /// In es, this message translates to:
  /// **'Control de Hábitos intestinales'**
  String get intestinalHabitControl;

  /// No description provided for @recommendedAtMonths.
  ///
  /// In es, this message translates to:
  /// **'Recomendada a los {months} meses'**
  String recommendedAtMonths(int months);

  /// No description provided for @vaccineAdded.
  ///
  /// In es, this message translates to:
  /// **'¡Vacuna registrada!'**
  String get vaccineAdded;

  /// No description provided for @addVaccine.
  ///
  /// In es, this message translates to:
  /// **'Agregar'**
  String get addVaccine;

  /// No description provided for @addVaccineTitle.
  ///
  /// In es, this message translates to:
  /// **'Agregar Vacuna'**
  String get addVaccineTitle;

  /// No description provided for @selectVaccine.
  ///
  /// In es, this message translates to:
  /// **'Selecciona una vacuna'**
  String get selectVaccine;

  /// No description provided for @vaccineAddedSuccess.
  ///
  /// In es, this message translates to:
  /// **'Vacuna agregada'**
  String get vaccineAddedSuccess;

  /// No description provided for @vaccineDeleted.
  ///
  /// In es, this message translates to:
  /// **'Vacuna eliminada'**
  String get vaccineDeleted;

  /// No description provided for @deleteVaccineConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar el registro de {name}?'**
  String deleteVaccineConfirm(String name);

  /// No description provided for @noVaccinesPending.
  ///
  /// In es, this message translates to:
  /// **'¡No hay vacunas pendientes!'**
  String get noVaccinesPending;

  /// No description provided for @noCompletedVaccines.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay vacunas completadas'**
  String get noCompletedVaccines;

  /// No description provided for @noVaccinesRegistered.
  ///
  /// In es, this message translates to:
  /// **'Sin vacunas registradas'**
  String get noVaccinesRegistered;

  /// No description provided for @addFirstVaccines.
  ///
  /// In es, this message translates to:
  /// **'Agrega las primeras vacunas para hacer seguimiento'**
  String get addFirstVaccines;

  /// No description provided for @loading.
  ///
  /// In es, this message translates to:
  /// **'Cargando...'**
  String get loading;

  /// No description provided for @searchingChild.
  ///
  /// In es, this message translates to:
  /// **'Buscando niño...'**
  String get searchingChild;

  /// No description provided for @years.
  ///
  /// In es, this message translates to:
  /// **'años'**
  String get years;

  /// No description provided for @year.
  ///
  /// In es, this message translates to:
  /// **'año'**
  String get year;

  /// No description provided for @months.
  ///
  /// In es, this message translates to:
  /// **'meses'**
  String get months;

  /// No description provided for @month.
  ///
  /// In es, this message translates to:
  /// **'mes'**
  String get month;

  /// No description provided for @lb.
  ///
  /// In es, this message translates to:
  /// **'lb'**
  String get lb;

  /// No description provided for @cm.
  ///
  /// In es, this message translates to:
  /// **'cm'**
  String get cm;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
