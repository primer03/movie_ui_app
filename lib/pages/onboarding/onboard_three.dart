import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bloctest/bloc/onboarding/onboarding_bloc.dart';
import 'package:bloctest/pages/main_page.dart';
import 'package:bloctest/pages/home/novel_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardThreePage extends StatelessWidget {
  final int pageIndex;
  final PageController pageController;

  const OnboardThreePage({
    super.key,
    required this.pageIndex,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/images/20240321205807.jpg',
              height: 450,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ).animate().fade(),
          const SizedBox(height: 20),
          const Text(
            'Watching can be from anywhere',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fade(),
          AnimatedTextKit(
            totalRepeatCount: 1,
            onFinished: () {
              context
                  .read<OnboardingBloc>()
                  .add(const OnboardingCompleted(isCompleted: [
                    true,
                    true,
                    true,
                  ]));
            },
            animatedTexts: [
              TyperAnimatedText(
                'Lorem ipsum dolor sit amet, consectetur adipisci elit, sed do eiusmod tempor incididunt sed do eiusmod tempor incididunt',
                textStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
                speed: const Duration(milliseconds: 25),
              ),
            ],
            onTap: () {},
          ),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: () {
              navigateWithAnimation(context, const Mainpage());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              padding: const EdgeInsets.symmetric(
                horizontal: 50,
                vertical: 10,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            child: const Text('Get Started'),
          )
              .animate()
              .custom(
                delay: Duration(milliseconds: 1000),
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
              ),
        ],
      ),
    );
  }
}

void navigateWithAnimation(BuildContext context, Widget page) {
  // ลบทุกหน้าที่อยู่ใน stack และเพิ่มหน้าใหม่เข้าไป
  Navigator.of(context).pushAndRemoveUntil(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Adjust the duration and curve for a smoother transition
        const begin = Offset(1.0, 0.0); // Slide in from right
        const end = Offset.zero;
        const curve = Curves.easeInOut; // Smooth in and out

        // Create a tween for the slide transition
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        // Apply a fade-in effect combined with the slide transition
        var fadeAnimation = CurvedAnimation(
          parent: animation,
          curve: Interval(0.0, 0.5, curve: Curves.easeInOut),
        );

        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: offsetAnimation,
            child: child,
          ),
        );
      },
      transitionDuration:
          const Duration(milliseconds: 600), // Adjusted duration
    ),
    (route) => false,
  );
}
