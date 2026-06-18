/// Modern App Bar with Glass morphism effect
import 'package:flutter/material.dart';
import 'package:easy_ride/core/constants/app_constants.dart';
import 'dart:ui' as ui;

class ModernAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final List<Widget>? actions;
  final Widget? leading;
  final VoidCallback? onLeadingPressed;
  final double elevation;
  final Color? backgroundColor;
  final LinearGradient? gradient;
  final bool isGlass;
  final double blurAmount;
  final double height;

  const ModernAppBar({
    Key? key,
    required this.title,
    this.centerTitle = true,
    this.actions,
    this.leading,
    this.onLeadingPressed,
    this.elevation = 0,
    this.backgroundColor,
    this.gradient,
    this.isGlass = false,
    this.blurAmount = 10,
    this.height = 56,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    Widget appBarContent = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacing16,
        vertical: AppConstants.spacing8,
      ),
      child: Row(
        children: [
          // Leading
          if (leading != null)
            leading!
          else if (Navigator.canPop(context))
            GestureDetector(
              onTap: onLeadingPressed ?? () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(AppConstants.spacing8),
                child: const Icon(Icons.arrow_back,
                    color: AppConstants.textPrimary),
              ),
            ),
          // Title
          Expanded(
            child: centerTitle
                ? Center(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppConstants.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(
                        left: AppConstants.spacing16),
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppConstants.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
          ),
          // Actions
          if (actions != null)
            ...actions!
          else
            const SizedBox(width: AppConstants.spacing8),
        ],
      ),
    );

    if (isGlass) {
      return AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.7),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
              ),
              child: appBarContent,
            ),
          ),
        ),
      );
    }

    return AppBar(
      backgroundColor: gradient != null ? Colors.transparent : backgroundColor ?? AppConstants.backgroundColor,
      flexibleSpace: gradient != null
          ? Container(
              decoration: BoxDecoration(
                gradient: gradient,
              ),
              child: appBarContent,
            )
          : appBarContent,
      elevation: elevation,
      title: const SizedBox.shrink(),
      leading: const SizedBox.shrink(),
      actions: const [],
    );
  }
}

/// Gradient App Bar
class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final LinearGradient? gradient;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;
  final double height;

  const GradientAppBar({
    Key? key,
    required this.title,
    this.gradient = AppConstants.premiumGradient,
    this.actions,
    this.onBackPressed,
    this.height = 56,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return ModernAppBar(
      title: title,
      gradient: gradient,
      actions: actions,
      onLeadingPressed: onBackPressed ?? () => Navigator.pop(context),
      height: height,
    );
  }
}
