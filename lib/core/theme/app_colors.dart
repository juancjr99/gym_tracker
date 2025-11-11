import 'package:flutter/material.dart';

/// App color palette - organized for easy theming
class AppColors {
  AppColors._();

  // ==================== DARK THEME ====================
  
  /// Dark theme - Background colors
  static const darkBackground = Color(0xFF0A0A0A); // Negro profundo
  static const darkSurface = Color(0xFF1C1C1E); // Tarjetas
  static const darkSurfaceVariant = Color(0xFF2C2C2E); // Hover/pressed states
  
  /// Dark theme - Gold colors (para detalles especiales)
  static const darkPrimary = Color(0xFFC5A572); // Dorado arena brillante (sutil)
  static const darkPrimaryVariant = Color(0xFF8B7355); // Dorado apagado
  static const darkOnPrimary = Color(0xFF0A0A0A); // Text on gold
  
  /// Dark theme - Accent color (para botones de acción normales)
  static const darkAccent = Color(0xFF9D2933); // Rojo oscuro vivo
  static const darkAccentVariant = Color(0xFF6B1F25); // Rojo más oscuro
  static const darkOnAccent = Color(0xFFECEFF1); // Text on accent
  
  /// Dark theme - Text colors
  static const darkOnBackground = Color(0xFFECEFF1); // Texto principal
  static const darkOnSurface = Color(0xFFB0B3B8); // Texto secundario
  static const darkOnSurfaceVariant = Color(0xFF8E918F); // Texto terciario
  
  /// Dark theme - Semantic colors
  static const darkError = Color(0xFFD72638); // Rojo error (más vivo)
  static const darkSuccess = Color(0xFF00A86B); // Verde jade (success)
  static const darkWarning = Color(0xFFFFA726); // Naranja (warning)
  static const darkInfo = Color(0xFF2978A0); // Azul acero (info)
  
  /// Dark theme - Border/Divider
  static const darkBorder = Color(0xFF2C2C2E);
  static const darkDivider = Color(0xFF1C1C1E);
  
  // ==================== LIGHT THEME (PLACEHOLDER) ====================
  // TODO: Implementar light theme después
  
  /// Light theme - Background colors
  static const lightBackground = Color(0xFFF5F5F5);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightSurfaceVariant = Color(0xFFF0F0F0);
  
  /// Light theme - Primary colors
  static const lightPrimary = Color(0xFF8B7355);
  static const lightPrimaryVariant = Color(0xFFC0A060);
  static const lightOnPrimary = Color(0xFFFFFFFF);
  
  /// Light theme - Text colors
  static const lightOnBackground = Color(0xFF1A1A1A);
  static const lightOnSurface = Color(0xFF333333);
  static const lightOnSurfaceVariant = Color(0xFF666666);
  
  /// Light theme - Semantic colors
  static const lightError = Color(0xFFD72638);
  static const lightSuccess = Color(0xFF00A86B);
  static const lightWarning = Color(0xFFFFA726);
  static const lightInfo = Color(0xFF2978A0);
  
  /// Light theme - Border/Divider
  static const lightBorder = Color(0xFFE0E0E0);
  static const lightDivider = Color(0xFFF0F0F0);
  
  // ==================== GRADIENTS ====================
  
  /// Gold gradient for special highlights (achievements, PRs)
  static const goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFC5A572), // Dorado arena brillante
      Color(0xFF8B7355), // Dorado apagado
    ],
  );
  
  /// Red gradient for action buttons
  static const redGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF9D2933), // Rojo vivo
      Color(0xFF6B1F25), // Rojo oscuro
    ],
  );
  
  /// Subtle surface gradient for cards
  static const surfaceGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF2C2C2E),
      Color(0xFF1C1C1E),
    ],
  );
}
