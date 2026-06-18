/// Premium Card Widget - Modern design with multiple style options
import 'package:flutter/material.dart';
import 'package:easy_ride/core/constants/app_constants.dart';

enum PremiumCardStyle {
  elevated,
  outlined,
  filled,
}

class PremiumCard extends StatefulWidget {
  final Widget child;
  final PremiumCardStyle style;
  final Color? backgroundColor;
  final Color? borderColor;
  final LinearGradient? gradient;
  final double borderRadius;
  final EdgeInsets padding;
  final List<BoxShadow>? shadows;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final bool isHoverable;

  const PremiumCard({
    Key? key,
    required this.child,
    this.style = PremiumCardStyle.filled,
    this.backgroundColor,
    this.borderColor,
    this.gradient,
    this.borderRadius = AppConstants.borderRadius16,
    this.padding = const EdgeInsets.all(AppConstants.spacing16),
    this.shadows,
    this.onTap,
    this.width,
    this.height,
    this.isHoverable = false,
  }) : super(key: key);

  @override
  State<PremiumCard> createState() => _PremiumCardState();
}

class _PremiumCardState extends State<PremiumCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: AppConstants.animationNormalDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );

    _elevationAnimation = Tween<double>(begin: 0, end: 12).animate(
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
        child: AnimatedBuilder(
          animation: _elevationAnimation,
          builder: (context, _) {
            return _buildCard();
          },
        ),
      ),
    );
  }

  Widget _buildCard() {
    Widget cardContent = Padding(
      padding: widget.padding,
      child: widget.child,
    );

    final bgColor = widget.backgroundColor ?? AppConstants.cardBackground;
    final borderCol = widget.borderColor ?? Color(0xFFE5E7EB);

    switch (widget.style) {
      case PremiumCardStyle.elevated:
        return _buildElevatedCard(cardContent, bgColor, borderCol);
      case PremiumCardStyle.outlined:
        return _buildOutlinedCard(cardContent, bgColor, borderCol);
      case PremiumCardStyle.filled:
      default:
        return _buildFilledCard(cardContent, bgColor);
    }
  }

  Widget _buildElevatedCard(
      Widget cardContent, Color bgColor, Color borderCol) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: widget.shadows ??
            [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12 + (_elevationAnimation.value),
                offset: Offset(0, 4 + (_elevationAnimation.value / 2)),
              ),
            ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: cardContent,
        ),
      ),
    );
  }

  Widget _buildOutlinedCard(
      Widget cardContent, Color bgColor, Color borderCol) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(
          color: borderCol,
          width: 1.5,
        ),
        boxShadow: widget.shadows ?? AppConstants.softShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: cardContent,
        ),
      ),
    );
  }

  Widget _buildFilledCard(Widget cardContent, Color bgColor) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        gradient: widget.gradient,
        color: widget.gradient == null ? bgColor : null,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: widget.shadows ?? AppConstants.softShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: cardContent,
        ),
      ),
    );
  }
}

/// Gradient Card - Pre-styled with gradient
class GradientCard extends StatelessWidget {
  final Widget child;
  final LinearGradient? gradient;
  final double borderRadius;
  final EdgeInsets padding;
  final VoidCallback? onTap;

  const GradientCard({
    Key? key,
    required this.child,
    this.gradient = AppConstants.premiumGradient,
    this.borderRadius = AppConstants.borderRadius16,
    this.padding = const EdgeInsets.all(AppConstants.spacing16),
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      style: PremiumCardStyle.filled,
      gradient: gradient,
      borderRadius: borderRadius,
      padding: padding,
      onTap: onTap,
      child: child,
    );
  }
}
