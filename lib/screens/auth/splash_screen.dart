// Splash screen — World-class animated branding with premium dark design
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_ride/core/constants/app_constants.dart';
import 'package:easy_ride/core/constants/route_constants.dart';
import 'package:easy_ride/core/theme/app_design_system.dart';
import 'package:easy_ride/providers/auth_provider.dart';
import 'package:easy_ride/providers/user_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _orbitController;
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _textFade;
  late Animation<Offset> _taglineSlide;
  late Animation<double> _glowPulse;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _textController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _orbitController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _logoScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.elasticOut,
      ),
    );
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );
    _taglineSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
    );
    _glowPulse = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );

    _startAnimations();
    _checkAuthStatus();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (mounted) _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) _textController.forward();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _orbitController.dispose();
    super.dispose();
  }

  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(milliseconds: 2800));
    if (!mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    await authProvider.initialize();

    if (authProvider.isAuthenticated && authProvider.currentUser != null) {
      final userId = authProvider.currentUser!.uid;
      await userProvider.loadUser(userId);

      if (userProvider.currentUser == null && userProvider.errorMessage != null) {
        await userProvider.loadUserFromLocal();
      }

      if (userProvider.currentUser != null) {
        _navigateToHome(userProvider.userRole!);
      } else {
        _navigateToLogin();
      }
    } else {
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacementNamed(RouteConstants.login);
  }

  void _navigateToHome(String role) {
    String route;
    switch (role) {
      case 'conductor':
        route = RouteConstants.conductorDashboard;
        break;
      case 'admin':
        route = RouteConstants.adminDashboard;
        break;
      default:
        route = RouteConstants.passengerHome;
    }
    Navigator.of(context).pushReplacementNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-0.3, -0.4),
            radius: 1.8,
            colors: [
              Color(0xFF1A1F3E),
              Color(0xFF0F0F1E),
              Color(0xFF080812),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Floating decorative orbs
              _buildDecorativeOrbs(),

              // Main content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),

                    // Animated logo
                    AnimatedBuilder(
                      animation: _logoController,
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: _logoFade,
                          child: Transform.scale(
                            scale: _logoScale.value,
                            child: _buildLogoSection(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 40),

                    // App name and tagline
                    FadeTransition(
                      opacity: _textFade,
                      child: SlideTransition(
                        position: _taglineSlide,
                        child: _buildTextSection(),
                      ),
                    ),

                    const Spacer(flex: 2),

                    // Bottom section
                    FadeTransition(
                      opacity: _textFade,
                      child: _buildBottomSection(),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDecorativeOrbs() {
    return AnimatedBuilder(
      animation: _orbitController,
      builder: (context, child) {
        final angle = _orbitController.value * 2 * math.pi;
        return Stack(
          children: [
            // Top-left orb
            Positioned(
              top: -80 + 30 * math.sin(angle),
              left: -60 + 20 * math.cos(angle),
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.liquidCyan.withValues(alpha: 0.12),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Bottom-right orb
            Positioned(
              bottom: -60 + 25 * math.cos(angle + math.pi),
              right: -80 + 15 * math.sin(angle + math.pi),
              child: Container(
                width: 280,
                height: 280,
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
      },
    );
  }

  Widget _buildLogoSection() {
    return AnimatedBuilder(
      animation: _glowPulse,
      builder: (context, child) {
        return Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF00E5FF),
                Color(0xFF3B5BFF),
                Color(0xFF7C3AED),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.liquidCyan
                    .withValues(alpha: 0.4 * _glowPulse.value),
                blurRadius: 40,
                spreadRadius: 8,
              ),
              BoxShadow(
                color: AppColors.electricPurple
                    .withValues(alpha: 0.25 * _glowPulse.value),
                blurRadius: 60,
                spreadRadius: 12,
              ),
            ],
          ),
          child: const Icon(
            Icons.directions_bus_filled_rounded,
            size: 64,
            color: Colors.white,
          ),
        );
      },
    );
  }

  Widget _buildTextSection() {
    return Column(
      children: [
        // App name with gradient
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF00E5FF), Color(0xFFFFFFFF), Color(0xFF9D5FFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            AppConstants.appName,
            style: AppTypography.displaySmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: 2.0,
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Subtitle
        Text(
          'Hybrid Bus Ticketing System',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textTertiary,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 16),

        // Divider accent
        Container(
          width: 60,
          height: 2,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00E5FF), Color(0xFF7C3AED)],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Tagline
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.liquidCyan.withValues(alpha: 0.08),
            border: Border.all(
              color: AppColors.liquidCyan.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Text(
            AppConstants.appTagline,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.liquidCyan,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomSection() {
    return Column(
      children: [
        // Loading indicator
        SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppColors.liquidCyan.withValues(alpha: 0.7),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Powered by APSRTC',
          style: AppTypography.captionSmall.copyWith(
            color: AppColors.textQuaternary,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
