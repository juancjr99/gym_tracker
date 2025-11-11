import 'package:gym_tracker/data/datasources/local/routine_dao.dart';
import 'package:gym_tracker/data/models/models.dart';
import 'package:gym_tracker/domain/entities/entities.dart';
import 'package:gym_tracker/domain/repositories/repositories.dart';

/// Implementación del repositorio de rutinas usando Floor/SQLite
class RoutineRepositoryImpl implements RoutineRepository {
  RoutineRepositoryImpl(
    this._routineDao,
    this._routineExerciseDao,
  );

  final RoutineDao _routineDao;
  final RoutineExerciseDao _routineExerciseDao;

  @override
  Future<List<Routine>> getAllRoutines() async {
    final models = await _routineDao.getAllRoutines();
    return _mapRoutinesWithExercises(models);
  }

  @override
  Future<List<Routine>> getRoutinesByType(RoutineType type) async {
    final models = await _routineDao.getRoutinesByType(type.name);
    return _mapRoutinesWithExercises(models);
  }

  @override
  Future<Routine?> getRoutineById(String id) async {
    final model = await _routineDao.getRoutineById(id);
    if (model == null) return null;

    final exerciseModels =
        await _routineExerciseDao.getExercisesByRoutineId(id);
    final exercises =
        exerciseModels.map((RoutineExerciseModel e) => e.toEntity()).toList();

    return model.toEntity(exercises: exercises);
  }

  @override
  Future<List<Routine>> searchRoutines(String query) async {
    final models = await _routineDao.searchRoutines(query);
    return _mapRoutinesWithExercises(models);
  }

  @override
  Future<Routine> createRoutine(Routine routine) async {
    final model = RoutineModel.fromEntity(routine);
    await _routineDao.insertRoutine(model);

    // Insertar ejercicios de la rutina
    for (var i = 0; i < routine.exercises.length; i++) {
      final exerciseModel = RoutineExerciseModel.fromEntity(
        routine.exercises[i],
        routine.id,
      );
      await _routineExerciseDao.insertRoutineExercise(exerciseModel);
    }

    return routine;
  }

  @override
  Future<Routine> updateRoutine(Routine routine) async {
    final model = RoutineModel.fromEntity(routine);
    await _routineDao.updateRoutine(model);

    // Eliminar ejercicios antiguos y reinsertar
    await _routineExerciseDao.deleteExercisesByRoutineId(routine.id);
    for (var i = 0; i < routine.exercises.length; i++) {
      final exerciseModel = RoutineExerciseModel.fromEntity(
        routine.exercises[i],
        routine.id,
      );
      await _routineExerciseDao.insertRoutineExercise(exerciseModel);
    }

    return routine;
  }

  @override
  Future<void> deleteRoutine(String id) async {
    final model = await _routineDao.getRoutineById(id);
    if (model != null) {
      await _routineExerciseDao.deleteExercisesByRoutineId(id);
      await _routineDao.deleteRoutine(model);
    }
  }

  @override
  Future<Routine> duplicateRoutine(String routineId, String newName) async {
    final original = await getRoutineById(routineId);
    if (original == null) {
      throw Exception('Routine not found: $routineId');
    }

    final duplicate = original.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: newName,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return createRoutine(duplicate);
  }

  @override
  Future<List<Routine>> getTemplateRoutines() async {
    final models = await _routineDao.getTemplateRoutines();
    return _mapRoutinesWithExercises(models);
  }

  @override
  Future<List<Routine>> getArchivedRoutines() async {
    final models = await _routineDao.getArchivedRoutines();
    return _mapRoutinesWithExercises(models);
  }

  @override
  Future<void> toggleArchiveRoutine(String routineId) async {
    final model = await _routineDao.getRoutineById(routineId);
    if (model != null) {
      // isActive = false significa archivado
      final updated = model.copyWith(isActive: !model.isActive);
      await _routineDao.updateRoutine(updated);
    }
  }

  @override
  Future<List<Routine>> getRoutinesByTags(List<String> tags) async {
    // El DAO solo soporta un tag por vez; iteramos y combinamos
    final allModels = <RoutineModel>[];
    for (final tag in tags) {
      final models = await _routineDao.getRoutinesByTag('%$tag%');
      allModels.addAll(models);
    }
    // Eliminar duplicados por ID
    final uniqueModels = <String, RoutineModel>{};
    for (final model in allModels) {
      uniqueModels[model.id] = model;
    }
    return _mapRoutinesWithExercises(uniqueModels.values.toList());
  }

  @override
  Future<List<String>> getAllTags() async {
    // No hay método en DAO para esto; retornamos lista vacía por ahora.
    // TODO: Implementar query para tags únicos si se requiere.
    return [];
  }

  @override
  Future<Routine> reorderExercises(
    String routineId,
    List<String> exerciseIds,
  ) async {
    final routine = await getRoutineById(routineId);
    if (routine == null) {
      throw Exception('Routine not found: $routineId');
    }

    // Reordenar ejercicios según la lista de IDs
    final reorderedExercises = <RoutineExercise>[];
    for (final id in exerciseIds) {
      final exercise = routine.exercises.firstWhere(
        (e) => e.exerciseId == id,
        orElse: () => throw Exception('Exercise not found: $id'),
      );
      reorderedExercises.add(exercise);
    }

    final updatedRoutine = routine.copyWith(exercises: reorderedExercises);
    return updateRoutine(updatedRoutine);
  }

  /// Helper para mapear rutinas con sus ejercicios
  Future<List<Routine>> _mapRoutinesWithExercises(
    List<RoutineModel> models,
  ) async {
    final routines = <Routine>[];
    for (final model in models) {
      final exerciseModels =
          await _routineExerciseDao.getExercisesByRoutineId(
        model.id,
      );
      final exercises = exerciseModels
          .map((RoutineExerciseModel e) => e.toEntity())
          .toList();
      routines.add(model.toEntity(exercises: exercises));
    }
    return routines;
  }
}
