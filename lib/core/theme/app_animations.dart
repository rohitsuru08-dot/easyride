/// Premium Animation System - Durations, Curves, Transitions
import 'package:flutter/material.dart';

class AppAnimations {
  // ============ ANIMATION DURATIONS ============
  // Fast - Micro interactions
  static const Duration fast = Duration(milliseconds: 150);

  // Normal - Standard component animations
  static const Duration normal = Duration(milliseconds: 250);

  // Medium - Page transitions
  static const Duration medium = Duration(milliseconds: 400);

  // Slow - Prominent animations
  static const Duration slow = Duration(milliseconds: 700);

  // Extra slow - Entrance animations
  static const Duration extraSlow = Duration(milliseconds: 1000);

  // ============ SEMANTIC DURATIONS ============
  // Button press animation
  static const Duration buttonPress = fast;

  // Focus animation
  static const Duration focus = normal;

  // Card interaction
  static const Duration cardInteraction = normal;

  // Page transition
  static const Duration pageTransition = medium;

  // Entrance animation
  static const Duration entrance = slow;

  // Loading animation
  static const Duration loading = slow;

  // Success animation
  static const Duration success = medium;

  // Error animation (shake)
  static const Duration error = fast;

  // Scroll animation
  static const Duration scroll = normal;

  // ============ ANIMATION CURVES ============
  // Ease curves
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve easeIn = Curves.easeIn;
  static const Curve easeOut = Curves.easeOut;

  // Standard curves
  static const Curve linear = Curves.linear;
  static const Curve decelerate = Curves.decelerate;

  // Custom curves for premium feel
  // Smooth entrance curve
  static const Curve smoothEntrance = Curves.easeOutCubic;

  // Bouncy curve
  static const Curve bouncy = Curves.elasticOut;

  // Quick response curve
  static const Curve quickResponse = Curves.easeOutQuad;

  // Smooth exit curve
  static const Curve smoothExit = Curves.easeInCubic;

  // ============ CURVE CUSTOMIZATION ============
  /// Get custom cubic Bezier curve
  static Curve customCubic(
    double a,
    double b,
    double c,
    double d,
  ) =>
      Cubic(a, b, c, d);

  // Premium custom curves
  static const Curve premiumEnter = Cubic(0.34, 1.56, 0.64, 1);
  static const Curve premiumExit = Cubic(0.25, 0.46, 0.45, 0.94);
  static const Curve smoothScroll = Cubic(0.42, 0, 0.58, 1);

  // ============ TRANSITION CURVES ============
  static const Curve sharpCurve = Curves.fastOutSlowIn;
  static const Curve gentleCurve = Curves.easeInOutCubic;

  // ============ SHEET MODAL DURATION ============
  static const Duration bottomSheetDuration = medium;

  // ============ ANIMATION DELAY STEPS ============
  static const Duration delayStagger1 = Duration(milliseconds: 50);
  static const Duration delayStagger2 = Duration(milliseconds: 100);
  static const Duration delayStagger3 = Duration(milliseconds: 150);
  static const Duration delayStagger4 = Duration(milliseconds: 200);

  // ============ RIPPLE ANIMATION ============
  static const Duration rippleDuration = Duration(milliseconds: 400);

  // ============ BOUNCE ANIMATION ============
  static const Duration bounceDuration = Duration(milliseconds: 500);

  // ============ SKELETON LOADER ============
  static const Duration skeletonShimmer = Duration(seconds: 2);

  // ============ PULSE ANIMATION ============
  static const Duration pulseDuration = Duration(seconds: 2);

  // ============ TRANSITION BUILDERS ============
  /// Fade transition
  static PageTransitionsBuilder getFadeTransition() => FadePageTransitionsBuilder();

  /// Slide transition from right
  static PageTransitionsBuilder getSlideTransition() => SlidePageTransitionsBuilder();

  // ============ ANIMATION UTILITY METHODS ============

  /// Get staggered delay for index
  static Duration getStaggerDelay(int index, {Duration delay = delayStagger1}) {
    return delay * index;
  }

  /// Get curve value at time
  static double getCurveValue(Curve curve, double t) => curve.transform(t);

  /// Create custom delay animation
  static Future<void> delayedAnimation(Duration delay) async {
    return Future.delayed(delay);
  }
}

/// Custom page transition builders
class FadePageTransitionsBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }
}

class SlidePageTransitionsBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final tween = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    );
    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }
}

/// Hero animation wrapper
class HeroAnimation extends StatelessWidget {
  final String tag;
  final Widget child;
  final Duration duration;

  const HeroAnimation({
    Key? key,
    required this.tag,
    required this.child,
    this.duration = AppAnimations.medium,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      flightShuttleBuilder: (
        BuildContext flightContext,
        Animation<double> animation,
        HeroFlightDirection flightDirection,
        BuildContext fromHeroContext,
        BuildContext toHeroContext,
      ) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
      child: child,
    );
  }
}

/// Animated container wrapper with premium defaults
class PremiumAnimatedContainer extends StatelessWidget {
  final Color? color;
  final double? width;
  final double? height;
  final BoxDecoration? decoration;
  final Duration duration;
  final Curve curve;
  final Widget? child;
  final EdgeInsets? padding;

  const PremiumAnimatedContainer({
    Key? key,
    this.color,
    this.width,
    this.height,
    this.decoration,
    this.duration = AppAnimations.medium,
    this.curve = AppAnimations.easeInOut,
    this.child,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      curve: curve,
      color: color,
      width: width,
      height: height,
      decoration: decoration,
      padding: padding,
      child: child,
    );
  }
}
