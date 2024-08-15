import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeadNovelCategory extends StatelessWidget {
  final String title;
  const HeadNovelCategory({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Divider(
              color: Colors.grey[300],
              height: 20,
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.athiti(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            flex: 5,
            child: Divider(
              color: Colors.grey[300],
              height: 20,
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderNovel extends StatelessWidget {
  final String title;
  final VoidCallback route;

  const HeaderNovel({super.key, required this.title, required this.route});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 20),
        Text(
          title,
          style: GoogleFonts.athiti(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: route, // ใช้ route ฟังก์ชันในการนำทาง
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            minimumSize: const Size(0, 0),
            overlayColor: Colors.black.withOpacity(0.1),
          ),
          child: Text(
            "ดูทั้งหมด",
            style: GoogleFonts.athiti(
              fontSize: 13,
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 20),
      ],
    );
  }
}
