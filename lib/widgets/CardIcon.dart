import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CardIcon extends StatelessWidget {
  const CardIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          splashColor: Colors.grey.withOpacity(0.3),
          highlightColor: Colors.grey.withOpacity(0.2),
          splashFactory: InkRipple.splashFactory,
          onTap: () {
            print('Icon clicked');
          },
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 80,
            height: 80,
            child: Image.asset('assets/lottie/logo.png'),
          ),
        ),
      ),
    )
        .animate()
        .custom(
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: child,
            );
          },
          duration: const Duration(seconds: 1),
          curve: Curves.bounceOut,
          begin: 0.3,
          end: 1.0,
        )
        .fade(
          duration: const Duration(milliseconds: 500),
        );
  }
}
