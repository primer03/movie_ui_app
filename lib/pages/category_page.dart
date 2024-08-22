import 'package:bloctest/bloc/novelcate/novel_cate_bloc.dart';
import 'package:bloctest/function/app_function.dart';
import 'package:bloctest/main.dart';
import 'package:bloctest/models/novel_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
  late AutoScrollController autoScrollController;
  final ScrollController scrollController = ScrollController();

  bool isMenuVisible = true;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: widget.cate.length, vsync: this);
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
  Widget build(BuildContext context) {
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
          onPressed: () {
            novelBox.delete('cateID');
            novelBox.delete('searchData');
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
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
                  child: TabBar(
                    physics: const BouncingScrollPhysics(),
                    tabAlignment: TabAlignment.center,
                    controller: tabController,
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    onPressed: () {
                      print('Filter');
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
            return Stack(
              children: [
                ListView.builder(
                  controller: scrollController,
                  itemCount: state.allsearch.length,
                  itemBuilder: (context, index) {
                    final e = state.allsearch[index];
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
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 6,
                                  spreadRadius: 0.1,
                                  offset: const Offset(4, 5),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: e.img,
                                fit: BoxFit.fill,
                                height: 140,
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
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
                  offset: isMenuVisible ? Offset(0, 0) : Offset(0, -1),
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
                          '${state.allsearch.length} รายการ',
                          style: GoogleFonts.athiti(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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
