import 'package:bloctest/models/novel_allsearch_model.dart';
import 'package:bloctest/models/novel_model.dart';
import 'package:bloctest/repositories/novel_repository.dart';
import 'package:bloctest/widgets/AnimatedVisibilityWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class Category extends StatelessWidget {
  final List<Cate> cate;
  const Category({super.key, required this.cate});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const SizedBox(width: 20),
          ...cate.asMap().entries.map((entry) {
            final index = entry.key;
            final e = entry.value;

            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: AnimatedVisibilityWidget(
                key: ValueKey(e),
                beforeChild: const SizedBox(
                  width: 100,
                  height: 45,
                ),
                child: GestureDetector(
                  onTap: () async {
                    print('Category: ${e.img}');
                    Navigator.pushNamed(context, '/category',
                        arguments: {'cateId': e.id, 'cate': cate});
                    // List<Searchnovel> search =
                    //     await NovelRepository().searchNovels(e.id);
                    // print(search[0].cat1);
                    // print(search[0].cat2);
                  },
                  child: Chip(
                    label: Text(
                      e.name,
                      style: GoogleFonts.athiti(
                        fontSize: 14,
                        color: index == 0 ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: index == 0 ? Colors.black : Colors.white,
                    side: BorderSide.none,
                  ).animate().fadeIn(delay: 200.ms),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
