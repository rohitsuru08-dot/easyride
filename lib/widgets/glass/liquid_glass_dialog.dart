/// Premium Liquid Glass Dialog & Bottom Sheet Components
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:easy_ride/core/theme/app_colors.dart';
import 'package:easy_ride/core/theme/app_typography.dart';
import 'package:easy_ride/core/theme/app_shadows.dart';
import 'package:easy_ride/core/theme/app_spacing.dart';
import 'package:easy_ride/core/constants/app_constants.dart';

/// Premium Glass Dialog
class LiquidGlassDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget>? actions;
  final double blurAmount;
  final EdgeInsets? contentPadding;
  final Color? barrierColor;

  const LiquidGlassDialog({
    Key? key,
    required this.title,
    required this.content,
    this.actions,
    this.blurAmount = 10.0,
    this.contentPadding,
    this.barrierColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius16),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(
            sigmaX: blurAmount,
            sigmaY: blurAmount,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.bgSecondary.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(AppConstants.borderRadius16),
              border: Border.all(
                color: AppColors.liquidCyan.withValues(alpha: 0.3),
                width: 1.0,
              ),
              boxShadow: AppShadows.hard,
              gradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.1),
                  Colors.white.withValues(alpha: 0.02),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.paddingM),
                  child: Text(
                    title,
                    style: AppTypography.headlineMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Divider
                Container(
                  height: 1,
                  color: AppColors.borderLight.withValues(alpha: 0.3),
                ),
                // Content
                Padding(
                  padding: contentPadding ??
                      const EdgeInsets.all(AppSpacing.paddingM),
                  child: content,
                ),
                // Actions
                if (actions != null && actions!.isNotEmpty) ...[
                  Container(
                    height: 1,
                    color: AppColors.borderLight.withValues(alpha: 0.3),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.paddingM),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ...actions!.map((action) => Padding(
                          padding:
                              const EdgeInsets.only(left: AppSpacing.paddingS),
                          child: action,
                        ))
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Show dialog helper
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required Widget content,
    List<Widget>? actions,
  }) {
    return showDialog<T>(
      context: context,
      builder: (context) => LiquidGlassDialog(
        title: title,
        content: content,
        actions: actions,
      ),
    );
  }
}

/// Premium Glass Bottom Sheet
class LiquidGlassBottomSheet extends StatelessWidget {
  final String? title;
  final Widget child;
  final List<Widget>? actions;
  final double blurAmount;
  final Color? backgroundColor;
  final EdgeInsets? contentPadding;
  final bool isDismissible;

  const LiquidGlassBottomSheet({
    Key? key,
    this.title,
    required this.child,
    this.actions,
    this.blurAmount = 15.0,
    this.backgroundColor,
    this.contentPadding,
    this.isDismissible = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(AppConstants.borderRadius16),
        topRight: Radius.circular(AppConstants.borderRadius16),
      ),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(
          sigmaX: blurAmount,
          sigmaY: blurAmount,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor ??
                AppColors.bgSecondary.withValues(alpha: 0.7),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppConstants.borderRadius16),
              topRight: Radius.circular(AppConstants.borderRadius16),
            ),
            border: Border(
              top: BorderSide(
                color: AppColors.liquidCyan.withValues(alpha: 0.3),
                width: 1.0,
              ),
              left: BorderSide(
                color: AppColors.liquidCyan.withValues(alpha: 0.2),
                width: 1.0,
              ),
              right: BorderSide(
                color: AppColors.liquidCyan.withValues(alpha: 0.2),
                width: 1.0,
              ),
            ),
            boxShadow: AppShadows.floating,
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.1),
                Colors.white.withValues(alpha: 0.02),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.paddingM),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderLight.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Title
              if (title != null)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.paddingM,
                    vertical: AppSpacing.paddingS,
                  ),
                  child: Text(
                    title!,
                    style: AppTypography.headlineMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              // Content
              Padding(
                padding: contentPadding ??
                    const EdgeInsets.all(AppSpacing.paddingM),
                child: child,
              ),
              // Actions
              if (actions != null && actions!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.paddingM),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        ...actions!.map((action) => Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.paddingXS,
                          ),
                          child: action,
                        ))
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Show bottom sheet helper
  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    required Widget child,
    List<Widget>? actions,
    bool isDismissible = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (context) => LiquidGlassBottomSheet(
        title: title,
        child: child,
        actions: actions,
        isDismissible: isDismissible,
      ),
    );
  }
}

/// Confirmation Glass Dialog
class ConfirmationGlassDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final bool isDangerous;

  const ConfirmationGlassDialog({
    Key? key,
    required this.title,
    required this.message,
    this.confirmLabel = 'Confirm',
    this.cancelLabel = 'Cancel',
    required this.onConfirm,
    this.onCancel,
    this.isDangerous = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LiquidGlassDialog(
      title: title,
      content: Text(
        message,
        style: AppTypography.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onCancel?.call();
          },
          child: Text(
            cancelLabel,
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          child: Text(
            confirmLabel,
            style: AppTypography.labelLarge.copyWith(
              color: isDangerous ? AppColors.error : AppColors.liquidCyan,
            ),
          ),
        ),
      ],
    );
  }

  /// Show confirmation dialog
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    bool isDangerous = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationGlassDialog(
        title: title,
        message: message,
        onConfirm: onConfirm,
        onCancel: onCancel,
        isDangerous: isDangerous,
      ),
    );
  }
}
