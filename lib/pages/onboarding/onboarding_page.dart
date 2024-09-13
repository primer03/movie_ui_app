import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bloctest/bloc/onboarding/onboarding_bloc.dart';
import 'package:bloctest/pages/onboarding/onboard_one.dart';
import 'package:bloctest/pages/onboarding/onboard_three.dart';
import 'package:bloctest/pages/onboarding/onboard_two.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  List<bool> _showbtn = [false, false, false];
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  flex: 10,
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      OnboardOnePage(
                          pageController: _pageController, pageIndex: 0),
                      OnboardTwoPage(
                          pageController: _pageController, pageIndex: 1),
                      OnboardThreePage(
                          pageController: _pageController, pageIndex: 2),
                    ],
                    onPageChanged: (index) {
                      context
                          .read<OnboardingBloc>()
                          .add(OnboardingPageChanged(pageIndex: index));
                    },
                  ),
                ),
                Expanded(
                  child: Center(
                    child: state.pageIndex != 2
                        ? AnimatedSmoothIndicator(
                            onDotClicked: (index) {
                              _pageController.animateToPage(
                                index,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeIn,
                              );
                            },
                            activeIndex: state.pageIndex,
                            count: 3,
                            effect: const ExpandingDotsEffect(
                              dotColor: Colors.grey,
                              activeDotColor: Colors.black,
                              dotHeight: 8,
                              dotWidth: 8,
                              spacing: 10,
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.grey,
                                shadowColor: Colors.transparent,
                                overlayColor: Colors.black.withOpacity(0.8),
                                minimumSize: Size(double.infinity, 50),
                                splashFactory: InkRipple.splashFactory,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              child: Text('Sign In'),
                            ),
                          ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
