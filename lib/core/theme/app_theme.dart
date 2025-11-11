import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/app_text_styles.dart';

/// Configuración del tema de la aplicación usando Material Design 3
class AppTheme {
  AppTheme._();

  // Color semilla para Material - usando acento rojo vino
  static const Color _seedColor = Color(0xFF9D2933); // Rojo oscuro vivo para botones

  // Tema claro (placeholder - TODO: implementar completamente)
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
    );
  }

  // Tema oscuro - Acento azul acero para botones, dorado para elementos premium
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
    ).copyWith(
      // Sobrescribir primary con el azul acero para ElevatedButton
      primary: AppColors.darkAccent,
      onPrimary: AppColors.darkOnAccent,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.darkBackground,
      
      // Tipografía personalizada
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge(AppColors.darkOnBackground),
        displayMedium: AppTextStyles.displayMedium(AppColors.darkOnBackground),
        displaySmall: AppTextStyles.displaySmall(AppColors.darkOnBackground),
        headlineLarge: AppTextStyles.headlineLarge(AppColors.darkOnBackground),
        headlineMedium: AppTextStyles.headlineMedium(AppColors.darkOnBackground),
        headlineSmall: AppTextStyles.headlineSmall(AppColors.darkOnBackground),
        titleLarge: AppTextStyles.titleLarge(AppColors.darkOnSurface),
        titleMedium: AppTextStyles.titleMedium(AppColors.darkOnSurface),
        titleSmall: AppTextStyles.titleSmall(AppColors.darkOnSurface),
        bodyLarge: AppTextStyles.bodyLarge(AppColors.darkOnSurface),
        bodyMedium: AppTextStyles.bodyMedium(AppColors.darkOnSurface),
        bodySmall: AppTextStyles.bodySmall(AppColors.darkOnSurfaceVariant),
        labelLarge: AppTextStyles.labelLarge(AppColors.darkOnSurface),
        labelMedium: AppTextStyles.labelMedium(AppColors.darkOnSurfaceVariant),
        labelSmall: AppTextStyles.labelSmall(AppColors.darkOnSurfaceVariant),
      ),
      
      // AppBar transparente
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.darkOnBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.headlineSmall(AppColors.darkOnBackground),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      
      // Cards con borde sutil
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: AppColors.darkBorder.withOpacity(0.3),
            width: 1,
          ),
        ),
        color: AppColors.darkSurface,
      ),
      
      // ElevatedButton con el acento azul acero
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkAccent,
          foregroundColor: AppColors.darkOnAccent,
          elevation: 2,
          shadowColor: AppColors.darkAccent.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      
      // Input fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.darkBorder.withOpacity(0.3),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.darkAccent,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 2,
          ),
        ),
        labelStyle: AppTextStyles.bodyMedium(AppColors.darkOnSurfaceVariant),
        hintStyle: AppTextStyles.bodyMedium(AppColors.darkOnSurfaceVariant.withOpacity(0.5)),
      ),
    );
  }
}