/// Animated Gradient Background Container
import 'package:flutter/material.dart';
import 'package:easy_ride/core/constants/app_constants.dart';

class AnimatedGradientContainer extends StatefulWidget {
  final Widget child;
  final List<LinearGradient> gradients;
  final Duration duration;
  final Curve curve;
  final double borderRadius;
  final List<BoxShadow>? shadows;

  const AnimatedGradientContainer({
    Key? key,
    required this.child,
    required this.gradients,
    this.duration = const Duration(seconds: 3),
    this.curve = Curves.linear,
    this.borderRadius = AppConstants.borderRadius16,
    this.shadows,
  }) : super(key: key);

  @override
  State<AnimatedGradientContainer> createState() =>
      _AnimatedGradientContainerState();
}

class _AnimatedGradientContainerState extends State<AnimatedGradientContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _currentGradientIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _startGradientAnimation();
  }

  void _startGradientAnimation() {
    _controller.repeat();
    _controller.addListener(_onAnimationUpdate);
  }

  void _onAnimationUpdate() {
    if (_controller.isCompleted) {
      _controller.reset();
      setState(() {
        _currentGradientIndex =
            (_currentGradientIndex + 1) % widget.gradients.length;
      });
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: widget.gradients[_currentGradientIndex],
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: widget.shadows ?? AppConstants.softShadow,
      ),
      child: widget.child,
    );
  }
}

/// Gradient Mesh Background - Dynamic animated gradients
class GradientMeshBackground extends StatefulWidget {
  final Widget child;
  final LinearGradient gradient;
  final bool animate;
  final Duration animationDuration;

  const GradientMeshBackground({
    Key? key,
    required this.child,
    this.gradient = AppConstants.premiumGradient,
    this.animate = true,
    this.animationDuration = const Duration(seconds: 5),
  }) : super(key: key);

  @override
  State<GradientMeshBackground> createState() =>
      _GradientMeshBackgroundState();
}

class _GradientMeshBackgroundState extends State<GradientMeshBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<AlignmentGeometry> _alignmentAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _alignmentAnimation = TweenSequence<AlignmentGeometry>([
      TweenSequenceItem(
        tween: Tween<AlignmentGeometry>(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
        ),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<AlignmentGeometry>(
          begin: Alignment.topRight,
          end: Alignment.bottomRight,
        ),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<AlignmentGeometry>(
          begin: Alignment.bottomRight,
          end: Alignment.bottomLeft,
        ),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<AlignmentGeometry>(
          begin: Alignment.bottomLeft,
          end: Alignment.topLeft,
        ),
        weight: 25,
      ),
    ]).animate(_controller);

    if (widget.animate) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _alignmentAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: _alignmentAnimation.value as Alignment,
              end: Alignment.center,
              colors: widget.gradient.colors,
              stops: widget.gradient.stops,
            ),
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
