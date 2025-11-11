import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'theme_state.dart';

/// Cubit para gestionar el tema de la aplicación (dark/light)
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(ThemeMode.dark));

  /// Cambia entre dark y light mode
  void toggleTheme() {
    final newMode =
        state.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    emit(ThemeState(newMode));
  }

  /// Establece el tema específico
  void setTheme(ThemeMode mode) {
    emit(ThemeState(mode));
  }

  /// Usa el tema del sistema
  void useSystemTheme() {
    emit(const ThemeState(ThemeMode.system));
  }
}
