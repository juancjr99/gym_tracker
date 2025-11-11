import 'package:gym_tracker/domain/entities/entities.dart';
import 'package:uuid/uuid.dart';

/// Ejercicios básicos predefinidos para inicializar la base de datos
class DefaultExercises {
  DefaultExercises._();

  /// Retorna la lista de ejercicios básicos
  static List<Exercise> getExercises() {
    const uuid = Uuid();
    
    return [
      // PESO - PECHO
      Exercise(
        id: uuid.v4(),
        name: 'Press Banca',
        description: 'Press de pecho con barra en banco plano',
        type: ExerciseType.weight,
        muscleGroups: [MuscleGroup.chest, MuscleGroup.arms],
        equipment: ['Barra', 'Banco'],
      ),
      Exercise(
        id: uuid.v4(),
        name: 'Press Inclinado',
        description: 'Press de pecho con barra en banco inclinado',
        type: ExerciseType.weight,
        muscleGroups: [MuscleGroup.chest, MuscleGroup.shoulders],
        equipment: ['Barra', 'Banco inclinado'],
      ),
      Exercise(
        id: uuid.v4(),
        name: 'Aperturas con Mancuernas',
        description: 'Aperturas de pecho con mancuernas en banco plano',
        type: ExerciseType.weight,
        muscleGroups: [MuscleGroup.chest],
        equipment: ['Mancuernas', 'Banco'],
      ),

      // PESO - ESPALDA
      Exercise(
        id: uuid.v4(),
        name: 'Peso Muerto',
        description: 'Peso muerto convencional con barra',
        type: ExerciseType.weight,
        muscleGroups: [MuscleGroup.back, MuscleGroup.legs, MuscleGroup.glutes],
        equipment: ['Barra'],
      ),
      Exercise(
        id: uuid.v4(),
        name: 'Remo con Barra',
        description: 'Remo horizontal con barra',
        type: ExerciseType.weight,
        muscleGroups: [MuscleGroup.back, MuscleGroup.arms],
        equipment: ['Barra'],
      ),
      Exercise(
        id: uuid.v4(),
        name: 'Remo con Mancuerna',
        description: 'Remo a una mano con mancuerna',
        type: ExerciseType.weight,
        muscleGroups: [MuscleGroup.back, MuscleGroup.arms],
        equipment: ['Mancuerna', 'Banco'],
      ),

      // PESO - PIERNAS
      Exercise(
        id: uuid.v4(),
        name: 'Sentadillas',
        description: 'Sentadilla con barra trasera',
        type: ExerciseType.weight,
        muscleGroups: [MuscleGroup.legs, MuscleGroup.glutes],
        equipment: ['Barra', 'Rack'],
      ),
      Exercise(
        id: uuid.v4(),
        name: 'Sentadilla Frontal',
        description: 'Sentadilla con barra delantera',
        type: ExerciseType.weight,
        muscleGroups: [MuscleGroup.legs, MuscleGroup.core],
        equipment: ['Barra', 'Rack'],
      ),
      Exercise(
        id: uuid.v4(),
        name: 'Zancadas',
        description: 'Zancadas caminando con mancuernas',
        type: ExerciseType.weight,
        muscleGroups: [MuscleGroup.legs, MuscleGroup.glutes],
        equipment: ['Mancuernas'],
      ),
      Exercise(
        id: uuid.v4(),
        name: 'Prensa de Piernas',
        description: 'Press de piernas en máquina',
        type: ExerciseType.weight,
        muscleGroups: [MuscleGroup.legs, MuscleGroup.glutes],
        equipment: ['Máquina de prensa'],
      ),

      // PESO - HOMBROS
      Exercise(
        id: uuid.v4(),
        name: 'Press Militar',
        description: 'Press de hombros con barra de pie',
        type: ExerciseType.weight,
        muscleGroups: [MuscleGroup.shoulders, MuscleGroup.core],
        equipment: ['Barra'],
      ),
      Exercise(
        id: uuid.v4(),
        name: 'Press con Mancuernas',
        description: 'Press de hombros sentado con mancuernas',
        type: ExerciseType.weight,
        muscleGroups: [MuscleGroup.shoulders],
        equipment: ['Mancuernas', 'Banco'],
      ),
      Exercise(
        id: uuid.v4(),
        name: 'Elevaciones Laterales',
        description: 'Elevaciones laterales con mancuernas',
        type: ExerciseType.weight,
        muscleGroups: [MuscleGroup.shoulders],
        equipment: ['Mancuernas'],
      ),

      // PESO - BRAZOS
      Exercise(
        id: uuid.v4(),
        name: 'Curl de Bíceps',
        description: 'Curl de bíceps con barra',
        type: ExerciseType.weight,
        muscleGroups: [MuscleGroup.arms],
        equipment: ['Barra'],
      ),
      Exercise(
        id: uuid.v4(),
        name: 'Press Francés',
        description: 'Extensión de tríceps tumbado con barra',
        type: ExerciseType.weight,
        muscleGroups: [MuscleGroup.arms],
        equipment: ['Barra', 'Banco'],
      ),

      // PESO CORPORAL
      Exercise(
        id: uuid.v4(),
        name: 'Dominadas',
        description: 'Dominadas con agarre pronado',
        type: ExerciseType.bodyweight,
        muscleGroups: [MuscleGroup.back, MuscleGroup.arms],
        equipment: ['Barra de dominadas'],
      ),
      Exercise(
        id: uuid.v4(),
        name: 'Flexiones',
        description: 'Flexiones de pecho tradicionales',
        type: ExerciseType.bodyweight,
        muscleGroups: [MuscleGroup.chest, MuscleGroup.arms, MuscleGroup.core],
        equipment: [],
      ),
      Exercise(
        id: uuid.v4(),
        name: 'Dips',
        description: 'Fondos en paralelas',
        type: ExerciseType.bodyweight,
        muscleGroups: [MuscleGroup.chest, MuscleGroup.arms, MuscleGroup.shoulders],
        equipment: ['Paralelas'],
      ),
      Exercise(
        id: uuid.v4(),
        name: 'Sentadilla Búlgara',
        description: 'Sentadilla búlgara a una pierna',
        type: ExerciseType.bodyweight,
        muscleGroups: [MuscleGroup.legs, MuscleGroup.glutes],
        equipment: ['Banco'],
      ),

      // TIEMPO - CORE
      Exercise(
        id: uuid.v4(),
        name: 'Plank',
        description: 'Plancha abdominal estática',
        type: ExerciseType.time,
        muscleGroups: [MuscleGroup.core],
        equipment: [],
      ),
      Exercise(
        id: uuid.v4(),
        name: 'Plank Lateral',
        description: 'Plancha lateral estática',
        type: ExerciseType.time,
        muscleGroups: [MuscleGroup.core],
        equipment: [],
      ),
      Exercise(
        id: uuid.v4(),
        name: 'Hollow Hold',
        description: 'Posición hueca estática',
        type: ExerciseType.time,
        muscleGroups: [MuscleGroup.core],
        equipment: [],
      ),

      // TIEMPO - CARDIO
      Exercise(
        id: uuid.v4(),
        name: 'Burpees',
        description: 'Burpees con salto',
        type: ExerciseType.time,
        muscleGroups: [MuscleGroup.fullBody, MuscleGroup.cardio],
        equipment: [],
      ),
      Exercise(
        id: uuid.v4(),
        name: 'Mountain Climbers',
        description: 'Escaladores de montaña',
        type: ExerciseType.time,
        muscleGroups: [MuscleGroup.core, MuscleGroup.cardio],
        equipment: [],
      ),
      Exercise(
        id: uuid.v4(),
        name: 'Jumping Jacks',
        description: 'Saltos de tijera',
        type: ExerciseType.time,
        muscleGroups: [MuscleGroup.fullBody, MuscleGroup.cardio],
        equipment: [],
      ),

      // COMBINADO
      Exercise(
        id: uuid.v4(),
        name: 'Thrusters',
        description: 'Sentadilla frontal + press de hombros',
        type: ExerciseType.combined,
        muscleGroups: [MuscleGroup.fullBody],
        equipment: ['Barra'],
      ),
      Exercise(
        id: uuid.v4(),
        name: 'Wall Balls',
        description: 'Sentadilla con lanzamiento de balón medicinal',
        type: ExerciseType.combined,
        muscleGroups: [MuscleGroup.fullBody],
        equipment: ['Balón medicinal'],
      ),
    ];
  }
}
