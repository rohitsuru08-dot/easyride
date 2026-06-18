// App-wide constants for EasyRide - Modern Premium Design System
import 'package:flutter/material.dart';

// App Information
class AppConstants {
  // ============ COMPATIBILITY CONSTANTS ============

// Aliases used by generated UI code
static const Color secondaryGreen = primaryGreen;

static const Color errorRed = errorColor;

static const Color backgroundLight = backgroundColor;

static const Color surfaceLight = surfaceColor;

// Missing radius used in home_screen.dart
static const double borderRadius2 = 2.0;

// Additional aliases that future generated widgets may expect
static const Color successGreen = successColor;
static const Color warningAmber = warningColor;
static const Color dangerRed = errorColor;
  static const String appName = 'EasyRide';
  static const String appTagline = 'Smart. Inclusive. Reliable.';
  static const String apsrtcName = 'APSRTC';
  
  // ============ MODERN PREMIUM COLOR PALETTE ============
  // Primary Colors
  static const Color primaryBlue = Color(0xFF0066FF); // Vibrant Blue
  static const Color primaryBlueLight = Color(0xFF4D94FF); // Light Blue
  static const Color primaryBlueDark = Color(0xFF0052CC); // Dark Blue
  
  // Secondary Accent Colors
  static const Color primaryGreen = Color(0xFF00D084); // Vibrant Green
  static const Color accentPurple = Color(0xFF7C3AED); // Purple
  static const Color accentOrange = Color(0xFFFF6B35); // Vibrant Orange
  static const Color accentPink = Color(0xFFFF006E); // Pink
  
  // Neutral Colors
  static const Color backgroundColor = Color(0xFFF7F9FC); // Very Light Blue-Gray
  static const Color cardBackground = Colors.white;
  static const Color surfaceColor = Color(0xFFFAFBFC); // Slightly tinted white
  
  // Text Colors
  static const Color textPrimary = Color(0xFF0F1419); // Almost Black
  static const Color textSecondary = Color(0xFF52575C); // Dark Gray
  static const Color textTertiary = Color(0xFF909396); // Medium Gray
  static const Color textInverse = Colors.white;
  
  // Semantic Colors
  static const Color successColor = Color(0xFF10B981); // Green
  static const Color warningColor = Color(0xFFF59E0B); // Amber
  static const Color errorColor = Color(0xFFEF4444); // Red
  static const Color infoColor = Color(0xFF3B82F6); // Info Blue
  
  // Glass Morphism Colors
  static const Color glassDark = Color(0x1A000000); // Dark glass
  static const Color glassLight = Color(0xFFFFFFFF); // Light glass
  
