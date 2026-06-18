/// Premium Liquid Glass Text Field - Floating Labels with Glass Effect
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:easy_ride/core/theme/app_colors.dart';
import 'package:easy_ride/core/theme/app_typography.dart';
import 'package:easy_ride/core/theme/app_shadows.dart';
import 'package:easy_ride/core/theme/app_spacing.dart';
import 'package:easy_ride/core/constants/app_constants.dart';

class LiquidGlassTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final int? maxLines;
  final int? minLines;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final TextInputAction? textInputAction;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconTap;
  final double blurAmount;
  final bool showBorder;
  final String? errorText;

  const LiquidGlassTextField({
    Key? key,
    required this.label,
    this.hint,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines,
    this.onChanged,
    this.validator,
    this.textInputAction,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.blurAmount = 10.0,
    this.showBorder = true,
    this.errorText,
  }) : super(key: key);

  @override
  State<LiquidGlassTextField> createState() => _LiquidGlassTextFieldState();
}

class _LiquidGlassTextFieldState extends State<LiquidGlassTextField>
    with SingleTickerProviderStateMixin {
  late FocusNode _focusNode;
  late AnimationController _animationController;
  late Animation<double> _focusAnimation;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _focusAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus) {
      _animationController.forward();
    } else if (widget.controller?.text.isEmpty ?? true) {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppConstants.borderRadius12),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(
          sigmaX: widget.blurAmount,
          sigmaY: widget.blurAmount,
        ),
        child: AnimatedBuilder(
          animation: _focusAnimation,
          builder: (context, child) {
            final borderColor = Color.lerp(
              AppColors.borderLight.withValues(alpha: 0.3),
              AppColors.liquidCyan,
              _focusAnimation.value,
            )!;

            final shadowColor = Color.lerp(
              AppColors.liquidCyan.withValues(alpha: 0),
              AppColors.liquidCyan.withValues(alpha: 0.2),
              _focusAnimation.value,
            )!;

            return Container(
              decoration: BoxDecoration(
                color: AppColors.bgElevated.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(AppConstants.borderRadius12),
                border: widget.showBorder
                    ? Border.all(
                        color: borderColor,
                        width: 1.5,
                      )
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: 12.0 * _focusAnimation.value,
                    offset: Offset(0, 2 * _focusAnimation.value),
                    spreadRadius: 0,
                  ),
                ],
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.05),
                    Colors.white.withValues(alpha: 0.02),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Floating label — always above the input
                  Padding(
                    padding: EdgeInsets.only(
                      left: AppSpacing.paddingM +
                          (widget.prefixIcon != null ? 40 : 0),
                      top: AppSpacing.paddingXS,
                      bottom: 2,
                    ),
                    child: Text(
                      widget.label,
                      style: AppTypography.captionMedium.copyWith(
                        color: Color.lerp(
                          AppColors.textTertiary,
                          AppColors.liquidCyan,
                          _focusAnimation.value,
                        ),
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  // Text field row
                  Stack(
                    children: [
                      TextField(
                        controller: widget.controller,
                        focusNode: _focusNode,
                        keyboardType: widget.keyboardType,
                        obscureText: widget.obscureText,
                        maxLines: widget.obscureText ? 1 : widget.maxLines,
                        minLines: widget.minLines,
                        onChanged: widget.onChanged,
                        textInputAction: widget.textInputAction,
                        style: AppTypography.inputText.copyWith(
                          color: AppColors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          filled: false,
                          isCollapsed: false,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.paddingM,
                            vertical: AppSpacing.paddingS,
                          ),
                          hintText: widget.hint ?? widget.label,
                          hintStyle: AppTypography.inputHint.copyWith(
                            color: AppColors.textQuaternary,
                          ),
                          prefixIcon: widget.prefixIcon != null
                              ? Icon(
                                  widget.prefixIcon,
                                  color: Color.lerp(
                                    AppColors.textTertiary,
                                    AppColors.liquidCyan,
                                    _focusAnimation.value,
                                  ),
                                  size: 20,
                                )
                              : null,
                          suffixIcon: widget.suffixIcon != null
                              ? GestureDetector(
                                  onTap: widget.onSuffixIconTap,
                                  child: Icon(
                                    widget.suffixIcon,
                                    color: AppColors.liquidCyan,
                                    size: 20,
                                  ),
                                )
                              : null,
                        ),
                      ),
                      // Error indicator
                      if (widget.errorText != null)
                        Positioned(
                          right: AppSpacing.paddingM,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: Icon(
                              Icons.error_outline,
                              color: AppColors.error,
                              size: 18,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Glass Text Field with validation
class ValidatedGlassTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;
  final IconData? icon;
  final String? helperText;

  const ValidatedGlassTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.icon,
    this.helperText,
  }) : super(key: key);

  @override
  State<ValidatedGlassTextField> createState() =>
      _ValidatedGlassTextFieldState();
}

class _ValidatedGlassTextFieldState extends State<ValidatedGlassTextField> {
  String? _error;

  void _validate() {
    setState(() {
      _error = widget.validator?.call(widget.controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LiquidGlassTextField(
          label: widget.label,
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          prefixIcon: widget.icon,
          errorText: _error,
          onChanged: (_) => _validate(),
        ),
        if (widget.helperText != null)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.paddingXS),
            child: Text(
              widget.helperText!,
              style: AppTypography.captionSmall.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.paddingXS),
            child: Text(
              _error!,
              style: AppTypography.captionSmall.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
      ],
    );
  }
}
