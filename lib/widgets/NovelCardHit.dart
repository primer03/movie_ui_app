import 'package:bloctest/bloc/noveldetail/novel_detail_bloc.dart';
import 'package:bloctest/function/app_function.dart';
import 'package:bloctest/models/novel_model.dart';
import 'package:bloctest/pages/novel_detail.dart';
import 'package:bloctest/widgets/ContainerSkeltion.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class Novelcardhit extends StatelessWidget {
  final List<HitNovel> items;
  final int? maxLine;
  final bool isshowepisode;
  final bool isshowviewInimage;
  final int category;

  const Novelcardhit({
    super.key,
    required this.items,
    this.maxLine,
    this.isshowepisode = true,
    this.isshowviewInimage = true,
    this.category = 0,
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
            ...items
                .where((item) =>
                    category == 0 ||
                    item.cat1 == category.toString() ||
                    item.cat2 == category.toString())
                .map((item) => _buildNovelCard(context, item)),
          ],
        ),
      ),
    );
  }

  Widget _buildNovelCard(BuildContext context, HitNovel item) {
    return GestureDetector(
      onTap: () {
        print('novelId: ${item.id}');
        Navigator.of(context).pushNamed(
          '/noveldetail',
          arguments: {
            'novelId': item.id,
            'allep': item.allep ?? 0,
            'bloc': BlocProvider.of<NovelDetailBloc>(context),
          },
        );
      },
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(item),
            const SizedBox(height: 10),
            _buildTitle(item),
            const SizedBox(height: 1),
            _buildSubtitle(item),
            const SizedBox(height: 5),
            _buildStats(item),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(HitNovel item) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: item.img,
            fit: BoxFit.fill,
            height: 220,
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: Colors.grey[400]!,
              highlightColor: Colors.grey[100]!,
              period: const Duration(milliseconds: 1000),
              child: const ContainerSkeltion(
                height: double.infinity,
                width: double.infinity,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
          ),
          if (!isshowviewInimage)
            Positioned(
              top: 10,
              right: 10,
              child: _buildViewCount(item),
            ),
          if (item.end.name == 'END')
            Positioned(
              top: 10,
              left: -25,
              child: _buildEndLabel(),
            ),
        ],
      ),
    );
  }

  Widget _buildViewCount(HitNovel item) {
    return Container(
      alignment: Alignment.center,
      width: 75,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }

  Widget _buildEndLabel() {
    return Transform.rotate(
      angle: -0.8,
      child: Container(
        alignment: Alignment.center,
        width: 90,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.red[700],
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          'จบแล้ว',
          style: GoogleFonts.athiti(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(HitNovel item) {
    return Text(
      item.name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.athiti(
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSubtitle(HitNovel item) {
    return Text(
      item.title,
      maxLines: maxLine ?? 1,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.athiti(
        fontSize: 12,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildStats(HitNovel item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (isshowviewInimage)
          const Icon(
            Icons.remove_red_eye_rounded,
            size: 15,
          ),
        if (isshowviewInimage) const SizedBox(width: 5),
        if (isshowviewInimage)
          Text(
            abbreviateNumber(item.view),
            style: GoogleFonts.athiti(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        if (isshowviewInimage) const SizedBox(width: 10),
        if (isshowepisode)
          const Icon(
            Icons.list,
            size: 15,
          ),
        if (isshowepisode) const SizedBox(width: 5),
        if (isshowepisode)
          Text(
            abbreviateNumber(item.allep ?? 0),
            style: GoogleFonts.athiti(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }
}
