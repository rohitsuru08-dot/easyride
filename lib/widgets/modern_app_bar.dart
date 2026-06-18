/// Modern App Bar with Premium Glass morphism effect
import 'package:flutter/material.dart';
import 'package:easy_ride/core/constants/app_constants.dart';
import 'package:easy_ride/core/theme/app_design_system.dart';
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
    this.blurAmount = 15,
    this.height = 56,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    Widget appBarContent = Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingL,
        vertical: AppSpacing.paddingS,
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
                padding: EdgeInsets.all(AppSpacing.paddingXS),
                child: Icon(Icons.arrow_back,
                    color: AppColors.textPrimary),
              ),
            ),
          // Title
          Expanded(
            child: centerTitle
                ? Center(
                    child: Text(
                      title,
                      style: AppTypography.headlineSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.only(left: AppSpacing.paddingL),
                    child: Text(
                      title,
                      style: AppTypography.headlineSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
          ),
          // Actions
          if (actions != null)
            ...actions!
          else
            SizedBox(width: AppSpacing.paddingXS),
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
                color: AppColors.bgSecondary.withValues(alpha: 0.7),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.bgSecondary.withValues(alpha: 0.8),
                    AppColors.bgTertiary.withValues(alpha: 0.6),
                  ],
                ),
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.liquidCyan.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                boxShadow: AppShadows.glass,
              ),
              child: appBarContent,
            ),
          ),
        ),
      );
    }

    return AppBar(
      backgroundColor: gradient != null ? Colors.transparent : backgroundColor ?? AppColors.bgPrimary,
      flexibleSpace: gradient != null
          ? Container(
              decoration: BoxDecoration(
                gradient: gradient,
              ),
              child: appBarContent,
            )
          : Container(
              decoration: BoxDecoration(
                gradient: AppGradients.subtleElevation,
              ),
              child: appBarContent,
            ),
      elevation: elevation,
      title: const SizedBox.shrink(),
      leading: const SizedBox.shrink(),
      actions: const [],
    );
  }
}

/// Gradient App Bar - Premium variant
class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final LinearGradient? gradient;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;
  final double height;

  const GradientAppBar({
    Key? key,
    required this.title,
    this.gradient,
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
      gradient: gradient ?? AppGradients.premium,
      actions: actions,
      onLeadingPressed: onBackPressed ?? () => Navigator.pop(context),
      height: height,
    );
  }
}
