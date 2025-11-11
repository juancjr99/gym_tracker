import 'package:floor/floor.dart';
import '../../models/models.dart';

/// DAO para la gestión de rutinas en la base de datos
@dao
abstract class RoutineDao {
  /// Obtiene todas las rutinas activas
  @Query('SELECT * FROM routines WHERE isActive = 1 ORDER BY name ASC')
  Future<List<RoutineModel>> getAllRoutines();

  /// Obtiene rutinas por tipo
  @Query('SELECT * FROM routines WHERE type = :type AND isActive = 1 ORDER BY name ASC')
  Future<List<RoutineModel>> getRoutinesByType(String type);

  /// Obtiene una rutina por ID
  @Query('SELECT * FROM routines WHERE id = :id')
  Future<RoutineModel?> getRoutineById(String id);

  /// Busca rutinas por nombre
  @Query('SELECT * FROM routines WHERE name LIKE :query AND isActive = 1 ORDER BY name ASC')
  Future<List<RoutineModel>> searchRoutines(String query);

  /// Obtiene rutinas plantilla
  @Query('SELECT * FROM routines WHERE isTemplate = 1 ORDER BY name ASC')
  Future<List<RoutineModel>> getTemplateRoutines();

  /// Obtiene rutinas archivadas
  @Query('SELECT * FROM routines WHERE isActive = 0 ORDER BY name ASC')
  Future<List<RoutineModel>> getArchivedRoutines();

  /// Obtiene rutinas que contienen tags específicos
  @Query('SELECT * FROM routines WHERE tags LIKE :tag AND isActive = 1 ORDER BY name ASC')
  Future<List<RoutineModel>> getRoutinesByTag(String tag);

  /// Inserta una nueva rutina
  @insert
  Future<void> insertRoutine(RoutineModel routine);

  /// Actualiza una rutina existente
  @update
  Future<void> updateRoutine(RoutineModel routine);

  /// Elimina una rutina
  @delete
  Future<void> deleteRoutine(RoutineModel routine);

  /// Elimina una rutina por ID
  @Query('DELETE FROM routines WHERE id = :id')
  Future<void> deleteRoutineById(String id);

  /// Archiva una rutina
  @Query('UPDATE routines SET isActive = 0 WHERE id = :id')
  Future<void> archiveRoutine(String id);

  /// Desarchivar una rutina
  @Query('UPDATE routines SET isActive = 1 WHERE id = :id')
  Future<void> unarchiveRoutine(String id);

  /// Obtiene el conteo total de rutinas
  @Query('SELECT COUNT(*) FROM routines WHERE isActive = 1')
  Future<int?> getRoutineCount();
}

/// DAO para la gestión de ejercicios de rutina en la base de datos
@dao
abstract class RoutineExerciseDao {
  /// Obtiene todos los ejercicios de una rutina ordenados por orden
  @Query('SELECT * FROM routine_exercises WHERE routineId = :routineId ORDER BY "order" ASC')
  Future<List<RoutineExerciseModel>> getExercisesByRoutineId(String routineId);

  /// Obtiene un ejercicio específico de una rutina
  @Query('SELECT * FROM routine_exercises WHERE routineId = :routineId AND exerciseId = :exerciseId')
  Future<RoutineExerciseModel?> getRoutineExercise(String routineId, String exerciseId);

  /// Obtiene ejercicios de superset por grupo
  @Query('SELECT * FROM routine_exercises WHERE routineId = :routineId AND supersetGroup = :group ORDER BY "order" ASC')
  Future<List<RoutineExerciseModel>> getSupersetExercises(String routineId, String group);

  /// Inserta un nuevo ejercicio en la rutina
  @insert
  Future<void> insertRoutineExercise(RoutineExerciseModel routineExercise);

  /// Inserta múltiples ejercicios en la rutina
  @insert
  Future<void> insertRoutineExercises(List<RoutineExerciseModel> routineExercises);

  /// Actualiza un ejercicio de rutina
  @update
  Future<void> updateRoutineExercise(RoutineExerciseModel routineExercise);

  /// Elimina un ejercicio de rutina
  @delete
  Future<void> deleteRoutineExercise(RoutineExerciseModel routineExercise);

  /// Elimina todos los ejercicios de una rutina
  @Query('DELETE FROM routine_exercises WHERE routineId = :routineId')
  Future<void> deleteExercisesByRoutineId(String routineId);

  /// Elimina un ejercicio específico de una rutina
  @Query('DELETE FROM routine_exercises WHERE routineId = :routineId AND exerciseId = :exerciseId')
  Future<void> deleteRoutineExerciseById(String routineId, String exerciseId);

  /// Obtiene el máximo orden en una rutina
  @Query('SELECT MAX("order") FROM routine_exercises WHERE routineId = :routineId')
  Future<int?> getMaxOrder(String routineId);

  /// Actualiza el orden de ejercicios en una rutina
  @Query('UPDATE routine_exercises SET "order" = :newOrder WHERE id = :id')
  Future<void> updateExerciseOrder(String id, int newOrder);
}