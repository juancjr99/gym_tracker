import 'package:equatable/equatable.dart';
import 'package:gym_tracker/domain/entities/entities.dart';

/// Eventos del BLoC de rutinas
abstract class RoutineEvent extends Equatable {
  const RoutineEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para cargar todas las rutinas
class LoadRoutines extends RoutineEvent {
  const LoadRoutines();
}

/// Evento para cargar rutinas por tipo
class LoadRoutinesByType extends RoutineEvent {
  const LoadRoutinesByType(this.type);

  final RoutineType type;

  @override
  List<Object?> get props => [type];
}

/// Evento para buscar rutinas
class SearchRoutinesEvent extends RoutineEvent {
  const SearchRoutinesEvent(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

/// Evento para crear una nueva rutina
class CreateRoutineEvent extends RoutineEvent {
  const CreateRoutineEvent(this.routine);

  final Routine routine;

  @override
  List<Object?> get props => [routine];
}

/// Evento para actualizar una rutina existente
class UpdateRoutineEvent extends RoutineEvent {
  const UpdateRoutineEvent(this.routine);

  final Routine routine;

  @override
  List<Object?> get props => [routine];
}

/// Evento para eliminar una rutina
class DeleteRoutineEvent extends RoutineEvent {
  const DeleteRoutineEvent(this.routineId);

  final String routineId;

  @override
  List<Object?> get props => [routineId];
}

/// Evento para duplicar una rutina
class DuplicateRoutineEvent extends RoutineEvent {
  const DuplicateRoutineEvent({
    required this.routineId,
    required this.newName,
  });

  final String routineId;
  final String newName;

  @override
  List<Object?> get props => [routineId, newName];
}

/// Evento para archivar/desarchivar una rutina
class ToggleArchiveRoutineEvent extends RoutineEvent {
  const ToggleArchiveRoutineEvent(this.routineId);

  final String routineId;

  @override
  List<Object?> get props => [routineId];
}

/// Evento para reordenar ejercicios en una rutina
class ReorderRoutineExercisesEvent extends RoutineEvent {
  const ReorderRoutineExercisesEvent({
    required this.routineId,
    required this.exerciseIds,
  });

  final String routineId;
  final List<String> exerciseIds;

  @override
  List<Object?> get props => [routineId, exerciseIds];
}

/// Evento para cargar una rutina específica
class LoadRoutineById extends RoutineEvent {
  const LoadRoutineById(this.routineId);

  final String routineId;

  @override
  List<Object?> get props => [routineId];
}
