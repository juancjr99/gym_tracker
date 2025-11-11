import 'package:equatable/equatable.dart';

/// Tipos de rutina disponibles
enum RoutineType {
  /// Rutina tradicional con series y repeticiones
  traditional,
  /// Rutina en formato circuito
  circuit,
  /// Rutina personalizada mixta
  mixed,
}

/// Niveles de dificultad de rutinas
enum RoutineDifficulty {
  beginner,
  intermediate,
  advanced,
  expert,
}

/// Entidad que representa un ejercicio dentro de una rutina
class RoutineExercise extends Equatable {
  const RoutineExercise({
    required this.exerciseId,
    required this.order,
    this.sets,
    this.reps,
    this.weight,
    this.duration,
    this.restTime = 60,
    this.notes,
    this.isSuperset = false,
    this.supersetGroup,
  });

  /// ID del ejercicio
  final String exerciseId;
  
  /// Orden del ejercicio en la rutina
  final int order;
  
  /// Número de series planificadas
  final int? sets;
  
  /// Repeticiones objetivo por serie
  final int? reps;
  
  /// Peso objetivo en kg
  final double? weight;
  
  /// Duración objetivo en segundos
  final int? duration;
  
  /// Tiempo de descanso entre series en segundos
  final int restTime;
  
  /// Notas específicas del ejercicio en la rutina
  final String? notes;
  
  /// Si forma parte de un superset
  final bool isSuperset;
  
  /// Grupo de superset (si aplica)
  final String? supersetGroup;

  /// Crea una copia del ejercicio de rutina con campos actualizados
  RoutineExercise copyWith({
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
    return RoutineExercise(
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

  @override
  List<Object?> get props => [
        exerciseId,
        order,
        sets,
        reps,
        weight,
        duration,
        restTime,
        notes,
        isSuperset,
        supersetGroup,
      ];
}

/// Entidad que representa una rutina de entrenamiento
class Routine extends Equatable {
  const Routine({
    required this.id,
    required this.name,
    required this.exercises,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.estimatedDuration,
    this.difficulty = RoutineDifficulty.intermediate,
    this.tags = const [],
    this.isTemplate = false,
    this.isActive = true,
    this.color,
    this.icon,
  });

  /// Identificador único de la rutina
  final String id;
  
  /// Nombre de la rutina
  final String name;
  
  /// Descripción de la rutina
  final String? description;
  
  /// Ejercicios que componen la rutina
  final List<RoutineExercise> exercises;
  
  /// Tipo de rutina
  final RoutineType type;
  
  /// Duración estimada en minutos
  final int? estimatedDuration;
  
  /// Nivel de dificultad
  final RoutineDifficulty difficulty;
  
  /// Tags para categorizar la rutina
  final List<String> tags;
  
  /// Si es una plantilla reutilizable
  final bool isTemplate;
  
  /// Si está activa o archivada
  final bool isActive;
  
  /// Color personalizado para la rutina
  final String? color;
  
  /// Ícono personalizado para la rutina
  final String? icon;
  
  /// Fecha de creación
  final DateTime createdAt;
  
  /// Fecha de última actualización
  final DateTime updatedAt;

  /// Crea una copia de la rutina con campos actualizados
  Routine copyWith({
    String? id,
    String? name,
    String? description,
    List<RoutineExercise>? exercises,
    RoutineType? type,
    int? estimatedDuration,
    RoutineDifficulty? difficulty,
    List<String>? tags,
    bool? isTemplate,
    bool? isActive,
    String? color,
    String? icon,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Routine(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      exercises: exercises ?? this.exercises,
      type: type ?? this.type,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      difficulty: difficulty ?? this.difficulty,
      tags: tags ?? this.tags,
      isTemplate: isTemplate ?? this.isTemplate,
      isActive: isActive ?? this.isActive,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        exercises,
        type,
        estimatedDuration,
        difficulty,
        tags,
        isTemplate,
        isActive,
        color,
        icon,
        createdAt,
        updatedAt,
      ];
}