/// Premium App Theme Configuration - 2026 Liquid Glass Design System
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_ride/core/theme/app_colors.dart';
import 'package:easy_ride/core/theme/app_typography.dart';
import 'package:easy_ride/core/theme/app_spacing.dart';
import 'package:easy_ride/core/theme/app_shadows.dart';
import 'package:easy_ride/core/theme/app_animations.dart';
import 'package:easy_ride/core/constants/app_constants.dart';

class AppTheme {
  /// Premium Dark Theme - Midnight with Liquid Cyan accents
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // ============ COLOR SCHEME - Dark Theme ============
      colorScheme: ColorScheme.dark(
        primary: AppColors.liquidCyan,
        onPrimary: AppColors.bgPrimary,
        primaryContainer: AppColors.liquidCyan.withValues(alpha: 0.15),
        onPrimaryContainer: AppColors.liquidCyan,
        secondary: AppColors.electricPurple,
        onSecondary: Colors.white,
        secondaryContainer: AppColors.electricPurple.withValues(alpha: 0.15),
        onSecondaryContainer: AppColors.electricPurple,
        tertiary: AppColors.success,
        onTertiary: Colors.white,
        tertiaryContainer: AppColors.success.withValues(alpha: 0.15),
        onTertiaryContainer: AppColors.success,
        error: AppColors.error,
        onError: Colors.white,
        errorContainer: AppColors.error.withValues(alpha: 0.15),
        onErrorContainer: AppColors.error,
        surface: AppColors.bgSecondary,
        onSurface: AppColors.textPrimary,
        surfaceContainerHighest: AppColors.bgElevated,
        outline: AppColors.borderLight,
        outlineVariant: AppColors.borderMedium,
        scrim: Colors.black.withValues(alpha: 0.4),
        inverseSurface: AppColors.textPrimary,
        onInverseSurface: AppColors.bgPrimary,
        inversePrimary: AppColors.liquidCyanDark,
      ),
      
      // ============ SCAFFOLD & BACKGROUND ============
      scaffoldBackgroundColor: AppColors.bgPrimary,
      
      // ============ TYPOGRAPHY SYSTEM ============
      textTheme: TextTheme(
        displayLarge: AppTypography.displayLarge.copyWith(
          color: AppColors.textPrimary,
        ),
        displayMedium: AppTypography.displayMedium.copyWith(
          color: AppColors.textPrimary,
        ),
        displaySmall: AppTypography.displaySmall.copyWith(
          color: AppColors.textPrimary,
        ),
        headlineLarge: AppTypography.headlineLarge.copyWith(
          color: AppColors.textPrimary,
        ),
        headlineMedium: AppTypography.headlineMedium.copyWith(
          color: AppColors.textPrimary,
        ),
        headlineSmall: AppTypography.headlineSmall.copyWith(
          color: AppColors.textPrimary,
        ),
        titleLarge: AppTypography.titleLarge.copyWith(
          color: AppColors.textPrimary,
        ),
        titleMedium: AppTypography.titleMedium.copyWith(
          color: AppColors.textPrimary,
        ),
        titleSmall: AppTypography.titleSmall.copyWith(
          color: AppColors.textPrimary,
        ),
        bodyLarge: AppTypography.bodyLarge.copyWith(
          color: AppColors.textPrimary,
        ),
        bodyMedium: AppTypography.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
        bodySmall: AppTypography.bodySmall.copyWith(
          color: AppColors.textTertiary,
        ),
        labelLarge: AppTypography.labelLarge.copyWith(
          color: AppColors.textPrimary,
        ),
        labelMedium: AppTypography.labelMedium.copyWith(
          color: AppColors.textSecondary,
        ),
        labelSmall: AppTypography.labelSmall.copyWith(
          color: AppColors.textTertiary,
        ),
      ),
      
