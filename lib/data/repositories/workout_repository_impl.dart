import 'package:gym_tracker/data/datasources/local/workout_dao.dart';
import 'package:gym_tracker/data/models/models.dart';
import 'package:gym_tracker/domain/entities/entities.dart';
import 'package:gym_tracker/domain/repositories/repositories.dart';
import 'package:injectable/injectable.dart';

/// Implementación del repositorio de entrenamientos usando Floor/SQLite
@LazySingleton(as: WorkoutRepository)
class WorkoutRepositoryImpl implements WorkoutRepository {
  WorkoutRepositoryImpl(
    this._workoutDao,
    this._exerciseRecordDao,
    this._setRecordDao,
  );

  final WorkoutRecordDao _workoutDao;
  final ExerciseRecordDao _exerciseRecordDao;
  final SetRecordDao _setRecordDao;

  @override
  Future<List<WorkoutRecord>> getAllWorkouts() async {
    final models = await _workoutDao.getAllWorkouts();
    return _mapWorkoutsWithRecords(models);
  }

  @override
  Future<List<WorkoutRecord>> getWorkoutsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final models = await _workoutDao.getWorkoutsByDateRange(
      startDate.millisecondsSinceEpoch,
      endDate.millisecondsSinceEpoch,
    );
    return _mapWorkoutsWithRecords(models);
  }

  @override
  Future<WorkoutRecord?> getWorkoutById(String id) async {
    final model = await _workoutDao.getWorkoutById(id);
    if (model == null) return null;

    final exerciseRecords =
        await _exerciseRecordDao.getExerciseRecordsByWorkout(id);
    final exercises = await Future.wait(
      exerciseRecords.map((e) async {
        final sets = await _setRecordDao.getSetsByExerciseRecord(e.id);
        return e.toEntity(sets: sets.map((s) => s.toEntity()).toList());
      }),
    );

    return model.toEntity(exerciseRecords: exercises);
  }

  @override
  Future<List<WorkoutRecord>> getWorkoutsByRoutine(String routineId) async {
    final models = await _workoutDao.getWorkoutsByRoutine(routineId);
    return _mapWorkoutsWithRecords(models);
  }

  @override
  Future<WorkoutRecord?> getLastWorkout() async {
    final model = await _workoutDao.getLastWorkout();
    if (model == null) return null;

    final exerciseRecords =
        await _exerciseRecordDao.getExerciseRecordsByWorkout(model.id);
    final exercises = await Future.wait(
      exerciseRecords.map((e) async {
        final sets = await _setRecordDao.getSetsByExerciseRecord(e.id);
        return e.toEntity(sets: sets.map((s) => s.toEntity()).toList());
      }),
    );

    return model.toEntity(exerciseRecords: exercises);
  }

  @override
  Future<List<WorkoutRecord>> getActiveWorkouts() async {
    final models = await _workoutDao.getActiveWorkouts();
    return _mapWorkoutsWithRecords(models);
  }

  @override
  Future<WorkoutRecord> createWorkout(WorkoutRecord workout) async {
    final model = WorkoutRecordModel.fromEntity(workout);
    await _workoutDao.insertWorkout(model);

    // Insertar ejercicios y sets
    for (final exercise in workout.exerciseRecords) {
      final exerciseModel = ExerciseRecordModel.fromEntity(
        exercise,
        workout.id,
      );
      await _exerciseRecordDao.insertExerciseRecord(exerciseModel);

      for (final set in exercise.sets) {
        final setModel = SetRecordModel.fromEntity(set, exerciseModel.id);
        await _setRecordDao.insertSetRecord(setModel);
      }
    }

    return workout;
  }

  @override
  Future<WorkoutRecord> updateWorkout(WorkoutRecord workout) async {
    final model = WorkoutRecordModel.fromEntity(workout);
    await _workoutDao.updateWorkout(model);

    // Eliminar registros antiguos y reinsertar
    await _exerciseRecordDao.deleteExerciseRecordsByWorkout(workout.id);

    for (final exercise in workout.exerciseRecords) {
      final exerciseModel = ExerciseRecordModel.fromEntity(
        exercise,
        workout.id,
      );
      await _exerciseRecordDao.insertExerciseRecord(exerciseModel);

      for (final set in exercise.sets) {
        final setModel = SetRecordModel.fromEntity(set, exerciseModel.id);
        await _setRecordDao.insertSetRecord(setModel);
      }
    }

    return workout;
  }

  @override
  Future<void> deleteWorkout(String id) async {
    final model = await _workoutDao.getWorkoutById(id);
    if (model != null) {
      // Los sets se eliminan en cascada al eliminar exercise records
      await _exerciseRecordDao.deleteExerciseRecordsByWorkout(id);
      await _workoutDao.deleteWorkout(model);
    }
  }

  @override
  Future<WorkoutRecord> startWorkout(String routineId) async {
    final now = DateTime.now();
    final workout = WorkoutRecord(
      id: now.millisecondsSinceEpoch.toString(),
      routineId: routineId,
      date: now,
      startTime: now,
      exerciseRecords: const <ExerciseRecord>[],
      status: WorkoutStatus.inProgress,
    );

    return createWorkout(workout);
  }

  @override
  Future<WorkoutRecord> completeWorkout(String workoutId) async {
    final workout = await getWorkoutById(workoutId);
    if (workout == null) {
      throw Exception('Workout not found: $workoutId');
    }

    final completed = workout.copyWith(
      status: WorkoutStatus.completed,
      endTime: DateTime.now(),
    );

    return updateWorkout(completed);
  }

  @override
  Future<WorkoutRecord> cancelWorkout(String workoutId) async {
    final workout = await getWorkoutById(workoutId);
    if (workout == null) {
      throw Exception('Workout not found: $workoutId');
    }

    final cancelled = workout.copyWith(
      status: WorkoutStatus.cancelled,
      endTime: DateTime.now(),
    );

    return updateWorkout(cancelled);
  }

  @override
  Future<WorkoutRecord> updateExerciseRecord(
    String workoutId,
    ExerciseRecord exerciseRecord,
  ) async {
    final workout = await getWorkoutById(workoutId);
    if (workout == null) {
      throw Exception('Workout not found: $workoutId');
    }

    // Buscar y reemplazar el ejercicio
    final exerciseRecords = workout.exerciseRecords.map(
      (ExerciseRecord e) {
        if (e.exerciseId == exerciseRecord.exerciseId) {
          return exerciseRecord;
        }
        return e;
      },
    ).toList();

    final updated = workout.copyWith(exerciseRecords: exerciseRecords);
    return updateWorkout(updated);
  }

  @override
  Future<Map<String, dynamic>> getExerciseStats(String exerciseId) async {
    // TODO: Implementar estadísticas agregadas (series, reps, peso máximo, etc.).
    return {};
  }

  @override
  Future<List<Map<String, dynamic>>> getExerciseProgress(
    String exerciseId,
  ) async {
    // TODO: Implementar historial de progreso por fecha.
    return [];
  }

  @override
  Future<Map<String, dynamic>> getPersonalRecords() async {
    // TODO: Implementar cálculo de récords personales.
    return {};
  }

  /// Helper para mapear workouts con sus ejercicios y sets
  Future<List<WorkoutRecord>> _mapWorkoutsWithRecords(
    List<WorkoutRecordModel> models,
  ) async {
    final workouts = <WorkoutRecord>[];
    for (final model in models) {
      final exerciseRecords =
          await _exerciseRecordDao.getExerciseRecordsByWorkout(model.id);
      final exercises = await Future.wait(
        exerciseRecords.map((e) async {
          final sets = await _setRecordDao.getSetsByExerciseRecord(e.id);
          return e.toEntity(sets: sets.map((s) => s.toEntity()).toList());
        }),
      );
      workouts.add(model.toEntity(exerciseRecords: exercises));
    }
    return workouts;
  }
}
