import 'package:bloctest/bloc/noveldetail/novel_detail_bloc.dart';
import 'package:bloctest/function/app_function.dart';
import 'package:bloctest/models/novel_allsearch_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class Cateview extends StatefulWidget {
  Cateview({
    super.key,
    required this.scrollController,
    required this.isMenuVisible,
    required this.allsearch,
    required this.CateId,
  });

  final ScrollController scrollController;
  final bool isMenuVisible;
  List<Searchnovel> allsearch;
  final int CateId;

  @override
  State<Cateview> createState() => _CateviewState();
}

class _CateviewState extends State<Cateview> {
  List<Searchnovel> allSearch = [];
  void sortnovel(String value) {
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
      default:
        allSearch.sort((a, b) => b.view.compareTo(a.view));
    }
  }

  @override
  void initState() {
    super.initState();
    allSearch = widget.allsearch
        .where((element) =>
            widget.CateId == 0 ||
            element.cat1 == widget.CateId.toString() ||
            element.cat2 == widget.CateId.toString())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          controller: widget.scrollController,
          itemCount: allSearch.length,
          itemBuilder: (context, index) {
            final e = allSearch[index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                  '/noveldetail',
                  arguments: {
                    'novelId': e.id,
                    'allep': e.allep,
                    'bloc': BlocProvider.of<NovelDetailBloc>(context),
                  },
                );
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
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
                              key: Key('catevieimage-${e.id}'),
                              imageUrl: e.img,
                              fit: BoxFit.fill,
                              height: 140,
                              placeholder: (context, url) => Shimmer.fromColors(
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
                              ),
                            ),
                            e.end.name == 'END'
                                ? Positioned(
                                    top: 10,
                                    left: -25,
                                    child: Transform.rotate(
                                        angle: -0.9,
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: 80,
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            color: Colors.red[700],
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Text(
                                            'จบแล้ว',
                                            style: GoogleFonts.athiti(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e.name,
                            style: GoogleFonts.athiti(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            e.title,
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.remove_red_eye,
                                size: 16,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                abbreviateNumber(e.view),
                                style: GoogleFonts.athiti(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Icon(
                                Icons.list,
                                size: 16,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                abbreviateNumber(e.allep),
                                style: GoogleFonts.athiti(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Icon(
                                Icons.thumb_up,
                                size: 16,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                abbreviateNumber(e.score),
                                style: GoogleFonts.athiti(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fade(duration: 400.ms, curve: Curves.easeInOut);
          },
        ),
        AnimatedSlide(
          offset: widget.isMenuVisible ? Offset(0, 0) : Offset(0, -1),
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
                DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    isExpanded: true,
                    customButton: SvgPicture.asset(
                      'assets/svg/Sort.svg',
                      width: 20,
                      height: 20,
                    ),
                    items: [
                      ...['ยอดการดู', 'จำนวนตอน', 'อัพเดทล่าสุด']
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                e,
                                style: GoogleFonts.athiti(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ],
                    onChanged: (value) {
                      print('value: $value');
                      setState(() {
                        sortnovel(value.toString());
                      });
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
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
