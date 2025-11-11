import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_tracker/domain/usecases/routine_usecases.dart' as uc;
import 'package:gym_tracker/presentation/bloc/routine/routine_event.dart';
import 'package:gym_tracker/presentation/bloc/routine/routine_state.dart';
import 'package:injectable/injectable.dart';

/// BLoC para gestionar el estado de las rutinas
@injectable
class RoutineBloc extends Bloc<RoutineEvent, RoutineState> {
  RoutineBloc({
    required uc.GetAllRoutines getAllRoutines,
    required uc.GetRoutinesByType getRoutinesByType,
    required uc.GetRoutineById getRoutineById,
    required uc.SearchRoutines searchRoutinesUseCase,
    required uc.CreateRoutine createRoutineUseCase,
    required uc.UpdateRoutine updateRoutineUseCase,
    required uc.DeleteRoutine deleteRoutineUseCase,
    required uc.DuplicateRoutine duplicateRoutineUseCase,
    required uc.ToggleArchiveRoutine toggleArchiveRoutineUseCase,
    required uc.ReorderRoutineExercises reorderRoutineExercisesUseCase,
  })  : _getAllRoutines = getAllRoutines,
        _getRoutinesByType = getRoutinesByType,
        _getRoutineById = getRoutineById,
        _searchRoutinesUseCase = searchRoutinesUseCase,
        _createRoutineUseCase = createRoutineUseCase,
        _updateRoutineUseCase = updateRoutineUseCase,
        _deleteRoutineUseCase = deleteRoutineUseCase,
        _duplicateRoutineUseCase = duplicateRoutineUseCase,
        _toggleArchiveRoutineUseCase = toggleArchiveRoutineUseCase,
        _reorderRoutineExercisesUseCase = reorderRoutineExercisesUseCase,
        super(const RoutineInitial()) {
    on<LoadRoutines>(_onLoadRoutines);
    on<LoadRoutinesByType>(_onLoadRoutinesByType);
    on<LoadRoutineById>(_onLoadRoutineById);
    on<SearchRoutinesEvent>(_onSearchRoutines);
    on<CreateRoutineEvent>(_onCreateRoutine);
    on<UpdateRoutineEvent>(_onUpdateRoutine);
    on<DeleteRoutineEvent>(_onDeleteRoutine);
    on<DuplicateRoutineEvent>(_onDuplicateRoutine);
    on<ToggleArchiveRoutineEvent>(_onToggleArchiveRoutine);
    on<ReorderRoutineExercisesEvent>(_onReorderRoutineExercises);
  }

  final uc.GetAllRoutines _getAllRoutines;
  final uc.GetRoutinesByType _getRoutinesByType;
  final uc.GetRoutineById _getRoutineById;
  final uc.SearchRoutines _searchRoutinesUseCase;
  final uc.CreateRoutine _createRoutineUseCase;
  final uc.UpdateRoutine _updateRoutineUseCase;
  final uc.DeleteRoutine _deleteRoutineUseCase;
  final uc.DuplicateRoutine _duplicateRoutineUseCase;
  final uc.ToggleArchiveRoutine _toggleArchiveRoutineUseCase;
  final uc.ReorderRoutineExercises _reorderRoutineExercisesUseCase;

  Future<void> _onLoadRoutines(
    LoadRoutines event,
    Emitter<RoutineState> emit,
  ) async {
    try {
      emit(const RoutineLoading());
      final routines = await _getAllRoutines();
      if (routines.isEmpty) {
        emit(const RoutineEmpty());
      } else {
        emit(RoutineLoaded(routines));
      }
    } catch (e) {
      emit(RoutineError(e.toString()));
    }
  }

  Future<void> _onLoadRoutinesByType(
    LoadRoutinesByType event,
    Emitter<RoutineState> emit,
  ) async {
    try {
      emit(const RoutineLoading());
      final routines = await _getRoutinesByType(event.type);
      if (routines.isEmpty) {
        emit(const RoutineEmpty());
      } else {
        emit(RoutineLoaded(routines));
      }
    } catch (e) {
      emit(RoutineError(e.toString()));
    }
  }

