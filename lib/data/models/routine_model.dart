import 'package:floor/floor.dart';
import 'package:gym_tracker/domain/entities/entities.dart';

/// Modelo de datos para Routine con anotaciones de Floor
@Entity(tableName: 'routines')
class RoutineModel {
  @PrimaryKey()
  final String id;
  
  final String name;
  final String? description;
  final String type; // Serializado como String
  final String difficulty; // Serializado como String
  final int? estimatedDuration; // En minutos
  final String tags; // JSON serializado
  final bool isTemplate;
  final bool isActive;
  final String? color;
  final String? icon;
  final int createdAt; // Timestamp en millisecondsSinceEpoch
  final int updatedAt; // Timestamp en millisecondsSinceEpoch

  const RoutineModel({
    required this.id,
    required this.name,
    required this.type,
    required this.difficulty,
    required this.tags,
    required this.isTemplate,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.estimatedDuration,
    this.color,
    this.icon,
  });

  /// Convierte el modelo a entidad de dominio
  Routine toEntity({required List<RoutineExercise> exercises}) {
    return Routine(
      id: id,
      name: name,
      exercises: exercises,
      type: RoutineType.values.firstWhere(
        (e) => e.name == type,
        orElse: () => RoutineType.traditional,
      ),
      difficulty: RoutineDifficulty.values.firstWhere(
        (e) => e.name == difficulty,
        orElse: () => RoutineDifficulty.intermediate,
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAt),
      description: description,
      estimatedDuration: estimatedDuration,
      tags: _parseTags(tags),
      isTemplate: isTemplate,
      isActive: isActive,
      color: color,
      icon: icon,
    );
  }

  /// Crea modelo desde entidad de dominio
  factory RoutineModel.fromEntity(Routine routine) {
    return RoutineModel(
      id: routine.id,
      name: routine.name,
      type: routine.type.name,
      difficulty: routine.difficulty.name,
      tags: _serializeTags(routine.tags),
      isTemplate: routine.isTemplate,
      isActive: routine.isActive,
      createdAt: routine.createdAt.millisecondsSinceEpoch,
      updatedAt: routine.updatedAt.millisecondsSinceEpoch,
      description: routine.description,
      estimatedDuration: routine.estimatedDuration,
      color: routine.color,
      icon: routine.icon,
    );
  }

  /// Parsea tags desde String
  static List<String> _parseTags(String json) {
    try {
      if (json.isEmpty) return [];
      return json.split(',').map((e) => e.trim()).toList();
    } catch (e) {
      return [];
    }
  }

  /// Serializa tags a String
  static String _serializeTags(List<String> tags) {
    return tags.join(',');
  }

  /// Crea una copia del modelo con campos actualizados
  RoutineModel copyWith({
    String? id,
    String? name,
    String? description,
    String? type,
    String? difficulty,
    int? estimatedDuration,
    String? tags,
    bool? isTemplate,
    bool? isActive,
    String? color,
    String? icon,
    int? createdAt,
    int? updatedAt,
  }) {
    return RoutineModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      difficulty: difficulty ?? this.difficulty,
      tags: tags ?? this.tags,
      isTemplate: isTemplate ?? this.isTemplate,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      description: description ?? this.description,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      color: color ?? this.color,
      icon: icon ?? this.icon,
    );
  }
}

/// Modelo de datos para RoutineExercise con anotaciones de Floor
@Entity(tableName: 'routine_exercises')
class RoutineExerciseModel {
  @PrimaryKey()
  final String id; // Identificador único para la tabla
  
  final String routineId;
  final String exerciseId;
  final int order;
  final int? sets;
  final int? reps;
  final double? weight;
  final int? duration; // En segundos
  final int restTime; // En segundos
  final String? notes;
  final bool isSuperset;
  final String? supersetGroup;

  const RoutineExerciseModel({
    required this.id,
    required this.routineId,
    required this.exerciseId,
    required this.order,
    required this.restTime,
    required this.isSuperset,
    this.sets,
    this.reps,
    this.weight,
    this.duration,
    this.notes,
    this.supersetGroup,
  });

  /// Convierte el modelo a entidad de dominio
  RoutineExercise toEntity() {
    return RoutineExercise(
      exerciseId: exerciseId,
      order: order,
      sets: sets,
      reps: reps,
      weight: weight,
      duration: duration,
      restTime: restTime,
      notes: notes,
      isSuperset: isSuperset,
      supersetGroup: supersetGroup,
    );
  }

  /// Crea modelo desde entidad de dominio
  factory RoutineExerciseModel.fromEntity(
    RoutineExercise routineExercise,
    String routineId,
  ) {
    return RoutineExerciseModel(
      id: '${routineId}_${routineExercise.exerciseId}_${routineExercise.order}',
      routineId: routineId,
      exerciseId: routineExercise.exerciseId,
      order: routineExercise.order,
      sets: routineExercise.sets,
      reps: routineExercise.reps,
      weight: routineExercise.weight,
      duration: routineExercise.duration,
      restTime: routineExercise.restTime,
      notes: routineExercise.notes,
      isSuperset: routineExercise.isSuperset,
      supersetGroup: routineExercise.supersetGroup,
    );
  }

  /// Crea una copia del modelo con campos actualizados
  RoutineExerciseModel copyWith({
    String? id,
    String? routineId,
    String? exerciseId,
    int? order,
    int? sets,
    int? reps,
    double? weight,
    int? duration,
    int? restTime,
    String? notes,
    bool? isSuperset,
    String? supersetGroup,
  }) {
    return RoutineExerciseModel(
      id: id ?? this.id,
      routineId: routineId ?? this.routineId,
      exerciseId: exerciseId ?? this.exerciseId,
      order: order ?? this.order,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      duration: duration ?? this.duration,
      restTime: restTime ?? this.restTime,
      notes: notes ?? this.notes,
      isSuperset: isSuperset ?? this.isSuperset,
      supersetGroup: supersetGroup ?? this.supersetGroup,
    );
  }
}