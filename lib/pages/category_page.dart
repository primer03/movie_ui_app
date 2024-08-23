import 'dart:io';

import 'package:bloctest/bloc/novelcate/novel_cate_bloc.dart';
import 'package:bloctest/function/app_function.dart';
import 'package:bloctest/main.dart';
import 'package:bloctest/models/novel_allsearch_model.dart';
import 'package:bloctest/models/novel_model.dart';
import 'package:bloctest/pages/onboard_one.dart';
import 'package:bloctest/pages/onboarding_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:logger/web.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key, required this.cateId, required this.cate});
  final int cateId;
  final List<Cate> cate;

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with TickerProviderStateMixin {
  late TabController tabController;
  late PageController pageController;
  late AutoScrollController autoScrollController;
  final ScrollController scrollController = ScrollController();

  bool isMenuVisible = true;
  bool isCateVisible = false;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: widget.cate.length, vsync: this);
    pageController = PageController();
    autoScrollController = AutoScrollController();
    tabController.animateTo(widget.cateId);
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setState(() {
          isMenuVisible = false;
        });
      } else if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        setState(() {
          isMenuVisible = true;
        });
      }
    });

    context.read<NovelCateBloc>().add(FetchNovelCate(cateID: widget.cateId));
  }

  @override
  void dispose() async {
    super.dispose();
    print('dispose');
    tabController.dispose();
    pageController.dispose();
    autoScrollController.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.cate[0].img);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(
          'หมวดหมู่',
          style: GoogleFonts.athiti(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () async {
            await novelBox.delete('cateID');
            await novelBox.delete('searchData');
            // var allhive = await novelBox.toMap();
            // allhive.forEach((key, value) {
            //   Logger().i('key: $key');
            // });
            // print(await novelBox.get('cateID'));
            // print(await novelBox.get('searchData'));
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final cacheManager = DefaultCacheManager();
              await cacheManager.emptyCache(); // ลบแคชทั้งหมด
              // Navigator.pushNamed(context, '/search');
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: isCateVisible
                      ? Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            'หมวดหมู่',
                            style: GoogleFonts.athiti(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ).animate().fade()
                      : TabBar(
                          physics: const BouncingScrollPhysics(),
                          tabAlignment: TabAlignment.center,
                          controller: tabController,
                          onTap: (value) {
                            pageController.animateToPage(
                              value,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOutCubic,
                            );
                            print('TabBar: $value');
                          },
                          isScrollable: true,
                          labelColor: Colors.black,
                          labelStyle: GoogleFonts.athiti(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: Colors.black,
                          tabs: widget.cate
                              .map(
                                (e) => Tab(
                                  text: e.name,
                                ),
                              )
                              .toList(),
                        ),
                ),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      border: Border(
                    bottom: BorderSide(color: Colors.grey[300]!, width: 2),
                  )),
                  child: IconButton(
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    style: IconButton.styleFrom(
                      surfaceTintColor: Colors.white,
                      highlightColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    onPressed: () {
                      print('Filter');
                      setState(() {
                        isCateVisible = !isCateVisible;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: BlocBuilder<NovelCateBloc, NovelCateState>(
        builder: (context, state) {
          if (state is NovelCateLoading) {
            return Center(
              child: LoadingAnimationWidget.discreteCircle(
                color: Colors.grey,
                secondRingColor: Colors.black,
                thirdRingColor: Colors.red[900]!,
                size: 50,
              ),
            );
          } else if (state is NovelCateLoaded) {
            pageController = PageController(initialPage: widget.cateId);
            return Stack(
              children: [
                PageView.builder(
                  controller: pageController,
                  itemCount: widget.cate.length,
                  onPageChanged: (value) {
                    tabController.animateTo(value);
                  },
                  itemBuilder: (context, index) {
                    return Cateview(
                      key: Key('cateview-${widget.cate[index].id}'),
                      scrollController: scrollController,
                      isMenuVisible: isMenuVisible,
                      allsearch: state.allsearch,
                      CateId: widget.cate[index].id,
                    );
                  },
                ),
                AnimatedSlide(
                  offset:
                      isCateVisible ? const Offset(0, 0) : const Offset(0, -1),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubic,
                  child: Container(
                    height: double.infinity,
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 10,
                      right: 10,
                      bottom: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: isCateVisible ? 3 : 0,
                          spreadRadius: isCateVisible ? 0.1 : 0,
                          offset: isCateVisible
                              ? const Offset(3, 5)
                              : const Offset(0, 0),
                        )
                      ],
                    ),
                    child: GridView.builder(
                      shrinkWrap: true, // ใช้ควบคุมความสูง
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        childAspectRatio: 1,
                      ),
                      itemCount: widget.cate.where((e) => e.id != 0).length,
                      itemBuilder: (context, index) {
                        final e =
                            widget.cate.where((e) => e.id != 0).toList()[index];
                        return Card(
                          elevation: 0,
                          color: Colors.white,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isCateVisible = false;
                              });
                              tabController.animateTo(index + 1);
                              pageController.animateToPage(
                                index + 1,
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOutCubic,
                              );
                            },
                            child: CachedNetworkImage(
                              key: Key('cateimage-${e.id}'),
                              imageUrl: e.img,
                              fit: BoxFit.fill,
                              height: 50,
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey[400]!,
                                highlightColor: Colors.grey[100]!,
                                period: const Duration(milliseconds: 1000),
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          } else if (state is NovelCateEmpty) {
            return const Center(child: Text('No data'));
          } else if (state is NovelCateError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}

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
  void sortnovel(String value) {
    switch (value) {
      case 'ยอดการดู':
        widget.allsearch.sort((a, b) => b.view.compareTo(a.view));
        break;
      case 'จำนวนตอน':
        widget.allsearch.sort((a, b) => b.allep.compareTo(a.allep));
        break;
      case 'อัพเดทล่าสุด':
        widget.allsearch.sort((a, b) => b.updateEp.compareTo(a.updateEp));
        break;
      default:
        widget.allsearch.sort((a, b) => b.view.compareTo(a.view));
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.allsearch = widget.allsearch
        .where((element) =>
            widget.CateId == 0 ||
            element.cat1 == widget.CateId.toString() ||
            element.cat2 == widget.CateId.toString())
        .toList();
    // print('allsearch: ${widget.allsearch[0].updateEp}');
    return Stack(
      children: [
        ListView.builder(
          controller: widget.scrollController,
          itemCount: widget.allsearch.length,
          itemBuilder: (context, index) {
            final e = widget.allsearch[index];
            return Card(
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
                      child: CachedNetworkImage(
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
            );
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
                  '${widget.allsearch.length} รายการ',
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
                      ...['ยอดการดู', 'จำนวนตอน', 'อัพเดทล่าสุด'].map(
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
                      ),
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
