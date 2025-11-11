# Floor y la capa de datos (Gym Tracker)

Este documento explica qué es Floor, por qué lo usamos en este proyecto, y exactamente qué hicimos en la capa de datos (Data Layer) para implementar persistencia local.

## ¿Qué es Floor?
Floor es un ORM ligero para Flutter/Dart que facilita trabajar con SQLite usando anotaciones (annotations) y generación de código. Floor proporciona:

- Entidades anotadas con `@entity` que se mapean a tablas SQLite.
- DAOs (`@dao`) donde defines consultas SQL mediante `@Query`, además de `@insert`, `@update` y `@delete`.
- Una clase `@Database` que agrupa las entidades y expone los DAOs.
- Generación de código por `build_runner` que crea las implementaciones concretas de los DAOs y el `Database`.

Floor es una buena opción cuando quieres un control explícito de tus consultas SQL pero prefieres evitar escribir el boilerplate de bajo nivel de `sqflite`.

## Por qué lo usamos
- Persistencia local requerida por el MVP: guardar rutinas, ejercicios y registros de entrenamientos.
- Integración sencilla con patrones de Clean Architecture: los modelos de datos (Floor entities) se mapean a entidades de dominio mediante mappers.
- API declarativa y generación automática de DAOs para reducir errores manuales al implementar consultas.

## Qué hicimos exactamente en la capa de datos
Lista de archivos añadidos y su propósito:

- `lib/data/models/exercise_model.dart`
  - Entidad `ExerciseModel` con anotación de Floor (campos: id, name, type, muscleGroups serializados, etc.).
  - Métodos `toEntity()` y `fromEntity()` para convertir entre modelo de datos (DB) y entidad de dominio.
  - Cambios notables: los campos `DateTime` se almacenan como `int` (milisegundos desde epoch) porque Floor no soporta directamente `DateTime` como tipo de columna.

- `lib/data/models/routine_model.dart`
  - `RoutineModel` y `RoutineExerciseModel` para representar rutinas y la relación con ejercicios.
  - `createdAt` / `updatedAt` almacenados como `int` (timestamp). Mappers `toEntity()` / `fromEntity()` añadidos.

- `lib/data/models/workout_record_model.dart`
  - Modelos para `WorkoutRecord`, `ExerciseRecord` y `SetRecord`.
  - Fechas/horas guardadas como `int` (timestamp) y conversiones a la capa de dominio.

- `lib/data/models/models.dart`
  - Barrel export para los modelos.

- `lib/data/datasources/local/exercise_dao.dart`
  - DAO con consultas básicas CRUD para ejercicios (select all, by id, insert, update, delete).

- `lib/data/datasources/local/routine_dao.dart`
  - DAO para rutinas y rutinas-ejercicio. Consultas para listar rutinas, buscar por tags, archivar, etc.

- `lib/data/datasources/local/workout_dao.dart`
  - DAO para registros de entrenamiento. Consultas para crear/leer registros, contar entrenos en rango de fechas, etc.

- `lib/data/datasources/local/app_database.dart`
  - Clase `@Database` que agrupa todas las entidades y expone los DAOs.
  - Nota: se dejó la inicialización simple; en el futuro podemos añadir una semilla (seed) controlada para datos predeterminados.

- `lib/data/datasources/local/app_database.g.dart`
  - Código generado por Floor (implementaciones concretas). Este archivo no se edita manualmente.

### Cambios importantes y por qué
- DateTime -> int (timestamp): Floor requiere tipos primitivos para columnas; se eligió usar `millisecondsSinceEpoch` para preservar precisión y facilitar conversiones.
- Evitar `Map<String, dynamic>` en firmas DAO: Floor no puede inferir tipos complejos en firmas DAO; se cambiaron las firmas a tipos escalares o a modelos concretos.

## Cómo reproducir (comandos útiles)
1. Asegúrate de usar FVM y la versión correcta de Flutter (en este proyecto se usó Flutter 3.35.7):

```bash
# instala/usa la versión FVM si no la tienes
fvm use 3.35.7

# Obtener dependencias usando FVM
fvm flutter pub get
```

2. Generar código de Floor (build_runner):

```bash
fvm flutter packages pub run build_runner build --delete-conflicting-outputs
```

3. Analizar con el analyzer (puede mostrar warnings/infos generados por archivos .g.dart):

```bash
fvm flutter analyze
```

4. Ejecutar la app (emulador o device):

```bash
# Ejecuta en dispositivo/emulador (development flavor)
fvm flutter run --flavor development -t lib/main_development.dart

# O construir APK de debug
fvm flutter build apk --debug --flavor development -t lib/main_development.dart
```

## Notas y recomendaciones
- `app_database.g.dart` es un archivo generado — no lo modifiques a mano. Si necesitas cambios en la DB (nuevas columnas/entidades), actualiza las entidades/DAOs y vuelve a ejecutar build_runner.
- Si el analyzer muestra problemas dentro de `app_database.g.dart`, normalmente se ignoran en revisiones manuales porque son generados; aún así, puedes ajustar reglas de lint o excluir carpetas generadas si lo deseas.
- Siguiente paso técnico recomendable: implementar `Repository` (por ejemplo `ExerciseRepositoryImpl`) que use los DAOs y mappers, y registrar la DB/repositories en GetIt para exponerlos a la capa de presentación.
- Si quieres datos iniciales (por ejemplo ejercicios por defecto), implementa un `seedDefaultExercises()` que se ejecute en la primera ejecución, en vez de intentar insertar en el callback del generador de Floor (que complica la generación).

## Preguntas frecuentes rápidas
- ¿Floor es lo mismo que sqflite? No: Floor usa sqflite bajo el capó para acceder a SQLite, pero Floor añade anotaciones y generación de código para simplificar el uso.
- ¿Puedo ejecutar migraciones con Floor? Sí, Floor soporta migrations; se deben declarar y registrarlas en el `databaseBuilder`.

---

Si quieres, ahora puedo:
- Añadir una sección con ejemplos de código para `ExerciseRepositoryImpl` y su registro en `GetIt`.
- Crear un `seedDefaultExercises()` y el flujo de primer arranque.
- Corregir automáticamente pequeñas advertencias (p. ej. imports package: vs relativos y newlines finales) para que `flutter analyze` baje el número de issues.

Dime cuál prefieres y me pongo a ello.