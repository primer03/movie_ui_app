import 'package:bloctest/function/app_function.dart';
import 'package:bloctest/models/novel_model.dart';
import 'package:bloctest/pages/novel_detail.dart';
import 'package:bloctest/widgets/ContainerSkeltion.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class Novelcardhit extends StatelessWidget {
  final List<HitNovel> items;
  final int? maxLine;
  final bool isshowepisode;
  final bool isshowviewInimage;
  const Novelcardhit({
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
            ...items.map((HitNovel item) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const NovelDetail();
                  }));
                },
                child: Container(
                  width: 150,
                  margin: const EdgeInsets.only(right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          children: [
                            Container(
                              height: 220,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                // image: DecorationImage(
                                //   image: NetworkImage(item.img),
                                //   fit: BoxFit.fill,
                                // ),
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
                                    top: 10,
                                    left: -25,
                                    child: Transform.rotate(
                                        angle: -0.8,
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: 90,
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            color: Colors.red[700],
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Text(
                                            'จบแล้ว',
                                            style: GoogleFonts.athiti(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )),
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
                        item.title,
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
                                  size: 15,
                                )
                              : Container(),
                          SizedBox(width: isshowviewInimage ? 5 : 0),
                          isshowviewInimage
                              ? Text(
                                  abbreviateNumber(item.view),
                                  style: GoogleFonts.athiti(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : Container(),
                          // const Spacer(),
                          SizedBox(width: isshowviewInimage ? 10 : 0),
                          isshowepisode
                              ? const Icon(
                                  Icons.list,
                                  size: 15,
                                )
                              : Container(),
                          const SizedBox(width: 5),
                          isshowepisode
                              ? Text(
                                  abbreviateNumber(item.allep ?? 0),
                                  style: GoogleFonts.athiti(
                                    fontSize: 14,
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
