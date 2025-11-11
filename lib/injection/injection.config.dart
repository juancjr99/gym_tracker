// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:gym_tracker/data/datasources/local/app_database.dart' as _i234;
import 'package:gym_tracker/data/datasources/local/exercise_dao.dart' as _i364;
import 'package:gym_tracker/data/datasources/local/routine_dao.dart' as _i325;
import 'package:gym_tracker/data/datasources/local/workout_dao.dart' as _i24;
import 'package:gym_tracker/data/repositories/exercise_repository_impl.dart'
    as _i861;
import 'package:gym_tracker/data/repositories/routine_repository_impl.dart'
    as _i448;
import 'package:gym_tracker/data/repositories/workout_repository_impl.dart'
    as _i255;
import 'package:gym_tracker/domain/repositories/repositories.dart' as _i609;
import 'package:gym_tracker/domain/usecases/exercise_usecases.dart' as _i616;
import 'package:gym_tracker/domain/usecases/routine_usecases.dart' as _i172;
import 'package:gym_tracker/domain/usecases/workout_usecases.dart' as _i365;
import 'package:gym_tracker/injection/database_module.dart' as _i362;
import 'package:gym_tracker/presentation/bloc/exercise/exercise_bloc.dart'
    as _i331;
import 'package:gym_tracker/presentation/bloc/routine/routine_bloc.dart'
    as _i270;
