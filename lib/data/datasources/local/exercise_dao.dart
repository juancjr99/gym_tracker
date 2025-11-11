import 'package:floor/floor.dart';
import '../../models/models.dart';

/// DAO para la gestión de ejercicios en la base de datos
@dao
abstract class ExerciseDao {
  /// Obtiene todos los ejercicios
  @Query('SELECT * FROM exercises ORDER BY name ASC')
  Future<List<ExerciseModel>> getAllExercises();

  /// Obtiene ejercicios por tipo
  @Query('SELECT * FROM exercises WHERE type = :type ORDER BY name ASC')
  Future<List<ExerciseModel>> getExercisesByType(String type);

  /// Obtiene ejercicios que contienen un grupo muscular específico
  @Query('SELECT * FROM exercises WHERE muscleGroups LIKE :muscleGroup ORDER BY name ASC')
  Future<List<ExerciseModel>> getExercisesByMuscleGroup(String muscleGroup);

  /// Obtiene un ejercicio por ID
  @Query('SELECT * FROM exercises WHERE id = :id')
  Future<ExerciseModel?> getExerciseById(String id);

  /// Busca ejercicios por nombre
  @Query('SELECT * FROM exercises WHERE name LIKE :query ORDER BY name ASC')
  Future<List<ExerciseModel>> searchExercises(String query);

  /// Obtiene ejercicios personalizados del usuario
  @Query('SELECT * FROM exercises WHERE isCustom = 1 ORDER BY name ASC')
  Future<List<ExerciseModel>> getCustomExercises();

  /// Obtiene ejercicios por categoría
  @Query('SELECT * FROM exercises WHERE category = :category ORDER BY name ASC')
  Future<List<ExerciseModel>> getExercisesByCategory(String category);

  /// Inserta un nuevo ejercicio
  @insert
  Future<void> insertExercise(ExerciseModel exercise);

  /// Inserta múltiples ejercicios
  @insert
  Future<void> insertExercises(List<ExerciseModel> exercises);

  /// Actualiza un ejercicio existente
  @update
  Future<void> updateExercise(ExerciseModel exercise);

  /// Elimina un ejercicio
  @delete
  Future<void> deleteExercise(ExerciseModel exercise);

  /// Elimina un ejercicio por ID
  @Query('DELETE FROM exercises WHERE id = :id')
  Future<void> deleteExerciseById(String id);

  /// Obtiene el conteo total de ejercicios
  @Query('SELECT COUNT(*) FROM exercises')
  Future<int?> getExerciseCount();

  /// Obtiene el conteo de ejercicios personalizados
  @Query('SELECT COUNT(*) FROM exercises WHERE isCustom = 1')
  Future<int?> getCustomExerciseCount();
}