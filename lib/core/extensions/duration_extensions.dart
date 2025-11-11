/// Extensiones para la clase Duration
extension DurationExtensions on Duration {
  /// Formatea la duración como "2h 30m" o "45m" o "30s"
  String toFormattedString() {
    final hours = inHours;
    final minutes = inMinutes % 60;
    final seconds = inSeconds % 60;

    if (hours > 0) {
      if (minutes > 0) {
        return '${hours}h ${minutes}m';
      }
      return '${hours}h';
    } else if (minutes > 0) {
      if (seconds > 0) {
        return '${minutes}m ${seconds}s';
      }
      return '${minutes}m';
    } else {
      return '${seconds}s';
    }
  }

  /// Formatea la duración como "02:30:45" (HH:mm:ss)
  String toHoursMinutesSeconds() {
    final hours = inHours;
    final minutes = inMinutes % 60;
    final seconds = inSeconds % 60;

    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  /// Formatea la duración como "30:45" (mm:ss)
  String toMinutesSeconds() {
    final minutes = inMinutes;
    final seconds = inSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }
}