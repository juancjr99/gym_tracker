import 'package:equatable/equatable.dart';

/// Entidad que representa una serie realizada
class SetRecord extends Equatable {
  const SetRecord({
    required this.setNumber,
    this.reps,
    this.weight,
    this.duration,
    this.restTime,
    this.completed = false,
    this.notes,
  });

  /// Número de la serie
  final int setNumber;
  
  /// Repeticiones realizadas
  final int? reps;
  
  /// Peso utilizado en kg
  final double? weight;
  
  /// Duración en segundos (para ejercicios por tiempo)
  final int? duration;
  
  /// Tiempo de descanso después de la serie en segundos
  final int? restTime;
  
  /// Si la serie fue completada
  final bool completed;
  
  /// Notas adicionales de la serie
  final String? notes;

  /// Crea una copia del registro de serie con campos actualizados
  SetRecord copyWith({
    int? setNumber,
    int? reps,
    double? weight,
    int? duration,
    int? restTime,
    bool? completed,
    String? notes,
  }) {
    return SetRecord(
      setNumber: setNumber ?? this.setNumber,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      duration: duration ?? this.duration,
      restTime: restTime ?? this.restTime,
      completed: completed ?? this.completed,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
        setNumber,
        reps,
        weight,
        duration,
        restTime,
        completed,
        notes,
      ];
}

/// Entidad que representa el registro de un ejercicio en un entrenamiento
class ExerciseRecord extends Equatable {
  const ExerciseRecord({
    required this.exerciseId,
    required this.sets,
    this.totalTime,
    this.notes,
    this.completed = false,
  });

  /// ID del ejercicio
  final String exerciseId;
  
  /// Lista de series realizadas
  final List<SetRecord> sets;
  
  /// Tiempo total del ejercicio en segundos (para ejercicios por tiempo)
  final int? totalTime;
  
  /// Notas del ejercicio
  final String? notes;
  
  /// Si el ejercicio fue completado
  final bool completed;

  /// Crea una copia del registro de ejercicio con campos actualizados
  ExerciseRecord copyWith({
    String? exerciseId,
    List<SetRecord>? sets,
    int? totalTime,
    String? notes,
    bool? completed,
  }) {
    return ExerciseRecord(
      exerciseId: exerciseId ?? this.exerciseId,
      sets: sets ?? this.sets,
      totalTime: totalTime ?? this.totalTime,
      notes: notes ?? this.notes,
      completed: completed ?? this.completed,
    );
  }

  @override
  List<Object?> get props => [
        exerciseId,
        sets,
        totalTime,
        notes,
        completed,
      ];
}

/// Estados posibles de un entrenamiento
enum WorkoutStatus {
  /// Entrenamiento planificado pero no iniciado
  planned,
  /// Entrenamiento en progreso
  inProgress,
  /// Entrenamiento completado
  completed,
  /// Entrenamiento cancelado
  cancelled,
}

/// Entidad que representa un registro completo de entrenamiento
class WorkoutRecord extends Equatable {
  const WorkoutRecord({
    required this.id,
    required this.routineId,
    required this.date,
    required this.status,
    required this.exerciseRecords,
    this.startTime,
    this.endTime,
    this.totalDuration,
    this.notes,
    this.rating,
  });

  /// Identificador único del entrenamiento
  final String id;
  
  /// ID de la rutina utilizada
  final String routineId;
  
  /// Fecha del entrenamiento
  final DateTime date;
  
  /// Hora de inicio del entrenamiento
  final DateTime? startTime;
  
  /// Hora de finalización del entrenamiento
  final DateTime? endTime;
  
  /// Duración total del entrenamiento
  final Duration? totalDuration;
  
  /// Estado del entrenamiento
  final WorkoutStatus status;
  
  /// Registros de ejercicios realizados
  final List<ExerciseRecord> exerciseRecords;
  
  /// Notas generales del entrenamiento
  final String? notes;
  
  /// Calificación del entrenamiento (1-5)
  final int? rating;

  /// Crea una copia del registro de entrenamiento con campos actualizados
  WorkoutRecord copyWith({
    String? id,
    String? routineId,
    DateTime? date,
    DateTime? startTime,
    DateTime? endTime,
    Duration? totalDuration,
    WorkoutStatus? status,
    List<ExerciseRecord>? exerciseRecords,
    String? notes,
    int? rating,
  }) {
    return WorkoutRecord(
      id: id ?? this.id,
      routineId: routineId ?? this.routineId,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      totalDuration: totalDuration ?? this.totalDuration,
      status: status ?? this.status,
      exerciseRecords: exerciseRecords ?? this.exerciseRecords,
      notes: notes ?? this.notes,
      rating: rating ?? this.rating,
    );
  }

  @override
  List<Object?> get props => [
        id,
        routineId,
        date,
        startTime,
        endTime,
        totalDuration,
        status,
        exerciseRecords,
        notes,
        rating,
      ];
}