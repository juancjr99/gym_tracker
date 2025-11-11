import 'package:equatable/equatable.dart';

/// Tipos de ejercicios disponibles
enum ExerciseType {
  /// Ejercicios con peso (pesas, máquinas)
  weight,
  /// Ejercicios por tiempo (plank, cardio)
  time,
  /// Ejercicios de peso corporal (flexiones, dominadas)
  bodyweight,
  /// Ejercicios combinados (peso + tiempo)
  combined,
}

/// Grupos musculares principales
enum MuscleGroup {
  chest,
  back,
  shoulders,
  arms,
  legs,
  glutes,
  core,
  cardio,
  fullBody,
}

/// Niveles de dificultad de ejercicios
enum ExerciseDifficulty {
  beginner,
  intermediate,
  advanced,
  expert,
}

/// Entidad que representa un ejercicio
class Exercise extends Equatable {
  const Exercise({
    required this.id,
    required this.name,
    required this.type,
    required this.muscleGroups,
    this.description,
    this.instructions,
    this.imageUrl,
    this.videoUrl,
    this.category,
    this.equipment,
    this.difficulty = ExerciseDifficulty.intermediate,
    this.isCustom = false,
  });

  /// Identificador único del ejercicio
  final String id;
  
  /// Nombre del ejercicio
  final String name;
  
  /// Tipo de ejercicio
  final ExerciseType type;
  
  /// Grupos musculares que trabaja
  final List<MuscleGroup> muscleGroups;
  
  /// Descripción del ejercicio
  final String? description;
  
  /// Instrucciones de ejecución
  final String? instructions;
  
  /// URL de imagen del ejercicio
  final String? imageUrl;
  
  /// URL de video demostrativo
  final String? videoUrl;
  
  /// Categoría del ejercicio
  final String? category;
  
  /// Equipamiento necesario
  final List<String>? equipment;
  
  /// Nivel de dificultad
  final ExerciseDifficulty difficulty;
  
  /// Si es un ejercicio personalizado del usuario
  final bool isCustom;

  /// Crea una copia del ejercicio con campos actualizados
  Exercise copyWith({
    String? id,
    String? name,
    ExerciseType? type,
    List<MuscleGroup>? muscleGroups,
    String? description,
    String? instructions,
    String? imageUrl,
    String? videoUrl,
    String? category,
    List<String>? equipment,
    ExerciseDifficulty? difficulty,
    bool? isCustom,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      muscleGroups: muscleGroups ?? this.muscleGroups,
      description: description ?? this.description,
      instructions: instructions ?? this.instructions,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      category: category ?? this.category,
      equipment: equipment ?? this.equipment,
      difficulty: difficulty ?? this.difficulty,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        muscleGroups,
        description,
        instructions,
        imageUrl,
        videoUrl,
        category,
        equipment,
        difficulty,
        isCustom,
      ];
}