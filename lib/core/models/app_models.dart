// Re-export module para mantener compatibilidad con codigo existente.
//
// Antes este archivo definia localmente `AppAlert`, `AppAlertType`,
// `VaccineScheduleItem` y `AppAlertPriority`. Esos tipos vivian duplicados
// con los definidos en `database_providers.dart`. Para evitar la duplicacion
// y la inconsistencia entre APIs (campo `appliedVaccine` singular vs
// `appliedVaccines` plural), ahora re-exportamos los tipos canonicos desde
// `database_providers.dart`.
//
// Solo `AppAlertPriority` permanece aqui porque es el unico tipo que no
// existe en `database_providers.dart`. Es un enum usado por el repository
// al construir `AppAlert`.
//
// Migracion recomendada:
//   - Reemplazar imports de `app_models.dart` por `database_providers.dart`
//     (los tipos son los mismos).
//   - El unico simbolo que sigue viviendo aqui es `AppAlertPriority`.

export 'package:pediatrack/core/providers/database_providers.dart'
    show AppAlert, AppAlertType, VaccineScheduleItem;

enum AppAlertPriority { high, medium, low }
