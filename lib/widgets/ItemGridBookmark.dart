import 'package:bloctest/bloc/noveldetail/novel_detail_bloc.dart';
import 'package:bloctest/function/app_function.dart';
import 'package:bloctest/models/novel_bookmark_model.dart';
import 'package:bloctest/widgets/ContainerSkeltion.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class Itemgridbookmark extends StatelessWidget {
  const Itemgridbookmark({
    super.key,
    required this.width,
    required this.bookmarkList,
  });

  final double width;
  final List<Bookmark> bookmarkList;

  @override
  Widget build(BuildContext context) {
    print('bookmarkList: ${bookmarkList[0].userId}');
    return AlignedGridView.count(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: width > 600 ? 4 : 3,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      itemCount: bookmarkList.length,
      itemBuilder: (context, index) => _buildNovelItem(context, index),
    );
  }

  Widget _buildNovelItem(BuildContext context, int index) {
    final novel = bookmarkList[index];
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/noveldetail',
          arguments: {
            'novelId': novel.sbtId,
            'allep': novel.sbtAllep,
            'bloc': BlocProvider.of<NovelDetailBloc>(context),
          },
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              _buildCoverImage(novel.sbtImg),
              if (novel.sbtEnd.toUpperCase() == 'END') _buildEndBadge(),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            novel.sbtName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.athiti(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
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