  // Gradient Colors
  static const LinearGradient premiumGradient = LinearGradient(
    colors: [primaryBlue, accentPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient sunsetGradient = LinearGradient(
    colors: [accentOrange, accentPink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient forestGradient = LinearGradient(
    colors: [primaryGreen, primaryBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient neutralGradient = LinearGradient(
    colors: [Color(0xFFE5E7EB), Color(0xFFF3F4F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // ============ SPACING SYSTEM ============
  static const double spacing2 = 2.0; // Micro spacing
  static const double spacing4 = 4.0; // Extra small
  static const double spacing6 = 6.0; // Extra small plus
  static const double spacing8 = 8.0; // Small
  static const double spacing12 = 12.0; // Small plus
  static const double spacing16 = 16.0; // Default/Medium
  static const double spacing20 = 20.0; // Medium plus
  static const double spacing24 = 24.0; // Large
  static const double spacing28 = 28.0;
  static const double spacing32 = 32.0; // Extra large
  static const double spacing40 = 40.0; // XXL
  static const double spacing48 = 48.0; // XXXL
  
  // Legacy spacing names (keeping for compatibility)
  static const double spacingSmall = spacing8;
  static const double spacing = spacing16;
  static const double spacingLarge = spacing24;
  
  // ============ BORDER & RADIUS ============
  static const double borderRadius4 = 4.0;
  static const double borderRadius6 = 6.0;
  static const double borderRadius8 = 8.0;
  static const double borderRadius12 = 12.0;
  static const double borderRadius16 = 16.0;
  static const double borderRadius20 = 20.0;
  static const double borderRadius24 = 24.0;
  static const double borderRadiusMax = 999.0; // Fully rounded
  
  // Legacy border radius (keeping for compatibility)
  static const double borderRadius = borderRadius12;
  
  // ============ ELEVATION & SHADOW ============
  static const double cardElevation = 0.0; // No shadow - modern flat
  static const double buttonElevation = 0.0;
  static const double appBarElevation = 0.0;
  
  // Modern shadows with blur
  static const List<BoxShadow> softShadow = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 8.0,
      offset: Offset(0, 2),
    ),
  ];
  
  static const List<BoxShadow> mediumShadow = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 16.0,
      offset: Offset(0, 4),
    ),
  ];
  
  static const List<BoxShadow> hardShadow = [
    BoxShadow(
      color: Color(0x1F000000),
      blurRadius: 24.0,
      offset: Offset(0, 8),
    ),
  ];
  
  // ============ COMPONENT SIZES ============
  static const double buttonHeight = 48.0;
  static const double buttonHeightSmall = 40.0;
  static const double buttonHeightLarge = 56.0;
  static const double iconSize = 24.0;
  static const double iconSizeSmall = 16.0;
  static const double iconSizeLarge = 32.0;
  static const double qrCodeSize = 200.0;
  
  // ============ MODERN TYPOGRAPHY - GOOGLE FONTS ============
  // Font Family
  static const String fontFamilyPrimary = 'Inter';
  static const String fontFamilyDisplay = 'Poppins';
  
  // Display Heading Styles (Large, Bold)
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.5,
    color: textPrimary,
  );
  
  static const TextStyle displayMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.3,
    letterSpacing: -0.25,
    color: textPrimary,
  );
  
  static const TextStyle displaySmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.4,
    color: textPrimary,
  );
  
  // Heading Styles
  static const TextStyle headingLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.4,
    color: textPrimary,
  );
  
  static const TextStyle headingMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: textPrimary,
  );
  
  static const TextStyle headingSmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
    color: textPrimary,
  );
  
  // Legacy heading style (keeping for compatibility)
  static const TextStyle headingStyle = displaySmall;
  static const TextStyle subheadingStyle = headingMedium;
  
  // Body Text Styles
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: textPrimary,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.6,
    color: textPrimary,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.6,
    color: textSecondary,
  );
  
  // Legacy body style (keeping for compatibility)
  static const TextStyle bodyStyle = bodyMedium;
  
  // Label Styles (for buttons, tags, etc.)
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: 0.5,
    color: textPrimary,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: 0.4,
    color: textPrimary,
  );
  
  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: 0.3,
    color: textSecondary,
  );
  
  // Caption Styles (smallest text)
  static const TextStyle captionLarge = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: textSecondary,
  );
  
  static const TextStyle captionSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: textTertiary,
  );
  
  // Legacy caption style (keeping for compatibility)
  static const TextStyle captionStyle = captionLarge;
  
  // ============ DATE/TIME FORMATS ============
  static const String dateFormat = 'dd MMM yyyy';
  static const String timeFormat = 'hh:mm a';
  static const String dateTimeFormat = 'dd MMM yyyy, hh:mm a';
  
  // ============ VALIDATION ============
  static const int phoneNumberLength = 10;
  static const int otpLength = 6;
  
  // ============ ANIMATION DURATIONS ============
  static const Duration animationFastDuration = Duration(milliseconds: 150);
  static const Duration animationNormalDuration = Duration(milliseconds: 300);
  static const Duration animationSlowDuration = Duration(milliseconds: 500);
  static const Duration animationExtraSlowDuration = Duration(milliseconds: 800);
  
  // ============ LANGUAGES ============
  static const String languageEnglish = 'en';
  static const String languageTelugu = 'te';
}
