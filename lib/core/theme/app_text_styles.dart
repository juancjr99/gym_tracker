import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App typography system - using Montserrat + Manrope
/// Montserrat: Strong headings
/// Manrope: Readable body text
class AppTextStyles {
  AppTextStyles._();

  // Base text theme using Manrope for body
  static TextTheme get baseTextTheme => GoogleFonts.manropeTextTheme();

  // ==================== HEADINGS (Montserrat) ====================

  /// Display Large - 57pt / ExtraBold
  static TextStyle displayLarge(Color color) => GoogleFonts.montserrat(
        fontSize: 57,
        fontWeight: FontWeight.w800,
        height: 1.12,
        letterSpacing: -0.25,
        color: color,
      );

  /// Display Medium - 45pt / ExtraBold
  static TextStyle displayMedium(Color color) => GoogleFonts.montserrat(
        fontSize: 45,
        fontWeight: FontWeight.w800,
        height: 1.16,
        color: color,
      );

  /// Display Small - 36pt / Bold
  static TextStyle displaySmall(Color color) => GoogleFonts.montserrat(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        height: 1.22,
        color: color,
      );

  /// Headline Large - 32pt / Bold
  static TextStyle headlineLarge(Color color) => GoogleFonts.montserrat(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.25,
        color: color,
      );

  /// Headline Medium - 28pt / Bold
  static TextStyle headlineMedium(Color color) => GoogleFonts.montserrat(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.29,
        color: color,
      );

  /// Headline Small - 24pt / SemiBold
  static TextStyle headlineSmall(Color color) => GoogleFonts.montserrat(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.33,
        color: color,
      );

  // ==================== TITLES (Montserrat) ====================

  /// Title Large - 22pt / SemiBold
  static TextStyle titleLarge(Color color) => GoogleFonts.montserrat(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.27,
        color: color,
      );

  /// Title Medium - 16pt / SemiBold
  static TextStyle titleMedium(Color color) => GoogleFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.5,
        letterSpacing: 0.15,
        color: color,
      );

  /// Title Small - 14pt / Medium
  static TextStyle titleSmall(Color color) => GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.43,
        letterSpacing: 0.1,
        color: color,
      );

  // ==================== BODY TEXT (Manrope) ====================

  /// Body Large - 16pt / Regular
  static TextStyle bodyLarge(Color color) => GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        letterSpacing: 0.5,
        color: color,
      );

  /// Body Medium - 14pt / Regular
  static TextStyle bodyMedium(Color color) => GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.43,
        letterSpacing: 0.25,
        color: color,
      );

  /// Body Small - 12pt / Regular
  static TextStyle bodySmall(Color color) => GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.33,
        letterSpacing: 0.4,
        color: color,
      );

  // ==================== LABELS (Manrope) ====================

  /// Label Large - 14pt / Medium
  static TextStyle labelLarge(Color color) => GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.43,
        letterSpacing: 0.1,
        color: color,
      );

  /// Label Medium - 12pt / Medium
  static TextStyle labelMedium(Color color) => GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.33,
        letterSpacing: 0.5,
        color: color,
      );

  /// Label Small - 11pt / Medium
  static TextStyle labelSmall(Color color) => GoogleFonts.manrope(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 1.45,
        letterSpacing: 0.5,
        color: color,
      );

  // ==================== SPECIAL (Numbers - Tabular) ====================

  /// Stats/Numbers - Tabular figures for aligned numbers
  static TextStyle statsNumber(Color color, {double fontSize = 32}) =>
      GoogleFonts.montserrat(
        fontSize: fontSize,
        fontWeight: FontWeight.w800,
        height: 1.2,
        color: color,
        fontFeatures: const [
          FontFeature.tabularFigures(), // Números alineados
        ],
      );

  /// Button text - 14pt / SemiBold / All caps
  static TextStyle button(Color color) => GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.43,
        letterSpacing: 1.25,
        color: color,
      );
}
