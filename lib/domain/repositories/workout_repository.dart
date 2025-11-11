import '../entities/entities.dart';

/// Repositorio abstracto para la gestión de registros de entrenamiento
abstract class WorkoutRepository {
  /// Obtiene todos los registros de entrenamiento
  Future<List<WorkoutRecord>> getAllWorkouts();
  
  /// Obtiene registros de entrenamiento por rango de fechas
  Future<List<WorkoutRecord>> getWorkoutsByDateRange(
    DateTime startDate,
    DateTime endDate,
  );
  
  /// Obtiene un registro de entrenamiento por ID
  Future<WorkoutRecord?> getWorkoutById(String id);
  
  /// Obtiene registros por rutina
  Future<List<WorkoutRecord>> getWorkoutsByRoutine(String routineId);
  
  /// Obtiene el último entrenamiento realizado
  Future<WorkoutRecord?> getLastWorkout();
  
  /// Obtiene entrenamientos en progreso
  Future<List<WorkoutRecord>> getActiveWorkouts();
  
  /// Crea un nuevo registro de entrenamiento
  Future<WorkoutRecord> createWorkout(WorkoutRecord workout);
  
  /// Actualiza un registro de entrenamiento
  Future<WorkoutRecord> updateWorkout(WorkoutRecord workout);
  
  /// Elimina un registro de entrenamiento
  Future<void> deleteWorkout(String id);
  
  /// Inicia un nuevo entrenamiento
  Future<WorkoutRecord> startWorkout(String routineId);
  
  /// Completa un entrenamiento en progreso
  Future<WorkoutRecord> completeWorkout(String workoutId);
  
  /// Cancela un entrenamiento en progreso
  Future<WorkoutRecord> cancelWorkout(String workoutId);
  
  /// Actualiza un ejercicio específico en el entrenamiento
  Future<WorkoutRecord> updateExerciseRecord(
    String workoutId,
    ExerciseRecord exerciseRecord,
  );
  
  /// Obtiene estadísticas de entrenamientos por ejercicio
  Future<Map<String, dynamic>> getExerciseStats(String exerciseId);
  
  /// Obtiene el historial de progreso para un ejercicio específico
  Future<List<Map<String, dynamic>>> getExerciseProgress(String exerciseId);
  
  /// Obtiene records personales del usuario
  Future<Map<String, dynamic>> getPersonalRecords();
}