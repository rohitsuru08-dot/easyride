/// Premium Color System - Liquid Glass, Fintech Aesthetic
import 'package:flutter/material.dart';

class AppColors {
  // ============ PRIMARY PALETTE ============
  // Liquid Cyan - Main accent
  static const Color liquidCyan = Color(0xFF00E5FF);
  static const Color liquidCyanLight = Color(0xFF4DFFFF);
  static const Color liquidCyanDark = Color(0xFF00B8CC);

  // Premium Blue - Card background accent
  static const Color premiumBlue = Color(0xFF4CC9F0);

  // Midnight - Dark background
  static const Color midnight = Color(0xFF0F0F1E);
  static const Color midnightLight = Color(0xFF1A1A2E);
  static const Color midnightDark = Color(0xFF0A0A14);

  // Electric Purple - Secondary accent
  static const Color electricPurple = Color(0xFF7C3AED);
  static const Color electricPurpleLight = Color(0xFF9D5FFF);
  static const Color electricPurpleDark = Color(0xFF5B21B6);

  // ============ SEMANTIC COLORS ============
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xA310B981);
  static const Color successDark = Color(0xFF059669);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFA3F59E0B);
  static const Color warningDark = Color(0xFFD97706);

  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFFECEC);
  static const Color errorDark = Color(0xFDC2405);

  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDCEAFF);
  static const Color infoDark = Color(0xFF1D4ED8);

  // ============ NEUTRAL PALETTE (11-step) ============
  // Backgrounds
  static const Color bgPrimary = Color(0xFF0F0F1E); // Darkest
  static const Color bgSecondary = Color(0xFF1A1A2E);
  static const Color bgTertiary = Color(0xFF25253D);
  static const Color bgElevated = Color(0xFF2D2D42);
  static const Color bgSurface = Color(0xFF36364D);

  // Text & Foreground
  static const Color textPrimary = Color(0xFFFAFAFA); // Lightest
  static const Color textSecondary = Color(0xFFD4D4D8);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textQuaternary = Color(0xFF6B7280);
  static const Color textDisabled = Color(0xFF4B5563);

  static const Color textInverse = Color(0xFF0F0F1E); // For light backgrounds

  // ============ GLASS COLORS ============
  static const Color glassLight = Color(0x1AFFFFFF); // 10% white
  static const Color glassDark = Color(0x1A000000);  // 10% black
  static const Color glassAccent = Color(0x2600E5FF); // 15% cyan

  // ============ BORDERS & DIVIDERS ============
  static const Color borderLight = Color(0xFF404054);
  static const Color borderMedium = Color(0xFF2D2D42);
  static const Color borderDark = Color(0xFF1A1A2E);

  // ============ OVERLAY ============
  static const Color overlayLight = Color(0x1AFFFFFF);
  static const Color overlayDark = Color(0x4D000000);

  // ============ SHADOW COLORS ============
  static const Color shadowPrimary = Color(0x1F000000);
  static const Color shadowSecondary = Color(0x0F000000);

  // ============ GRADIENT COLORS ============
  static const Color gradientCyanStart = Color(0xFF00E5FF);
  static const Color gradientCyanEnd = Color(0xFF00B8CC);
  static const Color gradientPurpleStart = Color(0xFF7C3AED);
  static const Color gradientPurpleEnd = Color(0xFF5B21B6);

  // ============ UTILITY METHODS ============

  /// Get color with opacity
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }

  /// Get contrasting text color for background
  static Color getContrastingText(Color bgColor) {
    final luminance = bgColor.computeLuminance();
    return luminance > 0.5 ? textInverse : textPrimary;
  }

  /// Get glass color variant
  static Color getGlassColor({
    required bool isDark,
    double opacity = 0.1,
  }) {
    return isDark
        ? glassDark.withValues(alpha: opacity)
        : glassLight.withValues(alpha: opacity);
  }

  /// Status color mapping
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'available':
      case 'success':
        return success;
      case 'pending':
      case 'warning':
        return warning;
      case 'error':
      case 'failed':
      case 'cancelled':
        return error;
      case 'info':
        return info;
      default:
        return textTertiary;
    }
  }
}
