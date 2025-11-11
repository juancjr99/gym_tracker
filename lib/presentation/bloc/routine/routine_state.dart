import 'package:equatable/equatable.dart';
import 'package:gym_tracker/domain/entities/entities.dart';

/// Estados del BLoC de rutinas
abstract class RoutineState extends Equatable {
  const RoutineState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class RoutineInitial extends RoutineState {
  const RoutineInitial();
}

/// Estado de carga
class RoutineLoading extends RoutineState {
  const RoutineLoading();
}

/// Estado cuando las rutinas se cargan exitosamente
class RoutineLoaded extends RoutineState {
  const RoutineLoaded(this.routines);

  final List<Routine> routines;

  @override
  List<Object?> get props => [routines];
}

/// Estado cuando se carga una rutina específica
class RoutineDetailLoaded extends RoutineState {
  const RoutineDetailLoaded(this.routine);

  final Routine routine;

  @override
  List<Object?> get props => [routine];
}

/// Estado de operación exitosa
class RoutineOperationSuccess extends RoutineState {
  const RoutineOperationSuccess(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Estado de error
class RoutineError extends RoutineState {
  const RoutineError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Estado vacío (sin rutinas)
class RoutineEmpty extends RoutineState {
  const RoutineEmpty();
}
