import 'package:gym_tracker/domain/entities/entities.dart';
import 'package:gym_tracker/domain/repositories/repositories.dart';

/// Caso de uso para obtener todas las rutinas activas
class GetAllRoutines {
  const GetAllRoutines(this._repository);

  final RoutineRepository _repository;

  Future<List<Routine>> call() async {
    return _repository.getAllRoutines();
  }
}

/// Caso de uso para obtener rutinas por tipo
class GetRoutinesByType {
  const GetRoutinesByType(this._repository);

  final RoutineRepository _repository;

  Future<List<Routine>> call(RoutineType type) async {
    return _repository.getRoutinesByType(type);
  }
}

/// Caso de uso para obtener una rutina por ID
class GetRoutineById {
  const GetRoutineById(this._repository);

  final RoutineRepository _repository;

  Future<Routine?> call(String id) async {
    return _repository.getRoutineById(id);
  }
}

/// Caso de uso para buscar rutinas por nombre
class SearchRoutines {
  const SearchRoutines(this._repository);

  final RoutineRepository _repository;

  Future<List<Routine>> call(String query) async {
    if (query.trim().isEmpty) {
      return _repository.getAllRoutines();
    }
    return _repository.searchRoutines(query);
  }
}

/// Caso de uso para crear una nueva rutina
class CreateRoutine {
  const CreateRoutine(this._repository);

  final RoutineRepository _repository;

  Future<Routine> call(Routine routine) async {
    // Validar que tenga al menos un ejercicio
    if (routine.exercises.isEmpty) {
      throw Exception('La rutina debe tener al menos un ejercicio');
    }

    // Validar nombre no vacío
    if (routine.name.trim().isEmpty) {
      throw Exception('La rutina debe tener un nombre');
    }

    return _repository.createRoutine(routine);
  }
}

/// Caso de uso para actualizar una rutina existente
class UpdateRoutine {
  const UpdateRoutine(this._repository);

  final RoutineRepository _repository;

  Future<Routine> call(Routine routine) async {
    // Validar que exista la rutina
    final existing = await _repository.getRoutineById(routine.id);
    if (existing == null) {
      throw Exception('Rutina no encontrada: ${routine.id}');
    }

    return _repository.updateRoutine(routine);
  }
}

/// Caso de uso para eliminar una rutina
class DeleteRoutine {
  const DeleteRoutine(this._repository);

  final RoutineRepository _repository;

  Future<void> call(String id) async {
    return _repository.deleteRoutine(id);
  }
}

/// Caso de uso para duplicar una rutina existente
class DuplicateRoutine {
  const DuplicateRoutine(this._repository);

  final RoutineRepository _repository;

  Future<Routine> call(String routineId, String newName) async {
    // Validar que el nuevo nombre no esté vacío
    if (newName.trim().isEmpty) {
      throw Exception('El nuevo nombre no puede estar vacío');
    }

    return _repository.duplicateRoutine(routineId, newName);
  }
}

/// Caso de uso para obtener rutinas plantilla
class GetTemplateRoutines {
  const GetTemplateRoutines(this._repository);

  final RoutineRepository _repository;

  Future<List<Routine>> call() async {
    return _repository.getTemplateRoutines();
  }
}

/// Caso de uso para obtener rutinas archivadas
class GetArchivedRoutines {
  const GetArchivedRoutines(this._repository);

  final RoutineRepository _repository;

  Future<List<Routine>> call() async {
    return _repository.getArchivedRoutines();
  }
}

/// Caso de uso para archivar/desarchivar una rutina
class ToggleArchiveRoutine {
  const ToggleArchiveRoutine(this._repository);

  final RoutineRepository _repository;

  Future<void> call(String routineId) async {
    return _repository.toggleArchiveRoutine(routineId);
  }
}

/// Caso de uso para obtener rutinas por etiquetas
class GetRoutinesByTags {
  const GetRoutinesByTags(this._repository);

  final RoutineRepository _repository;

  Future<List<Routine>> call(List<String> tags) async {
    if (tags.isEmpty) {
      return _repository.getAllRoutines();
    }
    return _repository.getRoutinesByTags(tags);
  }
}

/// Caso de uso para reordenar ejercicios en una rutina
class ReorderRoutineExercises {
  const ReorderRoutineExercises(this._repository);

  final RoutineRepository _repository;

  Future<Routine> call(String routineId, List<String> exerciseIds) async {
    return _repository.reorderExercises(routineId, exerciseIds);
  }
}