      // ============ APP BAR THEME - Floating Glass ============
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        titleTextStyle: AppTypography.headlineMedium.copyWith(
          color: AppColors.textPrimary,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.liquidCyan,
          size: 24,
        ),
      ),
      
      // ============ CARD THEME - Premium Glass ============
      cardTheme: CardThemeData(
        color: AppColors.premiumBlue,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: AppColors.liquidCyan.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius16),
          side: BorderSide(
            color: AppColors.borderLight.withValues(alpha: 0.5),
            width: 1.0,
          ),
        ),
        margin: EdgeInsets.zero,
      ),
      
      // ============ ELEVATED BUTTON THEME - Liquid Glass ============
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.liquidCyan,
          foregroundColor: AppColors.bgPrimary,
          minimumSize: const Size(double.infinity, AppConstants.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius12),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
          textStyle: AppTypography.buttonText.copyWith(
            color: AppColors.bgPrimary,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.buttonPaddingHorizontal,
            vertical: AppSpacing.buttonPaddingVertical,
          ),
        ),
      ),
      
      // ============ OUTLINED BUTTON THEME ============
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.liquidCyan,
          minimumSize: const Size(double.infinity, AppConstants.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius12),
          ),
          side: const BorderSide(
            color: AppColors.liquidCyan,
            width: 1.5,
          ),
          textStyle: AppTypography.buttonText,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.buttonPaddingHorizontal,
            vertical: AppSpacing.buttonPaddingVertical,
          ),
        ),
      ),
      
      // ============ TEXT BUTTON THEME ============
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.liquidCyan,
          textStyle: AppTypography.labelLarge,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.paddingS,
            vertical: AppSpacing.paddingXS,
          ),
        ),
      ),
      
      // ============ INPUT DECORATION THEME - Glass Style ============
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.bgElevated.withValues(alpha: 0.5),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.fieldPadding,
          vertical: AppSpacing.fieldPaddingVertical,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius12),
          borderSide: BorderSide(
            color: AppColors.borderLight.withValues(alpha: 0.3),
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius12),
          borderSide: BorderSide(
            color: AppColors.borderLight.withValues(alpha: 0.2),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius12),
          borderSide: const BorderSide(
            color: AppColors.liquidCyan,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius12),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 1.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius12),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 2.0,
          ),
        ),
        labelStyle: AppTypography.fieldLabel.copyWith(
          color: AppColors.textTertiary,
        ),
        hintStyle: AppTypography.inputHint.copyWith(
          color: AppColors.textQuaternary,
        ),
        errorStyle: AppTypography.captionMedium.copyWith(
          color: AppColors.error,
        ),
        prefixIconColor: AppColors.liquidCyan,
        suffixIconColor: AppColors.liquidCyan,
      ),
      
      // ============ BOTTOM NAVIGATION BAR THEME ============
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.bgSecondary.withValues(alpha: 0.9),
        selectedItemColor: AppColors.liquidCyan,
        unselectedItemColor: AppColors.textTertiary,
        elevation: 0,
        selectedLabelStyle: AppTypography.labelSmall.copyWith(
          color: AppColors.liquidCyan,
        ),
        unselectedLabelStyle: AppTypography.labelSmall.copyWith(
          color: AppColors.textTertiary,
        ),
        type: BottomNavigationBarType.fixed,
      ),
      
      // ============ FLOATING ACTION BUTTON THEME ============
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.liquidCyan,
        foregroundColor: AppColors.bgPrimary,
        elevation: 8,
        splashColor: AppColors.liquidCyan.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius16),
        ),
      ),
      
      // ============ CHIP THEME ============
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.bgElevated,
        selectedColor: AppColors.liquidCyan.withValues(alpha: 0.2),
        disabledColor: AppColors.textQuaternary.withValues(alpha: 0.2),
        labelStyle: AppTypography.labelMedium.copyWith(
          color: AppColors.textPrimary,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.paddingM,
          vertical: AppSpacing.paddingS,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMax),
          side: BorderSide(
            color: AppColors.borderLight.withValues(alpha: 0.3),
          ),
        ),
      ),
      
      // ============ DIVIDER THEME ============
      dividerTheme: DividerThemeData(
        color: AppColors.borderMedium,
        thickness: 0.5,
        space: 0,
      ),
      
      // ============ ICON THEME ============
      iconTheme: const IconThemeData(
        color: AppColors.liquidCyan,
        size: 24,
      ),
      
      // ============ SNACK BAR THEME ============
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.bgElevated,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textPrimary,
        ),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius12),
        ),
        actionTextColor: AppColors.liquidCyan,
      ),
      
      // ============ PROGRESS INDICATOR THEME ============
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.liquidCyan,
        linearTrackColor: AppColors.liquidCyan.withValues(alpha: 0.1),
        circularTrackColor: AppColors.liquidCyan.withValues(alpha: 0.1),
      ),
      
      // ============ DIALOG THEME ============
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius16),
        ),
        backgroundColor: AppColors.bgSecondary,
        elevation: 0,
        surfaceTintColor: AppColors.liquidCyan.withValues(alpha: 0.1),
        titleTextStyle: AppTypography.headlineMedium.copyWith(
          color: AppColors.textPrimary,
        ),
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      
      // ============ NAVIGATION BAR THEME ============
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.bgSecondary.withValues(alpha: 0.8),
        elevation: 0,
        height: 80,
        labelTextStyle: WidgetStateProperty.all(
          AppTypography.labelSmall.copyWith(
            color: AppColors.liquidCyan,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(
              color: AppColors.liquidCyan,
              size: 24,
            );
          }
          return const IconThemeData(
            color: AppColors.textTertiary,
            size: 24,
          );
        }),
        indicatorColor: AppColors.liquidCyan.withValues(alpha: 0.15),
      ),
      
      // ============ MENU THEME ============
      menuTheme: MenuThemeData(
        style: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(AppColors.bgElevated),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius12),
            ),
          ),
          elevation: WidgetStatePropertyAll(8),
          surfaceTintColor: WidgetStatePropertyAll(
            AppColors.liquidCyan.withValues(alpha: 0.05),
          ),
        ),
      ),

      // ============ DROPDOWN / CANVAS COLOR ============
      // This controls the dropdown popup background for DropdownButtonFormField
      canvasColor: AppColors.premiumBlue, // Premium blue, readable

      // ============ POPUP MENU THEME ============
      popupMenuTheme: PopupMenuThemeData(
        color: AppColors.premiumBlue,
        textStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius12),
        ),
        elevation: 8,
      ),
    );
  }
  
  // Dark Theme - Optional
  static ThemeData get darkTheme {
    return lightTheme; // Fallback to light theme
  }
}
