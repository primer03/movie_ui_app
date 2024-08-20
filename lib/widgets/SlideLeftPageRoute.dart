import 'package:flutter/material.dart';

class SlideLeftRoute extends PageRouteBuilder {
  final Widget page;
  SlideLeftRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = const Offset(1.0, 0.0);
            var end = Offset.zero;
            var curve = Curves.easeInOutCubic;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            var scaleTween =
                Tween(begin: 0.95, end: 1.0).chain(CurveTween(curve: curve));
            var scaleAnimation = animation.drive(scaleTween);

            var fadeTween =
                Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));
            var fadeAnimation = animation.drive(fadeTween);

            return SlideTransition(
              position: offsetAnimation,
              child: FadeTransition(
                opacity: fadeAnimation,
                child: ScaleTransition(
                  scale: scaleAnimation,
                  child: child,
                ),
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
        );
}
