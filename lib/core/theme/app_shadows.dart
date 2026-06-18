/// Premium Shadow & Elevation System
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppShadows {
  // ============ SOFT SHADOWS (Subtle) ============
  static const List<BoxShadow> soft = [
    BoxShadow(
      color: AppColors.shadowSecondary,
      blurRadius: 4.0,
      offset: Offset(0, 1),
      spreadRadius: 0,
    ),
  ];

  // ============ MEDIUM SHADOWS (Balanced) ============
  static const List<BoxShadow> medium = [
    BoxShadow(
      color: AppColors.shadowPrimary,
      blurRadius: 12.0,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  // ============ HARD SHADOWS (Prominent) ============
  static const List<BoxShadow> hard = [
    BoxShadow(
      color: AppColors.shadowPrimary,
      blurRadius: 24.0,
      offset: Offset(0, 8),
      spreadRadius: 2,
    ),
  ];

  // ============ GLOW EFFECTS ============
  static const List<BoxShadow> glowCyan = [
    BoxShadow(
      color: Color(0x4600E5FF),
      blurRadius: 20.0,
      offset: Offset(0, 0),
      spreadRadius: 2,
    ),
  ];

  static const List<BoxShadow> glowPurple = [
    BoxShadow(
      color: Color(0x467C3AED),
      blurRadius: 20.0,
      offset: Offset(0, 0),
      spreadRadius: 2,
    ),
  ];

  static const List<BoxShadow> glowGreen = [
    BoxShadow(
      color: Color(0x4610B981),
      blurRadius: 20.0,
      offset: Offset(0, 0),
      spreadRadius: 2,
    ),
  ];

  // ============ GLASS SHADOWS (For glass morphism) ============
  static const List<BoxShadow> glass = [
    BoxShadow(
      color: AppColors.shadowSecondary,
      blurRadius: 8.0,
      offset: Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> glassElevated = [
    BoxShadow(
      color: AppColors.shadowPrimary,
      blurRadius: 16.0,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  // ============ FLOATING SHADOWS (Elevated effect) ============
  static const List<BoxShadow> floating = [
    BoxShadow(
      color: AppColors.shadowPrimary,
      blurRadius: 20.0,
      offset: Offset(0, 8),
      spreadRadius: 2,
    ),
  ];

  static const List<BoxShadow> floatingElevated = [
    BoxShadow(
      color: AppColors.shadowPrimary,
      blurRadius: 32.0,
      offset: Offset(0, 16),
      spreadRadius: 4,
    ),
  ];

  // ============ DEPTH LAYERS ============
  // Layer 1 - Subtle depth
  static const List<BoxShadow> depth1 = [
    BoxShadow(
      color: Color(0x08000000),
      blurRadius: 2.0,
      offset: Offset(0, 1),
    ),
  ];

  // Layer 2 - Moderate depth
  static const List<BoxShadow> depth2 = [
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 8.0,
      offset: Offset(0, 3),
    ),
  ];

  // Layer 3 - Strong depth
  static const List<BoxShadow> depth3 = [
    BoxShadow(
      color: Color(0x18000000),
      blurRadius: 16.0,
      offset: Offset(0, 6),
    ),
  ];

  // Layer 4 - Maximum depth
  static const List<BoxShadow> depth4 = [
    BoxShadow(
      color: Color(0x24000000),
      blurRadius: 32.0,
      offset: Offset(0, 12),
    ),
  ];

  // ============ CARD SHADOWS ============
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 12.0,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> cardPressed = [
    BoxShadow(
      color: Color(0x08000000),
      blurRadius: 4.0,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> cardHover = [
    BoxShadow(
      color: Color(0x18000000),
      blurRadius: 20.0,
      offset: Offset(0, 8),
    ),
  ];

  // ============ BUTTON SHADOWS ============
  static const List<BoxShadow> button = [
    BoxShadow(
      color: Color(0x12000000),
      blurRadius: 8.0,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> buttonPressed = [
    BoxShadow(
      color: Color(0x08000000),
      blurRadius: 2.0,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> buttonHover = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 12.0,
      offset: Offset(0, 4),
    ),
  ];

  // ============ FAB SHADOWS ============
  static const List<BoxShadow> fab = [
    BoxShadow(
      color: Color(0x26000000),
      blurRadius: 12.0,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> fabPressed = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 8.0,
      offset: Offset(0, 2),
    ),
  ];

  // ============ TEXT SHADOWS (For text over images) ============
  static const List<Shadow> textShadow = [
    Shadow(
      color: Color(0x4D000000),
      offset: Offset(0, 2),
      blurRadius: 4.0,
    ),
  ];

  static const List<Shadow> textShadowStrong = [
    Shadow(
      color: Color(0x66000000),
      offset: Offset(0, 4),
      blurRadius: 8.0,
    ),
  ];

  // ============ UTILITY METHODS ============
  /// Get shadow with custom color
  static List<BoxShadow> customShadow({
    required Color color,
    double blurRadius = 12.0,
    Offset offset = const Offset(0, 4),
    double spreadRadius = 0,
  }) {
    return [
      BoxShadow(
        color: color,
        blurRadius: blurRadius,
        offset: offset,
        spreadRadius: spreadRadius,
      ),
    ];
  }

  /// Get glow effect with custom color
  static List<BoxShadow> glow({
    required Color color,
    double blurRadius = 20.0,
    double spreadRadius = 2,
  }) {
    return [
      BoxShadow(
        color: color.withValues(alpha: 0.4),
        blurRadius: blurRadius,
        offset: const Offset(0, 0),
        spreadRadius: spreadRadius,
      ),
    ];
  }

  /// Combine multiple shadows
  static List<BoxShadow> combine(
    List<BoxShadow> shadow1,
    List<BoxShadow> shadow2,
  ) {
    return [...shadow1, ...shadow2];
  }
}
