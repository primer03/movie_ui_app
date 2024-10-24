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
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key, required this.cateId, required this.cate})
      : super(key: key);
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
  final List<ScrollController> scrollControllers = [];
  final List<String> cateImg = [
    'assets/genre/heart-like-svgrepo-com.svg',
    'assets/genre/castle-svgrepo-com.svg',
    'assets/genre/holy-scriptures-svgrepo-com.svg',
    'assets/genre/yin-yang-taiji-diagram-svgrepo-com.svg',
    'assets/genre/chess-svgrepo-com.svg',
    'assets/genre/compass-svgrepo-com.svg',
  ];

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
        // Update the floating button only when it's not already shown
        if (!isShowFloating) {
          setState(() {
            isShowFloating = true;
          });
        }
      }
    });

    scrollController.addListener(() {
      final isScrollingDown = scrollController.position.userScrollDirection ==
          ScrollDirection.reverse;
      final isAtTop = scrollController.position.pixels == 0;

      // Handle showing and hiding the floating button efficiently
      if (isScrollingDown && !isShowFloating) {
        // Only update if the floating button is not already shown
        setState(() {
          isShowFloating = true;
        });
      } else if (!isScrollingDown && isShowFloating && isAtTop) {
        // Only hide if the floating button is currently shown
        setState(() {
          isShowFloating = false;
        });
      }

      // Handle menu visibility efficiently
      if (isScrollingDown && isMenuVisible) {
        // Only hide the menu if it's currently visible
        setState(() {
          isMenuVisible = false;
        });
      } else if (!isScrollingDown && !isMenuVisible) {
        // Only show the menu if it's currently hidden
        setState(() {
          isMenuVisible = true;
        });
      }
    });

    // Fetch the initial data for NovelCate
    context.read<NovelCateBloc>().add(FetchNovelCate(cateID: widget.cateId));
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
    pageController.dispose();
    autoScrollController.dispose();
    scrollController.dispose();
    novelBox.delete('cateID');
    novelBox.delete('searchData');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(
          'หมวดหมู่',
          style: GoogleFonts.athiti(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.pushNamed(context, '/search'),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Container(
            color: Colors.white,
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
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ).animate().fade())
                      : TabBar(
                          tabAlignment: TabAlignment.start,
                          physics: const BouncingScrollPhysics(),
                          controller: tabController,
                          onTap: (value) {
                            pageController.animateToPage(
                              value,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOutCubic,
                            );
                          },
                          isScrollable: true,
                          labelColor: Colors.black,
                          labelStyle: GoogleFonts.athiti(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: Colors.black,
                          tabs: widget.cate
                              .map((e) => Tab(text: e.name))
                              .toList(),
                        ),
                ),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[300]!, width: 2),
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    onPressed: () {
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
      body: BlocConsumer<NovelCateBloc, NovelCateState>(
        listener: (context, state) {
          if (state is NovelCateError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          } else if (state is NovelCateLoaded) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              pageController.jumpToPage(widget.cateId);
            });
          }
        },
        builder: (context, state) {
          if (state is NovelCateLoading) {
            return CateSkeleton().animate().fade();
          } else if (state is NovelCateLoaded) {
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
                  offset: isCateVisible ? Offset.zero : const Offset(0, -1),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubic,
                  child: Container(
                    height: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        if (isCateVisible)
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 3,
                            offset: const Offset(3, 5),
                          ),
                      ],
                    ),
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        childAspectRatio: 1.5,
                      ),
                      itemCount: widget.cate.where((e) => e.id != 0).length,
                      itemBuilder: (context, index) {
                        final e =
                            widget.cate.where((e) => e.id != 0).toList()[index];
                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: Colors.white,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Material(
                              color: Colors.transparent,
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
                                child: Column(
                                  children: [
                                    SvgPicture.asset(
                                      cateImg[index],
                                      width: 50,
                                      height: 50,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      e.name,
                                      style: GoogleFonts.athiti(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
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
              elevation: 2.0,
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
