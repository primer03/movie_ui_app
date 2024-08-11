import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CarouselExplore extends StatefulWidget {
  const CarouselExplore({
    super.key,
  });

  @override
  State<CarouselExplore> createState() => _CarouselExploreState();
}

class _CarouselExploreState extends State<CarouselExplore> {
  int _currentIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          carouselController: _carouselController,
          options: CarouselOptions(
            height: 250,
            autoPlay: true,
            aspectRatio: 16 / 9,
            viewportFraction: 0.4,
            enlargeFactor: 0.2,
            enlargeCenterPage: true,
            enlargeStrategy: CenterPageEnlargeStrategy.height,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: [1, 2, 3, 4, 5].map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/images/20240611231729.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    height: double.infinity,
                    alignment: Alignment.bottomLeft,
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                      color: Colors.black.withOpacity(0.3),
                    ),
                    child: Text(
                      'Kimi to Boku no Saigo no Senjou',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.white,
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        AnimatedSmoothIndicator(
          curve: Curves.easeInOutCubic,
          activeIndex: _currentIndex,
          count: 5,
          effect: const ExpandingDotsEffect(
            dotColor: Colors.grey,
            activeDotColor: Colors.black,
            dotHeight: 8,
            dotWidth: 8,
            spacing: 5,
            expansionFactor: 4,
          ),
          onDotClicked: (index) {
            _carouselController.animateToPage(index);
          },
        )
      ],
    );
  }
}
