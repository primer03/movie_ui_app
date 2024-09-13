import 'dart:convert';

import 'package:bloctest/bloc/noveldetail/novel_detail_bloc.dart';
import 'package:bloctest/function/app_function.dart';
import 'package:bloctest/main.dart';
import 'package:bloctest/models/novel_allsearch_model.dart';
import 'package:bloctest/models/user_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class Cateview extends StatefulWidget {
  const Cateview({
    super.key,
    required this.scrollController,
    required this.isMenuVisible,
    required this.allsearch,
    required this.CateId,
  });

  final ScrollController scrollController;
  final bool isMenuVisible;
  final List<Searchnovel> allsearch;
  final int CateId;

  @override
  State<Cateview> createState() => _CateviewState();
}

class _CateviewState extends State<Cateview> {
  late List<Searchnovel> allSearch;
  String _sortValue = 'ยอดการดู';

  @override
  void initState() {
    super.initState();
    allSearch = _filterSearchResults(widget.allsearch, widget.CateId);
    _sortNovels(_sortValue);
  }

  List<Searchnovel> _filterSearchResults(
      List<Searchnovel> searchList, int cateId) {
    return searchList
        .where((novel) =>
            cateId == 0 ||
            novel.cat1 == cateId.toString() ||
            novel.cat2 == cateId.toString())
        .toList();
  }

  void _sortNovels(String value) {
    setState(() {
      _sortValue = value;
      switch (value) {
        case 'ยอดการดู':
          allSearch.sort((a, b) => b.view.compareTo(a.view));
          break;
        case 'จำนวนตอน':
          allSearch.sort((a, b) => b.allep.compareTo(a.allep));
          break;
        case 'อัพเดทล่าสุด':
          allSearch.sort((a, b) => b.updateEp.compareTo(a.updateEp));
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ListView.builder(
        //   controller: widget.scrollController,
        //   itemCount: allSearch.length,
        //   cacheExtent:
        //       500.0, // คือการกำหนดความสูงของ ListView ที่จะทำการเก็บไว้ในหน่วย pixel
        //   itemBuilder: (context, index) {
        //     return NovelItemCard(novel: allSearch[index], index: index);
        //   },
        // ),
        AlignedGridView.count(
          controller: widget.scrollController,
          crossAxisCount: 1,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          itemCount: allSearch.length,
          itemBuilder: (context, index) {
            return NovelItemCard(
              novel: allSearch[index],
              index: index,
              key: ValueKey('cateview-${allSearch[index].id}'),
            );
          },
        ),
        _buildAnimatedMenu(),
      ],
    );
  }

  Widget _buildAnimatedMenu() {
    return AnimatedSlide(
      offset: widget.isMenuVisible ? const Offset(0, 0) : const Offset(0, -1),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${allSearch.length} รายการ',
              style: GoogleFonts.athiti(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            _buildSortDropdown(),
          ],
        ),
      ),
    );
  }

  Widget _buildSortDropdown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        isExpanded: true,
        customButton: SvgPicture.asset(
          'assets/svg/Sort.svg',
          width: 20,
          height: 20,
        ),
        items: ['ยอดการดู', 'จำนวนตอน', 'อัพเดทล่าสุด']
            .map(
              (value) => DropdownMenuItem(
                value: value,
                child: Text(
                  value,
                  style: GoogleFonts.athiti(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: (value) {
          _sortNovels(value as String);
        },
        dropdownStyleData: DropdownStyleData(
          width: 160,
          padding: const EdgeInsets.symmetric(vertical: 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
            color: Colors.black,
          ),
          offset: const Offset(100, -10),
        ),
        menuItemStyleData: const MenuItemStyleData(
          padding: EdgeInsets.only(left: 16, right: 16),
        ),
      ),
    );
  }
}

class NovelItemCard extends StatelessWidget {
  const NovelItemCard({
    Key? key,
    required this.novel,
    required this.index,
  }) : super(key: key);

  final Searchnovel novel;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final userData = await novelBox.get('user');
        if (userData != null) {
          User user = User.fromJson(json.decode(userData));
          Navigator.of(context).pushNamed(
            '/noveldetail',
            arguments: {
              'novelId': novel.id,
              'allep': novel.allep,
              'bloc': BlocProvider.of<NovelDetailBloc>(context),
              'user': user,
            },
          );
        }
      },
      child: Card(
        elevation: 0,
        color: Colors.white,
        margin: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 20,
          top: index == 0 ? 50 : 0,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildThumbnail(),
            const SizedBox(width: 15),
            Expanded(child: _buildNovelDetails()),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 3,
            spreadRadius: 0.1,
            offset: const Offset(3, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            CachedNetworkImage(
              key: Key('catevieimage-${novel.id}'),
              imageUrl: novel.img,
              fit: BoxFit.fill,
              height: 140,
              width: 100,
              errorWidget: (context, url, error) => const Center(
                child: Icon(Icons.error),
              ),
              placeholder: (context, url) => const NovelImageShimmer(),
            ),
            if (novel.end.name == 'END')
              Positioned(
                top: 3,
                left: 2,
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/images/label.png',
                      width: 50,
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
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNovelDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          novel.name,
          style: GoogleFonts.athiti(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          novel.title,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.athiti(
            fontSize: 14,
            color: Colors.grey[500],
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            const Icon(Icons.remove_red_eye, size: 16),
            const SizedBox(width: 5),
            Text(
              abbreviateNumber(novel.view),
              style: GoogleFonts.athiti(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.list, size: 16),
            const SizedBox(width: 5),
            Text(
              abbreviateNumber(novel.allep),
              style: GoogleFonts.athiti(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.thumb_up, size: 16),
            const SizedBox(width: 5),
            Text(
              abbreviateNumber(novel.score),
              style: GoogleFonts.athiti(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class NovelImageShimmer extends StatelessWidget {
  const NovelImageShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[400]!,
      highlightColor: Colors.grey[100]!,
      period: const Duration(milliseconds: 1000),
      child: Container(
        height: 140,
        width: 100,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
