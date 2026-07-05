import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_ride/core/theme/app_design_system.dart';
import 'package:easy_ride/widgets/common/message_dialog.dart';
import 'package:easy_ride/core/constants/route_constants.dart';
import 'dart:async';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isEmailVerified = false;
  Timer? timer;
  bool isResending = false;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;

    if (!isEmailVerified) {
      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();
    
    if (mounted) {
      setState(() {
        isEmailVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;
      });

      if (isEmailVerified) {
        timer?.cancel();
        // Go to auth wrapper which will redirect appropriately based on role
        Navigator.of(context).pushNamedAndRemoveUntil(
          RouteConstants.splash,
          (route) => false,
        );
      }
    }
  }

  Future<void> resendVerificationEmail() async {
    setState(() => isResending = true);
    try {
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      if (mounted) {
        MessageDialog.showSuccess(
          context,
          title: 'Email Resent',
          message: 'A new verification link has been sent to your email address.',
        );
      }
    } catch (e) {
      if (mounted) {
        MessageDialog.showError(
          context,
          message: 'Failed to resend email: $e',
        );
      }
    } finally {
      if (mounted) {
        setState(() => isResending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: Text(
          'Verify Email',
          style: AppTypography.titleMedium.copyWith(color: AppColors.textPrimary),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.mark_email_unread_rounded,
                size: 80,
                color: AppColors.liquidCyan,
              ),
              const SizedBox(height: 24),
              Text(
                'Verify your email address',
                style: AppTypography.titleLarge.copyWith(color: AppColors.textPrimary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'We have just sent a verification link to your email address. Please check your inbox and click on the link to continue.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isResending ? null : resendVerificationEmail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.liquidCyan,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: isResending
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Resend Email',
                          style: AppTypography.labelLarge.copyWith(color: Colors.black),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      RouteConstants.login,
                      (route) => false,
                    );
                  }
                },
                child: Text(
                  'Cancel',
                  style: AppTypography.labelLarge.copyWith(color: AppColors.error),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
