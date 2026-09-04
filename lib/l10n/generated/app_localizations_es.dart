// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'PediaTrack';

  @override
  String get start => 'Inicio';

  @override
  String get growth => 'Crecimiento';

  @override
  String get habits => 'Hábitos';

  @override
  String get vaccines => 'Vacunas';

  @override
  String get alerts => 'Alertas';

  @override
  String get exit => 'Salir';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get delete => 'Eliminar';

  @override
  String get edit => 'Editar';

  @override
  String get add => 'Agregar';

  @override
  String get register => 'Registrar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get exitConfirm => '¿Estás seguro de que quieres salir de PediaTrack?';

  @override
  String get pressBackAgainToExit => 'Presiona de nuevo para salir';

  @override
  String get childName => 'Nombre';

  @override
  String get birthDate => 'Fecha de Nacimiento';

  @override
  String get gender => 'Género';

  @override
  String get selectChild => 'Selecciona un niño para ver su información';

  @override
  String get selectChildForGrowth =>
      'Selecciona un niño para ver su crecimiento';

  @override
  String get selectChildForHabits => 'Selecciona un niño para ver sus Hábitos';

  @override
  String get selectChildForAlerts =>
      'Selecciona un niño para ver sus alertas de salud';

  @override
  String get selectChildForVaccines =>
      'Selecciona un niño para ver sus vacunas';

  @override
  String get welcomeToPediaTrack => '¡Bienvenido a PediaTrack!';

  @override
  String get welcomeSubtitle =>
      'Registra a tu primer niño para comenzar a monitorear su crecimiento y Hábitos.';

  @override
  String get addFirstChild => 'Agregar Primer niño';

  @override
  String get selectChildTitle => 'Seleccionar Hijo';

  @override
  String get noChildSelected => 'Selecciona un niño para ver su información';

  @override
  String get quickSuggestion => 'Sugerencia rápida';

  @override
  String get quickSuggestionSubtitle => 'Para registrar más fácil';

  @override
  String get quickSuggestionHint =>
      'Usa el botón \"Registrar\" para guardar Consulta o Hábito desde cualquier pantalla principal.';

  @override
  String get noData => 'Sin dato';

  @override
  String get withoutData => 'Sin dato';

  @override
  String get error => 'Error';

  @override
  String get age => 'Edad';

  @override
  String get weight => 'Peso';

  @override
  String get height => 'Estatura';

  @override
  String get birthWeight => 'Peso al nacer';

  @override
  String get birthHeight => 'Estatura al nacer';

  @override
  String get birthData => 'Datos al Nacer';

  @override
  String get birthDataSubtitle => 'Registro inicial';

  @override
  String get birthRecord => 'Registro inicial';

  @override
  String get recentGrowth => 'Crecimiento Reciente';

  @override
  String lastRecord(String date) {
    return 'Último registro: $date';
  }

  @override
  String get noGrowthRecords => 'Sin registros de crecimiento';

  @override
  String get addRecord => 'Agregar registro';

  @override
  String get showRecords => 'Mostrar:';

  @override
  String get fiveRecords => '5 registros';

  @override
  String get tenRecords => '10 registros';

  @override
  String get twentyRecords => '20 registros';

  @override
  String get allRecords => 'Todos';

  @override
  String get recentRecords => 'Registros Recientes';

  @override
  String get whoGrowthCurves => 'Curvas de Crecimiento OMS';

  @override
  String get weightCurve => 'Curva de Peso';

  @override
  String get heightCurve => 'Curva de Estatura';

  @override
  String get compareWithWHO => 'Comparación con curvas OMS';

  @override
  String get growthHistory => 'Historial de Crecimiento';

  @override
  String monthsOfAge(int months) {
    return '$months meses de edad';
  }

  @override
  String get deleteRecord => 'Eliminar registro';

  @override
  String get deleteRecordConfirm =>
      '¿Seguro que deseas eliminar este registro de crecimiento?';

  @override
  String get habitsOfToday => 'Hábitos de Hoy';

  @override
  String get noRecordsToday => 'Sin registros hoy';

  @override
  String todayRecords(int count) {
    return '$count registros';
  }

  @override
  String get registerIntestinalHabits =>
      'Registra los Hábitos intestinales del día.';

  @override
  String get vaccineTitle => 'Vacunas';

  @override
  String vaccinesCompleted(int completed, int upcoming, int overdue) {
    return '$completed completadas, $upcoming próximas, $overdue atrasadas';
  }

  @override
  String overdueVaccines(int count) {
    return '$count vacuna(s) atrasada(s)';
  }

  @override
  String upcomingVaccines(int count) {
    return '$count vacuna(s) próxima(s) en el mes';
  }

  @override
  String get measureRecord => 'Registrar Medidas';

  @override
  String get heightCm => 'Estatura (cm)';

  @override
  String get headCircumference => 'Perímetro craneal (cm)';

  @override
  String get bothFieldsOptional => 'Ambos campos son opcionales';

  @override
  String get enterAtLeastOneMeasure => 'Ingresa al menos una medida';

  @override
  String get measuresRegistered => 'Medidas registradas';

  @override
  String get measureUnit => 'cm';

  @override
  String get weightUnit => 'lb';

  @override
  String get date => 'Fecha';

  @override
  String get settings => 'Configuración';

  @override
  String get autoBackup => 'Respaldo Automático';

  @override
  String get autoBackupTitle => 'Respaldo automático';

  @override
  String get autoBackupSubtitle => 'Crear backup cada día';

  @override
  String get backupTime => 'Hora del respaldo';

  @override
  String get backupFolder => 'Carpeta de respaldo';

  @override
  String get folderName => 'Nombre de carpeta';

  @override
  String get folderHint => 'Ej: PediaTrack';

  @override
  String get nextBackup => 'Próximo respaldo';

  @override
  String get runNow => 'Ejecutar ahora';

  @override
  String get runNowSubtitle => 'Generar backup manualmente';

  @override
  String get forceAutoBackup => 'Forzar respaldo automático';

  @override
  String get forceAutoBackupSubtitle => 'Prueba del sistema de respaldo';

  @override
  String get lastBackup => 'Último respaldo';

  @override
  String get lastBackupAuto => 'Último automático';

  @override
  String get lastBackupManual => 'Último manual';

  @override
  String get automaticLabel => 'Automático';

  @override
  String get manualLabel => 'Manual';

  @override
  String get generatingBackup => 'Generando respaldo...';

  @override
  String backupGenerated(String path) {
    return 'Respaldo guardado en: $path';
  }

  @override
  String nextBackupScheduled(String datetime) {
    return 'Próximo respaldo: $datetime';
  }

  @override
  String get exportImport => 'Exportar / Importar';

  @override
  String get exportData => 'Exportar datos';

  @override
  String get exportDataSubtitle =>
      'Compartir o descargar respaldo JSON y Excel';

  @override
  String get importBackup => 'Importar respaldo';

  @override
  String get importBackupSubtitle => 'Cargar un archivo JSON de respaldo';

  @override
  String get importBackupConfirm =>
      'Esto reemplazará todos los datos actuales. ¿Deseas continuar?';

  @override
  String get importSuccess => 'Respaldo importado correctamente';

  @override
  String get shareJson => 'Compartir JSON';

  @override
  String get shareJsonSubtitle => 'Enviar por correo o WhatsApp';

  @override
  String get downloadJson => 'Descargar JSON';

  @override
  String get downloadJsonSubtitle => 'Guardar archivo localmente';

  @override
  String get shareExcel => 'Compartir Excel';

  @override
  String get shareExcelSubtitle => 'Enviar por correo o WhatsApp';

  @override
  String get downloadExcel => 'Descargar Excel';

  @override
  String get downloadExcelSubtitle => 'Guardar archivo localmente';

  @override
  String get backupReadyToShare => 'Respaldo JSON listo para compartir';

  @override
  String get backupReadyToShareExcel => 'Respaldo Excel listo para compartir';

  @override
  String exportError(String error) {
    return 'No se pudo exportar: $error';
  }

  @override
  String get saveBackup => 'Guardar respaldo';

  @override
  String jsonBackupSaved(String path) {
    return 'Respaldo guardado en: $path';
  }

  @override
  String excelSaved(String path) {
    return 'Excel guardado en: $path';
  }

  @override
  String get about => 'Acerca de';

  @override
  String get version => 'Versión';

  @override
  String get versionNumber => '1.0.0';

  @override
  String get developedWith => 'Desarrollado con';

  @override
  String get developedWithValue => 'Flutter + Riverpod';

  @override
  String get child => 'niño';

  @override
  String get childNotFound => 'niño no encontrado';

  @override
  String get masculine => 'Masculino';

  @override
  String get femenine => 'Femenino';

  @override
  String get boy => 'Niño';

  @override
  String get girl => 'Niña';

  @override
  String get habitType => 'Tipo de hábito';

  @override
  String get normalEvacuation => 'Evacuación normal';

  @override
  String get constipation => 'Estreñimiento';

  @override
  String get diarrhea => 'Diarrea';

  @override
  String get feeding => 'Alimentación';

  @override
  String get sleep => 'Sueño';

  @override
  String get hydration => 'Hidratación';

  @override
  String get medication => 'Medicación';

  @override
  String get otherHabit => 'Otro habito';

  @override
  String get observations => 'Observaciones (opcional)';

  @override
  String get observationsOptional => 'Observaciones (opcional)';

  @override
  String get addChild => 'Agregar niño';

  @override
  String get editChild => 'Editar niño';

  @override
  String get enterChildName => 'Ingresa el nombre del niño';

  @override
  String childAdded(String name) {
    return '$name agregado exitosamente';
  }

  @override
  String childUpdated(String name) {
    return '$name actualizado exitosamente';
  }

  @override
  String get consultationRecord => 'Registro de Consulta';

  @override
  String get weightHeightHead => 'Peso, Estatura y Perímetro Craneal';

  @override
  String get enterAtLeastOneValue =>
      'Ingresa al menos un valor. Los demás son opcionales.';

  @override
  String get recordSaved => 'Registro guardado exitosamente';

  @override
  String get registerHabit => 'Registrar Hábito';

  @override
  String get selectHabit => 'Selecciona hábito';

  @override
  String get habitRegistered => 'Hábito registrado exitosamente';

  @override
  String get stats => 'Estadísticas';

  @override
  String get noEnoughData => 'Sin datos suficientes';

  @override
  String get registerDaysForStats =>
      'Registra al menos 3 días para ver Estadísticas';

  @override
  String get frequency => 'Frecuencia';

  @override
  String get total => 'Total';

  @override
  String get constipationDays => 'Estreñimiento';

  @override
  String get timesPerWeek => 'veces/semana';

  @override
  String get records => 'registros';

  @override
  String get days => 'días';

  @override
  String get distribution => 'Distribución:';

  @override
  String get normal => 'Normal';

  @override
  String get evaluating => 'Evaluando...';

  @override
  String get noPreviousData => 'Sin datos previos';

  @override
  String get improving => 'Mejorando';

  @override
  String get worsening => 'Empeorando';

  @override
  String get noChanges => 'Sin cambios';

  @override
  String get historyOfDefecations => 'Historial de Defecaciones';

  @override
  String get historySubtitle => 'Registro completo';

  @override
  String get noRecords => 'Sin registros';

  @override
  String recordsCount(int count) {
    return '$count registro(s)';
  }

  @override
  String get deleteHabit => 'Eliminar hábito';

  @override
  String get deleteHabitConfirm =>
      '¿Seguro que deseas eliminar este registro de hábito?';

  @override
  String get editHabit => 'Editar hábito';

  @override
  String get dateAndTime => 'Fecha y hora';

  @override
  String get emptyAlerts => '¡Sin Alertas!';

  @override
  String get noPendingNotifications => 'No hay notificaciones pendientes';

  @override
  String get noAlertsForSelectedChild =>
      'No hay alertas para el niño seleccionado';

  @override
  String dose(int current, int total) {
    return 'Dosis $current/$total';
  }

  @override
  String get pending => 'Pendientes';

  @override
  String get completed => 'Completadas';

  @override
  String get all => 'Todas';

  @override
  String get completedStatus => 'Completada';

  @override
  String get overdueStatus => 'Atrasada';

  @override
  String get pendingStatus => 'Pendiente';

  @override
  String get recommendedDate => 'Fecha recomendada';

  @override
  String get applied => 'Aplicada';

  @override
  String get touchToRegister => 'Toca para registrar';

  @override
  String get editVaccine => 'Editar Vacuna';

  @override
  String get registerVaccine => 'Registrar Vacuna';

  @override
  String get vaccine => 'Vacuna';

  @override
  String get batchOptional => 'Lote (opcional)';

  @override
  String get batchNumber => 'Número de lote (opcional)';

  @override
  String get vaccineUpdated => 'Vacuna actualizada';

  @override
  String get vaccineRegistered => 'Vacuna registrada';

  @override
  String get recordsTitle => 'Registros';

  @override
  String get currentWeight => 'Peso actual';

  @override
  String get currentHeight => 'Estatura actual';

  @override
  String currentRecords(int count) {
    return '$count registros';
  }

  @override
  String get atBirth => 'al nacer';

  @override
  String get atMonth => 'al mes';

  @override
  String atMonths(int months) {
    return 'a los $months meses';
  }

  @override
  String get atYear => 'al año';

  @override
  String atYears(int years) {
    return 'a los $years años';
  }

  @override
  String atYearsAndMonths(int years, int months) {
    return 'a los $years años y $months meses';
  }

  @override
  String atYearsAndOneMonth(int years) {
    return 'a los $years años y 1 mes';
  }

  @override
  String get intestinalHabitControl => 'Control de Hábitos intestinales';

  @override
  String recommendedAtMonths(int months) {
    return 'Recomendada a los $months meses';
  }

  @override
  String get vaccineAdded => '¡Vacuna registrada!';

  @override
  String get addVaccine => 'Agregar';

  @override
  String get addVaccineTitle => 'Agregar Vacuna';

  @override
  String get selectVaccine => 'Selecciona una vacuna';

  @override
  String get vaccineAddedSuccess => 'Vacuna agregada';

  @override
  String get vaccineDeleted => 'Vacuna eliminada';

  @override
  String deleteVaccineConfirm(String name) {
    return '¿Eliminar el registro de $name?';
  }

  @override
  String get noVaccinesPending => '¡No hay vacunas pendientes!';

  @override
  String get noCompletedVaccines => 'Aún no hay vacunas completadas';

  @override
  String get noVaccinesRegistered => 'Sin vacunas registradas';

  @override
  String get addFirstVaccines =>
      'Agrega las primeras vacunas para hacer seguimiento';

  @override
  String get loading => 'Cargando...';

  @override
  String get searchingChild => 'Buscando niño...';

  @override
  String get years => 'años';

  @override
  String get year => 'año';

  @override
  String get months => 'meses';

  @override
  String get month => 'mes';

  @override
  String get lb => 'lb';

  @override
  String get cm => 'cm';
}
