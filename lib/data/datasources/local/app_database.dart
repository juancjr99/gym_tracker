import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../../models/models.dart';
import 'exercise_dao.dart';
import 'routine_dao.dart';
import 'workout_dao.dart';

part 'app_database.g.dart'; // El archivo generado por Floor

/// Base de datos principal de la aplicación
@Database(
  version: 1,
  entities: [
    ExerciseModel,
    RoutineModel,
    RoutineExerciseModel,
    WorkoutRecordModel,
    ExerciseRecordModel,
    SetRecordModel,
  ],
)
abstract class AppDatabase extends FloorDatabase {
  /// DAO para ejercicios
  ExerciseDao get exerciseDao;
  
  /// DAO para rutinas
  RoutineDao get routineDao;
  
  /// DAO para ejercicios de rutina
  RoutineExerciseDao get routineExerciseDao;
  
  /// DAO para registros de entrenamiento
  WorkoutRecordDao get workoutRecordDao;
  
  /// DAO para registros de ejercicios
  ExerciseRecordDao get exerciseRecordDao;
  
  /// DAO para registros de series
  SetRecordDao get setRecordDao;
}

/// Clase para gestionar la configuración y creación de la base de datos
class DatabaseConfig {
  static const String _databaseName = 'gym_tracker.db';
  static const int _databaseVersion = 1;
  
  /// Crea y configura la base de datos
  static Future<AppDatabase> create() async {
    return await $FloorAppDatabase
        .databaseBuilder(_databaseName)
        .addCallback(_DatabaseCallback())
        .build();
  }
}

/// Callback para inicializar datos por defecto
class _DatabaseCallback extends Callback {}
