import 'package:equatable/equatable.dart';
import 'package:gym_tracker/domain/entities/entities.dart';

/// Estados del BLoC de ejercicios
abstract class ExerciseState extends Equatable {
  const ExerciseState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class ExerciseInitial extends ExerciseState {
  const ExerciseInitial();
}

/// Estado de carga
class ExerciseLoading extends ExerciseState {
  const ExerciseLoading();
}

/// Estado cuando los ejercicios se cargan exitosamente
class ExerciseLoaded extends ExerciseState {
  const ExerciseLoaded(this.exercises);

  final List<Exercise> exercises;

  @override
  List<Object?> get props => [exercises];
}

/// Estado cuando se carga un ejercicio específico
class ExerciseDetailLoaded extends ExerciseState {
  const ExerciseDetailLoaded(this.exercise);

  final Exercise exercise;

  @override
  List<Object?> get props => [exercise];
}

/// Estado de operación exitosa
class ExerciseOperationSuccess extends ExerciseState {
  const ExerciseOperationSuccess(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Estado de error
class ExerciseError extends ExerciseState {
  const ExerciseError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Estado vacío (sin ejercicios)
class ExerciseEmpty extends ExerciseState {
  const ExerciseEmpty();
}