import 'package:gym_tracker/presentation/bloc/workout/workout_bloc.dart'
    as _i592;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final databaseModule = _$DatabaseModule();
    await gh.singletonAsync<_i234.AppDatabase>(
      () => databaseModule.database,
      preResolve: true,
    );
    gh.singleton<_i364.ExerciseDao>(
        () => databaseModule.exerciseDao(gh<_i234.AppDatabase>()));
    gh.singleton<_i325.RoutineDao>(
        () => databaseModule.routineDao(gh<_i234.AppDatabase>()));
    gh.singleton<_i325.RoutineExerciseDao>(
        () => databaseModule.routineExerciseDao(gh<_i234.AppDatabase>()));
    gh.singleton<_i24.WorkoutRecordDao>(
        () => databaseModule.workoutRecordDao(gh<_i234.AppDatabase>()));
    gh.singleton<_i24.ExerciseRecordDao>(
        () => databaseModule.exerciseRecordDao(gh<_i234.AppDatabase>()));
    gh.singleton<_i24.SetRecordDao>(
        () => databaseModule.setRecordDao(gh<_i234.AppDatabase>()));
    gh.lazySingleton<_i609.RoutineRepository>(() => _i448.RoutineRepositoryImpl(
          gh<_i325.RoutineDao>(),
          gh<_i325.RoutineExerciseDao>(),
        ));
    gh.lazySingleton<_i609.WorkoutRepository>(() => _i255.WorkoutRepositoryImpl(
          gh<_i24.WorkoutRecordDao>(),
          gh<_i24.ExerciseRecordDao>(),
          gh<_i24.SetRecordDao>(),
        ));
    gh.factory<_i172.GetAllRoutines>(
        () => _i172.GetAllRoutines(gh<_i609.RoutineRepository>()));
    gh.factory<_i172.GetRoutinesByType>(
        () => _i172.GetRoutinesByType(gh<_i609.RoutineRepository>()));
    gh.factory<_i172.GetRoutineById>(
        () => _i172.GetRoutineById(gh<_i609.RoutineRepository>()));
    gh.factory<_i172.SearchRoutines>(
        () => _i172.SearchRoutines(gh<_i609.RoutineRepository>()));
    gh.factory<_i172.CreateRoutine>(
        () => _i172.CreateRoutine(gh<_i609.RoutineRepository>()));
    gh.factory<_i172.UpdateRoutine>(
        () => _i172.UpdateRoutine(gh<_i609.RoutineRepository>()));
    gh.factory<_i172.DeleteRoutine>(
        () => _i172.DeleteRoutine(gh<_i609.RoutineRepository>()));
    gh.factory<_i172.DuplicateRoutine>(
        () => _i172.DuplicateRoutine(gh<_i609.RoutineRepository>()));
    gh.factory<_i172.GetTemplateRoutines>(
        () => _i172.GetTemplateRoutines(gh<_i609.RoutineRepository>()));
    gh.factory<_i172.GetArchivedRoutines>(
        () => _i172.GetArchivedRoutines(gh<_i609.RoutineRepository>()));
    gh.factory<_i172.ToggleArchiveRoutine>(
        () => _i172.ToggleArchiveRoutine(gh<_i609.RoutineRepository>()));
    gh.factory<_i172.GetRoutinesByTags>(
        () => _i172.GetRoutinesByTags(gh<_i609.RoutineRepository>()));
    gh.factory<_i172.ReorderRoutineExercises>(
        () => _i172.ReorderRoutineExercises(gh<_i609.RoutineRepository>()));
    gh.lazySingleton<_i609.ExerciseRepository>(
        () => _i861.ExerciseRepositoryImpl(gh<_i364.ExerciseDao>()));
    gh.factory<_i616.GetAllExercises>(
        () => _i616.GetAllExercises(gh<_i609.ExerciseRepository>()));
    gh.factory<_i616.GetExercisesByMuscleGroup>(
        () => _i616.GetExercisesByMuscleGroup(gh<_i609.ExerciseRepository>()));
    gh.factory<_i616.SearchExercises>(
        () => _i616.SearchExercises(gh<_i609.ExerciseRepository>()));
    gh.factory<_i616.CreateCustomExercise>(
        () => _i616.CreateCustomExercise(gh<_i609.ExerciseRepository>()));
    gh.factory<_i616.GetFavoriteExercises>(
        () => _i616.GetFavoriteExercises(gh<_i609.ExerciseRepository>()));
    gh.factory<_i616.ToggleExerciseFavorite>(
        () => _i616.ToggleExerciseFavorite(gh<_i609.ExerciseRepository>()));
    gh.factory<_i331.ExerciseBloc>(() => _i331.ExerciseBloc(
          getAllExercises: gh<_i616.GetAllExercises>(),
          getExercisesByMuscleGroup: gh<_i616.GetExercisesByMuscleGroup>(),
          searchExercisesUseCase: gh<_i616.SearchExercises>(),
          createCustomExercise: gh<_i616.CreateCustomExercise>(),
          getFavoriteExercises: gh<_i616.GetFavoriteExercises>(),
          toggleExerciseFavorite: gh<_i616.ToggleExerciseFavorite>(),
        ));
    gh.factory<_i270.RoutineBloc>(() => _i270.RoutineBloc(
          getAllRoutines: gh<_i172.GetAllRoutines>(),
          getRoutinesByType: gh<_i172.GetRoutinesByType>(),
          getRoutineById: gh<_i172.GetRoutineById>(),
          searchRoutinesUseCase: gh<_i172.SearchRoutines>(),
          createRoutineUseCase: gh<_i172.CreateRoutine>(),
          updateRoutineUseCase: gh<_i172.UpdateRoutine>(),
          deleteRoutineUseCase: gh<_i172.DeleteRoutine>(),
          duplicateRoutineUseCase: gh<_i172.DuplicateRoutine>(),
          toggleArchiveRoutineUseCase: gh<_i172.ToggleArchiveRoutine>(),
          reorderRoutineExercisesUseCase: gh<_i172.ReorderRoutineExercises>(),
        ));
    gh.factory<_i365.GetAllWorkouts>(
        () => _i365.GetAllWorkouts(gh<_i609.WorkoutRepository>()));
    gh.factory<_i365.GetWorkoutsByDateRange>(
        () => _i365.GetWorkoutsByDateRange(gh<_i609.WorkoutRepository>()));
    gh.factory<_i365.GetWorkoutById>(
        () => _i365.GetWorkoutById(gh<_i609.WorkoutRepository>()));
    gh.factory<_i365.GetWorkoutsByRoutine>(
        () => _i365.GetWorkoutsByRoutine(gh<_i609.WorkoutRepository>()));
    gh.factory<_i365.GetLastWorkout>(
        () => _i365.GetLastWorkout(gh<_i609.WorkoutRepository>()));
    gh.factory<_i365.GetActiveWorkouts>(
        () => _i365.GetActiveWorkouts(gh<_i609.WorkoutRepository>()));
    gh.factory<_i365.StartWorkout>(
        () => _i365.StartWorkout(gh<_i609.WorkoutRepository>()));
    gh.factory<_i365.CompleteWorkout>(
        () => _i365.CompleteWorkout(gh<_i609.WorkoutRepository>()));
    gh.factory<_i365.CancelWorkout>(
        () => _i365.CancelWorkout(gh<_i609.WorkoutRepository>()));
    gh.factory<_i365.UpdateExerciseRecord>(
        () => _i365.UpdateExerciseRecord(gh<_i609.WorkoutRepository>()));
    gh.factory<_i365.SaveWorkout>(
        () => _i365.SaveWorkout(gh<_i609.WorkoutRepository>()));
    gh.factory<_i365.DeleteWorkout>(
        () => _i365.DeleteWorkout(gh<_i609.WorkoutRepository>()));
    gh.factory<_i365.GetExerciseStats>(
        () => _i365.GetExerciseStats(gh<_i609.WorkoutRepository>()));
    gh.factory<_i365.GetExerciseProgress>(
        () => _i365.GetExerciseProgress(gh<_i609.WorkoutRepository>()));
    gh.factory<_i365.GetPersonalRecords>(
        () => _i365.GetPersonalRecords(gh<_i609.WorkoutRepository>()));
    gh.factory<_i592.WorkoutBloc>(() => _i592.WorkoutBloc(
          getAllWorkouts: gh<_i365.GetAllWorkouts>(),
          getWorkoutsByDateRange: gh<_i365.GetWorkoutsByDateRange>(),
          getWorkoutById: gh<_i365.GetWorkoutById>(),
          getWorkoutsByRoutine: gh<_i365.GetWorkoutsByRoutine>(),
          getLastWorkout: gh<_i365.GetLastWorkout>(),
          getActiveWorkouts: gh<_i365.GetActiveWorkouts>(),
          startWorkoutUseCase: gh<_i365.StartWorkout>(),
          completeWorkoutUseCase: gh<_i365.CompleteWorkout>(),
          cancelWorkoutUseCase: gh<_i365.CancelWorkout>(),
          updateExerciseRecordUseCase: gh<_i365.UpdateExerciseRecord>(),
          saveWorkoutUseCase: gh<_i365.SaveWorkout>(),
          deleteWorkoutUseCase: gh<_i365.DeleteWorkout>(),
        ));
    return this;
  }
}

class _$DatabaseModule extends _i362.DatabaseModule {}
