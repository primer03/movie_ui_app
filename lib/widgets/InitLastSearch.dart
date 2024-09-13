import 'dart:convert';

import 'package:bloctest/bloc/noveldetail/novel_detail_bloc.dart';
import 'package:bloctest/function/app_function.dart';
import 'package:bloctest/models/novel_allsearch_model.dart';
import 'package:bloctest/models/user_model.dart';
import 'package:bloctest/widgets/ContainerSkeltion.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../main.dart';

class InitLastSearch extends StatelessWidget {
  final List<String> lastSearch;
  final VoidCallback onClear;
  final ValueChanged<String> onRemove;
  final ValueChanged<String> changeSearch;
  final List<Searchnovel> lastSearchListData;
  // build context
  final BuildContext context;

  const InitLastSearch({
    super.key,
    required this.lastSearch,
    required this.onRemove,
    required this.onClear,
    required this.changeSearch,
    required this.lastSearchListData,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        _buildHeader(),
        const SizedBox(height: 10),
        _buildSearchChips(),
        const SizedBox(height: 20),
        _buildRecentReads(),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'ค้นหาล่าสุด',
            style: GoogleFonts.athiti(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onClear,
            child: Text(
              'ลบทั้งหมด',
              style: GoogleFonts.athiti(
                color: Colors.red[900],
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchChips() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        spacing: 5,
        runSpacing: -10,
        children: lastSearch.map((value) {
          return GestureDetector(
            onTap: () => changeSearch(value),
            child: Chip(
              deleteButtonTooltipMessage: 'ลบ',
              padding: const EdgeInsets.symmetric(horizontal: 5),
              label: Text(
                value,
                style: GoogleFonts.athiti(
                  color: const Color(0xFF96979B),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              backgroundColor: Colors.white,
              onDeleted: () => onRemove(value),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              deleteIcon: SvgPicture.asset(
                'assets/svg/close_ring_duotone_line@3x.svg',
                width: 25,
                height: 25,
                color: const Color(0xff96979B),
              ),
              side: const BorderSide(
                color: Color(0xFF9D9D9D9),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRecentReads() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: lastSearchListData.length,
        itemBuilder: (context, index) {
          return _buildRecentReadCard(lastSearchListData[index]);
        },
      ),
    );
  }

  Widget _buildRecentReadCard(Searchnovel novel) {
    return GestureDetector(
      onTap: () async {
        final userData = await novelBox.get('user');
        User user = User.fromJson(json.decode(userData));
        Navigator.of(context).pushNamed('/noveldetail', arguments: {
          'novelId': novel.id,
          'allep': novel.allep,
          'bloc': BlocProvider.of<NovelDetailBloc>(context),
          'user': user,
        });
      },
      child: Card(
        elevation: 0,
        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: [
            _buildImage(novel),
            const SizedBox(width: 15),
            Expanded(
              child: _buildCardContent(novel),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(Searchnovel novel) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 2,
            spreadRadius: 0.1,
            offset: const Offset(3, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: novel.img,
              fit: BoxFit.cover,
              height: 120,
              errorWidget: (context, url, error) => Icon(Icons.error),
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Colors.grey[400]!,
                highlightColor: Colors.grey[100]!,
                period: const Duration(milliseconds: 1000),
                child: ContainerSkeltion(
                  height: 100,
                  width: 100,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Positioned(
              top: 5,
              left: 3,
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/label.png',
                    width: 40,
                  ),
                  Positioned(
                    top: 1,
                    left: 9,
                    child: Text(
                      'จบแล้ว',
                      style: GoogleFonts.athiti(
                        color: Colors.red[700],
                        fontSize: 8,
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

  Widget _buildCardContent(Searchnovel novel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          novel.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.athiti(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          novel.title,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 5),
        _buildStatsRow(novel),
      ],
    );
  }

  Widget _buildStatsRow(Searchnovel novel) {
    return Row(
      children: [
        _buildStatItemx(Icons.remove_red_eye, abbreviateNumber(novel.view)),
        const SizedBox(width: 10),
        _buildStatItemx(Icons.list, abbreviateNumber(novel.allep)),
      ],
    );
  }

  Widget _buildStatItemx(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16),
        const SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
