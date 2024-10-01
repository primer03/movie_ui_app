import 'dart:convert';

import 'package:bloctest/bloc/noveldetail/novel_detail_bloc.dart';
import 'package:bloctest/function/app_function.dart';
import 'package:bloctest/main.dart';
import 'package:bloctest/models/novel_allsearch_model.dart';
import 'package:bloctest/models/user_model.dart';
import 'package:bloctest/widgets/ContainerSkeltion.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class ItemNovelSearch extends StatelessWidget {
  const ItemNovelSearch({
    super.key,
    required this.width,
    required this.getCategoryName,
    required this.searchnovel,
  });

  final double width;
  final String Function(String id) getCategoryName;
  final List<Searchnovel> searchnovel;

  @override
  Widget build(BuildContext context) {
    return AlignedGridView.count(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: width > 600 ? 4 : 3,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      itemCount: searchnovel.length,
      itemBuilder: (context, index) => _buildNovelItem(context, index),
    );
  }

  Widget _buildNovelItem(BuildContext context, int index) {
    final novel = searchnovel[index];
    return GestureDetector(
      onTap: () async {
        final userData = await novelBox.get('user');
        if (userData != null) {
          List<Searchnovel> lastSearch = [];
          if (novelBox.containsKey('lastsearchnoval')) {
            lastSearch = (json.decode(novelBox.get('lastsearchnoval')) as List)
                .map((e) => Searchnovel.fromJson(e))
                .toList();
            lastSearch.remove(novel);
          }
          lastSearch.insert(0, novel);
          if (lastSearch.length > 10) lastSearch.removeLast();
          novelBox.put('lastsearchnoval', json.encode(lastSearch));
          lastSearch
              .forEach((element) => print('lastsearchnoval: ${element.name}'));
          User user = User.fromJson(json.decode(userData));
          Navigator.of(context).pushNamed('/noveldetail', arguments: {
            'novelId': novel.id,
            'allep': novel.allep,
            'bloc': BlocProvider.of<NovelDetailBloc>(context),
            'user': user,
          });
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              _buildCoverImage(novel.img),
              if (novel.end.name == 'END') _buildEndBadge(),
              _buildInfoOverlay(novel),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            novel.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.athiti(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '${getCategoryName(novel.cat1)} ${getCategoryName(novel.cat2)}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.athiti(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _buildCoverImage(String imageUrl) {
    return Container(
      width: 120,
      height: 170,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.fill,
          width: double.infinity,
          height: 170,
          errorWidget: (context, url, error) => Icon(Icons.error),
          placeholder: (context, url) => Shimmer.fromColors(
            baseColor: Colors.grey[400]!,
            highlightColor: Colors.grey[100]!,
            period: const Duration(milliseconds: 1000),
            child: ContainerSkeltion(
              height: 170,
              width: double.infinity,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEndBadge() {
    return Positioned(
      top: 5,
      left: 3,
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
        decoration: BoxDecoration(
          color: const Color(0xFFdc3545),
          borderRadius: BorderRadius.circular(5),
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
    );
  }

  Widget _buildInfoOverlay(Searchnovel novel) {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          gradient: const LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black, Colors.transparent],
          ),
        ),
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            _buildInfoItem(Icons.remove_red_eye_rounded, novel.view),
            const Spacer(),
            _buildInfoItem(Icons.list, novel.allep),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, int value) {
    return Row(
      children: [
        Icon(icon, size: 10, color: Colors.white),
        const SizedBox(width: 2),
        Text(
          abbreviateNumber(value),
          style: GoogleFonts.athiti(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            shadows: const [
              Shadow(color: Colors.black, offset: Offset(1, 1), blurRadius: 1)
            ],
          ),
        ),
      ],
    );
  }
}
