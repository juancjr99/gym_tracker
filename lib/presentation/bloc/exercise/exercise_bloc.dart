import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_tracker/domain/usecases/exercise_usecases.dart' as uc;
import 'package:gym_tracker/presentation/bloc/exercise/exercise_event.dart';
import 'package:gym_tracker/presentation/bloc/exercise/exercise_state.dart';
import 'package:injectable/injectable.dart';

/// BLoC para gestionar el estado de los ejercicios
@injectable
class ExerciseBloc extends Bloc<ExerciseEvent, ExerciseState> {
  ExerciseBloc({
    required uc.GetAllExercises getAllExercises,
    required uc.GetExercisesByMuscleGroup getExercisesByMuscleGroup,
    required uc.SearchExercises searchExercisesUseCase,
    required uc.CreateCustomExercise createCustomExercise,
    required uc.GetFavoriteExercises getFavoriteExercises,
    required uc.ToggleExerciseFavorite toggleExerciseFavorite,
  })  : _getAllExercises = getAllExercises,
        _getExercisesByMuscleGroup = getExercisesByMuscleGroup,
        _searchExercisesUseCase = searchExercisesUseCase,
        _createCustomExercise = createCustomExercise,
        _getFavoriteExercises = getFavoriteExercises,
        _toggleExerciseFavorite = toggleExerciseFavorite,
        super(const ExerciseInitial()) {
    on<LoadExercises>(_onLoadExercises);
    on<LoadExercisesByMuscleGroup>(_onLoadExercisesByMuscleGroup);
    on<SearchExercisesEvent>(_onSearchExercises);
    on<CreateExerciseEvent>(_onCreateExercise);
    on<ToggleFavoriteExercise>(_onToggleFavorite);
  }

  final uc.GetAllExercises _getAllExercises;
  final uc.GetExercisesByMuscleGroup _getExercisesByMuscleGroup;
  final uc.SearchExercises _searchExercisesUseCase;
  final uc.CreateCustomExercise _createCustomExercise;
  final uc.GetFavoriteExercises _getFavoriteExercises;
  final uc.ToggleExerciseFavorite _toggleExerciseFavorite;

  Future<void> _onLoadExercises(
    LoadExercises event,
    Emitter<ExerciseState> emit,
  ) async {
    try {
      emit(const ExerciseLoading());
      final exercises = await _getAllExercises();
      if (exercises.isEmpty) {
        emit(const ExerciseEmpty());
      } else {
        emit(ExerciseLoaded(exercises));
      }
    } catch (e) {
      emit(ExerciseError(e.toString()));
    }
  }

  Future<void> _onLoadExercisesByMuscleGroup(
    LoadExercisesByMuscleGroup event,
    Emitter<ExerciseState> emit,
  ) async {
    try {
      emit(const ExerciseLoading());
      final exercises = await _getExercisesByMuscleGroup(event.muscleGroup);
      if (exercises.isEmpty) {
        emit(const ExerciseEmpty());
      } else {
        emit(ExerciseLoaded(exercises));
      }
    } catch (e) {
      emit(ExerciseError(e.toString()));
    }
  }

  Future<void> _onSearchExercises(
    SearchExercisesEvent event,
    Emitter<ExerciseState> emit,
  ) async {
    try {
      emit(const ExerciseLoading());
      final exercises = await _searchExercisesUseCase(event.query);
      if (exercises.isEmpty) {
        emit(const ExerciseEmpty());
      } else {
        emit(ExerciseLoaded(exercises));
      }
    } catch (e) {
      emit(ExerciseError(e.toString()));
    }
  }

  Future<void> _onCreateExercise(
    CreateExerciseEvent event,
    Emitter<ExerciseState> emit,
  ) async {
    try {
      emit(const ExerciseLoading());
      await _createCustomExercise(event.exercise);
      emit(const ExerciseOperationSuccess('Ejercicio personalizado creado exitosamente'));
      // Recargar ejercicios
      add(const LoadExercises());
    } catch (e) {
      emit(ExerciseError(e.toString()));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteExercise event,
    Emitter<ExerciseState> emit,
  ) async {
    try {
      await _toggleExerciseFavorite(event.exerciseId);
      // Recargar ejercicios para reflejar el cambio
      add(const LoadExercises());
    } catch (e) {
      emit(ExerciseError(e.toString()));
    }
  }
}
