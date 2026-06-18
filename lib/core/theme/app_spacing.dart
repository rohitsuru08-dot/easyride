/// Premium Spacing System - Consistent rhythm
import 'package:flutter/material.dart';

class AppSpacing {
  // ============ BASE SPACING SCALE ============
  // 2px scale (xs, s, m, l, xl, xxl)
  static const double xs2 = 2.0;
  static const double xs4 = 4.0;
  static const double xs6 = 6.0;
  static const double xs8 = 8.0;

  static const double sm12 = 12.0;
  static const double sm14 = 14.0;
  static const double sm16 = 16.0;

  static const double md20 = 20.0;
  static const double md24 = 24.0;

  static const double lg28 = 28.0;
  static const double lg32 = 32.0;

  static const double xl40 = 40.0;
  static const double xl48 = 48.0;

  static const double xxl56 = 56.0;
  static const double xxl64 = 64.0;

  // ============ SEMANTIC SPACING ============
  // These names describe the use case
  static const double micro = xs2;
  static const double extraSmall = xs4;
  static const double small = xs8;
  static const double smallMedium = xs6;
  static const double medium = sm16;
  static const double mediumLarge = md20;
  static const double large = md24;
  static const double largeExtra = lg28;
  static const double extraLarge = lg32;
  static const double xxLarge = xl40;
  static const double xxxLarge = xl48;

  // ============ COMPONENT SPACING ============
  // Padding & Margin for specific components
  static const double paddingXS = xs4;
  static const double paddingS = xs8;
  static const double paddingM = sm16;
  static const double paddingL = md24;
  static const double paddingXL = lg32;

  static const double marginXS = xs4;
  static const double marginS = xs8;
  static const double marginM = sm16;
  static const double marginL = md24;
  static const double marginXL = lg32;

  // ============ SPECIFIC USE CASES ============
  // Button padding
  static const double buttonPaddingHorizontal = sm16;
  static const double buttonPaddingVertical = sm12;

  // Card padding
  static const double cardPadding = md24;
  static const double cardPaddingSmall = sm16;
  static const double cardPaddingLarge = lg32;

  // Field padding
  static const double fieldPadding = sm16;
  static const double fieldPaddingVertical = sm12;

  // List item padding
  static const double listItemPadding = md20;
  static const double listItemPaddingVertical = sm16;

  // Bottom sheet padding
  static const double bottomSheetPadding = md24;
  static const double bottomSheetPaddingTop = lg32;

  // Dialog padding
  static const double dialogPadding = md24;

  // AppBar padding
  static const double appBarPadding = sm16;
  static const double appBarPaddingHorizontal = sm16;
  static const double appBarPaddingVertical = xs8;

  // Gap between elements
  static const double gapXS = xs4;
  static const double gapS = xs8;
  static const double gapM = sm16;
  static const double gapL = md24;
  static const double gapXL = lg32;

  // ============ GRID & LAYOUT ============
  static const double gridSpacing = md20;
  static const double columnSpacing = md24;
  static const double rowSpacing = md20;

  // ============ SECTION SPACING ============
  static const double sectionPaddingVertical = lg32;
  static const double sectionPaddingHorizontal = sm16;
  static const double sectionGap = md24;

  // ============ UTILITY METHODS ============
  /// Get responsive padding based on screen width
  static EdgeInsets responsivePadding({
    required double screenWidth,
    double mobileHorizontal = paddingM,
    double mobileVertical = paddingM,
    double tabletHorizontal = paddingL,
    double tabletVertical = paddingL,
  }) {
    if (screenWidth < 600) {
      return EdgeInsets.symmetric(
        horizontal: mobileHorizontal,
        vertical: mobileVertical,
      );
    } else {
      return EdgeInsets.symmetric(
        horizontal: tabletHorizontal,
        vertical: tabletVertical,
      );
    }
  }
}
