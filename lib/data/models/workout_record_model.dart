import 'package:floor/floor.dart';
import 'package:gym_tracker/domain/entities/entities.dart';

/// Modelo de datos para WorkoutRecord con anotaciones de Floor
@Entity(tableName: 'workout_records')
class WorkoutRecordModel {
  @PrimaryKey()
  final String id;
  
  final String routineId;
  final int date; // Timestamp en millisecondsSinceEpoch
  final int? startTime; // Timestamp en millisecondsSinceEpoch
  final int? endTime; // Timestamp en millisecondsSinceEpoch
  final int? totalDurationMinutes; // Duración en minutos
  final String status; // Serializado como String
  final String? notes;
  final int? rating;

  const WorkoutRecordModel({
    required this.id,
    required this.routineId,
    required this.date,
    required this.status,
    this.startTime,
    this.endTime,
    this.totalDurationMinutes,
    this.notes,
    this.rating,
  });

  /// Convierte el modelo a entidad de dominio
  WorkoutRecord toEntity({required List<ExerciseRecord> exerciseRecords}) {
    return WorkoutRecord(
      id: id,
      routineId: routineId,
      date: DateTime.fromMillisecondsSinceEpoch(date),
      startTime: startTime != null ? DateTime.fromMillisecondsSinceEpoch(startTime!) : null,
      endTime: endTime != null ? DateTime.fromMillisecondsSinceEpoch(endTime!) : null,
      totalDuration: totalDurationMinutes != null 
          ? Duration(minutes: totalDurationMinutes!) 
          : null,
      status: WorkoutStatus.values.firstWhere(
        (e) => e.name == status,
        orElse: () => WorkoutStatus.planned,
      ),
      exerciseRecords: exerciseRecords,
      notes: notes,
      rating: rating,
    );
  }

  /// Crea modelo desde entidad de dominio
  factory WorkoutRecordModel.fromEntity(WorkoutRecord workout) {
    return WorkoutRecordModel(
      id: workout.id,
      routineId: workout.routineId,
      date: workout.date.millisecondsSinceEpoch,
      startTime: workout.startTime?.millisecondsSinceEpoch,
      endTime: workout.endTime?.millisecondsSinceEpoch,
      totalDurationMinutes: workout.totalDuration?.inMinutes,
      status: workout.status.name,
      notes: workout.notes,
      rating: workout.rating,
    );
  }

  /// Crea una copia del modelo con campos actualizados
  WorkoutRecordModel copyWith({
    String? id,
    String? routineId,
    int? date,
    int? startTime,
    int? endTime,
    int? totalDurationMinutes,
    String? status,
    String? notes,
    int? rating,
  }) {
    return WorkoutRecordModel(
      id: id ?? this.id,
      routineId: routineId ?? this.routineId,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      totalDurationMinutes: totalDurationMinutes ?? this.totalDurationMinutes,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      rating: rating ?? this.rating,
    );
  }
}

/// Modelo de datos para ExerciseRecord con anotaciones de Floor
@Entity(tableName: 'exercise_records')
class ExerciseRecordModel {
  @PrimaryKey()
  final String id; // Identificador único para la tabla
  
  final String workoutId;
  final String exerciseId;
  final int? totalTime; // En segundos
  final String? notes;
  final bool completed;

  const ExerciseRecordModel({
    required this.id,
    required this.workoutId,
    required this.exerciseId,
    required this.completed,
    this.totalTime,
    this.notes,
  });

  /// Convierte el modelo a entidad de dominio
  ExerciseRecord toEntity({required List<SetRecord> sets}) {
    return ExerciseRecord(
      exerciseId: exerciseId,
      sets: sets,
      totalTime: totalTime,
      notes: notes,
      completed: completed,
    );
  }

  /// Crea modelo desde entidad de dominio
  factory ExerciseRecordModel.fromEntity(
    ExerciseRecord exerciseRecord,
    String workoutId,
  ) {
    return ExerciseRecordModel(
      id: '${workoutId}_${exerciseRecord.exerciseId}',
      workoutId: workoutId,
      exerciseId: exerciseRecord.exerciseId,
      totalTime: exerciseRecord.totalTime,
      notes: exerciseRecord.notes,
      completed: exerciseRecord.completed,
    );
  }

  /// Crea una copia del modelo con campos actualizados
  ExerciseRecordModel copyWith({
    String? id,
    String? workoutId,
    String? exerciseId,
    int? totalTime,
    String? notes,
    bool? completed,
  }) {
    return ExerciseRecordModel(
      id: id ?? this.id,
      workoutId: workoutId ?? this.workoutId,
      exerciseId: exerciseId ?? this.exerciseId,
      totalTime: totalTime ?? this.totalTime,
      notes: notes ?? this.notes,
      completed: completed ?? this.completed,
    );
  }
}

/// Modelo de datos para SetRecord con anotaciones de Floor
@Entity(tableName: 'set_records')
class SetRecordModel {
  @PrimaryKey()
  final String id; // Identificador único para la tabla
  
  final String exerciseRecordId;
  final int setNumber;
  final int? reps;
  final double? weight; // En kg
  final int? duration; // En segundos
  final bool completed;
  final String? notes;

  const SetRecordModel({
    required this.id,
    required this.exerciseRecordId,
    required this.setNumber,
    required this.completed,
    this.reps,
    this.weight,
    this.duration,
    this.notes,
  });

  /// Convierte el modelo a entidad de dominio
  SetRecord toEntity() {
    return SetRecord(
      setNumber: setNumber,
      reps: reps,
      weight: weight,
      duration: duration,
      completed: completed,
      notes: notes,
    );
  }

  /// Crea modelo desde entidad de dominio
  factory SetRecordModel.fromEntity(
    SetRecord setRecord,
    String exerciseRecordId,
  ) {
    return SetRecordModel(
      id: '${exerciseRecordId}_${setRecord.setNumber}',
      exerciseRecordId: exerciseRecordId,
      setNumber: setRecord.setNumber,
      reps: setRecord.reps,
      weight: setRecord.weight,
      duration: setRecord.duration,
      completed: setRecord.completed,
      notes: setRecord.notes,
    );
  }

  /// Crea una copia del modelo con campos actualizados
  SetRecordModel copyWith({
    String? id,
    String? exerciseRecordId,
    int? setNumber,
    int? reps,
    double? weight,
    int? duration,
    bool? completed,
    String? notes,
  }) {
    return SetRecordModel(
      id: id ?? this.id,
      exerciseRecordId: exerciseRecordId ?? this.exerciseRecordId,
      setNumber: setNumber ?? this.setNumber,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      duration: duration ?? this.duration,
      completed: completed ?? this.completed,
      notes: notes ?? this.notes,
    );
  }
}