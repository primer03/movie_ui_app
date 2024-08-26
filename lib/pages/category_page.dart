import 'package:bloctest/bloc/novelcate/novel_cate_bloc.dart';
import 'package:bloctest/main.dart';
import 'package:bloctest/models/novel_model.dart';
import 'package:bloctest/widgets/CateSkeletion.dart';
import 'package:bloctest/widgets/CateView.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
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
  bool isShowFloating = false;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: widget.cate.length, vsync: this);
    pageController = PageController();
    autoScrollController = AutoScrollController();
    tabController.animateTo(widget.cateId);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients &&
          scrollController.position.pixels != 0) {
        setState(() {
          isShowFloating = true;
        });
      }
    });
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isShowFloating) {
          setState(() {
            isShowFloating = true;
          });
        }
        setState(() {
          isMenuVisible = false;
        });
      } else if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (scrollController.position.pixels == 0) {
          setState(() {
            isShowFloating = false;
          });
        }
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
    await novelBox.delete('cateID');
    await novelBox.delete('searchData');
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
            decoration: const BoxDecoration(
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
            return CateSkeleton().animate().fade();
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
      floatingActionButton: isShowFloating
          ? FloatingActionButton(
              onPressed: () async {
                await scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
                setState(() {
                  isShowFloating = scrollController.position.pixels != 0;
                  isMenuVisible = true;
                });
              },
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              mini: true,
              elevation: 8.0,
              child: SvgPicture.asset(
                'assets/svg/Expand_up@3x.svg',
                width: 20,
                height: 20,
                color: Colors.white,
              ),
            )
          : null,
    );
  }
}
