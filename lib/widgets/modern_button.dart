/// Premium Modern Button - Enhanced with Liquid Glass Design System
import 'package:flutter/material.dart';
import 'package:easy_ride/core/theme/app_colors.dart';
import 'package:easy_ride/core/theme/app_typography.dart';
import 'package:easy_ride/core/theme/app_shadows.dart';
import 'package:easy_ride/core/theme/app_spacing.dart';
import 'package:easy_ride/core/theme/app_animations.dart';
import 'package:easy_ride/core/theme/app_gradients.dart';
import 'package:easy_ride/core/constants/app_constants.dart';

class ModernButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final LinearGradient? gradient;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double borderRadius;
  final IconData? icon;
  final bool isLoading;
  final bool isDisabled;
  final TextStyle? textStyle;
  final EdgeInsets padding;

  const ModernButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.gradient,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius = AppConstants.borderRadius12,
    this.icon,
    this.isLoading = false,
    this.isDisabled = false,
    this.textStyle,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.buttonPaddingHorizontal,
      vertical: AppSpacing.buttonPaddingVertical,
    ),
  }) : super(key: key);

  @override
  State<ModernButton> createState() => _ModernButtonState();
}

class _ModernButtonState extends State<ModernButton>
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
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
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
    final textCol = widget.textColor ?? AppColors.bgPrimary;

    return GestureDetector(
      onTapDown: widget.isDisabled || widget.isLoading ? null : _onTapDown,
      onTapUp: widget.isDisabled || widget.isLoading ? null : _onTapUp,
      onTapCancel: widget.isDisabled || widget.isLoading ? null : _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: Container(
            width: widget.width ?? double.infinity,
            height: widget.height ?? AppConstants.buttonHeight,
            decoration: BoxDecoration(
              gradient: widget.gradient,
              color: widget.gradient == null ? bgColor : null,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              boxShadow: widget.isDisabled
                  ? []
                  : AppShadows.button,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1.0,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.isDisabled || widget.isLoading
                    ? null
                    : widget.onPressed,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                child: Center(
                  child: widget.isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(textCol),
                            strokeWidth: 2,
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.icon != null) ...[
                              Icon(widget.icon, color: textCol, size: 20),
                              const SizedBox(width: AppSpacing.gapS),
                            ],
                            Text(
                              widget.label,
                              style: widget.textStyle ??
                                  AppTypography.buttonText.copyWith(
                                    color: textCol,
                                  ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Gradient Button Preset
class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final LinearGradient? gradient;
  final double? width;
  final double? height;
  final IconData? icon;
  final bool isLoading;
  final TextStyle? textStyle;

  const GradientButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.gradient = AppConstants.premiumGradient,
    this.width,
    this.height,
    this.icon,
    this.isLoading = false,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ModernButton(
      label: label,
      onPressed: onPressed,
      gradient: gradient,
      width: width,
      height: height,
      icon: icon,
      isLoading: isLoading,
      textStyle: textStyle,
    );
  }
}
