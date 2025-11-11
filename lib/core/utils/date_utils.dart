import 'package:intl/intl.dart';

/// Utilidades para formatear fechas
class DateUtils {
  DateUtils._();

  /// Formato de fecha completa: "15 de noviembre de 2025"
  static final DateFormat _fullDateFormat = DateFormat('d \'de\' MMMM \'de\' y', 'es');
  
  /// Formato de fecha corta: "15/11/2025"
  static final DateFormat _shortDateFormat = DateFormat('dd/MM/y');
  
  /// Formato de hora: "14:30"
  static final DateFormat _timeFormat = DateFormat('HH:mm');
  
  /// Formato de fecha y hora: "15/11/2025 14:30"
  static final DateFormat _dateTimeFormat = DateFormat('dd/MM/y HH:mm');

  /// Formatea fecha completa
  static String formatFullDate(DateTime date) {
    return _fullDateFormat.format(date);
  }

  /// Formatea fecha corta
  static String formatShortDate(DateTime date) {
    return _shortDateFormat.format(date);
  }

  /// Formatea solo la hora
  static String formatTime(DateTime dateTime) {
    return _timeFormat.format(dateTime);
  }

  /// Formatea fecha y hora
  static String formatDateTime(DateTime dateTime) {
    return _dateTimeFormat.format(dateTime);
  }

  /// Obtiene fecha relativa (hoy, ayer, etc.)
  static String getRelativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final tomorrow = today.add(const Duration(days: 1));
    final dateToCheck = DateTime(date.year, date.month, date.day);

    if (dateToCheck == today) {
      return 'Hoy';
    } else if (dateToCheck == yesterday) {
      return 'Ayer';
    } else if (dateToCheck == tomorrow) {
      return 'Mañana';
    } else {
      return formatShortDate(date);
    }
  }

  /// Calcula la diferencia en días entre dos fechas
  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  /// Verifica si es la misma fecha (ignorando hora)
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Obtiene el inicio del día
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Obtiene el final del día
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }
}