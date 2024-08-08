import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CarouselAnime extends StatefulWidget {
  const CarouselAnime({
    super.key,
  });

  @override
  State<CarouselAnime> createState() => _CarouselAnimeState();
}

class _CarouselAnimeState extends State<CarouselAnime> {
  int _currentIndex = 0;
  final CarouselController _carouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          carouselController: _carouselController,
          options: CarouselOptions(
            height: 165,
            autoPlay: true,
            aspectRatio: 2.0,
            viewportFraction: 1,
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
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://wallpapercave.com/wp/wp8291793.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          const Color(0xFF685CF0),
                          const Color(0xFF685CF0).withOpacity(0.9),
                          Colors.transparent,
                        ],
                        stops: const [0.35, 0.5, 0.8],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Watch popular',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: Offset(0, 0),
                                blurRadius: 10.0,
                                color: const Color.fromARGB(255, 255, 255, 255)
                                    .withOpacity(0.8),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 170,
                          child: Text(
                            'Kimi to Boku no Saigo no Senjou',
                            softWrap: true,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 170,
                          child: Text(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer nec odio. Praesent libero. Sed cursus ante dapibus diam. Sed nisi.',
                            softWrap: true,
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFFCCC8F5),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.all(0),
                            minimumSize: const Size(100, 25),
                          ),
                          child: const Text(
                            'Watch Now',
                            style: TextStyle(
                              color: Color(0xFF685CF0),
                            ),
                          ),
                        ),
                      ],
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
            activeDotColor: Color(0xFF685CF0),
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
