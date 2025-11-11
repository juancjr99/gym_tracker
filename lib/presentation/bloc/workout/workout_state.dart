import 'package:equatable/equatable.dart';
import 'package:gym_tracker/domain/entities/entities.dart';

/// Estados del BLoC de entrenamientos
abstract class WorkoutState extends Equatable {
  const WorkoutState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class WorkoutInitial extends WorkoutState {
  const WorkoutInitial();
}

/// Estado de carga
class WorkoutLoading extends WorkoutState {
  const WorkoutLoading();
}

/// Estado cuando los entrenamientos se cargan exitosamente
class WorkoutLoaded extends WorkoutState {
  const WorkoutLoaded(this.workouts);

  final List<WorkoutRecord> workouts;

  @override
  List<Object?> get props => [workouts];
}

/// Estado cuando se carga un entrenamiento específico
class WorkoutDetailLoaded extends WorkoutState {
  const WorkoutDetailLoaded(this.workout);

  final WorkoutRecord workout;

  @override
  List<Object?> get props => [workout];
}

/// Estado cuando hay un entrenamiento activo en progreso
class WorkoutInProgress extends WorkoutState {
  const WorkoutInProgress(this.workout);

  final WorkoutRecord workout;

  @override
  List<Object?> get props => [workout];
}

/// Estado de operación exitosa
class WorkoutOperationSuccess extends WorkoutState {
  const WorkoutOperationSuccess(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Estado de error
class WorkoutError extends WorkoutState {
  const WorkoutError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Estado vacío (sin entrenamientos)
class WorkoutEmpty extends WorkoutState {
  const WorkoutEmpty();
}
