/// Utilidades para validación de datos
class ValidationUtils {
  ValidationUtils._();

  /// Valida si un string no está vacío
  static bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  /// Valida si un string tiene una longitud mínima
  static bool hasMinLength(String? value, int minLength) {
    return value != null && value.length >= minLength;
  }

  /// Valida si un string tiene una longitud máxima
  static bool hasMaxLength(String? value, int maxLength) {
    return value != null && value.length <= maxLength;
  }

  /// Valida si un string está en un rango de longitud
  static bool hasLengthBetween(String? value, int minLength, int maxLength) {
    return value != null && 
           value.length >= minLength && 
           value.length <= maxLength;
  }

  /// Valida si un número está en un rango
  static bool isInRange(num? value, num min, num max) {
    return value != null && value >= min && value <= max;
  }

  /// Valida si un número es positivo
  static bool isPositive(num? value) {
    return value != null && value > 0;
  }

  /// Valida si un número es positivo o cero
  static bool isPositiveOrZero(num? value) {
    return value != null && value >= 0;
  }

  /// Valida peso para ejercicios (0 a 999.9 kg)
  static bool isValidWeight(double? weight) {
    return weight != null && weight >= 0 && weight <= 999.9;
  }

  /// Valida repeticiones para ejercicios (1 a 999)
  static bool isValidReps(int? reps) {
    return reps != null && reps >= 1 && reps <= 999;
  }

  /// Valida series para ejercicios (1 a 10)
  static bool isValidSets(int? sets) {
    return sets != null && sets >= 1 && sets <= 10;
  }

  /// Valida tiempo de descanso en segundos (1 segundo a 30 minutos)
  static bool isValidRestTime(int? seconds) {
    return seconds != null && seconds >= 1 && seconds <= 1800; // 30 minutos
  }

  /// Valida duración de ejercicio en segundos (1 segundo a 1 hora)
  static bool isValidExerciseDuration(int? seconds) {
    return seconds != null && seconds >= 1 && seconds <= 3600; // 1 hora
  }

  /// Valida nombre de rutina o ejercicio
  static bool isValidName(String? name) {
    return isNotEmpty(name) && hasMaxLength(name, 50);
  }

  /// Valida descripción
  static bool isValidDescription(String? description) {
    return description == null || 
           description.isEmpty || 
           hasMaxLength(description, 500);
  }
}