import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bloctest/bloc/onboarding/onboarding_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardOnePage extends StatelessWidget {
  final int pageIndex;
  final PageController pageController;

  const OnboardOnePage({
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
              // context
              //     .read<OnboardingBloc>()
              //     .add(const OnboardingCompleted(isCompleted: [
              //       true,
              //       false,
              //       false,
              //     ]));
            },
            animatedTexts: [
              TyperAnimatedText(
                'Lorem ipsum dolor sit amet, consectetur adipisci elit, sed do eiusmod tempor incididunt sed do eiusmod tempor incididunt',
                textStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
                speed: const Duration(milliseconds: 20),
              ),
            ],
            onTap: () {},
          ),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: () {
              pageController.nextPage(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
              );
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
            child: const Text('Continue'),
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
