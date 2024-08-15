import 'package:bloctest/function/app_function.dart';
import 'package:bloctest/models/novel_model.dart';
import 'package:bloctest/widgets/ContainerSkeltion.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class newUpdateNovel extends StatelessWidget {
  const newUpdateNovel({
    super.key,
    required List<HitNovel> items,
  }) : _items = items;

  final List<HitNovel> _items;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: CarouselSlider(
      options: CarouselOptions(
        height: 220,
        aspectRatio: 16 / 9,
        viewportFraction: 1,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 10),
        autoPlayAnimationDuration: const Duration(milliseconds: 1000),
        autoPlayCurve: Curves.easeInOut,
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
      ),
      items: _items
          .map((item) => Builder(
                builder: (BuildContext context) {
                  // print(item.img);
                  return Container(
                    width: double.infinity,
                    height: 200,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: 130,
                            height: 190,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              // image: DecorationImage(
                              //   image: NetworkImage(item.img),
                              //   fit: BoxFit.cover,
                              // ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: item.img,
                                fit: BoxFit.fill,
                                height: double.infinity,
                                width: double.infinity,
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
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
                            )),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.athiti(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              ...List.generate(5, (context) {
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF494949),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 7,
                                          vertical: 2,
                                        ),
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        minimumSize: const Size(0, 0),
                                      ),
                                      child: Text(
                                        'อ่าน',
                                        style: GoogleFonts.athiti(
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        'บทที่ 100 ก็ทำให้มันเท่ากันทั้งสองข้างสิ!',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.athiti(
                                            fontSize: 12,
                                            color: const Color(0xFF333333),
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                );
                              }).expand((element) =>
                                  [element, const SizedBox(height: 5)]),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.remove_red_eye_rounded,
                                    size: 20,
                                    color: Color(0xFF333333),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    abbreviateNumber(item.view),
                                    style: GoogleFonts.athiti(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF333333),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Icon(
                                    Icons.list,
                                    size: 20,
                                    color: Color(0xFF333333),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    abbreviateNumber(item.allep ?? 0),
                                    style: GoogleFonts.athiti(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF333333),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ))
          .toList(),
    ));
  }
}
