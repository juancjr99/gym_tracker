import '../entities/entities.dart';

/// Repositorio abstracto para la gestión de ejercicios
abstract class ExerciseRepository {
  /// Obtiene todos los ejercicios
  Future<List<Exercise>> getAllExercises();
  
  /// Obtiene ejercicios por grupo muscular
  Future<List<Exercise>> getExercisesByMuscleGroup(MuscleGroup muscleGroup);
  
  /// Obtiene ejercicios por tipo
  Future<List<Exercise>> getExercisesByType(ExerciseType type);
  
  /// Obtiene un ejercicio por ID
  Future<Exercise?> getExerciseById(String id);
  
  /// Busca ejercicios por nombre
  Future<List<Exercise>> searchExercises(String query);
  
  /// Crea un nuevo ejercicio personalizado
  Future<Exercise> createExercise(Exercise exercise);
  
  /// Actualiza un ejercicio existente
  Future<Exercise> updateExercise(Exercise exercise);
  
  /// Elimina un ejercicio
  Future<void> deleteExercise(String id);
  
  /// Obtiene ejercicios favoritos del usuario
  Future<List<Exercise>> getFavoriteExercises();
  
  /// Marca/desmarca un ejercicio como favorito
  Future<void> toggleFavorite(String exerciseId);
  
  /// Obtiene ejercicios personalizados del usuario
  Future<List<Exercise>> getCustomExercises();
}