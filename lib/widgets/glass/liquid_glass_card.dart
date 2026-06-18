/// Premium Liquid Glass Card - Premium Glass Container
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:easy_ride/core/theme/app_colors.dart';
import 'package:easy_ride/core/theme/app_shadows.dart';
import 'package:easy_ride/core/theme/app_spacing.dart';
import 'package:easy_ride/core/theme/app_animations.dart';
import 'package:easy_ride/core/constants/app_constants.dart';

class LiquidGlassCard extends StatefulWidget {
  final Widget child;
  final double blurAmount;
  final double borderRadius;
  final LinearGradient? gradient;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final EdgeInsets padding;
  final List<BoxShadow>? shadows;
  final VoidCallback? onTap;
  final bool isClickable;
  final bool showBorder;

  const LiquidGlassCard({
    Key? key,
    required this.child,
    this.blurAmount = 15.0,
    this.borderRadius = AppConstants.borderRadius16,
    this.gradient,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.padding = const EdgeInsets.all(AppSpacing.paddingM),
    this.shadows,
    this.onTap,
    this.isClickable = false,
    this.showBorder = true,
  }) : super(key: key);

  @override
  State<LiquidGlassCard> createState() => _LiquidGlassCardState();
}

class _LiquidGlassCardState extends State<LiquidGlassCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shadowAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );

    _shadowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor =
        widget.backgroundColor ?? AppColors.premiumBlue.withValues(alpha: 0.85);
    final borderCol =
        widget.borderColor ?? Colors.white.withValues(alpha: 0.3);

    return MouseRegion(
      onEnter: widget.isClickable ? (_) => _hoverController.forward() : null,
      onExit: widget.isClickable ? (_) => _hoverController.reverse() : null,
      child: GestureDetector(
        onTap: widget.isClickable ? widget.onTap : null,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(
                sigmaX: widget.blurAmount,
                sigmaY: widget.blurAmount,
              ),
              child: AnimatedBuilder(
                animation: _shadowAnimation,
                builder: (context, child) {
                  final shadows = List<BoxShadow>.from(
                    widget.shadows ?? AppShadows.glass,
                  );
                  if (widget.isClickable) {
                    shadows.add(
                      BoxShadow(
                        color: AppColors.liquidCyan.withValues(
                          alpha: 0.1 * _shadowAnimation.value,
                        ),
                        blurRadius: 20 * _shadowAnimation.value,
                        offset: Offset(0, 4 * _shadowAnimation.value),
                        spreadRadius: 2 * _shadowAnimation.value,
                      ),
                    );
                  }
                  return Container(
                    padding: widget.padding,
                    decoration: BoxDecoration(
                      gradient: widget.gradient,
                      color: widget.gradient == null ? bgColor : null,
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      border: widget.showBorder
                          ? Border.all(
                              color: borderCol,
                              width: widget.borderWidth,
                            )
                          : null,
                      boxShadow: shadows,
                    ),
                    child: child,
                  );
                },
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Premium Glass Card with gradient overlay
class PremiumGlassCard extends StatefulWidget {
  final Widget child;
  final LinearGradient? gradient;
  final double blurAmount;
  final double borderRadius;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  final bool isClickable;
  final bool isHoverable;

  const PremiumGlassCard({
    Key? key,
    required this.child,
    this.gradient,
    this.blurAmount = 20.0,
    this.borderRadius = AppConstants.borderRadius16,
    this.padding = const EdgeInsets.all(AppSpacing.paddingM),
    this.onTap,
    this.isClickable = false,
    this.isHoverable = false,
  }) : super(key: key);

  @override
  State<PremiumGlassCard> createState() => _PremiumGlassCardState();
}

class _PremiumGlassCardState extends State<PremiumGlassCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: AppAnimations.normal,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _onHoverEnter() {
    if (widget.isHoverable) {
      setState(() => _isHovering = true);
      _hoverController.forward();
    }
  }

  void _onHoverExit() {
    if (widget.isHoverable) {
      setState(() => _isHovering = false);
      _hoverController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHoverEnter(),
      onExit: (_) => _onHoverExit(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: GestureDetector(
          onTap: widget.isClickable ? widget.onTap : null,
          child: LiquidGlassCard(
            blurAmount: widget.blurAmount,
            borderRadius: widget.borderRadius,
            gradient: widget.gradient ?? _buildDefaultGradient(),
            padding: widget.padding,
            shadows: _isHovering
                ? AppShadows.glassElevated
                : AppShadows.glass,
            child: widget.child,
          ),
        ),
      ),
    );
  }

  LinearGradient _buildDefaultGradient() {
    return LinearGradient(
      colors: [
        AppColors.liquidCyan.withValues(alpha: 0.1),
        AppColors.electricPurple.withValues(alpha: 0.05),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}

/// Elevated Glass Card with depth layering
class ElevatedGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double elevation;
  final VoidCallback? onTap;

  const ElevatedGlassCard({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.paddingM),
    this.elevation = 2.0,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LiquidGlassCard(
      blurAmount: 20.0,
      borderRadius: AppConstants.borderRadius16,
      backgroundColor: AppColors.premiumBlue.withValues(alpha: 0.75),
      gradient: LinearGradient(
        colors: [
          Colors.white.withValues(alpha: 0.08),
          Colors.white.withValues(alpha: 0.02),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      padding: padding,
      onTap: onTap,
      isClickable: onTap != null,
      shadows: elevation > 1.5 ? AppShadows.glassElevated : AppShadows.glass,
      child: child,
    );
  }
}
