/// Premium Liquid Glass Button - Frosted Glass with Animations
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:easy_ride/core/theme/app_colors.dart';
import 'package:easy_ride/core/theme/app_typography.dart';
import 'package:easy_ride/core/theme/app_shadows.dart';
import 'package:easy_ride/core/theme/app_spacing.dart';
import 'package:easy_ride/core/theme/app_animations.dart';
import 'package:easy_ride/core/constants/app_constants.dart';

class LiquidGlassButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final double? width;
  final double height;
  final Color? backgroundColor;
  final LinearGradient? gradient;
  final Color textColor;
  final IconData? icon;
  final bool isLoading;
  final bool isDisabled;
  final double blurAmount;
  final List<BoxShadow>? shadows;

  const LiquidGlassButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.width,
    this.height = AppConstants.buttonHeight,
    this.backgroundColor,
    this.gradient,
    this.textColor = Colors.white,
    this.icon,
    this.isLoading = false,
    this.isDisabled = false,
    this.blurAmount = 10.0,
    this.shadows,
  }) : super(key: key);

  @override
  State<LiquidGlassButton> createState() => _LiquidGlassButtonState();
}

class _LiquidGlassButtonState extends State<LiquidGlassButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.buttonPress,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: AppAnimations.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: AppAnimations.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (!widget.isDisabled && !widget.isLoading) {
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    if (!widget.isDisabled && !widget.isLoading) {
      widget.onPressed();
    }
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.backgroundColor ?? AppColors.liquidCyan;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius12),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(
                sigmaX: widget.blurAmount,
                sigmaY: widget.blurAmount,
              ),
              child: Container(
                width: widget.width ?? double.infinity,
                height: widget.height,
                decoration: BoxDecoration(
                  gradient: widget.gradient,
                  color: widget.gradient == null ? bgColor : null,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius12),
                  boxShadow: widget.shadows ?? AppShadows.button,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1.0,
                  ),
                ),
                child: Stack(
                  children: [
                    // Frosted overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0.1),
                            Colors.white.withValues(alpha: 0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius:
                            BorderRadius.circular(AppConstants.borderRadius12),
                      ),
                    ),
                    // Content
                    Center(
                      child: widget.isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  widget.textColor,
                                ),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (widget.icon != null) ...[
                                  Icon(
                                    widget.icon,
                                    color: widget.textColor,
                                    size: 20,
                                  ),
                                  const SizedBox(width: AppSpacing.gapS),
                                ],
                                Text(
                                  widget.label,
                                  style: AppTypography.buttonText.copyWith(
                                    color: widget.textColor,
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
    );
  }
}
