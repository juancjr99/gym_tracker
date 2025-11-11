/// Extensiones para la clase String
extension StringExtensions on String {
  /// Capitaliza la primera letra de la cadena
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Capitaliza la primera letra de cada palabra
  String capitalizeWords() {
    if (isEmpty) return this;
    return split(' ')
        .map((word) => word.capitalize())
        .join(' ');
  }

  /// Verifica si la cadena es un número válido
  bool get isNumeric {
    return double.tryParse(this) != null;
  }

  /// Verifica si la cadena es un entero válido
  bool get isInteger {
    return int.tryParse(this) != null;
  }

  /// Remueve todos los espacios en blanco
  String removeAllWhitespace() {
    return replaceAll(RegExp(r'\s+'), '');
  }

  /// Trunca la cadena a una longitud específica añadiendo '...'
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - suffix.length)}$suffix';
  }

  /// Convierte a double de forma segura
  double? toDoubleOrNull() {
    return double.tryParse(this);
  }

  /// Convierte a int de forma segura
  int? toIntOrNull() {
    return int.tryParse(this);
  }
}