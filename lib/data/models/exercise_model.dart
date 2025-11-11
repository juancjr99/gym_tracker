import 'package:floor/floor.dart';
import 'package:gym_tracker/domain/entities/entities.dart';

/// Modelo de datos para Exercise con anotaciones de Floor
@Entity(tableName: 'exercises')
class ExerciseModel {
  @PrimaryKey()
  final String id;
  
  final String name;
  final String? category;
  final String type; // Serializado como String
  final String? description;
  final String? instructions;
  final String? imageUrl;
  final String? videoUrl;
  final String muscleGroups; // JSON serializado como string
  final String? equipment; // JSON serializado como string
  final String difficulty; // Serializado como String
  final bool isCustom;

  const ExerciseModel({
    required this.id,
    required this.name,
    required this.type,
    required this.muscleGroups,
    required this.difficulty,
    required this.isCustom,
    this.category,
    this.description,
    this.instructions,
    this.imageUrl,
    this.videoUrl,
    this.equipment,
  });

  /// Convierte el modelo a entidad de dominio
  Exercise toEntity() {
    return Exercise(
      id: id,
      name: name,
      type: ExerciseType.values.firstWhere(
        (e) => e.name == type,
        orElse: () => ExerciseType.weight,
      ),
      muscleGroups: _parseMuscleGroups(muscleGroups),
      difficulty: ExerciseDifficulty.values.firstWhere(
        (e) => e.name == difficulty,
        orElse: () => ExerciseDifficulty.intermediate,
      ),
      isCustom: isCustom,
      category: category,
      description: description,
      instructions: instructions,
      imageUrl: imageUrl,
      videoUrl: videoUrl,
      equipment: equipment != null ? _parseEquipment(equipment!) : null,
    );
  }

  /// Crea modelo desde entidad de dominio
  factory ExerciseModel.fromEntity(Exercise exercise) {
    return ExerciseModel(
      id: exercise.id,
      name: exercise.name,
      type: exercise.type.name,
      muscleGroups: _serializeMuscleGroups(exercise.muscleGroups),
      difficulty: exercise.difficulty.name,
      isCustom: exercise.isCustom,
      category: exercise.category,
      description: exercise.description,
      instructions: exercise.instructions,
      imageUrl: exercise.imageUrl,
      videoUrl: exercise.videoUrl,
      equipment: exercise.equipment != null ? _serializeEquipment(exercise.equipment!) : null,
    );
  }

  /// Parsea muscle groups desde String
  static List<MuscleGroup> _parseMuscleGroups(String json) {
    try {
      final List<String> groups = json.split(',');
      return groups.map((g) => 
        MuscleGroup.values.firstWhere(
          (mg) => mg.name == g.trim(),
          orElse: () => MuscleGroup.core, // Fallback
        )
      ).toList();
    } catch (e) {
      return [MuscleGroup.core];
    }
  }

  /// Serializa muscle groups a String
  static String _serializeMuscleGroups(List<MuscleGroup> groups) {
    return groups.map((g) => g.name).join(',');
  }

  /// Parsea equipment desde String
  static List<String> _parseEquipment(String json) {
    try {
      return json.split(',').map((e) => e.trim()).toList();
    } catch (e) {
      return [];
    }
  }

  /// Serializa equipment a String
  static String _serializeEquipment(List<String> equipment) {
    return equipment.join(',');
  }

  /// Crea una copia del modelo con campos actualizados
  ExerciseModel copyWith({
    String? id,
    String? name,
    String? category,
    String? type,
    String? description,
    String? instructions,
    String? imageUrl,
    String? videoUrl,
    String? muscleGroups,
    String? equipment,
    String? difficulty,
    bool? isCustom,
  }) {
    return ExerciseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      type: type ?? this.type,
      muscleGroups: muscleGroups ?? this.muscleGroups,
      difficulty: difficulty ?? this.difficulty,
      isCustom: isCustom ?? this.isCustom,
      description: description ?? this.description,
      instructions: instructions ?? this.instructions,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      equipment: equipment ?? this.equipment,
    );
  }
}