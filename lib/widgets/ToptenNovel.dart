import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ToptenNovel extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  const ToptenNovel({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const SizedBox(width: 20),
            ...items.asMap().entries.map((e) {
              final int index = e.key;
              final Map<String, dynamic> item = e.value;
              return Container(
                margin: const EdgeInsets.only(right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: (index + 1) < 10 ? 175 : 190,
                          height: 200,
                          alignment: Alignment.bottomLeft,
                          child: (index + 1) < 10
                              ? Text(
                                  (index + 1).toString(),
                                  style: GoogleFonts.athiti(
                                    fontSize: 120,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    height: 1.3,
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
                                      Icons.favorite,
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
            }),
          ],
        ),
      ),
    );
  }
}
