import 'dart:convert';

import 'package:bloctest/bloc/noveldetail/novel_detail_bloc.dart';
import 'package:bloctest/function/app_function.dart';
import 'package:bloctest/main.dart';
import 'package:bloctest/models/novel_model.dart';
import 'package:bloctest/models/user_model.dart';
import 'package:bloctest/widgets/ContainerSkeltion.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class Toptennovelnew extends StatelessWidget {
  final List<HitNovel> items;
  const Toptennovelnew({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CarouselSlider(
        items: items.asMap().entries.map((e) {
          final int index = e.key;
          final HitNovel item = e.value;
          return Container(
            // margin: const EdgeInsets.only(right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      width: (index + 1) < 10 ? 175 : 195,
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
                                          bottom: 120,
                                          child: SvgPicture.asset(
                                            'assets/svg/crown-svgrepo-com.svg',
                                            width: 35,
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
                      left: (index + 1) < 10 ? 50 : 60,
                      child: GestureDetector(
                        onTap: () async {
                          final userData = await novelBox.get('user');
                          if (userData != null) {
                            User user = User.fromJson(json.decode(userData));
                            Navigator.of(context).pushNamed(
                              '/noveldetail',
                              arguments: {
                                'novelId': item.id,
                                'allep': item.allep,
                                'bloc':
                                    BlocProvider.of<NovelDetailBloc>(context),
                                'user': user,
                              },
                            );
                          }
                        },
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
                                      // Image.network(
                                      //   item.img,
                                      //   fit: BoxFit.cover,
                                      //   width: 120,
                                      // ),
                                      CachedNetworkImage(
                                          imageUrl: item.img,
                                          fit: BoxFit.cover,
                                          width: 120,
                                          placeholder: (context, url) =>
                                              Shimmer.fromColors(
                                                baseColor: Colors.grey[400]!,
                                                highlightColor:
                                                    Colors.grey[100]!,
                                                period: const Duration(
                                                    milliseconds: 1000),
                                                child: const ContainerSkeltion(
                                                  height: 170,
                                                  width: 120,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                ),
                                              )),
                                      item.end.name == 'END'
                                          ? Positioned(
                                              top: 5,
                                              left: 5,
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    top: 2,
                                                    bottom: 2),
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFFdc3545),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Text(
                                                  'จบ',
                                                  style: GoogleFonts.athiti(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.remove_red_eye,
                                    size: 15,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    abbreviateNumber(item.view),
                                    style: GoogleFonts.athiti(
                                      fontSize: 13,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  item.allep != null
                                      ? const Icon(
                                          Icons.list,
                                          size: 15,
                                        )
                                      : const SizedBox(),
                                  const SizedBox(width: 5),
                                  item.allep != null
                                      ? Text(
                                          abbreviateNumber(item.allep!),
                                          style: GoogleFonts.athiti(
                                            fontSize: 13,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            ],
                          ),
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
