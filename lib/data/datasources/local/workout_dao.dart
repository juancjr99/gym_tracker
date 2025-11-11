import 'package:floor/floor.dart';
import '../../models/models.dart';

/// DAO para la gestión de registros de entrenamiento
@dao
abstract class WorkoutRecordDao {
  /// Obtiene todos los registros de entrenamiento ordenados por fecha
  @Query('SELECT * FROM workout_records ORDER BY date DESC')
  Future<List<WorkoutRecordModel>> getAllWorkouts();

  /// Obtiene registros por rango de fechas
  @Query('SELECT * FROM workout_records WHERE date BETWEEN :startDate AND :endDate ORDER BY date DESC')
  Future<List<WorkoutRecordModel>> getWorkoutsByDateRange(int startDate, int endDate);

  /// Obtiene un registro por ID
  @Query('SELECT * FROM workout_records WHERE id = :id')
  Future<WorkoutRecordModel?> getWorkoutById(String id);

  /// Obtiene registros por rutina
  @Query('SELECT * FROM workout_records WHERE routineId = :routineId ORDER BY date DESC')
  Future<List<WorkoutRecordModel>> getWorkoutsByRoutine(String routineId);

  /// Obtiene el último entrenamiento
  @Query('SELECT * FROM workout_records ORDER BY date DESC LIMIT 1')
  Future<WorkoutRecordModel?> getLastWorkout();

  /// Obtiene entrenamientos en progreso
  @Query('SELECT * FROM workout_records WHERE status = :status')
  Future<List<WorkoutRecordModel>> getWorkoutsByStatus(String status);

  /// Obtiene entrenamientos activos (en progreso)
  @Query('SELECT * FROM workout_records WHERE status = "inProgress" ORDER BY startTime DESC')
  Future<List<WorkoutRecordModel>> getActiveWorkouts();

  /// Obtiene entrenamientos completados
  @Query('SELECT * FROM workout_records WHERE status = "completed" ORDER BY date DESC')
  Future<List<WorkoutRecordModel>> getCompletedWorkouts();

  /// Inserta un nuevo registro de entrenamiento
  @insert
  Future<void> insertWorkout(WorkoutRecordModel workout);

  /// Actualiza un registro de entrenamiento
  @update
  Future<void> updateWorkout(WorkoutRecordModel workout);

  /// Elimina un registro de entrenamiento
  @delete
  Future<void> deleteWorkout(WorkoutRecordModel workout);

  /// Elimina un registro por ID
  @Query('DELETE FROM workout_records WHERE id = :id')
  Future<void> deleteWorkoutById(String id);

  /// Obtiene el conteo de entrenamientos completados en un rango
  @Query('SELECT COUNT(*) FROM workout_records WHERE status = "completed" AND date >= :startDate AND date <= :endDate')
  Future<int?> getCompletedWorkoutCountInRange(int startDate, int endDate);

  /// Obtiene el conteo total de entrenamientos completados
  @Query('SELECT COUNT(*) FROM workout_records WHERE status = "completed"')
  Future<int?> getCompletedWorkoutCount();
}

/// DAO para la gestión de registros de ejercicios
@dao
abstract class ExerciseRecordDao {
  /// Obtiene todos los registros de ejercicios de un entrenamiento
  @Query('SELECT * FROM exercise_records WHERE workoutId = :workoutId')
  Future<List<ExerciseRecordModel>> getExerciseRecordsByWorkout(String workoutId);

  /// Obtiene un registro de ejercicio específico
  @Query('SELECT * FROM exercise_records WHERE workoutId = :workoutId AND exerciseId = :exerciseId')
  Future<ExerciseRecordModel?> getExerciseRecord(String workoutId, String exerciseId);

  /// Obtiene registros por ejercicio para análisis de progreso
  @Query('SELECT * FROM exercise_records WHERE exerciseId = :exerciseId ORDER BY id DESC')
  Future<List<ExerciseRecordModel>> getExerciseRecordsByExercise(String exerciseId);

