import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Toptennovelnew extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  const Toptennovelnew({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CarouselSlider(
        items: items.asMap().entries.map((e) {
          final int index = e.key;
          final Map<String, dynamic> item = e.value;
          return Container(
            // margin: const EdgeInsets.only(right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      width: (index + 1) < 10 ? 175 : 190,
                      height: 200,
                      alignment: Alignment.bottomLeft,
                      child: (index + 1) < 10
                          ? Container(
                              width: 175,
                              child: Stack(
                                children: [
                                  Text(
                                    (index + 1).toString(),
                                    style: GoogleFonts.athiti(
                                      fontSize: 120,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      height: 1.3,
                                    ),
                                  ),
                                  (index + 1) < 4
                                      ? Positioned(
                                          left: 10,
                                          bottom: 110,
                                          child: SvgPicture.asset(
                                            'assets/svg/crown-svgrepo-com.svg',
                                            width: 30,
                                            color: (index + 1) == 1
                                                ? Colors.yellow
                                                : (index + 1) == 2
                                                    ? Colors.grey
                                                    : Colors.brown,
                                          ))
                                      : const Positioned(
                                          left: 10,
                                          bottom: 110,
                                          child: SizedBox(
                                              // width: 30,
                                              ),
                                        ),
                                ],
                              ),
                            )
                          : Container(
                              width: 170,
                              child: Stack(
                                children: [
                                  Text(
                                    (index + 1).toString().split('')[0],
                                    style: GoogleFonts.athiti(
                                      fontSize: 120,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      height: 1.3,
                                    ),
                                  ),
                                  Positioned(
                                    left: 35,
                                    bottom: 0,
                                    child: Text(
                                      (index + 1).toString().split('')[1],
                                      style: GoogleFonts.athiti(
                                        fontSize: 120,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        height: 1.3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: (index + 1) < 10 ? 50 : 70,
                      child: Container(
                        // height: 170,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Stack(
                                  children: [
                                    Image.network(
                                      item['image'],
                                      fit: BoxFit.cover,
                                      width: 120,
                                    ),
                                    Positioned(
                                      top: 10,
                                      left: -25,
                                      child: Transform.rotate(
                                        angle: -0.8,
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: 80,
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            color: Colors.red[700],
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: const Text(
                                            'จบแล้ว',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Row(
                              children: [
                                Icon(
                                  Icons.remove_red_eye,
                                  size: 15,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  '1.2k',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Icon(
                                  Icons.list,
                                  size: 15,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  '1.2k',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
        options: CarouselOptions(
          height: 230,
          autoPlay: false,
          aspectRatio: 16 / 9,
          viewportFraction: 0.5,
          enlargeFactor: 0.2,
          enlargeCenterPage: true,
          enlargeStrategy: CenterPageEnlargeStrategy.height,
        ),
      ),
    );
  }
}
