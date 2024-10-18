import 'package:bloctest/widgets/FishbonePainter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MembershipCard extends StatelessWidget {
  final String title;
  final String price;
  final Color color;

  const MembershipCard({
    super.key,
    required this.title,
    required this.price,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
          width: double.infinity,
          height: 140,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  color: Colors.white, // เปลี่ยนสีของ Container เป็นสีเขียว
                  width: double.infinity,
                  height: 130,
                  child: CustomPaint(
                    size: const Size(double.infinity, 130),
                    painter: FishbonePainter(
                      color: color,
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 130,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FittedBox(
                            child: Text(
                              price,
                              style: GoogleFonts.athiti(
                                color: color,
                                fontSize: price.length > 4 ? 55 : 70,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'บาท',
                                style: GoogleFonts.athiti(
                                  color: color,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                title,
                                style: GoogleFonts.athiti(
                                  color: color,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'สมาชิก',
                    style: GoogleFonts.athiti(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'VIP',
                    style: GoogleFonts.athiti(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
        Positioned(
          left: 10,
          top: 9,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(100)),
            ),
          ),
        ),
        Positioned(
          left: 10,
          bottom: 9,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(100)),
            ),
          ),
        ),
      ],
    );
  }
}
