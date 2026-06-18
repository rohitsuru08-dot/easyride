/// Modern Premium Button Widget with Gradient Support
import 'package:flutter/material.dart';
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
      horizontal: AppConstants.spacing16,
      vertical: AppConstants.spacing12,
    ),
  }) : super(key: key);

  @override
  State<ModernButton> createState() => _ModernButtonState();
}

class _ModernButtonState extends State<ModernButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppConstants.animationFastDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.backgroundColor ?? AppConstants.primaryBlue;
    final textColor = widget.textColor ?? Colors.white;

    return GestureDetector(
      onTapDown: widget.isDisabled || widget.isLoading ? null : _onTapDown,
      onTapUp: widget.isDisabled || widget.isLoading ? null : _onTapUp,
      onTapCancel: widget.isDisabled || widget.isLoading ? null : _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: widget.width ?? double.infinity,
          height: widget.height ?? AppConstants.buttonHeight,
          decoration: BoxDecoration(
            gradient: widget.gradient,
            color: widget.gradient == null ? bgColor : null,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: [
              if (!widget.isDisabled)
                BoxShadow(
                  color: (widget.gradient?.colors.first ?? bgColor)
                      .withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.isDisabled || widget.isLoading
                  ? null
                  : widget.onPressed,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              child: Opacity(
                opacity: widget.isDisabled ? 0.5 : 1.0,
                child: Center(
                  child: widget.isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(textColor),
                            strokeWidth: 2,
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.icon != null) ...[
                              Icon(widget.icon, color: textColor),
                              const SizedBox(width: AppConstants.spacing8),
                            ],
                            Text(
                              widget.label,
                              style: widget.textStyle ??
                                  TextStyle(
                                    color: textColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
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
