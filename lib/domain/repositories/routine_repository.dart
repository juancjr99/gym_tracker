import '../entities/entities.dart';

/// Repositorio abstracto para la gestión de rutinas
abstract class RoutineRepository {
  /// Obtiene todas las rutinas activas del usuario
  Future<List<Routine>> getAllRoutines();
  
  /// Obtiene rutinas por tipo
  Future<List<Routine>> getRoutinesByType(RoutineType type);
  
  /// Obtiene una rutina por ID
  Future<Routine?> getRoutineById(String id);
  
  /// Busca rutinas por nombre
  Future<List<Routine>> searchRoutines(String query);
  
  /// Crea una nueva rutina
  Future<Routine> createRoutine(Routine routine);
  
  /// Actualiza una rutina existente
  Future<Routine> updateRoutine(Routine routine);
  
  /// Elimina una rutina
  Future<void> deleteRoutine(String id);
  
  /// Duplica una rutina existente
  Future<Routine> duplicateRoutine(String routineId, String newName);
  
  /// Obtiene rutinas plantilla
  Future<List<Routine>> getTemplateRoutines();
  
  /// Obtiene rutinas archivadas
  Future<List<Routine>> getArchivedRoutines();
  
  /// Archiva/desarchivar una rutina
  Future<void> toggleArchiveRoutine(String routineId);
  
  /// Obtiene rutinas por etiquetas
  Future<List<Routine>> getRoutinesByTags(List<String> tags);
  
  /// Obtiene todas las etiquetas disponibles
  Future<List<String>> getAllTags();
  
  /// Reordena ejercicios en una rutina
  Future<Routine> reorderExercises(String routineId, List<String> exerciseIds);
}