# PediaTrack

Aplicación móvil para el seguimiento del crecimiento y desarrollo infantil.

## Descripción

PediaTrack permite a padres y cuidadores registrar y monitorear:
- **Crecimiento**: Peso y estatura con gráficos de evolución
- **Hábitos intestinales**: Registro de defecaciones (normal, estreñimiento, diarrea)
- **Estadísticas**: Análisis de tendencias y patrones de salud

## Características

- Gestión de perfiles de niños
- Registro de crecimiento con evaluación según estándares OMS
- Registro de hábitos intestinales con estadísticas
- Interfaz intuitiva y fácil de usar

## Requisitos

- Flutter SDK >= 3.0
- Dart SDK >= 3.0
- Android SDK (para compilar APK)

## Instalación

```bash
# Clonar el repositorio
git clone <repository-url>
cd pediatrack

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
├── main.dart                    # Punto de entrada
├── app.dart                     # UI principal
├── data/database/               # Modelos y acceso a datos (Drift)
└── core/
    ├── providers/               # Providers de estado (Riverpod)
    ├── services/                # Servicios externos
    ├── constants/               # Constantes y configuraciones
    └── theme/                   # Tema de la aplicación
```

## Tecnologías

- **Estado**: Riverpod
- **Base de datos**: Drift (SQLite)
- **Gráficos**: fl_chart
- **Patrón**: Clean Architecture simplificado

## Licencia

MIT License

## Autor

- **Andrés Morales** - anfermorales@gmail.com