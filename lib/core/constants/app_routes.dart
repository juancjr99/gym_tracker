/// Rutas de la aplicación
class AppRoutes {
  AppRoutes._();

  // Rutas principales
  static const String home = '/';
  static const String splash = '/splash';
  
  // Rutinas
  static const String routines = '/routines';
  static const String routineDetail = '/routines/:id';
  static const String createRoutine = '/routines/create';
  static const String editRoutine = '/routines/:id/edit';
  
  // Ejercicios
  static const String exercises = '/exercises';
  static const String exerciseDetail = '/exercises/:id';
  static const String createExercise = '/exercises/create';
  static const String editExercise = '/exercises/:id/edit';
  
  // Entrenamientos
  static const String workouts = '/workouts';
  static const String workoutDetail = '/workouts/:id';
  static const String startWorkout = '/workouts/start';
  static const String activeWorkout = '/workouts/active/:id';
  
  // Progreso y estadísticas
  static const String progress = '/progress';
  static const String statistics = '/statistics';
  static const String history = '/history';
  
  // Configuración
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String about = '/about';
  
  // Utilidades para generar rutas con parámetros
  static String routineDetailById(String id) => '/routines/$id';
  static String editRoutineById(String id) => '/routines/$id/edit';
  static String exerciseDetailById(String id) => '/exercises/$id';
  static String editExerciseById(String id) => '/exercises/$id/edit';
  static String workoutDetailById(String id) => '/workouts/$id';
  static String activeWorkoutById(String id) => '/workouts/active/$id';
}