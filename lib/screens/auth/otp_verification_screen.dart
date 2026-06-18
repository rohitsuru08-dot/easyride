// OTP verification screen — Premium Liquid Glass Design
// NOTE: Temporarily unused — email/password login is active.
//       Restore by re-enabling the commented OTP blocks in:
//         - auth_service.dart
//         - auth_provider.dart
//         - login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:easy_ride/core/constants/app_constants.dart';
import 'package:easy_ride/core/constants/route_constants.dart';
import 'package:easy_ride/core/constants/firestore_constants.dart';
import 'package:easy_ride/core/theme/app_design_system.dart';
import 'package:easy_ride/core/utils/validators.dart';
import 'package:easy_ride/providers/auth_provider.dart';
import 'package:easy_ride/providers/user_provider.dart';
import 'package:easy_ride/models/user_model.dart';
import 'package:easy_ride/localization/localization_service.dart';
import 'package:easy_ride/widgets/glass/glass_components.dart';
import 'package:easy_ride/widgets/common/message_dialog.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  bool _isLoading = false;
  bool _isResending = false;

  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // ─── PHONE OTP — temporarily disabled ─────────────────────────────────
    // final otp = _otpController.text.trim();
    // final success = await authProvider.verifyOtp(otp);
    setState(() => _isLoading = false);
    if (!mounted) return;
    MessageDialog.showError(context, message: 'OTP login is temporarily disabled.');
    return;
    // ─────────────────────────────────────────────────────────────────────────

    // ignore: dead_code
    final success = false;

    if (!mounted) return;

    if (success && authProvider.currentUser != null) {
      await userProvider.loadUser(authProvider.currentUser!.uid);

      if (userProvider.currentUser == null) {
        final newUser = UserModel(
          userId: authProvider.currentUser!.uid,
          name: 'User',
          phone: widget.phoneNumber,
          role: FirestoreConstants.rolePassenger,
          language: Provider.of<LanguageProvider>(context, listen: false)
                  .locale
                  .languageCode,
          createdAt: DateTime.now(),
        );
        await userProvider.saveUser(newUser);
      }

      setState(() => _isLoading = false);

      if (userProvider.currentUser != null) {
        _navigateToHome(userProvider.userRole!);
      }
    } else {
      setState(() => _isLoading = false);
      MessageDialog.showError(
        context,
        message: authProvider.errorMessage ?? 'invalid_otp'.tr(context),
      );
    }
  }

  Future<void> _resendOtp() async {
    // ─── PHONE OTP — temporarily disabled ─────────────────────────────────
    MessageDialog.showError(context, message: 'OTP login is temporarily disabled.');
    // ─────────────────────────────────────────────────────────────────────────
  }

  void _navigateToHome(String role) {
    String route;
    switch (role) {
      case FirestoreConstants.roleConductor:
        route = RouteConstants.conductorDashboard;
        break;
      case FirestoreConstants.roleAdmin:
        route = RouteConstants.adminDashboard;
        break;
      default:
        route = RouteConstants.passengerHome;
    }
    Navigator.of(context).pushNamedAndRemoveUntil(
      route,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.deepMidnight),
        child: SafeArea(
          child: Column(
            children: [
              // Custom back header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    _buildBackButton(),
                    const SizedBox(width: 12),
                    Text(
                      'verify_otp'.tr(context),
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: FadeTransition(
                  opacity: _fadeIn,
                  child: SlideTransition(
                    position: _slideUp,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 24),

                            // Icon hero
                            Center(
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: AppGradients.forest,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.success.withValues(alpha: 0.35),
                                      blurRadius: 32,
                                      spreadRadius: 4,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.shield_rounded,
                                  size: 52,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),

                            // Title
                            Text(
                              'enter_otp'.tr(context),
                              style: AppTypography.headlineSmall.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w800,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),

                            Text(
                              'OTP sent to +91 ${widget.phoneNumber}',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 40),

                            // Glass card form
                            PremiumGlassCard(
                              gradient: AppGradients.glassLight,
                              blurAmount: 16,
                              padding: const EdgeInsets.all(24),
                              isHoverable: false,
                              child: Column(
                                children: [
                                  // OTP field
                                  LiquidGlassTextField(
                                    label: 'otp'.tr(context),
                                    hint: 'Enter 6-digit OTP',
                                    controller: _otpController,
                                    keyboardType: TextInputType.number,
                                    prefixIcon: Icons.lock_rounded,
                                    validator: Validators.validateOtp,
                                    maxLines: 1,
                                  ),
                                  const SizedBox(height: 24),

                                  // Verify button
                                  LiquidGlassButton(
                                    label: 'verify_otp'.tr(context),
                                    onPressed: _verifyOtp,
                                    isLoading: _isLoading,
                                    gradient: AppGradients.forest,
                                    icon: Icons.check_circle_rounded,
                                    width: double.infinity,
                                  ),
                                  const SizedBox(height: 12),

                                  // Resend button
                                  LiquidGlassButton(
                                    label: 'resend_otp'.tr(context),
                                    onPressed: _resendOtp,
                                    isLoading: _isResending,
                                    icon: Icons.refresh_rounded,
                                    width: double.infinity,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Timer info banner
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.warning.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.warning.withValues(alpha: 0.2),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.warning.withValues(alpha: 0.15),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.timer_rounded,
                                      color: AppColors.warning,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'OTP expires in 10 minutes. Didn\'t receive? Tap Resend OTP',
                                      style: AppTypography.bodySmall.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.08),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
        child: const Icon(
          Icons.arrow_back_rounded,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}