  /// Inserta un nuevo registro de ejercicio
  @insert
  Future<void> insertExerciseRecord(ExerciseRecordModel exerciseRecord);

  /// Inserta múltiples registros de ejercicios
  @insert
  Future<void> insertExerciseRecords(List<ExerciseRecordModel> exerciseRecords);

  /// Actualiza un registro de ejercicio
  @update
  Future<void> updateExerciseRecord(ExerciseRecordModel exerciseRecord);

  /// Elimina un registro de ejercicio
  @delete
  Future<void> deleteExerciseRecord(ExerciseRecordModel exerciseRecord);

  /// Elimina todos los registros de ejercicios de un entrenamiento
  @Query('DELETE FROM exercise_records WHERE workoutId = :workoutId')
  Future<void> deleteExerciseRecordsByWorkout(String workoutId);

  /// Marca un ejercicio como completado
  @Query('UPDATE exercise_records SET completed = 1 WHERE id = :id')
  Future<void> markExerciseCompleted(String id);

  /// Obtiene ejercicios completados de un entrenamiento
  @Query('SELECT * FROM exercise_records WHERE workoutId = :workoutId AND completed = 1')
  Future<List<ExerciseRecordModel>> getCompletedExercises(String workoutId);
}

/// DAO para la gestión de registros de series
@dao
abstract class SetRecordDao {
  /// Obtiene todas las series de un registro de ejercicio
  @Query('SELECT * FROM set_records WHERE exerciseRecordId = :exerciseRecordId ORDER BY setNumber ASC')
  Future<List<SetRecordModel>> getSetsByExerciseRecord(String exerciseRecordId);

  /// Obtiene una serie específica
  @Query('SELECT * FROM set_records WHERE exerciseRecordId = :exerciseRecordId AND setNumber = :setNumber')
  Future<SetRecordModel?> getSetRecord(String exerciseRecordId, int setNumber);

  /// Obtiene series completadas de un ejercicio
  @Query('SELECT * FROM set_records WHERE exerciseRecordId = :exerciseRecordId AND completed = 1 ORDER BY setNumber ASC')
  Future<List<SetRecordModel>> getCompletedSets(String exerciseRecordId);

  /// Inserta una nueva serie
  @insert
  Future<void> insertSetRecord(SetRecordModel setRecord);

  /// Inserta múltiples series
  @insert
  Future<void> insertSetRecords(List<SetRecordModel> setRecords);

  /// Actualiza una serie
  @update
  Future<void> updateSetRecord(SetRecordModel setRecord);

  /// Elimina una serie
  @delete
  Future<void> deleteSetRecord(SetRecordModel setRecord);

  /// Elimina todas las series de un ejercicio
  @Query('DELETE FROM set_records WHERE exerciseRecordId = :exerciseRecordId')
  Future<void> deleteSetsByExerciseRecord(String exerciseRecordId);

  /// Marca una serie como completada
  @Query('UPDATE set_records SET completed = 1 WHERE id = :id')
  Future<void> markSetCompleted(String id);

  /// Obtiene el máximo peso levantado para un ejercicio
  @Query('SELECT MAX(weight) FROM set_records sr INNER JOIN exercise_records er ON sr.exerciseRecordId = er.id WHERE er.exerciseId = :exerciseId AND sr.completed = 1')
  Future<double?> getMaxWeightForExercise(String exerciseId);

  /// Obtiene el máximo de repeticiones para un ejercicio con un peso específico
  @Query('SELECT MAX(reps) FROM set_records sr INNER JOIN exercise_records er ON sr.exerciseRecordId = er.id WHERE er.exerciseId = :exerciseId AND sr.weight = :weight AND sr.completed = 1')
  Future<int?> getMaxRepsForWeight(String exerciseId, double weight);
}