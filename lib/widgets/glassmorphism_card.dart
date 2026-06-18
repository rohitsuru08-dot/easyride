/// Premium Glassmorphism Card - Modern glass effect with blur and luxury aesthetics
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:easy_ride/core/constants/app_constants.dart';
import 'package:easy_ride/core/theme/app_design_system.dart';

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
    this.blurAmount = 15.0,
    this.borderRadius = AppConstants.borderRadius16,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.padding = const EdgeInsets.all(AppConstants.spacing16),
    this.shadows,
    this.onTap,
    this.isClickable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ??
        AppColors.bgSecondary.withValues(alpha: 0.7);
    final borderCol = borderColor ??
        AppColors.liquidCyan.withValues(alpha: 0.2);

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
              boxShadow: shadows ?? AppShadows.glass,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
