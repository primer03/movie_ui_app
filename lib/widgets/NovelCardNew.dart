import 'package:bloctest/bloc/novel/novel_bloc.dart';
import 'package:bloctest/bloc/noveldetail/novel_detail_bloc.dart';
import 'package:bloctest/function/app_function.dart';
import 'package:bloctest/models/novel_model.dart';
import 'package:bloctest/pages/movie_detail.dart';
import 'package:bloctest/pages/novel_detail.dart';
import 'package:bloctest/widgets/ContainerSkeltion.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class Novelcardnew extends StatelessWidget {
  final List<Recomnovel> items;
  final int? maxLine;
  final bool isshowepisode;
  final bool isshowviewInimage;
  const Novelcardnew({
    super.key,
    required this.items,
    this.maxLine,
    this.isshowepisode = true,
    this.isshowviewInimage = true,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 20),
            ...items.map((Recomnovel item) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    '/noveldetail',
                    arguments: {
                      'novelId': item.id,
                      'allep': item.allep,
                      'bloc': BlocProvider.of<NovelDetailBloc>(context),
                    },
                  );
                },
                child: Container(
                  width: 115,
                  margin: const EdgeInsets.only(right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          children: [
                            Container(
                              height: 170,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: item.img,
                                fit: BoxFit.fill,
                                height: double.infinity,
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
                            ),
                            !isshowviewInimage
                                ? Positioned(
                                    top: 10,
                                    right: 10,
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 65,
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.remove_red_eye_rounded,
                                            size: 12,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            abbreviateNumber(item.view),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.athiti(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(),
                            item.end.name == 'END'
                                ? Positioned(
                                    top: 5,
                                    left: 5,
                                    child: Stack(
                                      children: [
                                        Image.asset(
                                          'assets/images/label.png',
                                          width: 55,
                                        ),
                                        Positioned(
                                          top: 1,
                                          left: 10,
                                          child: Text(
                                            'จบแล้ว',
                                            style: GoogleFonts.athiti(
                                              color: Colors.red[700],
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.athiti(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        item.tag,
                        maxLines: maxLine ?? 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.athiti(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          isshowviewInimage
                              ? const Icon(
                                  Icons.remove_red_eye_rounded,
                                  size: 12,
                                )
                              : Container(),
                          SizedBox(width: isshowviewInimage ? 3 : 0),
                          isshowviewInimage
                              ? Text(
                                  abbreviateNumber(item.view),
                                  style: GoogleFonts.athiti(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : Container(),
                          // const Spacer(),
                          const Spacer(),
                          isshowepisode
                              ? const Icon(
                                  Icons.list,
                                  size: 12,
                                )
                              : Container(),
                          const SizedBox(width: 2),
                          isshowepisode
                              ? Text(
                                  abbreviateNumber(item.allep),
                                  style: GoogleFonts.athiti(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
