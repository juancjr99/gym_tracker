/// Constantes generales de la aplicación
class AppConstants {
  AppConstants._();

  // Información de la aplicación
  static const String appName = 'Gym Tracker';
  static const String appVersion = '1.0.0';
  
  // Base de datos
  static const String databaseName = 'gym_tracker.db';
  static const int databaseVersion = 1;
  
  // Configuración de UI
  static const double defaultPadding = 16;
  static const double smallPadding = 8;
  static const double largePadding = 24;
  static const double borderRadius = 12;
  
  // Animaciones
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration shortAnimationDuration = Duration(milliseconds: 150);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  
  // Validaciones
  static const int minPasswordLength = 6;
  static const int maxNameLength = 50;
  static const int maxDescriptionLength = 500;
  
  // Configuración de entrenamientos
  static const int maxSetsPerExercise = 10;
  static const int maxRepsPerSet = 999;
  static const double maxWeightKg = 999.9;
  static const int maxRestTimeMinutes = 30;
}