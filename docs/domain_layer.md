# Documentación - Capa de Dominio (Domain Layer)

Fecha: 2025-11-11

Resumen de cambios y diseño realizado en la capa de dominio y su integración con la capa de datos.

## Objetivo
Registrar lo que se implementó en la capa de dominio: casos de uso (use cases), implementaciones de repositorios en la capa de datos que satisfacen los contratos del dominio, y notas sobre mapeo entre modelos (data) y entidades (domain).

## Archivos añadidos / modificados
- `lib/data/repositories/exercise_repository_impl.dart`
  - Implementa `ExerciseRepository` usando `ExerciseDao`.
  - Métodos CRUD y búsquedas: `getAllExercises`, `getExercisesByMuscleGroup`, `getExercisesByType`, `searchExercises`, `createExercise`, `updateExercise`, `deleteExercise`, `getCustomExercises`.
  - `getFavoriteExercises` y `toggleFavorite` quedan como TODO (requieren añadir `isFavorite` en model).

- `lib/data/repositories/routine_repository_impl.dart`
  - Implementa `RoutineRepository` usando `RoutineDao` y `RoutineExerciseDao`.
  - Lógica para mapear rutinas con sus ejercicios desde la tabla de unión (`RoutineExerciseModel`).
  - Métodos: `getAllRoutines`, `getRoutinesByType`, `getRoutineById`, `searchRoutines`, `createRoutine`, `updateRoutine`, `deleteRoutine`, `duplicateRoutine`, `getTemplateRoutines`, `getArchivedRoutines`, `toggleArchiveRoutine`, `getRoutinesByTags`, `getAllTags` (vacío por ahora), `reorderExercises`.

- `lib/data/repositories/workout_repository_impl.dart`
  - Implementa `WorkoutRepository` usando `WorkoutRecordDao`, `ExerciseRecordDao`, `SetRecordDao`.
  - Mapea registros de entrenamiento con sus `exerciseRecords` y `sets` de forma recursiva.
  - Métodos: gestión del flujo de entrenamiento (`startWorkout`, `createWorkout`, `updateWorkout`, `completeWorkout`, `cancelWorkout`), consultas (`getAllWorkouts`, `getWorkoutsByDateRange`, `getWorkoutsByRoutine`, `getLastWorkout`, `getActiveWorkouts`) y utilidades (estadísticas TODO).

- `lib/domain/usecases/routine_usecases.dart` (nuevo)
  - Colección de use cases para operaciones sobre rutinas (crear, actualizar, eliminar, duplicar, buscar, reordenar).

- `lib/domain/usecases/workout_usecases.dart` (nuevo)
  - Colección de use cases para flujos de entrenamientos (iniciar, completar, cancelar, actualizar ejercicios, guardar).

- `lib/domain/usecases/usecases.dart` y `lib/data/repositories/repositories.dart`
  - Barrel files para exportar los módulos nuevos.

## Principios y decisiones de diseño
- Clean Architecture: la capa de dominio solo define entidades, interfaces (repositorios) y casos de uso. No depende de la capa de datos.
- Las implementaciones concretas de repositorios se colocan en `lib/data/repositories/` y usan DAOs generados por Floor.
- Mapeo:
  - Modelos (`*Model`) proveen `toEntity()` y `fromEntity()` para convertir entre data <-> domain.
  - Los repositorios se encargan de todas las conversiones; los use cases reciben/retornan entidades.
- Floor (sqlite): la base de datos y DAOs fueron generados previamente; las implementaciones de repositorio consumen esas APIs exactas (atención a parámetros posicionales vs nombrados).

## Notas importantes / TODOs pendientes
- Verificar/añadir campo `isFavorite` en `ExerciseModel` si se requiere funcionalidad de favoritos.
- Implementar `getAllTags()` en `RoutineDao` si se necesita obtener tags únicos desde BD.
- Implementar cálculos de estadísticas (`getExerciseStats`, `getExerciseProgress`, `getPersonalRecords`) en `WorkoutRepositoryImpl`.
- Configurar inyección de dependencias (GetIt + Injectable) para registrar la `AppDatabase`, DAOs, repositorios y use cases.
- Seguir con la presentación (BLoC/Cubit) y UI.

## Flujo típico de datos
1. La UI solicita una acción (por ejemplo, crear rutina) y llama a un UseCase.
2. El UseCase valida y llama al método correspondiente del `RoutineRepository`.
3. `RoutineRepositoryImpl` mapea la `Routine` (entidad) a `RoutineModel` y usa los DAOs para persistir datos.
4. Los DAOs ejecutan queries con Floor/SQLite; modelos generados se almacenan en la BD.
5. Las consultas vuelven como `Model`s: los repositorios llaman a `model.toEntity()` y retornan entidades a los use cases y luego a la UI.

## Verificación
- Se ejecutó `flutter analyze` (fvm) y no se encontraron errores de compilación; aparecieron 498 issues informativos/estilo (newlines finales, trailing commas, imports, líneas largas y lints en código generado). Estos son principalmente cosméticos y en archivos generados por Floor.

## Archivos relacionados
- `lib/data/datasources/local/app_database.dart`
- DAOs: `lib/data/datasources/local/*_dao.dart`
- Models: `lib/data/models/*`
- Entidades: `lib/domain/entities/*`
- Use cases: `lib/domain/usecases/*`

---

Este documento puede ser ampliado con ejemplos de uso, diagramas o comandos para ejecutar la generación de Floor (`flutter pub run build_runner build --delete-conflicting-outputs`) y la configuración de inyección de dependencias cuando se añada.
