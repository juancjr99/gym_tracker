import 'package:gym_tracker/data/datasources/local/app_database.dart';
import 'package:gym_tracker/data/datasources/local/exercise_dao.dart';
import 'package:gym_tracker/data/datasources/local/routine_dao.dart';
import 'package:gym_tracker/data/datasources/local/workout_dao.dart';
import 'package:injectable/injectable.dart';

/// Módulo para registrar la base de datos y los DAOs
@module
abstract class DatabaseModule {
  /// Registra la instancia de la base de datos como singleton
  @preResolve
  @singleton
  Future<AppDatabase> get database => DatabaseConfig.create();

  /// Provee el DAO de ejercicios
  @singleton
  ExerciseDao exerciseDao(AppDatabase database) => database.exerciseDao;

  /// Provee el DAO de rutinas
  @singleton
  RoutineDao routineDao(AppDatabase database) => database.routineDao;

  /// Provee el DAO de ejercicios de rutina
  @singleton
  RoutineExerciseDao routineExerciseDao(AppDatabase database) =>
      database.routineExerciseDao;

  /// Provee el DAO de registros de entrenamiento
  @singleton
  WorkoutRecordDao workoutRecordDao(AppDatabase database) =>
      database.workoutRecordDao;

  /// Provee el DAO de registros de ejercicios
  @singleton
  ExerciseRecordDao exerciseRecordDao(AppDatabase database) =>
      database.exerciseRecordDao;

  /// Provee el DAO de registros de series
  @singleton
  SetRecordDao setRecordDao(AppDatabase database) => database.setRecordDao;
}
