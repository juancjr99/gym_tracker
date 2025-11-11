# Capa de Datos — Floor (SQLite)

Este documento explica de forma clara y concisa qué es Floor, por qué lo usamos y exactamente qué se creó/modificó en la implementación de la capa de datos del proyecto `gym_tracker`.

## ¿Qué es Floor?

Floor es un ORM (Object-Relational Mapping) ligero para Flutter/Dart que se apoya en SQLite. Proporciona:

- Entidades (annotated classes) que se mapean a tablas SQLite.
- DAOs (Data Access Objects) con anotaciones `@Query`, `@insert`, `@update`, `@delete` para definir operaciones SQL en forma de métodos Dart.
- Generación de código con `build_runner` y `floor_generator` que crea las implementaciones del DAO y la clase de base de datos.

Floor está pensado para proyectos Flutter que necesitan persistencia local relacional y prefieren un mapeo tipo-objetos sin escribir SQL a bajo nivel para cada operación.

## Por qué lo elegimos aquí

- Necesitamos persistencia local para guardar rutinas, ejercicios y registros de entrenamiento.
- Floor ofrece una integración sencilla con SQLite y facilita conversiones entre modelos (DB) y entidades de dominio.
- Su enfoque de código generado reduce el boilerplate de acceso a la base de datos.

## Qué implementamos exactamente (resumen de archivos)

Se creó una capa de datos local basada en Floor. A continuación la lista de archivos añadidos y su propósito.

Archivos nuevos (ubicación: `lib/data/`):

- `lib/data/models/exercise_model.dart`
  - Entidad/Modelo Floor para `Exercise`.
  - Incluye serialización/deserialización de listas (muscle groups, equipment) y mapeo a/desde la entidad de dominio (`Exercise`).

- `lib/data/models/routine_model.dart`
  - Entidad/Modelo Floor para `Routine` y `RoutineExercise`.
  - Contiene campos como `createdAt`/`updatedAt` guardados como `int` (millisecondsSinceEpoch). Contiene métodos `toEntity()` y `fromEntity()`.

- `lib/data/models/workout_record_model.dart`
  - Entidades/Modelos Floor para `WorkoutRecord`, `ExerciseRecord`, `SetRecord`.
  - Campos de fecha/hora almacenados como `int` (timestamps), con conversiones a `DateTime` en `toEntity`/`fromEntity`.

- `lib/data/models/models.dart`
  - Barrel export para los modelos.

- `lib/data/datasources/local/exercise_dao.dart`
  - DAO con operaciones CRUD y queries útiles para los ejercicios.

- `lib/data/datasources/local/routine_dao.dart`
  - DAO para rutinas y relaciones rutina-ejercicio.

- `lib/data/datasources/local/workout_dao.dart`
  - DAO para registros de entrenamiento y sets.

- `lib/data/datasources/local/app_database.dart`
  - Definición de la base de datos Floor (`@Database(...)`) listando las entidades y exponiendo getters para los DAOs.
  - Configuración mínima para el builder y la apertura de la BD.

- `lib/data/datasources/local/app_database.g.dart`
  - Código generado por `floor_generator` (no editar manualmente). Contiene las implementaciones concretas de DAOs y el builder de la DB.

- `lib/data/datasources/datasources.dart`
  - Barrel export para los datasources.

## Decisiones técnicas importantes

- DateTime no se almacena directamente en Floor: se guardan como `int` (millisecondsSinceEpoch). Esto resolvió errores del generador.
- Evitamos firmas DAO que devuelvan `Map<String, dynamic>` porque Floor no soporta ese tipo en la firma del método; en su lugar usamos tipos escalares o modelos concretos.
- El archivo `app_database.g.dart` es generado y puede contener advertencias de linter (long lines, trailing commas, casts). No se deben editar manualmente.

## Integración / cómo reproducir localmente

Requisitos previos: usar FVM con la versión de Flutter configurada en el proyecto (3.35.7 según las pruebas). En VS Code se configuró la PATH del `flutter` de FVM en `launch.json`.

Pasos para regenerar / trabajar con la DB:

1. Instalar dependencias (usar FVM):

```bash
fvm flutter pub get
```

2. Generar código de Floor (si editas entidades o DAOs):

```bash
fvm flutter packages pub run build_runner build --delete-conflicting-outputs
```

3. Analizar el proyecto (opcional, da muchas advertencias por archivos generados):

```bash
fvm flutter analyze
```

4. Construir / ejecutar la app (ejemplo debug flavor `development`):

```bash
fvm flutter run --flavor development -t lib/main_development.dart
```

## Nota sobre `sqflite` y dependencias

El analizador reportó: "The imported package 'sqflite' isn't a dependency of the importing package" en `app_database.dart`. Asegúrate de que `sqflite` esté listado en `pubspec.yaml` bajo `dependencies:`. Si no está, añade:

```yaml
dependencies:
  sqflite: ^2.2.7+1 # o la versión que prefieras compatible
```

y luego ejecuta `fvm flutter pub get`.

## Qué falta para cerrar la capa de datos (siguientes pasos recomendados)

- Implementar las clases de repositorio (ej., `ExerciseRepositoryImpl`, `RoutineRepositoryImpl`) que usen los DAOs y mapeen modelos <-> entidades de dominio.
- Configurar inyección de dependencias (GetIt + Injectable) y registrar `AppDatabase` y repositorios.
- Añadir tests unitarios básicos para CRUD de ejercicios y rutinas usando la BD en memoria o una DB temporal.
- (Opcional) Implementar un mecanismo de seed para cargar ejercicios por defecto en la primera ejecución.

## Resumen final

Sí: lo que hice fue crear una base de datos local usando Floor/SQLite y mapear las entidades necesarias para las rutinas, ejercicios y registros de entrenamiento. También resolví problemas del generador (DateTime → int, tipos DAO) y generé el archivo de implementación de la DB (`app_database.g.dart`).

Si quieres, ahora:
- Puedo añadir ejemplo de repositorio (`lib/data/repositories/exercise_repository_impl.dart`) y una prueba rápida que cree/lea un ejercicio para verificar la persistencia, o
- Puedo crear un README más breve en `lib/data/README.md` con instrucciones de uso, o
- Puedo registrar la DB en GetIt y generar la configuración base de inyección.

Dime qué prefieres que haga a continuación y lo pongo en marcha. 