import 'package:injectable/injectable.dart';

import '../entities/entities.dart';
import '../repositories/repositories.dart';

/// Caso de uso para obtener todos los ejercicios
@injectable
class GetAllExercises {
  const GetAllExercises(this._repository);

  final ExerciseRepository _repository;

  Future<List<Exercise>> call() async {
    return await _repository.getAllExercises();
  }
}

/// Caso de uso para obtener ejercicios por grupo muscular
@injectable
class GetExercisesByMuscleGroup {
  const GetExercisesByMuscleGroup(this._repository);

  final ExerciseRepository _repository;

  Future<List<Exercise>> call(MuscleGroup muscleGroup) async {
    return await _repository.getExercisesByMuscleGroup(muscleGroup);
  }
}

/// Caso de uso para buscar ejercicios
@injectable
class SearchExercises {
  const SearchExercises(this._repository);

  final ExerciseRepository _repository;

  Future<List<Exercise>> call(String query) async {
    if (query.trim().isEmpty) {
      return await _repository.getAllExercises();
    }
    return await _repository.searchExercises(query);
  }
}

/// Caso de uso para crear un ejercicio personalizado
@injectable
class CreateCustomExercise {
  const CreateCustomExercise(this._repository);

  final ExerciseRepository _repository;

  Future<Exercise> call(Exercise exercise) async {
    // Validar que sea un ejercicio personalizado
    final customExercise = exercise.copyWith(isCustom: true);
    return await _repository.createExercise(customExercise);
  }
}

/// Caso de uso para obtener ejercicios favoritos
@injectable
class GetFavoriteExercises {
  const GetFavoriteExercises(this._repository);

  final ExerciseRepository _repository;

  Future<List<Exercise>> call() async {
    return await _repository.getFavoriteExercises();
  }
}

/// Caso de uso para alternar favorito de un ejercicio
@injectable
class ToggleExerciseFavorite {
  const ToggleExerciseFavorite(this._repository);

  final ExerciseRepository _repository;

  Future<void> call(String exerciseId) async {
    await _repository.toggleFavorite(exerciseId);
  }
}