/// Premium Modern Text Field - Enhanced with Premium Design System
import 'package:flutter/material.dart';
import 'package:easy_ride/core/theme/app_colors.dart';
import 'package:easy_ride/core/theme/app_typography.dart';
import 'package:easy_ride/core/theme/app_shadows.dart';
import 'package:easy_ride/core/theme/app_spacing.dart';
import 'package:easy_ride/core/theme/app_animations.dart';
import 'package:easy_ride/core/constants/app_constants.dart';
import 'dart:ui' as ui;

class ModernTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool obscureText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? suffixIconOnPressed;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final int minLines;
  final int maxLines;
  final bool isGlass;
  final bool readOnly;
  final int? maxLength;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;

  const ModernTextField({
    Key? key,
    required this.label,
    this.hint,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixIconOnPressed,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.minLines = 1,
    this.maxLines = 1,
    this.isGlass = false,
    this.readOnly = false,
    this.maxLength,
    this.textStyle,
    this.hintStyle,
  }) : super(key: key);

  @override
  State<ModernTextField> createState() => _ModernTextFieldState();
}

class _ModernTextFieldState extends State<ModernTextField>
    with SingleTickerProviderStateMixin {
  late FocusNode _focusNode;
  late AnimationController _animationController;
  late Animation<double> _focusAnimation;
  late Animation<Color?> _borderAnimation;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _animationController = AnimationController(
      duration: AppAnimations.focus,
      vsync: this,
    );
    _focusAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: AppAnimations.easeInOut),
    );
    _borderAnimation = ColorTween(
      begin: AppColors.borderLight.withValues(alpha: 0.3),
      end: AppColors.liquidCyan,
    ).animate(_animationController);

    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isGlass) {
      return _buildGlassTextField();
    }
    return _buildModernTextField();
  }

  Widget _buildModernTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.paddingS),
          child: Text(
            widget.label,
            style: AppTypography.fieldLabel.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        // Text Field
        AnimatedBuilder(
          animation: _borderAnimation,
          builder: (context, child) {
            return TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              obscureText: widget.obscureText,
              minLines: widget.minLines,
              maxLines: widget.obscureText ? 1 : widget.maxLines,
              maxLength: widget.maxLength,
              readOnly: widget.readOnly,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
              style: widget.textStyle ??
                  AppTypography.inputText.copyWith(
                    color: AppColors.textPrimary,
                  ),
              decoration: InputDecoration(
                hintText: widget.hint,
                labelText: null,
                prefixIcon: widget.prefixIcon != null
                    ? Icon(widget.prefixIcon,
                        color: Color.lerp(
                          AppColors.textTertiary,
                          AppColors.liquidCyan,
                          _focusAnimation.value,
                        ),
                        size: 20)
                    : null,
                suffixIcon: widget.suffixIcon != null
                    ? IconButton(
                        icon: Icon(widget.suffixIcon,
                            color: AppColors.liquidCyan,
                            size: 20),
                        onPressed: widget.suffixIconOnPressed,
                      )
                    : null,
                filled: true,
                fillColor: AppColors.bgElevated.withValues(alpha: 0.4),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.fieldPadding,
                  vertical: AppSpacing.fieldPaddingVertical,
                ),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppConstants.borderRadius12),
                  borderSide: BorderSide(
                    color: AppColors.borderLight.withValues(alpha: 0.2),
                    width: 1.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppConstants.borderRadius12),
                  borderSide: BorderSide(
                    color: AppColors.borderLight.withValues(alpha: 0.2),
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppConstants.borderRadius12),
                  borderSide: BorderSide(
                    color: _borderAnimation.value ?? AppColors.liquidCyan,
                    width: 2.0,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppConstants.borderRadius12),
                  borderSide: const BorderSide(
                    color: AppColors.error,
                    width: 1.0,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppConstants.borderRadius12),
                  borderSide: const BorderSide(
                    color: AppColors.error,
                    width: 2.0,
                  ),
                ),
                hintStyle: widget.hintStyle ??
                    AppTypography.inputHint.copyWith(
                      color: AppColors.textQuaternary,
                    ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildGlassTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.paddingS),
          child: Text(
            widget.label,
            style: AppTypography.fieldLabel.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        // Glass Text Field
        ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius12),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AnimatedBuilder(
              animation: _borderAnimation,
              builder: (context, child) {
                return TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  obscureText: widget.obscureText,
                  minLines: widget.minLines,
                  maxLines: widget.obscureText ? 1 : widget.maxLines,
                  maxLength: widget.maxLength,
                  readOnly: widget.readOnly,
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted,
                  style: widget.textStyle ??
                      AppTypography.inputText.copyWith(
                        color: AppColors.textPrimary,
                      ),
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    labelText: null,
                    prefixIcon: widget.prefixIcon != null
                        ? Icon(widget.prefixIcon,
                            color: AppColors.liquidCyan,
                            size: 20)
                        : null,
                    suffixIcon: widget.suffixIcon != null
                        ? IconButton(
                            icon: Icon(widget.suffixIcon,
                                color: AppColors.liquidCyan,
                                size: 20),
                            onPressed: widget.suffixIconOnPressed,
                          )
                        : null,
                    filled: true,
                    fillColor: AppColors.bgElevated.withValues(alpha: 0.4),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.fieldPadding,
                      vertical: AppSpacing.fieldPaddingVertical,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          AppConstants.borderRadius12),
                      borderSide: BorderSide(
                        color: AppColors.liquidCyan.withValues(alpha: 0.3),
                        width: 1.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          AppConstants.borderRadius12),
                      borderSide: BorderSide(
                        color: AppColors.liquidCyan.withValues(alpha: 0.2),
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          AppConstants.borderRadius12),
                      borderSide: BorderSide(
                        color: _borderAnimation.value ?? AppColors.liquidCyan,
                        width: 2.0,
                      ),
                    ),
                    hintStyle: widget.hintStyle ??
                        AppTypography.inputHint.copyWith(
                          color: AppColors.textQuaternary,
                        ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
