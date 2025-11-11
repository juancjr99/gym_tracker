import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_tracker/domain/entities/entities.dart';
import 'package:gym_tracker/domain/usecases/workout_usecases.dart' as uc;
import 'package:gym_tracker/presentation/bloc/workout/workout_event.dart';
import 'package:gym_tracker/presentation/bloc/workout/workout_state.dart';
import 'package:injectable/injectable.dart';

/// BLoC para gestionar el estado de los entrenamientos
@injectable
class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  WorkoutBloc({
    required uc.GetAllWorkouts getAllWorkouts,
    required uc.GetWorkoutsByDateRange getWorkoutsByDateRange,
    required uc.GetWorkoutById getWorkoutById,
    required uc.GetWorkoutsByRoutine getWorkoutsByRoutine,
    required uc.GetLastWorkout getLastWorkout,
    required uc.GetActiveWorkouts getActiveWorkouts,
    required uc.StartWorkout startWorkoutUseCase,
    required uc.CompleteWorkout completeWorkoutUseCase,
    required uc.CancelWorkout cancelWorkoutUseCase,
    required uc.UpdateExerciseRecord updateExerciseRecordUseCase,
    required uc.SaveWorkout saveWorkoutUseCase,
    required uc.DeleteWorkout deleteWorkoutUseCase,
  })  : _getAllWorkouts = getAllWorkouts,
        _getWorkoutsByDateRange = getWorkoutsByDateRange,
        _getWorkoutById = getWorkoutById,
        _getWorkoutsByRoutine = getWorkoutsByRoutine,
        _getLastWorkout = getLastWorkout,
        _getActiveWorkouts = getActiveWorkouts,
        _startWorkoutUseCase = startWorkoutUseCase,
        _completeWorkoutUseCase = completeWorkoutUseCase,
        _cancelWorkoutUseCase = cancelWorkoutUseCase,
        _updateExerciseRecordUseCase = updateExerciseRecordUseCase,
        _saveWorkoutUseCase = saveWorkoutUseCase,
        _deleteWorkoutUseCase = deleteWorkoutUseCase,
        super(const WorkoutInitial()) {
    on<LoadWorkouts>(_onLoadWorkouts);
    on<LoadWorkoutsByDateRange>(_onLoadWorkoutsByDateRange);
    on<LoadWorkoutById>(_onLoadWorkoutById);
    on<LoadWorkoutsByRoutine>(_onLoadWorkoutsByRoutine);
    on<LoadLastWorkout>(_onLoadLastWorkout);
    on<LoadActiveWorkouts>(_onLoadActiveWorkouts);
    on<StartWorkoutEvent>(_onStartWorkout);
    on<CompleteWorkoutEvent>(_onCompleteWorkout);
    on<CancelWorkoutEvent>(_onCancelWorkout);
    on<UpdateExerciseRecordEvent>(_onUpdateExerciseRecord);
    on<SaveWorkoutEvent>(_onSaveWorkout);
    on<DeleteWorkoutEvent>(_onDeleteWorkout);
  }

  final uc.GetAllWorkouts _getAllWorkouts;
  final uc.GetWorkoutsByDateRange _getWorkoutsByDateRange;
  final uc.GetWorkoutById _getWorkoutById;
  final uc.GetWorkoutsByRoutine _getWorkoutsByRoutine;
  final uc.GetLastWorkout _getLastWorkout;
  final uc.GetActiveWorkouts _getActiveWorkouts;
  final uc.StartWorkout _startWorkoutUseCase;
  final uc.CompleteWorkout _completeWorkoutUseCase;
  final uc.CancelWorkout _cancelWorkoutUseCase;
  final uc.UpdateExerciseRecord _updateExerciseRecordUseCase;
  final uc.SaveWorkout _saveWorkoutUseCase;
  final uc.DeleteWorkout _deleteWorkoutUseCase;

  Future<void> _onLoadWorkouts(
    LoadWorkouts event,
    Emitter<WorkoutState> emit,
  ) async {
    try {
      emit(const WorkoutLoading());
      final workouts = await _getAllWorkouts();
      if (workouts.isEmpty) {
        emit(const WorkoutEmpty());
      } else {
        emit(WorkoutLoaded(workouts));
      }
    } catch (e) {
      emit(WorkoutError(e.toString()));
    }
  }

  Future<void> _onLoadWorkoutsByDateRange(
    LoadWorkoutsByDateRange event,
    Emitter<WorkoutState> emit,
  ) async {
    try {
      emit(const WorkoutLoading());
      final workouts = await _getWorkoutsByDateRange(
        event.startDate,
        event.endDate,
      );
      if (workouts.isEmpty) {
        emit(const WorkoutEmpty());
      } else {
        emit(WorkoutLoaded(workouts));
      }
    } catch (e) {
      emit(WorkoutError(e.toString()));
    }
  }

  Future<void> _onLoadWorkoutById(
    LoadWorkoutById event,
    Emitter<WorkoutState> emit,
  ) async {
    try {
      emit(const WorkoutLoading());
      final workout = await _getWorkoutById(event.workoutId);
      if (workout == null) {
        emit(const WorkoutError('Entrenamiento no encontrado'));
      } else {
        if (workout.status == WorkoutStatus.inProgress) {
          emit(WorkoutInProgress(workout));
        } else {
          emit(WorkoutDetailLoaded(workout));
        }
      }
    } catch (e) {
      emit(WorkoutError(e.toString()));
    }
  }

  Future<void> _onLoadWorkoutsByRoutine(
    LoadWorkoutsByRoutine event,
    Emitter<WorkoutState> emit,
  ) async {
    try {
      emit(const WorkoutLoading());
      final workouts = await _getWorkoutsByRoutine(event.routineId);
      if (workouts.isEmpty) {
        emit(const WorkoutEmpty());
      } else {
        emit(WorkoutLoaded(workouts));
      }
    } catch (e) {
      emit(WorkoutError(e.toString()));
    }
  }

  Future<void> _onLoadLastWorkout(
    LoadLastWorkout event,
    Emitter<WorkoutState> emit,
  ) async {
    try {
      emit(const WorkoutLoading());
      final workout = await _getLastWorkout();
      if (workout == null) {
        emit(const WorkoutEmpty());
      } else {
        emit(WorkoutDetailLoaded(workout));
      }
    } catch (e) {
      emit(WorkoutError(e.toString()));
    }
  }

  Future<void> _onLoadActiveWorkouts(
    LoadActiveWorkouts event,
    Emitter<WorkoutState> emit,
  ) async {
    try {
      emit(const WorkoutLoading());
      final workouts = await _getActiveWorkouts();
      if (workouts.isEmpty) {
        emit(const WorkoutEmpty());
      } else {
        emit(WorkoutLoaded(workouts));
      }
    } catch (e) {
      emit(WorkoutError(e.toString()));
    }
  }

  Future<void> _onStartWorkout(
    StartWorkoutEvent event,
    Emitter<WorkoutState> emit,
  ) async {
    try {
      emit(const WorkoutLoading());
      final workout = await _startWorkoutUseCase(event.routineId);
      emit(WorkoutInProgress(workout));
    } catch (e) {
      emit(WorkoutError(e.toString()));
    }
  }

  Future<void> _onCompleteWorkout(
    CompleteWorkoutEvent event,
    Emitter<WorkoutState> emit,
  ) async {
    try {
      emit(const WorkoutLoading());
      await _completeWorkoutUseCase(event.workoutId);
      emit(
        const WorkoutOperationSuccess('Entrenamiento completado exitosamente'),
      );
      // Recargar entrenamientos
      add(const LoadWorkouts());
    } catch (e) {
      emit(WorkoutError(e.toString()));
    }
  }

  Future<void> _onCancelWorkout(
    CancelWorkoutEvent event,
    Emitter<WorkoutState> emit,
  ) async {
    try {
      emit(const WorkoutLoading());
      await _cancelWorkoutUseCase(event.workoutId);
      emit(
        const WorkoutOperationSuccess('Entrenamiento cancelado'),
      );
      // Recargar entrenamientos
      add(const LoadWorkouts());
    } catch (e) {
      emit(WorkoutError(e.toString()));
    }
  }

  Future<void> _onUpdateExerciseRecord(
    UpdateExerciseRecordEvent event,
    Emitter<WorkoutState> emit,
  ) async {
    try {
      emit(const WorkoutLoading());
      await _updateExerciseRecordUseCase(
        event.workoutId,
        event.exerciseRecord,
      );
      emit(
        const WorkoutOperationSuccess('Ejercicio actualizado'),
      );
      // Recargar el entrenamiento específico
      add(LoadWorkoutById(event.workoutId));
    } catch (e) {
      emit(WorkoutError(e.toString()));
    }
  }

  Future<void> _onSaveWorkout(
    SaveWorkoutEvent event,
    Emitter<WorkoutState> emit,
  ) async {
    try {
      emit(const WorkoutLoading());
      await _saveWorkoutUseCase(event.workout);
      emit(
        const WorkoutOperationSuccess('Entrenamiento guardado exitosamente'),
      );
      // Recargar entrenamientos
      add(const LoadWorkouts());
    } catch (e) {
      emit(WorkoutError(e.toString()));
    }
  }

  Future<void> _onDeleteWorkout(
    DeleteWorkoutEvent event,
    Emitter<WorkoutState> emit,
  ) async {
    try {
      emit(const WorkoutLoading());
      await _deleteWorkoutUseCase(event.workoutId);
      emit(
        const WorkoutOperationSuccess('Entrenamiento eliminado exitosamente'),
      );
      // Recargar entrenamientos
      add(const LoadWorkouts());
    } catch (e) {
      emit(WorkoutError(e.toString()));
    }
  }
}
