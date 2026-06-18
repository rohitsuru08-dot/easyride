/// Premium Typography System - Inter & Manrope fonts
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  // ============ FONT FAMILIES ============
  static String get displayFont => GoogleFonts.manrope().fontFamily!;
  static String get headingFont => GoogleFonts.manrope().fontFamily!;
  static String get bodyFont => GoogleFonts.inter().fontFamily!;

  // ============ TEXT STYLES - DISPLAY (Large Titles) ============
  static TextStyle get displayLarge => TextStyle(
        fontFamily: displayFont,
        fontSize: 56,
        fontWeight: FontWeight.w800,
        height: 1.2,
        letterSpacing: -1.0,
      );

  static TextStyle get displayMedium => TextStyle(
        fontFamily: displayFont,
        fontSize: 44,
        fontWeight: FontWeight.w800,
        height: 1.25,
        letterSpacing: -0.8,
      );

  static TextStyle get displaySmall => TextStyle(
        fontFamily: displayFont,
        fontSize: 36,
        fontWeight: FontWeight.w700,
        height: 1.3,
        letterSpacing: -0.6,
      );

  // ============ TEXT STYLES - HEADLINE (Sections) ============
  static TextStyle get headlineLarge => TextStyle(
        fontFamily: headingFont,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.35,
        letterSpacing: -0.4,
      );

  static TextStyle get headlineMedium => TextStyle(
        fontFamily: headingFont,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.4,
        letterSpacing: -0.2,
      );

  static TextStyle get headlineSmall => TextStyle(
        fontFamily: headingFont,
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.4,
        letterSpacing: 0,
      );

  // ============ TEXT STYLES - TITLE (Emphasis) ============
  static TextStyle get titleLarge => TextStyle(
        fontFamily: bodyFont,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.45,
        letterSpacing: 0.15,
      );

  static TextStyle get titleMedium => TextStyle(
        fontFamily: bodyFont,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.5,
        letterSpacing: 0.1,
      );

  static TextStyle get titleSmall => TextStyle(
        fontFamily: bodyFont,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.5,
        letterSpacing: 0.1,
      );

  // ============ TEXT STYLES - BODY (Main Content) ============
  static TextStyle get bodyLarge => TextStyle(
        fontFamily: bodyFont,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        letterSpacing: 0.5,
      );

  static TextStyle get bodyMedium => TextStyle(
        fontFamily: bodyFont,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.55,
        letterSpacing: 0.25,
      );

  static TextStyle get bodySmall => TextStyle(
        fontFamily: bodyFont,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.6,
        letterSpacing: 0.4,
      );

  // ============ TEXT STYLES - LABEL (Buttons & Tags) ============
  static TextStyle get labelLarge => TextStyle(
        fontFamily: bodyFont,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.4,
        letterSpacing: 0.1,
      );

  static TextStyle get labelMedium => TextStyle(
        fontFamily: bodyFont,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.4,
        letterSpacing: 0.5,
      );

  static TextStyle get labelSmall => TextStyle(
        fontFamily: bodyFont,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        height: 1.45,
        letterSpacing: 0.5,
      );

  // ============ TEXT STYLES - CAPTION (Helper Text) ============
  static TextStyle get captionLarge => TextStyle(
        fontFamily: bodyFont,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.5,
        letterSpacing: 0.3,
      );

  static TextStyle get captionMedium => TextStyle(
        fontFamily: bodyFont,
        fontSize: 11,
        fontWeight: FontWeight.w400,
        height: 1.55,
        letterSpacing: 0.3,
      );

  static TextStyle get captionSmall => TextStyle(
        fontFamily: bodyFont,
        fontSize: 10,
        fontWeight: FontWeight.w400,
        height: 1.6,
        letterSpacing: 0.2,
      );

  // ============ TEXT STYLES - SPECIAL ============
  // For button text
  static TextStyle get buttonText => TextStyle(
        fontFamily: bodyFont,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.25,
        letterSpacing: 0.5,
      );

  // For input fields
  static TextStyle get inputText => TextStyle(
        fontFamily: bodyFont,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        letterSpacing: 0.15,
      );

  static TextStyle get inputHint => TextStyle(
        fontFamily: bodyFont,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        letterSpacing: 0.15,
      );

  // For labels
  static TextStyle get fieldLabel => TextStyle(
        fontFamily: bodyFont,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.4,
        letterSpacing: 0.5,
      );

  // ============ TEXT STYLE VARIANTS ============
  /// Apply color to any text style
  static TextStyle applyColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  /// Apply weight to any text style
  static TextStyle applyWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  /// Apply size to any text style
  static TextStyle applySize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }

  /// Create custom text style
  static TextStyle custom({
    required double fontSize,
    required FontWeight fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
    bool isDisplay = false,
  }) {
    return TextStyle(
      fontFamily: isDisplay ? displayFont : bodyFont,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height ?? 1.5,
      letterSpacing: letterSpacing ?? 0,
      color: color,
      decoration: decoration,
    );
  }
}
