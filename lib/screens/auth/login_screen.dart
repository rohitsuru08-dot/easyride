// Premium Login Screen — Deep Navy + Glassmorphism Design
// NOTE: Phone OTP login is temporarily commented out — email/password is active.
//       To restore OTP: uncomment the [PHONE OTP] blocks, comment the [EMAIL] blocks,
//       and revert auth_service.dart and auth_provider.dart similarly.

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_ride/core/constants/app_constants.dart';
import 'package:easy_ride/core/constants/firestore_constants.dart';
import 'package:easy_ride/core/theme/app_design_system.dart';
import 'package:easy_ride/models/user_model.dart';
import 'package:easy_ride/providers/auth_provider.dart';
import 'package:easy_ride/providers/user_provider.dart';
import 'package:easy_ride/localization/localization_service.dart';
import 'package:easy_ride/widgets/glass/glass_components.dart';
import 'package:easy_ride/widgets/common/message_dialog.dart';
import 'package:easy_ride/core/constants/route_constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isRegisterMode = false;

  late AnimationController _entranceController;
  late AnimationController _bgController;
  late Animation<double> _logoFade;
  late Animation<Offset> _cardSlide;
  late Animation<double> _cardFade;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _bgController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
    _cardSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
      ),
    );
    _cardFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _entranceController.dispose();
    _bgController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isRegisterMode) {
      await _register();
    } else {
      await _login();
    }
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final success = await authProvider.signInWithEmail(email, password);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (!success) {
      MessageDialog.showError(
        context,
        message: authProvider.errorMessage ?? 'Login failed',
      );
      return;
    }

    await _loadUserAndNavigate(userProvider, authProvider, email);
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final success = await authProvider.registerWithEmail(email, password);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (!success) {
      MessageDialog.showError(
        context,
        message: authProvider.errorMessage ?? 'Registration failed',
      );
      return;
    }

    await _loadUserAndNavigate(userProvider, authProvider, email);
  }

  void _showForgotPasswordDialog() {
    final emailController = TextEditingController(text: _emailController.text);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.bgSecondary,
          title: Text(
            'Reset Password',
            style: AppTypography.titleMedium.copyWith(color: AppColors.textPrimary),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Enter your email to receive a password reset link.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Email address',
                  hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textTertiary),
                  filled: true,
                  fillColor: AppColors.bgPrimary,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: AppTypography.labelMedium.copyWith(color: AppColors.textTertiary),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final email = emailController.text.trim();
                if (email.isEmpty || !email.contains('@')) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid email.')),
                  );
                  return;
                }
                Navigator.pop(context); // close dialog
                
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                final success = await authProvider.sendPasswordResetEmail(email);
                
                if (!mounted) return;
                
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password reset link sent! Check your email.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  MessageDialog.showError(
                    context,
                    message: authProvider.errorMessage ?? 'Failed to send reset email.',
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.liquidCyan,
                foregroundColor: Colors.black,
              ),
              child: const Text('Send Link'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final success = await authProvider.signInWithGoogle();

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (!success) {
      MessageDialog.showError(
        context,
        message: authProvider.errorMessage ?? 'Google Sign-In failed',
      );
      return;
    }

    final email = authProvider.currentUser?.email ?? 'Unknown';
    await _loadUserAndNavigate(userProvider, authProvider, email);
  }

  Future<void> _loadUserAndNavigate(
    UserProvider userProvider,
    AuthProvider authProvider,
    String email,
  ) async {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);

    await userProvider.loadUser(authProvider.currentUser!.uid);

    if (!mounted) return;

    if (userProvider.currentUser == null) {
      if (userProvider.errorMessage != null) {
        await userProvider.loadUserFromLocal();
        if (!mounted) return;
        if (userProvider.currentUser == null) {
          MessageDialog.showError(
            context,
            message:
                'Could not load your profile. Please check your connection and try again.',
          );
          setState(() => _isLoading = false);
          return;
        }
      } else {
        final newUser = UserModel(
          userId: authProvider.currentUser!.uid,
          name: email.split('@').first,
          phone: '',
          role: FirestoreConstants.rolePassenger,
          language: languageProvider.locale.languageCode,
          createdAt: DateTime.now(),
        );
        await userProvider.saveUser(newUser);
        if (!mounted) return;
      }
    }

    if (!authProvider.currentUser!.emailVerified) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          RouteConstants.emailVerification, (route) => false);
      return;
    }

    _navigateToHome(userProvider.userRole ?? FirestoreConstants.rolePassenger);
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
    Navigator.of(context).pushNamedAndRemoveUntil(route, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: AnimatedBuilder(
        animation: _bgController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(
                  -0.4 + 0.2 * math.sin(_bgController.value * math.pi),
                  -0.6 + 0.15 * math.cos(_bgController.value * math.pi),
                ),
                radius: 1.6,
                colors: const [
                  Color(0xFF1A1F3E),
                  Color(0xFF0F0F1E),
                  Color(0xFF080810),
                ],
              ),
            ),
            child: child,
          );
        },
        child: Stack(
          children: [
            // Background decorative elements
            _buildBackground(),

            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 24 : 64,
                  vertical: 16,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: isMobile ? 32 : 64),

                      // Logo section
                      FadeTransition(
                        opacity: _logoFade,
                        child: _buildLogoSection(),
                      ),

                      const SizedBox(height: 40),

                      // Glass card
                      SlideTransition(
                        position: _cardSlide,
                        child: FadeTransition(
                          opacity: _cardFade,
                          child: _buildFormCard(),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Footer
                      FadeTransition(
                        opacity: _cardFade,
                        child: _buildFooter(),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Stack(
      children: [
        // Top-left glow
        Positioned(
          top: -100,
          left: -100,
          child: Container(
            width: 350,
            height: 350,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.liquidCyan.withValues(alpha: 0.08),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Bottom-right glow
        Positioned(
          bottom: -80,
          right: -80,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.electricPurple.withValues(alpha: 0.10),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogoSection() {
    return Column(
      children: [
        // Logo icon
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppGradients.premium,
            boxShadow: [
              BoxShadow(
                color: AppColors.liquidCyan.withValues(alpha: 0.35),
                blurRadius: 32,
                spreadRadius: 4,
              ),
            ],
          ),
          child: const Icon(
            Icons.directions_bus_filled_rounded,
            size: 48,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),

        // App name
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF00E5FF), Color(0xFFFFFFFF)],
          ).createShader(bounds),
          child: Text(
            'EasyRide',
            style: AppTypography.headlineLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 8),

        Text(
          _isRegisterMode
              ? 'Create your account'
              : 'welcome'.tr(context),
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFormCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withValues(alpha: 0.05),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: PremiumGlassCard(
          gradient: AppGradients.glassLight,
          blurAmount: 20.0,
          padding: const EdgeInsets.all(28),
          isHoverable: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Section label
              Text(
                _isRegisterMode ? 'New Account' : 'Sign In',
                style: AppTypography.titleLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: 40,
                height: 2,
                decoration: const BoxDecoration(
                  gradient: AppGradients.liquidCyan,
                ),
              ),
              const SizedBox(height: 24),

              // Email field
              LiquidGlassTextField(
                label: 'Email',
                hint: 'Enter your email address',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.email_outlined,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email is required';
                  }
                  if (!value.contains('@') || !value.contains('.')) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Password field
              LiquidGlassTextField(
                label: 'Password',
                hint: 'Enter your password (min 6 characters)',
                controller: _passwordController,
                obscureText: _obscurePassword,
                prefixIcon: Icons.lock_outline_rounded,
                suffixIcon: _obscurePassword
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                onSuffixIconTap: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),

              if (!_isRegisterMode) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _showForgotPasswordDialog,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Forgot Password?',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.liquidCyan,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ] else ...[
                const SizedBox(height: 28),
              ],

              // Action button
              LiquidGlassButton(
                label: _isRegisterMode ? 'Create Account' : 'Sign In',
                onPressed: _submit,
                isLoading: _isLoading,
                gradient: AppGradients.premium,
                width: double.infinity,
                icon: _isRegisterMode
                    ? Icons.person_add_rounded
                    : Icons.login_rounded,
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.2))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'OR',
                      style: AppTypography.captionSmall.copyWith(color: AppColors.textTertiary),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.2))),
                ],
              ),
              
              const SizedBox(height: 16),

              // Google Sign In button (Official Style)
              SizedBox(
                height: 52,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _signInWithGoogle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: _isLoading 
                    ? const SizedBox(
                        width: 24, 
                        height: 24, 
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/google_logo.png',
                            height: 24,
                            width: 24,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Sign in with Google',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ],
                      ),
                ),
              ),

              const SizedBox(height: 20),

              // Toggle mode
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isRegisterMode
                        ? 'Already have an account? '
                        : "Don't have an account? ",
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() => _isRegisterMode = !_isRegisterMode);
                      _formKey.currentState?.reset();
                      _emailController.clear();
                      _passwordController.clear();
                    },
                    child: Text(
                      _isRegisterMode ? 'Sign In' : 'Sign Up',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.liquidCyan,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.liquidCyan,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildFooterChip(Icons.lock_rounded, 'Secure'),
        const SizedBox(width: 16),
        _buildFooterChip(Icons.flash_on_rounded, 'Fast'),
        const SizedBox(width: 16),
        _buildFooterChip(Icons.verified_rounded, 'Reliable'),
      ],
    );
  }

  Widget _buildFooterChip(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 12, color: AppColors.textQuaternary),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTypography.captionSmall.copyWith(
            color: AppColors.textQuaternary,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}
