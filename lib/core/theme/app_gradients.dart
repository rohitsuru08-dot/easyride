/// Premium Gradient System - Liquid Glass, Fintech Aesthetics
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppGradients {
  // ============ PRIMARY GRADIENTS ============
  /// Liquid cyan gradient
  static const LinearGradient liquidCyan = LinearGradient(
    colors: [
      Color(0xFF00E5FF),
      Color(0xFF00B8CC),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Electric purple gradient
  static const LinearGradient electricPurple = LinearGradient(
    colors: [
      Color(0xFF7C3AED),
      Color(0xFF5B21B6),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Premium blend - Cyan to Purple
  static const LinearGradient premium = LinearGradient(
    colors: [
      Color(0xFF00E5FF),
      Color(0xFF7C3AED),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ============ BACKGROUND GRADIENTS ============
  /// Deep midnight gradient
  static const LinearGradient deepMidnight = LinearGradient(
    colors: [
      Color(0xFF0F0F1E),
      Color(0xFF1A1A2E),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Midnight to surface
  static const LinearGradient midnightSurface = LinearGradient(
    colors: [
      Color(0xFF0F0F1E),
      Color(0xFF25253D),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Subtle elevation gradient
  static const LinearGradient subtleElevation = LinearGradient(
    colors: [
      Color(0xFF1A1A2E),
      Color(0xFF25253D),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ============ SEMANTIC GRADIENTS ============
  /// Success green gradient
  static const LinearGradient success = LinearGradient(
    colors: [
      Color(0xFF10B981),
      Color(0xFF059669),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Warning amber gradient
  static const LinearGradient warning = LinearGradient(
    colors: [
      Color(0xFFF59E0B),
      Color(0xFFD97706),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Error red gradient
  static const LinearGradient error = LinearGradient(
    colors: [
      Color(0xFFEF4444),
      Color(0xFDC2405),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Info blue gradient
  static const LinearGradient info = LinearGradient(
    colors: [
      Color(0xFF3B82F6),
      Color(0xFF1D4ED8),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ============ ACCENT GRADIENTS ============
  /// Sunset gradient
  static const LinearGradient sunset = LinearGradient(
    colors: [
      Color(0xFFFF6B35),
      Color(0xFFFF006E),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Forest gradient
  static const LinearGradient forest = LinearGradient(
    colors: [
      Color(0xFF00D084),
      Color(0xFF00B8CC),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Twilight gradient
  static const LinearGradient twilight = LinearGradient(
    colors: [
      Color(0xFF6366F1),
      Color(0xFF7C3AED),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ============ RADIAL GRADIENTS ============
  /// Radial cyan glow
  static const RadialGradient radialCyan = RadialGradient(
    colors: [
      Color(0xFF00E5FF),
      Color(0xFF0A0A14),
    ],
    radius: 1.0,
  );

  /// Radial purple glow
  static const RadialGradient radialPurple = RadialGradient(
    colors: [
      Color(0xFF7C3AED),
      Color(0xFF0A0A14),
    ],
    radius: 1.0,
  );

  // ============ SWEEP GRADIENTS ============
  /// Rainbow sweep
  static const SweepGradient rainbow = SweepGradient(
    colors: [
      Color(0xFF00E5FF),
      Color(0xFF7C3AED),
      Color(0xFFFF6B35),
      Color(0xFF10B981),
      Color(0xFF00E5FF),
    ],
  );

  // ============ GLASS GRADIENTS ============
  /// Glass light overlay
  static LinearGradient glassLight = LinearGradient(
    colors: [
      Colors.white.withValues(alpha: 0.15),
      Colors.white.withValues(alpha: 0.05),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Glass dark overlay
  static LinearGradient glassDark = LinearGradient(
    colors: [
      Colors.black.withValues(alpha: 0.15),
      Colors.black.withValues(alpha: 0.05),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ============ BUTTON GRADIENTS ============
  /// Primary button gradient
  static const LinearGradient buttonPrimary = LinearGradient(
    colors: [
      Color(0xFF00E5FF),
      Color(0xFF00B8CC),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Secondary button gradient
  static const LinearGradient buttonSecondary = LinearGradient(
    colors: [
      Color(0xFF7C3AED),
      Color(0xFF5B21B6),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Success button gradient
  static const LinearGradient buttonSuccess = LinearGradient(
    colors: [
      Color(0xFF10B981),
      Color(0xFF059669),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ============ CARD GRADIENTS ============
  /// Premium card gradient
  static const LinearGradient cardPremium = LinearGradient(
    colors: [
      Color(0xFF1A1A2E),
      Color(0xFF25253D),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Elevated card gradient
  static const LinearGradient cardElevated = LinearGradient(
    colors: [
      Color(0xFF25253D),
      Color(0xFF2D2D42),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ============ TEXT GRADIENTS ============
  /// Cyan text gradient
  static const LinearGradient textCyan = LinearGradient(
    colors: [
      Color(0xFF00E5FF),
      Color(0xFF00B8CC),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Purple text gradient
  static const LinearGradient textPurple = LinearGradient(
    colors: [
      Color(0xFF7C3AED),
      Color(0xFF5B21B6),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ============ UTILITY METHODS ============

  /// Get gradient with custom colors
  static LinearGradient custom({
    required List<Color> colors,
    Alignment begin = Alignment.topLeft,
    Alignment end = Alignment.bottomRight,
    List<double>? stops,
    TileMode tileMode = TileMode.clamp,
  }) {
    return LinearGradient(
      colors: colors,
      begin: begin,
      end: end,
      stops: stops,
      tileMode: tileMode,
    );
  }

  /// Get gradient from start to end color
  static LinearGradient between({
    required Color startColor,
    required Color endColor,
    Alignment begin = Alignment.topLeft,
    Alignment end = Alignment.bottomRight,
  }) {
    return LinearGradient(
      colors: [startColor, endColor],
      begin: begin,
      end: end,
    );
  }

  /// Get radial gradient
  static RadialGradient radial({
    required List<Color> colors,
    double radius = 1.0,
    Alignment center = Alignment.center,
  }) {
    return RadialGradient(
      colors: colors,
      radius: radius,
      center: center,
    );
  }

  /// Create shader for text gradient
  static Shader textShader({
    required List<Color> colors,
    Size size = const Size(200, 50),
  }) {
    return LinearGradient(
      colors: colors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
  }
}
