import 'package:flutter/material.dart';

class ParallaxHeader extends StatelessWidget {
  final ScrollController scrollController;
  final Widget background;
  final Widget content;
  final double height;
  final double parallaxSpeed;

  const ParallaxHeader({
    Key? key,
    required this.scrollController,
    required this.background,
    required this.content,
    required this.height,
    this.parallaxSpeed = 0.5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: AnimatedBuilder(
        animation: scrollController,
        builder: (context, child) {
          double offset = 0.0;
          if (scrollController.hasClients) {
            offset = scrollController.offset;
            // Prevent pulling the image down when bouncing at top
            if (offset < 0) offset = 0; 
          }
          
          return Stack(
            fit: StackFit.expand,
            children: [
              // Parallax Background
              Positioned(
                top: -offset * parallaxSpeed,
                left: 0,
                right: 0,
                bottom: offset * parallaxSpeed,
                child: background,
              ),
              // Foreground Content
              Positioned.fill(
                child: content,
              ),
            ],
          );
        },
      ),
    );
  }
}
