/// Premium Liquid Glass Navigation Bar
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:easy_ride/core/theme/app_colors.dart';
import 'package:easy_ride/core/theme/app_typography.dart';
import 'package:easy_ride/core/theme/app_shadows.dart';
import 'package:easy_ride/core/theme/app_spacing.dart';
import 'package:easy_ride/core/constants/app_constants.dart';

class LiquidGlassNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<NavBarItem> items;
  final double blurAmount;
  final Color? backgroundColor;

  const LiquidGlassNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.blurAmount = 12.0,
    this.backgroundColor,
  }) : super(key: key);

  @override
  State<LiquidGlassNavBar> createState() => _LiquidGlassNavBarState();
}

class _LiquidGlassNavBarState extends State<LiquidGlassNavBar> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(AppConstants.borderRadius16),
        topRight: Radius.circular(AppConstants.borderRadius16),
      ),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(
          sigmaX: widget.blurAmount,
          sigmaY: widget.blurAmount,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor ??
                AppColors.bgSecondary.withValues(alpha: 0.7),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppConstants.borderRadius16),
              topRight: Radius.circular(AppConstants.borderRadius16),
            ),
            border: Border(
              top: BorderSide(
                color: AppColors.liquidCyan.withValues(alpha: 0.3),
                width: 1.0,
              ),
            ),
            boxShadow: AppShadows.floating,
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.08),
                Colors.white.withValues(alpha: 0.02),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom +
                  AppSpacing.paddingS,
              top: AppSpacing.paddingS,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                widget.items.length,
                (index) => NavBarItemWidget(
                  item: widget.items[index],
                  isActive: widget.currentIndex == index,
                  onTap: () => widget.onTap(index),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NavBarItem {
  final IconData icon;
  final String label;
  final Color? activeColor;
  final Color? inactiveColor;

  NavBarItem({
    required this.icon,
    required this.label,
    this.activeColor = AppColors.liquidCyan,
    this.inactiveColor = AppColors.textTertiary,
  });
}

class NavBarItemWidget extends StatefulWidget {
  final NavBarItem item;
  final bool isActive;
  final VoidCallback onTap;

  const NavBarItemWidget({
    Key? key,
    required this.item,
    required this.isActive,
    required this.onTap,
  }) : super(key: key);

  @override
  State<NavBarItemWidget> createState() => _NavBarItemWidgetState();
}

class _NavBarItemWidgetState extends State<NavBarItemWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    if (widget.isActive) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(NavBarItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _animationController.forward();
    } else if (!widget.isActive && oldWidget.isActive) {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Active indicator
            if (widget.isActive)
              FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  width: 40,
                  height: 3,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.liquidCyan.withValues(alpha: 0.5),
                        AppColors.liquidCyan,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
              )
            else
              const SizedBox(height: 3),
            const SizedBox(height: AppSpacing.gapXS),
            // Icon
            Icon(
              widget.item.icon,
              color: widget.isActive
                  ? widget.item.activeColor
                  : widget.item.inactiveColor,
              size: 24,
            ),
            const SizedBox(height: AppSpacing.gapXS),
            // Label
            Text(
              widget.item.label,
              style: AppTypography.labelSmall.copyWith(
                color: widget.isActive
                    ? widget.item.activeColor
                    : widget.item.inactiveColor,
                fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Alternative Glass AppBar with blur
class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;
  final double elevation;
  final Color? backgroundColor;
  final double blurAmount;
  final bool showBlur;

  const GlassAppBar({
    Key? key,
    this.title,
    this.actions,
    this.onBackPressed,
    this.elevation = 0,
    this.backgroundColor,
    this.blurAmount = 10.0,
    this.showBlur = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final child = ClipRRect(
      child: BackdropFilter(
        filter: showBlur
            ? ui.ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount)
            : ui.ImageFilter.blur(sigmaX: 0, sigmaY: 0),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor ??
                AppColors.bgPrimary.withValues(alpha: 0.6),
            border: Border(
              bottom: BorderSide(
                color: AppColors.borderLight.withValues(alpha: 0.2),
                width: 0.5,
              ),
            ),
            boxShadow: elevation > 0 ? AppShadows.glass : null,
            gradient: showBlur
                ? LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.05),
                      Colors.white.withValues(alpha: 0.01),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
          ),
          child: SafeArea(
            bottom: false,
            child: SizedBox(
              height: kToolbarHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.appBarPaddingHorizontal,
                ),
                child: Row(
                  children: [
                    // Back button
                    if (onBackPressed != null)
                      GestureDetector(
                        onTap: onBackPressed,
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: AppColors.liquidCyan,
                          size: 20,
                        ),
                      )
                    else if (Navigator.of(context).canPop())
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: AppColors.liquidCyan,
                          size: 20,
                        ),
                      ),
                    const SizedBox(width: AppSpacing.gapM),
                    // Title
                    if (title != null)
                      Expanded(
                        child: Text(
                          title!,
                          style: AppTypography.titleLarge.copyWith(
                            color: AppColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    const SizedBox(width: AppSpacing.gapM),
                    // Actions
                    if (actions != null)
                      ...actions!.map((action) => Padding(
                            padding: const EdgeInsets.only(
                              left: AppSpacing.gapM,
                            ),
                            child: action,
                          ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    return child;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
