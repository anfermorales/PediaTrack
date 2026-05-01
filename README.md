# PediaTrack

Aplicación móvil para el seguimiento del crecimiento y desarrollo infantil.

<!-- Badges -->
[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?style=flat-square&logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-blue?style=flat-square&logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)](LICENSE)
[![GitHub Stars](https://img.shields.io/github/stars/anfermorales/PediaTrack?style=flat-square)](https://github.com/anfermorales/PediaTrack/stargazers)

---

## Descripción

**PediaTrack** permite a padres y cuidadores registrar y monitorear el desarrollo de sus hijos de manera sencilla y efectiva.

### Funcionalidades principales

| Funcionalidad | Descripción |
|---------------|-------------|
| **Perfiles de niños** | Gestión de múltiples perfiles con datos de nacimiento |
| **Registro de crecimiento** | Peso y estatura con gráficos de evolución y evaluación OMS |
| **Hábitos intestinales** | Registro diario (normal, estreñimiento, diarrea) |
| **Estadísticas** | Análisis de tendencias, frecuencia y distribución |

## Capturas de pantalla

_(Próximamente)_

## Tecnologías

| Tecnología | Propósito |
|------------|-----------|
| **Flutter** | Framework multiplataforma |
| **Riverpod** | Gestión de estado reactiva |
| **Drift** | ORM para base de datos SQLite |
| **fl_chart** | Gráficos de crecimiento |
| **OMS** | Estándares de crecimiento infantil |

## Requisitos

- Flutter SDK >= 3.0
- Dart SDK >= 3.0
- Android SDK (API 21+)

## Instalación

```bash
# Clonar el repositorio
git clone https://github.com/anfermorales/PediaTrack.git
cd PediaTrack

# Instalar dependencias
flutter pub get

# Ejecutar en modo desarrollo
flutter run

# Compilar APK de debug
flutter build apk --debug

# Compilar APK de release
flutter build apk --release
```

## Estructura del Proyecto

```
lib/
├── main.dart                         # Punto de entrada
├── app.dart                          # UI principal (contiene todas las pantallas)
├── data/database/
│   ├── app_database.dart              # Modelos y DAOs
│   └── app_database.g.dart            # Código generado por Drift
└── core/
    ├── providers/
    │   └── database_providers.dart   # Providers de Riverpod
    ├── services/
    │   └── who_growth_service.dart   # Servicio de evaluación OMS
    ├── constants/
    │   └── app_constants.dart         # Constantes de la app
    └── theme/
        └── app_theme.dart            # Tema visual
```

## Base de datos

La aplicación utiliza **Drift** (SQLite) con las siguientes tablas:

| Tabla | Descripción |
|-------|-------------|
| `children` | Perfiles de niños |
| `growth_records` | Registros de peso y estatura |
| `habit_records` | Registros de hábitos intestinales |

## Contribuir

1. Fork el repositorio
2. Crea una rama (`git checkout -b feature/nueva-funcion`)
3. Commit tus cambios (`git commit -m 'Agregar nueva función'`)
4. Push a la rama (`git push origin feature/nueva-funcion`)
5. Abre un Pull Request

## Licencia

Este proyecto está bajo la licencia MIT. Ver el archivo [LICENSE](LICENSE) para más detalles.

---

Hecho con ❤️ usando Flutter

**Autor:** Andrés Morales  
**Email:** anfermorales@gmail.com  
**GitHub:** [@anfermorales](https://github.com/anfermorales)