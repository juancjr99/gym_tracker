part of 'theme_cubit.dart';

/// Estado del tema de la aplicación
class ThemeState extends Equatable {
  const ThemeState(this.themeMode);

  final ThemeMode themeMode;

  bool get isDark => themeMode == ThemeMode.dark;
  bool get isLight => themeMode == ThemeMode.light;
  bool get isSystem => themeMode == ThemeMode.system;

  @override
  List<Object> get props => [themeMode];
}
