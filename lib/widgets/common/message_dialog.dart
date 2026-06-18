// Error/Success dialog widget
import 'package:flutter/material.dart';
import 'package:easy_ride/core/constants/app_constants.dart';

class MessageDialog {
  // Show error dialog
  static Future<void> showError(
    BuildContext context, {
    required String message,
    String? title,
  }) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.error_outline,
                color: AppConstants.errorColor,
                size: 28,
              ),
              const SizedBox(width: AppConstants.spacingSmall),
              Text(
                title ?? 'Error',
                style: AppConstants.subheadingStyle.copyWith(
                  color: AppConstants.errorColor,
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: AppConstants.bodyStyle,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Show success dialog
  static Future<void> showSuccess(
    BuildContext context, {
    required String message,
    String? title,
    VoidCallback? onClose,
  }) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: AppConstants.successColor,
                size: 28,
              ),
              const SizedBox(width: AppConstants.spacingSmall),
              Text(
                title ?? 'Success',
                style: AppConstants.subheadingStyle.copyWith(
                  color: AppConstants.successColor,
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: AppConstants.bodyStyle,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onClose?.call();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Show confirmation dialog
  static Future<bool> showConfirmation(
    BuildContext context, {
    required String message,
    String? title,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          title: Text(
            title ?? 'Confirmation',
            style: AppConstants.subheadingStyle,
          ),
          content: Text(
            message,
            style: AppConstants.bodyStyle,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancelText),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(confirmText),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }
}
