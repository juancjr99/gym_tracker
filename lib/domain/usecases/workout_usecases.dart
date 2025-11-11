import 'package:gym_tracker/domain/entities/entities.dart';
import 'package:gym_tracker/domain/repositories/repositories.dart';
import 'package:injectable/injectable.dart';

/// Caso de uso para obtener todos los entrenamientos
@injectable
class GetAllWorkouts {
  const GetAllWorkouts(this._repository);

  final WorkoutRepository _repository;

  Future<List<WorkoutRecord>> call() async {
    return _repository.getAllWorkouts();
  }
}

/// Caso de uso para obtener entrenamientos por rango de fechas
@injectable
class GetWorkoutsByDateRange {
  const GetWorkoutsByDateRange(this._repository);

  final WorkoutRepository _repository;

  Future<List<WorkoutRecord>> call(DateTime startDate, DateTime endDate) async {
    return _repository.getWorkoutsByDateRange(startDate, endDate);
  }
}

/// Caso de uso para obtener un entrenamiento por ID
@injectable
class GetWorkoutById {
  const GetWorkoutById(this._repository);

  final WorkoutRepository _repository;

  Future<WorkoutRecord?> call(String id) async {
    return _repository.getWorkoutById(id);
  }
}

/// Caso de uso para obtener entrenamientos de una rutina específica
@injectable
class GetWorkoutsByRoutine {
  const GetWorkoutsByRoutine(this._repository);

  final WorkoutRepository _repository;

  Future<List<WorkoutRecord>> call(String routineId) async {
    return _repository.getWorkoutsByRoutine(routineId);
  }
}

/// Caso de uso para obtener el último entrenamiento realizado
@injectable
class GetLastWorkout {
  const GetLastWorkout(this._repository);

  final WorkoutRepository _repository;

  Future<WorkoutRecord?> call() async {
    return _repository.getLastWorkout();
  }
}

/// Caso de uso para obtener entrenamientos en progreso
@injectable
class GetActiveWorkouts {
  const GetActiveWorkouts(this._repository);

  final WorkoutRepository _repository;

  Future<List<WorkoutRecord>> call() async {
    return _repository.getActiveWorkouts();
  }
}

/// Caso de uso para iniciar un nuevo entrenamiento
@injectable
class StartWorkout {
  const StartWorkout(this._repository);

  final WorkoutRepository _repository;

  Future<WorkoutRecord> call(String routineId) async {
    // Validar que no haya entrenamientos activos
    final activeWorkouts = await _repository.getActiveWorkouts();
    if (activeWorkouts.isNotEmpty) {
      throw Exception(
        'Ya existe un entrenamiento en progreso. '
        'Complétalo o cancélalo antes de iniciar uno nuevo.',
      );
    }

    return _repository.startWorkout(routineId);
  }
}

/// Caso de uso para completar un entrenamiento
@injectable
class CompleteWorkout {
  const CompleteWorkout(this._repository);

  final WorkoutRepository _repository;

  Future<WorkoutRecord> call(String workoutId) async {
    final workout = await _repository.getWorkoutById(workoutId);
    if (workout == null) {
      throw Exception('Entrenamiento no encontrado: $workoutId');
    }

    if (workout.status != WorkoutStatus.inProgress) {
      throw Exception(
        'Solo se pueden completar entrenamientos en progreso',
      );
    }

    return _repository.completeWorkout(workoutId);
  }
}

/// Caso de uso para cancelar un entrenamiento
@injectable
class CancelWorkout {
  const CancelWorkout(this._repository);

  final WorkoutRepository _repository;

  Future<WorkoutRecord> call(String workoutId) async {
    final workout = await _repository.getWorkoutById(workoutId);
    if (workout == null) {
      throw Exception('Entrenamiento no encontrado: $workoutId');
    }

    if (workout.status != WorkoutStatus.inProgress) {
      throw Exception(
        'Solo se pueden cancelar entrenamientos en progreso',
      );
    }

    return _repository.cancelWorkout(workoutId);
  }
}

/// Caso de uso para actualizar un registro de ejercicio en un entrenamiento
@injectable
class UpdateExerciseRecord {
  const UpdateExerciseRecord(this._repository);

  final WorkoutRepository _repository;

  Future<WorkoutRecord> call(
    String workoutId,
    ExerciseRecord exerciseRecord,
  ) async {
    return _repository.updateExerciseRecord(workoutId, exerciseRecord);
  }
}

/// Caso de uso para guardar/actualizar un entrenamiento completo
@injectable
class SaveWorkout {
  const SaveWorkout(this._repository);

  final WorkoutRepository _repository;

  Future<WorkoutRecord> call(WorkoutRecord workout) async {
    // Verificar si es creación o actualización
    final existing = await _repository.getWorkoutById(workout.id);
    
    if (existing == null) {
      return _repository.createWorkout(workout);
    } else {
      return _repository.updateWorkout(workout);
    }
  }
}

/// Caso de uso para eliminar un entrenamiento
@injectable
class DeleteWorkout {
  const DeleteWorkout(this._repository);

  final WorkoutRepository _repository;

  Future<void> call(String id) async {
    return _repository.deleteWorkout(id);
  }
}

/// Caso de uso para obtener estadísticas de un ejercicio
@injectable
class GetExerciseStats {
  const GetExerciseStats(this._repository);

  final WorkoutRepository _repository;

  Future<Map<String, dynamic>> call(String exerciseId) async {
    return _repository.getExerciseStats(exerciseId);
  }
}

/// Caso de uso para obtener el progreso de un ejercicio
@injectable
class GetExerciseProgress {
  const GetExerciseProgress(this._repository);

  final WorkoutRepository _repository;

  Future<List<Map<String, dynamic>>> call(String exerciseId) async {
    return _repository.getExerciseProgress(exerciseId);
  }
}

/// Caso de uso para obtener récords personales del usuario
@injectable
class GetPersonalRecords {
  const GetPersonalRecords(this._repository);

  final WorkoutRepository _repository;

  Future<Map<String, dynamic>> call() async {
    return _repository.getPersonalRecords();
  }
}
