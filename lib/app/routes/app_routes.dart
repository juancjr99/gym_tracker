/// Nombres de las rutas de la aplicación
class AppRoutes {
  // Private constructor para evitar instanciación
  AppRoutes._();

  // Ruta raíz / home
  static const String home = '/';
  
  // Rutas de rutinas
  static const String routines = '/routines';
  static const String routineDetail = '/routines/:id';
  static const String createRoutine = '/routines/create';
  static const String editRoutine = '/routines/:id/edit';
  
  // Rutas de entrenamientos
  static const String workouts = '/workouts';
  static const String workoutDetail = '/workouts/:id';
  static const String activeWorkout = '/workout/active';
  static const String startWorkout = '/workout/start/:routineId';
  
  // Rutas de ejercicios
  static const String exercises = '/exercises';
  static const String exerciseDetail = '/exercises/:id';
  static const String createExercise = '/exercises/create';
  
  // Rutas de configuración
  static const String settings = '/settings';
  
  // Rutas de estadísticas
  static const String statistics = '/statistics';
  static const String exerciseStats = '/statistics/exercise/:id';
}
