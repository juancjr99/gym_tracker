// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ExerciseDao? _exerciseDaoInstance;

  RoutineDao? _routineDaoInstance;

  RoutineExerciseDao? _routineExerciseDaoInstance;

  WorkoutRecordDao? _workoutRecordDaoInstance;

  ExerciseRecordDao? _exerciseRecordDaoInstance;

  SetRecordDao? _setRecordDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `exercises` (`id` TEXT NOT NULL, `name` TEXT NOT NULL, `category` TEXT, `type` TEXT NOT NULL, `description` TEXT, `instructions` TEXT, `imageUrl` TEXT, `videoUrl` TEXT, `muscleGroups` TEXT NOT NULL, `equipment` TEXT, `difficulty` TEXT NOT NULL, `isCustom` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `routines` (`id` TEXT NOT NULL, `name` TEXT NOT NULL, `description` TEXT, `type` TEXT NOT NULL, `difficulty` TEXT NOT NULL, `estimatedDuration` INTEGER, `tags` TEXT NOT NULL, `isTemplate` INTEGER NOT NULL, `isActive` INTEGER NOT NULL, `color` TEXT, `icon` TEXT, `createdAt` INTEGER NOT NULL, `updatedAt` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `routine_exercises` (`id` TEXT NOT NULL, `routineId` TEXT NOT NULL, `exerciseId` TEXT NOT NULL, `order` INTEGER NOT NULL, `sets` INTEGER, `reps` INTEGER, `weight` REAL, `duration` INTEGER, `restTime` INTEGER NOT NULL, `notes` TEXT, `isSuperset` INTEGER NOT NULL, `supersetGroup` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `workout_records` (`id` TEXT NOT NULL, `routineId` TEXT NOT NULL, `date` INTEGER NOT NULL, `startTime` INTEGER, `endTime` INTEGER, `totalDurationMinutes` INTEGER, `status` TEXT NOT NULL, `notes` TEXT, `rating` INTEGER, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `exercise_records` (`id` TEXT NOT NULL, `workoutId` TEXT NOT NULL, `exerciseId` TEXT NOT NULL, `totalTime` INTEGER, `notes` TEXT, `completed` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `set_records` (`id` TEXT NOT NULL, `exerciseRecordId` TEXT NOT NULL, `setNumber` INTEGER NOT NULL, `reps` INTEGER, `weight` REAL, `duration` INTEGER, `completed` INTEGER NOT NULL, `notes` TEXT, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ExerciseDao get exerciseDao {
    return _exerciseDaoInstance ??= _$ExerciseDao(database, changeListener);
  }

  @override
  RoutineDao get routineDao {
    return _routineDaoInstance ??= _$RoutineDao(database, changeListener);
  }

  @override
  RoutineExerciseDao get routineExerciseDao {
    return _routineExerciseDaoInstance ??=
        _$RoutineExerciseDao(database, changeListener);
  }

  @override
  WorkoutRecordDao get workoutRecordDao {
    return _workoutRecordDaoInstance ??=
        _$WorkoutRecordDao(database, changeListener);
  }

  @override
  ExerciseRecordDao get exerciseRecordDao {
    return _exerciseRecordDaoInstance ??=
        _$ExerciseRecordDao(database, changeListener);
  }

  @override
  SetRecordDao get setRecordDao {
    return _setRecordDaoInstance ??= _$SetRecordDao(database, changeListener);
  }
}

class _$ExerciseDao extends ExerciseDao {
  _$ExerciseDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _exerciseModelInsertionAdapter = InsertionAdapter(
            database,
            'exercises',
            (ExerciseModel item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'category': item.category,
                  'type': item.type,
                  'description': item.description,
                  'instructions': item.instructions,
                  'imageUrl': item.imageUrl,
                  'videoUrl': item.videoUrl,
                  'muscleGroups': item.muscleGroups,
                  'equipment': item.equipment,
                  'difficulty': item.difficulty,
                  'isCustom': item.isCustom ? 1 : 0
                }),
        _exerciseModelUpdateAdapter = UpdateAdapter(
            database,
            'exercises',
            ['id'],
            (ExerciseModel item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'category': item.category,
                  'type': item.type,
                  'description': item.description,
                  'instructions': item.instructions,
                  'imageUrl': item.imageUrl,
                  'videoUrl': item.videoUrl,
                  'muscleGroups': item.muscleGroups,
                  'equipment': item.equipment,
                  'difficulty': item.difficulty,
                  'isCustom': item.isCustom ? 1 : 0
                }),
        _exerciseModelDeletionAdapter = DeletionAdapter(
            database,
            'exercises',
            ['id'],
            (ExerciseModel item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'category': item.category,
                  'type': item.type,
                  'description': item.description,
                  'instructions': item.instructions,
                  'imageUrl': item.imageUrl,
                  'videoUrl': item.videoUrl,
                  'muscleGroups': item.muscleGroups,
                  'equipment': item.equipment,
                  'difficulty': item.difficulty,
                  'isCustom': item.isCustom ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ExerciseModel> _exerciseModelInsertionAdapter;

  final UpdateAdapter<ExerciseModel> _exerciseModelUpdateAdapter;

  final DeletionAdapter<ExerciseModel> _exerciseModelDeletionAdapter;

  @override
  Future<List<ExerciseModel>> getAllExercises() async {
    return _queryAdapter.queryList('SELECT * FROM exercises ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => ExerciseModel(
            id: row['id'] as String,
            name: row['name'] as String,
            type: row['type'] as String,
            muscleGroups: row['muscleGroups'] as String,
            difficulty: row['difficulty'] as String,
            isCustom: (row['isCustom'] as int) != 0,
            category: row['category'] as String?,
            description: row['description'] as String?,
            instructions: row['instructions'] as String?,
            imageUrl: row['imageUrl'] as String?,
            videoUrl: row['videoUrl'] as String?,
            equipment: row['equipment'] as String?));
  }

  @override
  Future<List<ExerciseModel>> getExercisesByType(String type) async {
    return _queryAdapter.queryList(
        'SELECT * FROM exercises WHERE type = ?1 ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => ExerciseModel(
            id: row['id'] as String,
            name: row['name'] as String,
            type: row['type'] as String,
            muscleGroups: row['muscleGroups'] as String,
            difficulty: row['difficulty'] as String,
            isCustom: (row['isCustom'] as int) != 0,
            category: row['category'] as String?,
            description: row['description'] as String?,
            instructions: row['instructions'] as String?,
            imageUrl: row['imageUrl'] as String?,
            videoUrl: row['videoUrl'] as String?,
            equipment: row['equipment'] as String?),
        arguments: [type]);
  }

  @override
  Future<List<ExerciseModel>> getExercisesByMuscleGroup(
      String muscleGroup) async {
    return _queryAdapter.queryList(
        'SELECT * FROM exercises WHERE muscleGroups LIKE ?1 ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => ExerciseModel(
            id: row['id'] as String,
            name: row['name'] as String,
            type: row['type'] as String,
            muscleGroups: row['muscleGroups'] as String,
            difficulty: row['difficulty'] as String,
            isCustom: (row['isCustom'] as int) != 0,
            category: row['category'] as String?,
            description: row['description'] as String?,
            instructions: row['instructions'] as String?,
            imageUrl: row['imageUrl'] as String?,
            videoUrl: row['videoUrl'] as String?,
            equipment: row['equipment'] as String?),
        arguments: [muscleGroup]);
  }

  @override
  Future<ExerciseModel?> getExerciseById(String id) async {
    return _queryAdapter.query('SELECT * FROM exercises WHERE id = ?1',
        mapper: (Map<String, Object?> row) => ExerciseModel(
            id: row['id'] as String,
            name: row['name'] as String,
            type: row['type'] as String,
            muscleGroups: row['muscleGroups'] as String,
            difficulty: row['difficulty'] as String,
            isCustom: (row['isCustom'] as int) != 0,
            category: row['category'] as String?,
            description: row['description'] as String?,
            instructions: row['instructions'] as String?,
            imageUrl: row['imageUrl'] as String?,
            videoUrl: row['videoUrl'] as String?,
            equipment: row['equipment'] as String?),
        arguments: [id]);
  }

  @override
  Future<List<ExerciseModel>> searchExercises(String query) async {
    return _queryAdapter.queryList(
        'SELECT * FROM exercises WHERE name LIKE ?1 ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => ExerciseModel(
            id: row['id'] as String,
            name: row['name'] as String,
            type: row['type'] as String,
            muscleGroups: row['muscleGroups'] as String,
            difficulty: row['difficulty'] as String,
            isCustom: (row['isCustom'] as int) != 0,
            category: row['category'] as String?,
            description: row['description'] as String?,
            instructions: row['instructions'] as String?,
            imageUrl: row['imageUrl'] as String?,
            videoUrl: row['videoUrl'] as String?,
            equipment: row['equipment'] as String?),
        arguments: [query]);
  }

  @override
  Future<List<ExerciseModel>> getCustomExercises() async {
    return _queryAdapter.queryList(
        'SELECT * FROM exercises WHERE isCustom = 1 ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => ExerciseModel(
            id: row['id'] as String,
            name: row['name'] as String,
            type: row['type'] as String,
            muscleGroups: row['muscleGroups'] as String,
            difficulty: row['difficulty'] as String,
            isCustom: (row['isCustom'] as int) != 0,
            category: row['category'] as String?,
            description: row['description'] as String?,
            instructions: row['instructions'] as String?,
            imageUrl: row['imageUrl'] as String?,
            videoUrl: row['videoUrl'] as String?,
            equipment: row['equipment'] as String?));
  }

  @override
  Future<List<ExerciseModel>> getExercisesByCategory(String category) async {
    return _queryAdapter.queryList(
        'SELECT * FROM exercises WHERE category = ?1 ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => ExerciseModel(
            id: row['id'] as String,
            name: row['name'] as String,
            type: row['type'] as String,
            muscleGroups: row['muscleGroups'] as String,
            difficulty: row['difficulty'] as String,
            isCustom: (row['isCustom'] as int) != 0,
            category: row['category'] as String?,
            description: row['description'] as String?,
            instructions: row['instructions'] as String?,
            imageUrl: row['imageUrl'] as String?,
            videoUrl: row['videoUrl'] as String?,
            equipment: row['equipment'] as String?),
        arguments: [category]);
  }

  @override
  Future<void> deleteExerciseById(String id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM exercises WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<int?> getExerciseCount() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM exercises',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> getCustomExerciseCount() async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM exercises WHERE isCustom = 1',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<void> insertExercise(ExerciseModel exercise) async {
    await _exerciseModelInsertionAdapter.insert(
        exercise, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertExercises(List<ExerciseModel> exercises) async {
    await _exerciseModelInsertionAdapter.insertList(
        exercises, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateExercise(ExerciseModel exercise) async {
    await _exerciseModelUpdateAdapter.update(
        exercise, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteExercise(ExerciseModel exercise) async {
    await _exerciseModelDeletionAdapter.delete(exercise);
  }
}

class _$RoutineDao extends RoutineDao {
  _$RoutineDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _routineModelInsertionAdapter = InsertionAdapter(
            database,
            'routines',
            (RoutineModel item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'type': item.type,
                  'difficulty': item.difficulty,
                  'estimatedDuration': item.estimatedDuration,
                  'tags': item.tags,
                  'isTemplate': item.isTemplate ? 1 : 0,
                  'isActive': item.isActive ? 1 : 0,
                  'color': item.color,
                  'icon': item.icon,
                  'createdAt': item.createdAt,
                  'updatedAt': item.updatedAt
                }),
        _routineModelUpdateAdapter = UpdateAdapter(
            database,
            'routines',
            ['id'],
            (RoutineModel item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'type': item.type,
                  'difficulty': item.difficulty,
                  'estimatedDuration': item.estimatedDuration,
                  'tags': item.tags,
                  'isTemplate': item.isTemplate ? 1 : 0,
                  'isActive': item.isActive ? 1 : 0,
                  'color': item.color,
                  'icon': item.icon,
                  'createdAt': item.createdAt,
                  'updatedAt': item.updatedAt
                }),
        _routineModelDeletionAdapter = DeletionAdapter(
            database,
            'routines',
            ['id'],
            (RoutineModel item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'type': item.type,
                  'difficulty': item.difficulty,
                  'estimatedDuration': item.estimatedDuration,
                  'tags': item.tags,
                  'isTemplate': item.isTemplate ? 1 : 0,
                  'isActive': item.isActive ? 1 : 0,
                  'color': item.color,
                  'icon': item.icon,
                  'createdAt': item.createdAt,
                  'updatedAt': item.updatedAt
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<RoutineModel> _routineModelInsertionAdapter;

  final UpdateAdapter<RoutineModel> _routineModelUpdateAdapter;

  final DeletionAdapter<RoutineModel> _routineModelDeletionAdapter;

  @override
  Future<List<RoutineModel>> getAllRoutines() async {
    return _queryAdapter.queryList(
        'SELECT * FROM routines WHERE isActive = 1 ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => RoutineModel(
            id: row['id'] as String,
            name: row['name'] as String,
            type: row['type'] as String,
            difficulty: row['difficulty'] as String,
            tags: row['tags'] as String,
            isTemplate: (row['isTemplate'] as int) != 0,
            isActive: (row['isActive'] as int) != 0,
            createdAt: row['createdAt'] as int,
            updatedAt: row['updatedAt'] as int,
            description: row['description'] as String?,
            estimatedDuration: row['estimatedDuration'] as int?,
            color: row['color'] as String?,
            icon: row['icon'] as String?));
  }

  @override
  Future<List<RoutineModel>> getRoutinesByType(String type) async {
    return _queryAdapter.queryList(
        'SELECT * FROM routines WHERE type = ?1 AND isActive = 1 ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => RoutineModel(id: row['id'] as String, name: row['name'] as String, type: row['type'] as String, difficulty: row['difficulty'] as String, tags: row['tags'] as String, isTemplate: (row['isTemplate'] as int) != 0, isActive: (row['isActive'] as int) != 0, createdAt: row['createdAt'] as int, updatedAt: row['updatedAt'] as int, description: row['description'] as String?, estimatedDuration: row['estimatedDuration'] as int?, color: row['color'] as String?, icon: row['icon'] as String?),
        arguments: [type]);
  }

  @override
  Future<RoutineModel?> getRoutineById(String id) async {
    return _queryAdapter.query('SELECT * FROM routines WHERE id = ?1',
        mapper: (Map<String, Object?> row) => RoutineModel(
            id: row['id'] as String,
            name: row['name'] as String,
            type: row['type'] as String,
            difficulty: row['difficulty'] as String,
            tags: row['tags'] as String,
            isTemplate: (row['isTemplate'] as int) != 0,
            isActive: (row['isActive'] as int) != 0,
            createdAt: row['createdAt'] as int,
            updatedAt: row['updatedAt'] as int,
            description: row['description'] as String?,
            estimatedDuration: row['estimatedDuration'] as int?,
            color: row['color'] as String?,
            icon: row['icon'] as String?),
        arguments: [id]);
  }

  @override
  Future<List<RoutineModel>> searchRoutines(String query) async {
    return _queryAdapter.queryList(
        'SELECT * FROM routines WHERE name LIKE ?1 AND isActive = 1 ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => RoutineModel(id: row['id'] as String, name: row['name'] as String, type: row['type'] as String, difficulty: row['difficulty'] as String, tags: row['tags'] as String, isTemplate: (row['isTemplate'] as int) != 0, isActive: (row['isActive'] as int) != 0, createdAt: row['createdAt'] as int, updatedAt: row['updatedAt'] as int, description: row['description'] as String?, estimatedDuration: row['estimatedDuration'] as int?, color: row['color'] as String?, icon: row['icon'] as String?),
        arguments: [query]);
  }

  @override
  Future<List<RoutineModel>> getTemplateRoutines() async {
    return _queryAdapter.queryList(
        'SELECT * FROM routines WHERE isTemplate = 1 ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => RoutineModel(
            id: row['id'] as String,
            name: row['name'] as String,
            type: row['type'] as String,
            difficulty: row['difficulty'] as String,
            tags: row['tags'] as String,
            isTemplate: (row['isTemplate'] as int) != 0,
            isActive: (row['isActive'] as int) != 0,
            createdAt: row['createdAt'] as int,
            updatedAt: row['updatedAt'] as int,
            description: row['description'] as String?,
            estimatedDuration: row['estimatedDuration'] as int?,
            color: row['color'] as String?,
            icon: row['icon'] as String?));
  }

  @override
  Future<List<RoutineModel>> getArchivedRoutines() async {
    return _queryAdapter.queryList(
        'SELECT * FROM routines WHERE isActive = 0 ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => RoutineModel(
            id: row['id'] as String,
            name: row['name'] as String,
            type: row['type'] as String,
            difficulty: row['difficulty'] as String,
            tags: row['tags'] as String,
            isTemplate: (row['isTemplate'] as int) != 0,
            isActive: (row['isActive'] as int) != 0,
            createdAt: row['createdAt'] as int,
            updatedAt: row['updatedAt'] as int,
            description: row['description'] as String?,
            estimatedDuration: row['estimatedDuration'] as int?,
            color: row['color'] as String?,
            icon: row['icon'] as String?));
  }

  @override
  Future<List<RoutineModel>> getRoutinesByTag(String tag) async {
    return _queryAdapter.queryList(
        'SELECT * FROM routines WHERE tags LIKE ?1 AND isActive = 1 ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => RoutineModel(id: row['id'] as String, name: row['name'] as String, type: row['type'] as String, difficulty: row['difficulty'] as String, tags: row['tags'] as String, isTemplate: (row['isTemplate'] as int) != 0, isActive: (row['isActive'] as int) != 0, createdAt: row['createdAt'] as int, updatedAt: row['updatedAt'] as int, description: row['description'] as String?, estimatedDuration: row['estimatedDuration'] as int?, color: row['color'] as String?, icon: row['icon'] as String?),
        arguments: [tag]);
  }

  @override
  Future<void> deleteRoutineById(String id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM routines WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> archiveRoutine(String id) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE routines SET isActive = 0 WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> unarchiveRoutine(String id) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE routines SET isActive = 1 WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<int?> getRoutineCount() async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM routines WHERE isActive = 1',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<void> insertRoutine(RoutineModel routine) async {
    await _routineModelInsertionAdapter.insert(
        routine, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateRoutine(RoutineModel routine) async {
    await _routineModelUpdateAdapter.update(routine, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteRoutine(RoutineModel routine) async {
    await _routineModelDeletionAdapter.delete(routine);
  }
}

class _$RoutineExerciseDao extends RoutineExerciseDao {
  _$RoutineExerciseDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _routineExerciseModelInsertionAdapter = InsertionAdapter(
            database,
            'routine_exercises',
            (RoutineExerciseModel item) => <String, Object?>{
                  'id': item.id,
                  'routineId': item.routineId,
                  'exerciseId': item.exerciseId,
                  'order': item.order,
                  'sets': item.sets,
                  'reps': item.reps,
                  'weight': item.weight,
                  'duration': item.duration,
                  'restTime': item.restTime,
                  'notes': item.notes,
                  'isSuperset': item.isSuperset ? 1 : 0,
                  'supersetGroup': item.supersetGroup
                }),
        _routineExerciseModelUpdateAdapter = UpdateAdapter(
            database,
            'routine_exercises',
            ['id'],
            (RoutineExerciseModel item) => <String, Object?>{
                  'id': item.id,
                  'routineId': item.routineId,
                  'exerciseId': item.exerciseId,
                  'order': item.order,
                  'sets': item.sets,
                  'reps': item.reps,
                  'weight': item.weight,
                  'duration': item.duration,
                  'restTime': item.restTime,
                  'notes': item.notes,
                  'isSuperset': item.isSuperset ? 1 : 0,
                  'supersetGroup': item.supersetGroup
                }),
        _routineExerciseModelDeletionAdapter = DeletionAdapter(
            database,
            'routine_exercises',
            ['id'],
            (RoutineExerciseModel item) => <String, Object?>{
                  'id': item.id,
                  'routineId': item.routineId,
                  'exerciseId': item.exerciseId,
                  'order': item.order,
                  'sets': item.sets,
                  'reps': item.reps,
                  'weight': item.weight,
                  'duration': item.duration,
                  'restTime': item.restTime,
                  'notes': item.notes,
                  'isSuperset': item.isSuperset ? 1 : 0,
                  'supersetGroup': item.supersetGroup
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<RoutineExerciseModel>
      _routineExerciseModelInsertionAdapter;

  final UpdateAdapter<RoutineExerciseModel> _routineExerciseModelUpdateAdapter;

  final DeletionAdapter<RoutineExerciseModel>
      _routineExerciseModelDeletionAdapter;

  @override
  Future<List<RoutineExerciseModel>> getExercisesByRoutineId(
      String routineId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM routine_exercises WHERE routineId = ?1 ORDER BY \"order\" ASC',
        mapper: (Map<String, Object?> row) => RoutineExerciseModel(id: row['id'] as String, routineId: row['routineId'] as String, exerciseId: row['exerciseId'] as String, order: row['order'] as int, restTime: row['restTime'] as int, isSuperset: (row['isSuperset'] as int) != 0, sets: row['sets'] as int?, reps: row['reps'] as int?, weight: row['weight'] as double?, duration: row['duration'] as int?, notes: row['notes'] as String?, supersetGroup: row['supersetGroup'] as String?),
        arguments: [routineId]);
  }

  @override
  Future<RoutineExerciseModel?> getRoutineExercise(
    String routineId,
    String exerciseId,
  ) async {
    return _queryAdapter.query(
        'SELECT * FROM routine_exercises WHERE routineId = ?1 AND exerciseId = ?2',
        mapper: (Map<String, Object?> row) => RoutineExerciseModel(id: row['id'] as String, routineId: row['routineId'] as String, exerciseId: row['exerciseId'] as String, order: row['order'] as int, restTime: row['restTime'] as int, isSuperset: (row['isSuperset'] as int) != 0, sets: row['sets'] as int?, reps: row['reps'] as int?, weight: row['weight'] as double?, duration: row['duration'] as int?, notes: row['notes'] as String?, supersetGroup: row['supersetGroup'] as String?),
        arguments: [routineId, exerciseId]);
  }

  @override
  Future<List<RoutineExerciseModel>> getSupersetExercises(
    String routineId,
    String group,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM routine_exercises WHERE routineId = ?1 AND supersetGroup = ?2 ORDER BY \"order\" ASC',
        mapper: (Map<String, Object?> row) => RoutineExerciseModel(id: row['id'] as String, routineId: row['routineId'] as String, exerciseId: row['exerciseId'] as String, order: row['order'] as int, restTime: row['restTime'] as int, isSuperset: (row['isSuperset'] as int) != 0, sets: row['sets'] as int?, reps: row['reps'] as int?, weight: row['weight'] as double?, duration: row['duration'] as int?, notes: row['notes'] as String?, supersetGroup: row['supersetGroup'] as String?),
        arguments: [routineId, group]);
  }

  @override
  Future<void> deleteExercisesByRoutineId(String routineId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM routine_exercises WHERE routineId = ?1',
        arguments: [routineId]);
  }

  @override
  Future<void> deleteRoutineExerciseById(
    String routineId,
    String exerciseId,
  ) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM routine_exercises WHERE routineId = ?1 AND exerciseId = ?2',
        arguments: [routineId, exerciseId]);
  }

  @override
  Future<int?> getMaxOrder(String routineId) async {
    return _queryAdapter.query(
        'SELECT MAX(\"order\") FROM routine_exercises WHERE routineId = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [routineId]);
  }

  @override
  Future<void> updateExerciseOrder(
    String id,
    int newOrder,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE routine_exercises SET \"order\" = ?2 WHERE id = ?1',
        arguments: [id, newOrder]);
  }

  @override
  Future<void> insertRoutineExercise(
      RoutineExerciseModel routineExercise) async {
    await _routineExerciseModelInsertionAdapter.insert(
        routineExercise, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertRoutineExercises(
      List<RoutineExerciseModel> routineExercises) async {
    await _routineExerciseModelInsertionAdapter.insertList(
        routineExercises, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateRoutineExercise(
      RoutineExerciseModel routineExercise) async {
    await _routineExerciseModelUpdateAdapter.update(
        routineExercise, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteRoutineExercise(
      RoutineExerciseModel routineExercise) async {
    await _routineExerciseModelDeletionAdapter.delete(routineExercise);
  }
}

class _$WorkoutRecordDao extends WorkoutRecordDao {
  _$WorkoutRecordDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _workoutRecordModelInsertionAdapter = InsertionAdapter(
            database,
            'workout_records',
            (WorkoutRecordModel item) => <String, Object?>{
                  'id': item.id,
                  'routineId': item.routineId,
                  'date': item.date,
                  'startTime': item.startTime,
                  'endTime': item.endTime,
                  'totalDurationMinutes': item.totalDurationMinutes,
                  'status': item.status,
                  'notes': item.notes,
                  'rating': item.rating
                }),
        _workoutRecordModelUpdateAdapter = UpdateAdapter(
            database,
            'workout_records',
            ['id'],
            (WorkoutRecordModel item) => <String, Object?>{
                  'id': item.id,
                  'routineId': item.routineId,
                  'date': item.date,
                  'startTime': item.startTime,
                  'endTime': item.endTime,
                  'totalDurationMinutes': item.totalDurationMinutes,
                  'status': item.status,
                  'notes': item.notes,
                  'rating': item.rating
                }),
        _workoutRecordModelDeletionAdapter = DeletionAdapter(
            database,
            'workout_records',
            ['id'],
            (WorkoutRecordModel item) => <String, Object?>{
                  'id': item.id,
                  'routineId': item.routineId,
                  'date': item.date,
                  'startTime': item.startTime,
                  'endTime': item.endTime,
                  'totalDurationMinutes': item.totalDurationMinutes,
                  'status': item.status,
                  'notes': item.notes,
                  'rating': item.rating
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<WorkoutRecordModel>
      _workoutRecordModelInsertionAdapter;

  final UpdateAdapter<WorkoutRecordModel> _workoutRecordModelUpdateAdapter;

  final DeletionAdapter<WorkoutRecordModel> _workoutRecordModelDeletionAdapter;

  @override
  Future<List<WorkoutRecordModel>> getAllWorkouts() async {
    return _queryAdapter.queryList(
        'SELECT * FROM workout_records ORDER BY date DESC',
        mapper: (Map<String, Object?> row) => WorkoutRecordModel(
            id: row['id'] as String,
            routineId: row['routineId'] as String,
            date: row['date'] as int,
            status: row['status'] as String,
            startTime: row['startTime'] as int?,
            endTime: row['endTime'] as int?,
            totalDurationMinutes: row['totalDurationMinutes'] as int?,
            notes: row['notes'] as String?,
            rating: row['rating'] as int?));
  }

  @override
  Future<List<WorkoutRecordModel>> getWorkoutsByDateRange(
    int startDate,
    int endDate,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM workout_records WHERE date BETWEEN ?1 AND ?2 ORDER BY date DESC',
        mapper: (Map<String, Object?> row) => WorkoutRecordModel(id: row['id'] as String, routineId: row['routineId'] as String, date: row['date'] as int, status: row['status'] as String, startTime: row['startTime'] as int?, endTime: row['endTime'] as int?, totalDurationMinutes: row['totalDurationMinutes'] as int?, notes: row['notes'] as String?, rating: row['rating'] as int?),
        arguments: [startDate, endDate]);
  }

  @override
  Future<WorkoutRecordModel?> getWorkoutById(String id) async {
    return _queryAdapter.query('SELECT * FROM workout_records WHERE id = ?1',
        mapper: (Map<String, Object?> row) => WorkoutRecordModel(
            id: row['id'] as String,
            routineId: row['routineId'] as String,
            date: row['date'] as int,
            status: row['status'] as String,
            startTime: row['startTime'] as int?,
            endTime: row['endTime'] as int?,
            totalDurationMinutes: row['totalDurationMinutes'] as int?,
            notes: row['notes'] as String?,
            rating: row['rating'] as int?),
        arguments: [id]);
  }

  @override
  Future<List<WorkoutRecordModel>> getWorkoutsByRoutine(
      String routineId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM workout_records WHERE routineId = ?1 ORDER BY date DESC',
        mapper: (Map<String, Object?> row) => WorkoutRecordModel(
            id: row['id'] as String,
            routineId: row['routineId'] as String,
            date: row['date'] as int,
            status: row['status'] as String,
            startTime: row['startTime'] as int?,
            endTime: row['endTime'] as int?,
            totalDurationMinutes: row['totalDurationMinutes'] as int?,
            notes: row['notes'] as String?,
            rating: row['rating'] as int?),
        arguments: [routineId]);
  }

  @override
  Future<WorkoutRecordModel?> getLastWorkout() async {
    return _queryAdapter.query(
        'SELECT * FROM workout_records ORDER BY date DESC LIMIT 1',
        mapper: (Map<String, Object?> row) => WorkoutRecordModel(
            id: row['id'] as String,
            routineId: row['routineId'] as String,
            date: row['date'] as int,
            status: row['status'] as String,
            startTime: row['startTime'] as int?,
            endTime: row['endTime'] as int?,
            totalDurationMinutes: row['totalDurationMinutes'] as int?,
            notes: row['notes'] as String?,
            rating: row['rating'] as int?));
  }

  @override
  Future<List<WorkoutRecordModel>> getWorkoutsByStatus(String status) async {
    return _queryAdapter.queryList(
        'SELECT * FROM workout_records WHERE status = ?1',
        mapper: (Map<String, Object?> row) => WorkoutRecordModel(
            id: row['id'] as String,
            routineId: row['routineId'] as String,
            date: row['date'] as int,
            status: row['status'] as String,
            startTime: row['startTime'] as int?,
            endTime: row['endTime'] as int?,
            totalDurationMinutes: row['totalDurationMinutes'] as int?,
            notes: row['notes'] as String?,
            rating: row['rating'] as int?),
        arguments: [status]);
  }

  @override
  Future<List<WorkoutRecordModel>> getActiveWorkouts() async {
    return _queryAdapter.queryList(
        'SELECT * FROM workout_records WHERE status = \"inProgress\" ORDER BY startTime DESC',
        mapper: (Map<String, Object?> row) => WorkoutRecordModel(
            id: row['id'] as String,
            routineId: row['routineId'] as String,
            date: row['date'] as int,
            status: row['status'] as String,
            startTime: row['startTime'] as int?,
            endTime: row['endTime'] as int?,
            totalDurationMinutes: row['totalDurationMinutes'] as int?,
            notes: row['notes'] as String?,
            rating: row['rating'] as int?));
  }

  @override
  Future<List<WorkoutRecordModel>> getCompletedWorkouts() async {
    return _queryAdapter.queryList(
        'SELECT * FROM workout_records WHERE status = \"completed\" ORDER BY date DESC',
        mapper: (Map<String, Object?> row) => WorkoutRecordModel(
            id: row['id'] as String,
            routineId: row['routineId'] as String,
            date: row['date'] as int,
            status: row['status'] as String,
            startTime: row['startTime'] as int?,
            endTime: row['endTime'] as int?,
            totalDurationMinutes: row['totalDurationMinutes'] as int?,
            notes: row['notes'] as String?,
            rating: row['rating'] as int?));
  }

  @override
  Future<void> deleteWorkoutById(String id) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM workout_records WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<int?> getCompletedWorkoutCountInRange(
    int startDate,
    int endDate,
  ) async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM workout_records WHERE status = \"completed\" AND date >= ?1 AND date <= ?2',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [startDate, endDate]);
  }

  @override
  Future<int?> getCompletedWorkoutCount() async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM workout_records WHERE status = \"completed\"',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<void> insertWorkout(WorkoutRecordModel workout) async {
    await _workoutRecordModelInsertionAdapter.insert(
        workout, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateWorkout(WorkoutRecordModel workout) async {
    await _workoutRecordModelUpdateAdapter.update(
        workout, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteWorkout(WorkoutRecordModel workout) async {
    await _workoutRecordModelDeletionAdapter.delete(workout);
  }
}

class _$ExerciseRecordDao extends ExerciseRecordDao {
  _$ExerciseRecordDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _exerciseRecordModelInsertionAdapter = InsertionAdapter(
            database,
            'exercise_records',
            (ExerciseRecordModel item) => <String, Object?>{
                  'id': item.id,
                  'workoutId': item.workoutId,
                  'exerciseId': item.exerciseId,
                  'totalTime': item.totalTime,
                  'notes': item.notes,
                  'completed': item.completed ? 1 : 0
                }),
        _exerciseRecordModelUpdateAdapter = UpdateAdapter(
            database,
            'exercise_records',
            ['id'],
            (ExerciseRecordModel item) => <String, Object?>{
                  'id': item.id,
                  'workoutId': item.workoutId,
                  'exerciseId': item.exerciseId,
                  'totalTime': item.totalTime,
                  'notes': item.notes,
                  'completed': item.completed ? 1 : 0
                }),
        _exerciseRecordModelDeletionAdapter = DeletionAdapter(
            database,
            'exercise_records',
            ['id'],
            (ExerciseRecordModel item) => <String, Object?>{
                  'id': item.id,
                  'workoutId': item.workoutId,
                  'exerciseId': item.exerciseId,
                  'totalTime': item.totalTime,
                  'notes': item.notes,
                  'completed': item.completed ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ExerciseRecordModel>
      _exerciseRecordModelInsertionAdapter;

  final UpdateAdapter<ExerciseRecordModel> _exerciseRecordModelUpdateAdapter;

  final DeletionAdapter<ExerciseRecordModel>
      _exerciseRecordModelDeletionAdapter;

  @override
  Future<List<ExerciseRecordModel>> getExerciseRecordsByWorkout(
      String workoutId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM exercise_records WHERE workoutId = ?1',
        mapper: (Map<String, Object?> row) => ExerciseRecordModel(
            id: row['id'] as String,
            workoutId: row['workoutId'] as String,
            exerciseId: row['exerciseId'] as String,
            completed: (row['completed'] as int) != 0,
            totalTime: row['totalTime'] as int?,
            notes: row['notes'] as String?),
        arguments: [workoutId]);
  }

  @override
  Future<ExerciseRecordModel?> getExerciseRecord(
    String workoutId,
    String exerciseId,
  ) async {
    return _queryAdapter.query(
        'SELECT * FROM exercise_records WHERE workoutId = ?1 AND exerciseId = ?2',
        mapper: (Map<String, Object?> row) => ExerciseRecordModel(id: row['id'] as String, workoutId: row['workoutId'] as String, exerciseId: row['exerciseId'] as String, completed: (row['completed'] as int) != 0, totalTime: row['totalTime'] as int?, notes: row['notes'] as String?),
        arguments: [workoutId, exerciseId]);
  }

  @override
  Future<List<ExerciseRecordModel>> getExerciseRecordsByExercise(
      String exerciseId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM exercise_records WHERE exerciseId = ?1 ORDER BY id DESC',
        mapper: (Map<String, Object?> row) => ExerciseRecordModel(
            id: row['id'] as String,
            workoutId: row['workoutId'] as String,
            exerciseId: row['exerciseId'] as String,
            completed: (row['completed'] as int) != 0,
            totalTime: row['totalTime'] as int?,
            notes: row['notes'] as String?),
        arguments: [exerciseId]);
  }

  @override
  Future<void> deleteExerciseRecordsByWorkout(String workoutId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM exercise_records WHERE workoutId = ?1',
        arguments: [workoutId]);
  }

  @override
  Future<void> markExerciseCompleted(String id) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE exercise_records SET completed = 1 WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<List<ExerciseRecordModel>> getCompletedExercises(
      String workoutId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM exercise_records WHERE workoutId = ?1 AND completed = 1',
        mapper: (Map<String, Object?> row) => ExerciseRecordModel(
            id: row['id'] as String,
            workoutId: row['workoutId'] as String,
            exerciseId: row['exerciseId'] as String,
            completed: (row['completed'] as int) != 0,
            totalTime: row['totalTime'] as int?,
            notes: row['notes'] as String?),
        arguments: [workoutId]);
  }

  @override
  Future<void> insertExerciseRecord(ExerciseRecordModel exerciseRecord) async {
    await _exerciseRecordModelInsertionAdapter.insert(
        exerciseRecord, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertExerciseRecords(
      List<ExerciseRecordModel> exerciseRecords) async {
    await _exerciseRecordModelInsertionAdapter.insertList(
        exerciseRecords, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateExerciseRecord(ExerciseRecordModel exerciseRecord) async {
    await _exerciseRecordModelUpdateAdapter.update(
        exerciseRecord, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteExerciseRecord(ExerciseRecordModel exerciseRecord) async {
    await _exerciseRecordModelDeletionAdapter.delete(exerciseRecord);
  }
}

class _$SetRecordDao extends SetRecordDao {
  _$SetRecordDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _setRecordModelInsertionAdapter = InsertionAdapter(
            database,
            'set_records',
            (SetRecordModel item) => <String, Object?>{
                  'id': item.id,
                  'exerciseRecordId': item.exerciseRecordId,
                  'setNumber': item.setNumber,
                  'reps': item.reps,
                  'weight': item.weight,
                  'duration': item.duration,
                  'completed': item.completed ? 1 : 0,
                  'notes': item.notes
                }),
        _setRecordModelUpdateAdapter = UpdateAdapter(
            database,
            'set_records',
            ['id'],
            (SetRecordModel item) => <String, Object?>{
                  'id': item.id,
                  'exerciseRecordId': item.exerciseRecordId,
                  'setNumber': item.setNumber,
                  'reps': item.reps,
                  'weight': item.weight,
                  'duration': item.duration,
                  'completed': item.completed ? 1 : 0,
                  'notes': item.notes
                }),
        _setRecordModelDeletionAdapter = DeletionAdapter(
            database,
            'set_records',
            ['id'],
            (SetRecordModel item) => <String, Object?>{
                  'id': item.id,
                  'exerciseRecordId': item.exerciseRecordId,
                  'setNumber': item.setNumber,
                  'reps': item.reps,
                  'weight': item.weight,
                  'duration': item.duration,
                  'completed': item.completed ? 1 : 0,
                  'notes': item.notes
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SetRecordModel> _setRecordModelInsertionAdapter;

  final UpdateAdapter<SetRecordModel> _setRecordModelUpdateAdapter;

  final DeletionAdapter<SetRecordModel> _setRecordModelDeletionAdapter;

  @override
  Future<List<SetRecordModel>> getSetsByExerciseRecord(
      String exerciseRecordId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM set_records WHERE exerciseRecordId = ?1 ORDER BY setNumber ASC',
        mapper: (Map<String, Object?> row) => SetRecordModel(id: row['id'] as String, exerciseRecordId: row['exerciseRecordId'] as String, setNumber: row['setNumber'] as int, completed: (row['completed'] as int) != 0, reps: row['reps'] as int?, weight: row['weight'] as double?, duration: row['duration'] as int?, notes: row['notes'] as String?),
        arguments: [exerciseRecordId]);
  }

  @override
  Future<SetRecordModel?> getSetRecord(
    String exerciseRecordId,
    int setNumber,
  ) async {
    return _queryAdapter.query(
        'SELECT * FROM set_records WHERE exerciseRecordId = ?1 AND setNumber = ?2',
        mapper: (Map<String, Object?> row) => SetRecordModel(id: row['id'] as String, exerciseRecordId: row['exerciseRecordId'] as String, setNumber: row['setNumber'] as int, completed: (row['completed'] as int) != 0, reps: row['reps'] as int?, weight: row['weight'] as double?, duration: row['duration'] as int?, notes: row['notes'] as String?),
        arguments: [exerciseRecordId, setNumber]);
  }

  @override
  Future<List<SetRecordModel>> getCompletedSets(String exerciseRecordId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM set_records WHERE exerciseRecordId = ?1 AND completed = 1 ORDER BY setNumber ASC',
        mapper: (Map<String, Object?> row) => SetRecordModel(id: row['id'] as String, exerciseRecordId: row['exerciseRecordId'] as String, setNumber: row['setNumber'] as int, completed: (row['completed'] as int) != 0, reps: row['reps'] as int?, weight: row['weight'] as double?, duration: row['duration'] as int?, notes: row['notes'] as String?),
        arguments: [exerciseRecordId]);
  }

  @override
  Future<void> deleteSetsByExerciseRecord(String exerciseRecordId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM set_records WHERE exerciseRecordId = ?1',
        arguments: [exerciseRecordId]);
  }

  @override
  Future<void> markSetCompleted(String id) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE set_records SET completed = 1 WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<double?> getMaxWeightForExercise(String exerciseId) async {
    return _queryAdapter.query(
        'SELECT MAX(weight) FROM set_records sr INNER JOIN exercise_records er ON sr.exerciseRecordId = er.id WHERE er.exerciseId = ?1 AND sr.completed = 1',
        mapper: (Map<String, Object?> row) => row.values.first as double,
        arguments: [exerciseId]);
  }

  @override
  Future<int?> getMaxRepsForWeight(
    String exerciseId,
    double weight,
  ) async {
    return _queryAdapter.query(
        'SELECT MAX(reps) FROM set_records sr INNER JOIN exercise_records er ON sr.exerciseRecordId = er.id WHERE er.exerciseId = ?1 AND sr.weight = ?2 AND sr.completed = 1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [exerciseId, weight]);
  }

  @override
  Future<void> insertSetRecord(SetRecordModel setRecord) async {
    await _setRecordModelInsertionAdapter.insert(
        setRecord, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertSetRecords(List<SetRecordModel> setRecords) async {
    await _setRecordModelInsertionAdapter.insertList(
        setRecords, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateSetRecord(SetRecordModel setRecord) async {
    await _setRecordModelUpdateAdapter.update(
        setRecord, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteSetRecord(SetRecordModel setRecord) async {
    await _setRecordModelDeletionAdapter.delete(setRecord);
  }
}
