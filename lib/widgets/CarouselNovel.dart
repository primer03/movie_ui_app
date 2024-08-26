import 'package:bloctest/models/novel_model.dart';
import 'package:bloctest/pages/novel_detail.dart';
import 'package:bloctest/widgets/ContainerSkeltion.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Carouselnovel extends StatefulWidget {
  const Carouselnovel({super.key, required this.promote});
  final List<Promote> promote;
  @override
  State<Carouselnovel> createState() => _CarouselnovelState();
}

class _CarouselnovelState extends State<Carouselnovel> {
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
            height: 150,
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
          items: widget.promote.map((Promote promote) {
            // print(promote.)
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: promote.img,
                          fit: BoxFit.fill,
                          height: double.infinity,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey[400]!,
                            highlightColor: Colors.grey[100]!,
                            period: const Duration(milliseconds: 1000),
                            child: const ContainerSkeltion(
                              height: double.infinity,
                              width: double.infinity,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        child: promote.type.name == 'BOOK'
                            ? Container(
                                padding: const EdgeInsets.all(10),
                                width: MediaQuery.of(context).size.width,
                                height: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            print(promote.dataVal);
                                            Navigator.pushNamed(
                                              context,
                                              '/noveldetail',
                                              arguments: {
                                                'novelId': promote.id,
                                                'allep': promote.allep,
                                              },
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.white.withOpacity(0.9),
                                            foregroundColor: Colors.black,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 5,
                                            ),
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap,
                                            minimumSize: const Size(0, 0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                          child: Text(
                                            'อ่าน',
                                            style: GoogleFonts.athiti(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                              context,
                                              '/noveldetail',
                                              arguments: {
                                                'novelId': promote.id,
                                                'allep': promote.allep,
                                              },
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.black.withOpacity(0.5),
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 5,
                                            ),
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap,
                                            minimumSize: const Size(0, 0),
                                            splashFactory:
                                                InkRipple.splashFactory,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                          child: Text(
                                            'เรื่องย่อ',
                                            style: GoogleFonts.athiti(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                      ),
                    ],
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
          count: widget.promote.length,
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
