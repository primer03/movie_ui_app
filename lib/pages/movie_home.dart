import 'package:bloctest/Skeleton/movie_home_skeleton.dart';
import 'package:bloctest/bloc/novel/novel_bloc.dart';
import 'package:bloctest/pages/search_page.dart';
import 'package:bloctest/widgets/CarouselNovel.dart';
import 'package:bloctest/widgets/Categorymenu.dart';
import 'package:bloctest/widgets/HeadNovelCategory.dart';
import 'package:bloctest/widgets/NovelCardHit.dart';
import 'package:bloctest/widgets/NovelCardItem.dart';
import 'package:bloctest/widgets/NovelCardNew.dart';
import 'package:bloctest/widgets/ToptenNovelNew.dart';
import 'package:bloctest/widgets/newUpdateNovel.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class MovieHome extends StatefulWidget {
  const MovieHome({super.key});

  @override
  State<MovieHome> createState() => _MovieHomeState();
}

class _MovieHomeState extends State<MovieHome> {
  final ScrollController _scrollController = ScrollController();
  int _selectedcateIndex = 0;
  @override
  void initState() {
    super.initState();
    // _scrollController.addListener(() {
    //   if (_scrollController.position.userScrollDirection ==
    //       ScrollDirection.reverse) {
    //     print('down');
    //     context.read<PageBloc>().add(const PageScroll(isScrolling: false));
    //   } else {
    //     print('up');
    //     context.read<PageBloc>().add(const PageScroll(isScrolling: true));
    //   }
    //   if (_scrollController.offset <= 0) {
    //     print('top');
    //     context.read<PageBloc>().add(const PageScroll(isScrolling: true));
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white, // สีของ status bar
      statusBarIconBrightness: Brightness.dark, // สี icon ของ status bar
    ));

    return BlocBuilder<NovelBloc, NovelState>(builder: (context, state) {
      if (state is NovelLoading) {
        return const MovieHomeSkeleton();
      } else if (state is NovelLoaded) {
        print('loaded');
        // print(state.novels.newnovelupdate.upnovel.runtimeType);
        return SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Carouselnovel(promote: state.novels.promote),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'นิยายแนะนำ',
                    style: GoogleFonts.athiti(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Novelcardnew(
                  items: state.novels.recomnovel,
                ).animate().fadeIn(
                      duration: 200.ms,
                    ),
                const SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'หมวดหมู่',
                      style: GoogleFonts.athiti(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Category(cate: state.novels.cate),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    '10 นิยายยอดนิยม',
                    style: GoogleFonts.athiti(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Toptennovelnew(items: state.novels.top10).animate().fadeIn(
                      duration: 500.ms,
                    ),
                Row(
                  children: [
                    const SizedBox(width: 20),
                    const Text(
                      'นิยายฮิต',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        items: state.novels.cate.asMap().entries.map((e) {
                          return DropdownMenuItem<String>(
                            value: e.value.name,
                            child: Text(
                              e.value.name,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          );
                        }).toList(),
                        value: state.novels.cate[_selectedcateIndex].name,
                        onChanged: (String? value) {
                          int index = state.novels.cate.indexWhere((element) {
                            return element.name == value;
                          });
                          print(index);
                          setState(() {
                            _selectedcateIndex = index;
                          });
                        },
                        buttonStyleData: ButtonStyleData(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          height: 40,
                          width: 120,
                          overlayColor: WidgetStateProperty.all(Colors.black12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          elevation: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                        ),
                        style: GoogleFonts.athiti(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                Novelcardhit(
                  items: state.novels.hitNovel,
                  isshowepisode: false,
                  maxLine: 3,
                  isshowviewInimage: false,
                  category: _selectedcateIndex,
                ).animate().fadeIn(
                      duration: 500.ms,
                    ),
                const SizedBox(height: 20),
                HeadNovelCategory(
                    title: state.novels.columnnovel[0][0].colName),
                const SizedBox(height: 10),
                Novelcarditem(
                  items: state.novels.columnnovel[0][0].items,
                ).animate().fadeIn(
                      duration: 500.ms,
                    ),
                const SizedBox(height: 20),
                HeaderNovel(
                  title: 'นิยายอัปเดตล่าสุด',
                  route: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) {
                    //   return const MyHomePage();
                    // }));
                  },
                ),
                const SizedBox(height: 5),
                newUpdateNovel(items: state.novels.newnovelupdate.upnovel),
                ...state.novels.columnnovel.asMap().entries.map((e) {
                  int index = e.key;
                  if (index == 0) {
                    return const SizedBox();
                  }
                  return Column(
                    children: [
                      HeadNovelCategory(title: e.value[0].colName),
                      const SizedBox(height: 10),
                      Novelcarditem(items: e.value[0].items).animate().fadeIn(
                            duration: 500.ms,
                          ),
                      const SizedBox(height: 20),
                    ],
                  );
                }),
                // const SizedBox(height: 20),
                HeaderNovel(
                  title: 'การค้นหายอดนิยม',
                  route: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const SearchPage();
                    }));
                  },
                ),
                // const SizedBox(height: 5),
                // Container(
                //   padding: const EdgeInsets.symmetric(horizontal: 20),
                //   width: double.infinity,
                //   child: Column(
                //     children: List.generate(5, (index) {
                //       return AnimatedVisibilityWidget(
                //         key: Key('s-$index'),
                //         beforeChild: const SizedBox(
                //           width: 120,
                //           height: 80,
                //         ),
                //         child: Row(
                //           children: [
                //             Container(
                //               width: 120,
                //               height: 80,
                //               decoration: BoxDecoration(
                //                 borderRadius: BorderRadius.circular(10),
                //                 image: DecorationImage(
                //                   image: NetworkImage(_items[index]),
                //                   fit: BoxFit.cover,
                //                 ),
                //               ),
                //             ),
                //             const SizedBox(width: 10),
                //             const SizedBox(
                //               width: 150,
                //               child: Column(
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 children: [
                //                   Text(
                //                     'Kimi to Boku no Saigo no Senjou',
                //                     maxLines: 1,
                //                     overflow: TextOverflow.ellipsis,
                //                     style: TextStyle(
                //                       fontSize: 13,
                //                       fontWeight: FontWeight.bold,
                //                     ),
                //                   ),
                //                   SizedBox(height: 5),
                //                   Text(
                //                     'Action, Adventure, Fantasy',
                //                     maxLines: 1,
                //                     overflow: TextOverflow.ellipsis,
                //                     style: TextStyle(
                //                       fontSize: 11,
                //                       color: Colors.grey,
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //             ),
                //             const Spacer(),
                //             IconButton(
                //               onPressed: () {
                //                 Navigator.push(context,
                //                     MaterialPageRoute(builder: (context) {
                //                   return const MyHomePage();
                //                 }));
                //               },
                //               icon: const Icon(Icons.play_circle_outlined),
                //             ),
                //           ],
                //         ).animate().slideX(
                //               curve: Curves.easeInOut,
                //               duration: 500.ms,
                //               begin: -1.0,
                //               end: 0.0,
                //             ),
                //       );
                //     })
                //         .expand(
                //             (element) => [element, const SizedBox(height: 20)])
                //         .toList(),
                //   ),
                // ),
              ],
            ),
          ),
        );
      } else if (state is NovelError) {
        return Center(
          child: Text(state.message),
        );
      } else {
        return const SizedBox();
      }
    });
  }
}
