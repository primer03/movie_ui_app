import 'package:bloctest/pages/detail/movie_detail.dart';
import 'package:bloctest/pages/detail/novel_detail.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Novelcard extends StatelessWidget {
  final List<dynamic> items;
  final int? maxLine;
  final bool isshowepisode;
  final bool isshowviewInimage;
  const Novelcard({
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
            ...items.asMap().entries.map((e) {
              final int index = e.key;
              final dynamic item = e.value;
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/noveldetail',
                    arguments: {
                      'novelId': 12345, // Replace with actual novel ID
                      'allep': 50, // Replace with the actual number of episodes
                    },
                  );
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
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(item['image']),
                                  fit: BoxFit.cover,
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
                                            '123.2k',
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
                            Positioned(
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
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: const Text(
                                      'จบแล้ว',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        item['title'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        item['description'],
                        maxLines: maxLine ?? 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
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
                                  '1.2k',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : Container(),
                          // const Spacer(),
                          SizedBox(width: isshowviewInimage ? 10 : 0),
                          isshowepisode
                              ? Icon(
                                  Icons.list,
                                  size: 15,
                                )
                              : Container(),
                          SizedBox(width: 5),
                          isshowepisode
                              ? Text(
                                  '12 ตอน',
                                  style: TextStyle(
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