  Future<void> _onLoadRoutineById(
    LoadRoutineById event,
    Emitter<RoutineState> emit,
  ) async {
    try {
      emit(const RoutineLoading());
      final routine = await _getRoutineById(event.routineId);
      if (routine == null) {
        emit(const RoutineError('Rutina no encontrada'));
      } else {
        emit(RoutineDetailLoaded(routine));
      }
    } catch (e) {
      emit(RoutineError(e.toString()));
    }
  }

  Future<void> _onSearchRoutines(
    SearchRoutinesEvent event,
    Emitter<RoutineState> emit,
  ) async {
    try {
      emit(const RoutineLoading());
      final routines = await _searchRoutinesUseCase(event.query);
      if (routines.isEmpty) {
        emit(const RoutineEmpty());
      } else {
        emit(RoutineLoaded(routines));
      }
    } catch (e) {
      emit(RoutineError(e.toString()));
    }
  }

  Future<void> _onCreateRoutine(
    CreateRoutineEvent event,
    Emitter<RoutineState> emit,
  ) async {
    try {
      emit(const RoutineLoading());
      await _createRoutineUseCase(event.routine);
      emit(const RoutineOperationSuccess('Rutina creada exitosamente'));
      // Recargar rutinas
      add(const LoadRoutines());
    } catch (e) {
      emit(RoutineError(e.toString()));
    }
  }

  Future<void> _onUpdateRoutine(
    UpdateRoutineEvent event,
    Emitter<RoutineState> emit,
  ) async {
    try {
      emit(const RoutineLoading());
      await _updateRoutineUseCase(event.routine);
      emit(const RoutineOperationSuccess('Rutina actualizada exitosamente'));
      // Recargar rutinas
      add(const LoadRoutines());
    } catch (e) {
      emit(RoutineError(e.toString()));
    }
  }

  Future<void> _onDeleteRoutine(
    DeleteRoutineEvent event,
    Emitter<RoutineState> emit,
  ) async {
    try {
      emit(const RoutineLoading());
      await _deleteRoutineUseCase(event.routineId);
      emit(const RoutineOperationSuccess('Rutina eliminada exitosamente'));
      // Recargar rutinas
      add(const LoadRoutines());
    } catch (e) {
      emit(RoutineError(e.toString()));
    }
  }

  Future<void> _onDuplicateRoutine(
    DuplicateRoutineEvent event,
    Emitter<RoutineState> emit,
  ) async {
    try {
      emit(const RoutineLoading());
      await _duplicateRoutineUseCase(
        event.routineId,
        event.newName,
      );
      emit(const RoutineOperationSuccess('Rutina duplicada exitosamente'));
      // Recargar rutinas
      add(const LoadRoutines());
    } catch (e) {
      emit(RoutineError(e.toString()));
    }
  }

  Future<void> _onToggleArchiveRoutine(
    ToggleArchiveRoutineEvent event,
    Emitter<RoutineState> emit,
  ) async {
    try {
      emit(const RoutineLoading());
      await _toggleArchiveRoutineUseCase(event.routineId);
      emit(const RoutineOperationSuccess('Estado de archivo actualizado'));
      // Recargar rutinas
      add(const LoadRoutines());
    } catch (e) {
      emit(RoutineError(e.toString()));
    }
  }

  Future<void> _onReorderRoutineExercises(
    ReorderRoutineExercisesEvent event,
    Emitter<RoutineState> emit,
  ) async {
    try {
      emit(const RoutineLoading());
      await _reorderRoutineExercisesUseCase(
        event.routineId,
        event.exerciseIds,
      );
      emit(
        const RoutineOperationSuccess('Ejercicios reordenados exitosamente'),
      );
      // Recargar la rutina específica
      add(LoadRoutineById(event.routineId));
    } catch (e) {
      emit(RoutineError(e.toString()));
    }
  }
}
