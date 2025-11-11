import 'dart:async';
import 'dart:developer' as dev;

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../../models/models.dart';
import '../../seed/default_exercises.dart';
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
  
  /// Crea y configura la base de datos
  static Future<AppDatabase> create() async {
    return await $FloorAppDatabase
        .databaseBuilder(_databaseName)
        .addCallback(_DatabaseCallback())
        .build();
  }
}

/// Callback para inicializar datos por defecto  
class _DatabaseCallback extends Callback {
  const _DatabaseCallback();

  @override
  Future<void> Function(sqflite.Database, int)? get onCreate =>
      (database, version) async {
        dev.log('Database onCreate called - inserting default exercises');
        await _insertDefaultExercises(database);
      };

  @override
  Future<void> Function(sqflite.Database)? get onOpen =>
      (database) async {
        dev.log('Database onOpen called - checking exercises');
        // Verificar si hay ejercicios
        final result = await database.rawQuery(
          'SELECT COUNT(*) as count FROM exercises',
        );
        final count = result.first['count'] as int;
        dev.log('Found $count exercises in database');
        
        if (count == 0) {
          dev.log('No exercises found - inserting defaults');
          await _insertDefaultExercises(database);
        }
      };

  Future<void> _insertDefaultExercises(sqflite.Database database) async {
    final exercises = DefaultExercises.getExercises();
    dev.log('Inserting ${exercises.length} default exercises');
    
    for (final exercise in exercises) {
      final model = ExerciseModel.fromEntity(exercise);
      await database.insert('exercises', {
        'id': model.id,
        'name': model.name,
        'category': model.category,
        'type': model.type,
        'description': model.description,
        'instructions': model.instructions,
        'imageUrl': model.imageUrl,
        'videoUrl': model.videoUrl,
        'muscleGroups': model.muscleGroups,
        'equipment': model.equipment,
        'difficulty': model.difficulty,
        'isCustom': model.isCustom ? 1 : 0,
      });
    }
    
    dev.log('Successfully inserted ${exercises.length} exercises');
  }
}
