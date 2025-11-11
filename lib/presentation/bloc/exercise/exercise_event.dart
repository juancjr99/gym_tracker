import 'package:equatable/equatable.dart';
import 'package:gym_tracker/domain/entities/entities.dart';

/// Eventos del BLoC de ejercicios
abstract class ExerciseEvent extends Equatable {
  const ExerciseEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para cargar todos los ejercicios
class LoadExercises extends ExerciseEvent {
  const LoadExercises();
}

/// Evento para cargar ejercicios por grupo muscular
class LoadExercisesByMuscleGroup extends ExerciseEvent {
  const LoadExercisesByMuscleGroup(this.muscleGroup);

  final MuscleGroup muscleGroup;

  @override
  List<Object?> get props => [muscleGroup];
}

/// Evento para buscar ejercicios
class SearchExercisesEvent extends ExerciseEvent {
  const SearchExercisesEvent(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

/// Evento para crear un nuevo ejercicio personalizado
class CreateExerciseEvent extends ExerciseEvent {
  const CreateExerciseEvent(this.exercise);

  final Exercise exercise;

  @override
  List<Object?> get props => [exercise];
}

/// Evento para toggle favorito de un ejercicio
class ToggleFavoriteExercise extends ExerciseEvent {
  const ToggleFavoriteExercise(this.exerciseId);

  final String exerciseId;

  @override
  List<Object?> get props => [exerciseId];
}
