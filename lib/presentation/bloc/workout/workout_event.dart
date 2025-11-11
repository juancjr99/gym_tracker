import 'package:equatable/equatable.dart';
import 'package:gym_tracker/domain/entities/entities.dart';

/// Eventos del BLoC de entrenamientos
abstract class WorkoutEvent extends Equatable {
  const WorkoutEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para cargar todos los entrenamientos
class LoadWorkouts extends WorkoutEvent {
  const LoadWorkouts();
}

/// Evento para cargar entrenamientos por rango de fechas
class LoadWorkoutsByDateRange extends WorkoutEvent {
  const LoadWorkoutsByDateRange({
    required this.startDate,
    required this.endDate,
  });

  final DateTime startDate;
  final DateTime endDate;

  @override
  List<Object?> get props => [startDate, endDate];
}

/// Evento para cargar un entrenamiento específico
class LoadWorkoutById extends WorkoutEvent {
  const LoadWorkoutById(this.workoutId);

  final String workoutId;

  @override
  List<Object?> get props => [workoutId];
}

/// Evento para cargar entrenamientos de una rutina
class LoadWorkoutsByRoutine extends WorkoutEvent {
  const LoadWorkoutsByRoutine(this.routineId);

  final String routineId;

  @override
  List<Object?> get props => [routineId];
}

/// Evento para cargar el último entrenamiento
class LoadLastWorkout extends WorkoutEvent {
  const LoadLastWorkout();
}

/// Evento para cargar entrenamientos activos
class LoadActiveWorkouts extends WorkoutEvent {
  const LoadActiveWorkouts();
}

/// Evento para iniciar un nuevo entrenamiento
class StartWorkoutEvent extends WorkoutEvent {
  const StartWorkoutEvent(this.routineId);

  final String routineId;

  @override
  List<Object?> get props => [routineId];
}

/// Evento para completar un entrenamiento
class CompleteWorkoutEvent extends WorkoutEvent {
  const CompleteWorkoutEvent(this.workoutId);

  final String workoutId;

  @override
  List<Object?> get props => [workoutId];
}

/// Evento para cancelar un entrenamiento
class CancelWorkoutEvent extends WorkoutEvent {
  const CancelWorkoutEvent(this.workoutId);

  final String workoutId;

  @override
  List<Object?> get props => [workoutId];
}

/// Evento para actualizar un registro de ejercicio
class UpdateExerciseRecordEvent extends WorkoutEvent {
  const UpdateExerciseRecordEvent({
    required this.workoutId,
    required this.exerciseRecord,
  });

  final String workoutId;
  final ExerciseRecord exerciseRecord;

  @override
  List<Object?> get props => [workoutId, exerciseRecord];
}

/// Evento para guardar un entrenamiento (crear o actualizar)
class SaveWorkoutEvent extends WorkoutEvent {
  const SaveWorkoutEvent(this.workout);

  final WorkoutRecord workout;

  @override
  List<Object?> get props => [workout];
}

/// Evento para eliminar un entrenamiento
class DeleteWorkoutEvent extends WorkoutEvent {
  const DeleteWorkoutEvent(this.workoutId);

  final String workoutId;

  @override
  List<Object?> get props => [workoutId];
}
