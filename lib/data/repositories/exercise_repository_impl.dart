import 'package:gym_tracker/data/datasources/local/exercise_dao.dart';
import 'package:gym_tracker/data/models/models.dart';
import 'package:gym_tracker/domain/entities/entities.dart';
import 'package:gym_tracker/domain/repositories/repositories.dart';
import 'package:injectable/injectable.dart';

/// Implementación del repositorio de ejercicios usando Floor/SQLite
@LazySingleton(as: ExerciseRepository)
class ExerciseRepositoryImpl implements ExerciseRepository {
  ExerciseRepositoryImpl(this._exerciseDao);

  final ExerciseDao _exerciseDao;

  @override
  Future<List<Exercise>> getAllExercises() async {
    final models = await _exerciseDao.getAllExercises();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Exercise>> getExercisesByMuscleGroup(
    MuscleGroup muscleGroup,
  ) async {
    final models = await _exerciseDao.getExercisesByMuscleGroup(
      muscleGroup.name,
    );
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Exercise>> getExercisesByType(ExerciseType type) async {
    final models = await _exerciseDao.getExercisesByType(type.name);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Exercise?> getExerciseById(String id) async {
    final model = await _exerciseDao.getExerciseById(id);
    return model?.toEntity();
  }

  @override
  Future<List<Exercise>> searchExercises(String query) async {
    final models = await _exerciseDao.searchExercises(query);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Exercise> createExercise(Exercise exercise) async {
    final model = ExerciseModel.fromEntity(exercise);
    await _exerciseDao.insertExercise(model);
    return exercise;
  }

  @override
  Future<Exercise> updateExercise(Exercise exercise) async {
    final model = ExerciseModel.fromEntity(exercise);
    await _exerciseDao.updateExercise(model);
    return exercise;
  }

  @override
  Future<void> deleteExercise(String id) async {
    final model = await _exerciseDao.getExerciseById(id);
    if (model != null) {
      await _exerciseDao.deleteExercise(model);
    }
  }

  @override
  Future<List<Exercise>> getFavoriteExercises() async {
    // TODO: Implementar campo `isFavorite` en el modelo si se requiere.
    // Por ahora retornamos lista vacía.
    return [];
  }

  @override
  Future<void> toggleFavorite(String exerciseId) async {
    // TODO: Implementar toggle favorito cuando se agregue el campo.
    // Actualmente no realiza ninguna acción.
  }

  @override
  Future<List<Exercise>> getCustomExercises() async {
    final models = await _exerciseDao.getCustomExercises();
    return models.map((m) => m.toEntity()).toList();
  }
}
