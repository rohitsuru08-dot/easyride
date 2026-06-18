/// Glassmorphism Card - Modern glass effect with blur
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:easy_ride/core/constants/app_constants.dart';

class GlassmorphismCard extends StatelessWidget {
  final Widget child;
  final double blurAmount;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final EdgeInsets padding;
  final List<BoxShadow>? shadows;
  final GestureTapCallback? onTap;
  final bool isClickable;

  const GlassmorphismCard({
    Key? key,
    required this.child,
    this.blurAmount = 10.0,
    this.borderRadius = AppConstants.borderRadius16,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.5,
    this.padding = const EdgeInsets.all(AppConstants.spacing16),
    this.shadows,
    this.onTap,
    this.isClickable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bgColor =
        backgroundColor ?? Colors.white.withValues(alpha: 0.7);
    final borderCol = borderColor ?? Colors.white.withValues(alpha: 0.3);

    return GestureDetector(
      onTap: isClickable ? onTap : null,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(
            sigmaX: blurAmount,
            sigmaY: blurAmount,
          ),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: borderCol,
                width: borderWidth,
              ),
              boxShadow: shadows ?? AppConstants.softShadow,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Premium Glass Card with gradient and effects
class PremiumGlassCard extends StatelessWidget {
  final Widget child;
  final LinearGradient? gradient;
  final double blurAmount;
  final double borderRadius;
  final EdgeInsets padding;
  final GestureTapCallback? onTap;

  const PremiumGlassCard({
    Key? key,
    required this.child,
    this.gradient,
    this.blurAmount = 15.0,
    this.borderRadius = AppConstants.borderRadius16,
    this.padding = const EdgeInsets.all(AppConstants.spacing16),
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(
            sigmaX: blurAmount,
            sigmaY: blurAmount,
          ),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              gradient: gradient ??
                  LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.8),
                      Colors.white.withValues(alpha: 0.6),
                    ],
                  ),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.4),
                width: 2,
              ),
              boxShadow: AppConstants.mediumShadow,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
