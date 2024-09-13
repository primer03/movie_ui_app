import 'dart:async';
import 'dart:convert';
import 'package:bloctest/bloc/novelsearch/novelsearch_bloc.dart';
import 'package:bloctest/function/app_function.dart';
import 'package:bloctest/main.dart';
import 'package:bloctest/models/novel_allsearch_model.dart';
import 'package:bloctest/models/novel_model.dart';
import 'package:bloctest/widgets/InitLastSearch.dart';
import 'package:bloctest/widgets/ItemNovelSearch.dart';
import 'package:bloctest/widgets/gridskeleton.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:logger/web.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Timer? _debounce;
  final List<String> lastSearch = [];
  TextEditingController searchController = TextEditingController();
  List<Cate> cate = [];
  FocusNode focusNode = FocusNode();
  int selectCate = 0;
  List<Searchnovel> novelSearch = [];
  List<Searchnovel> lastSearchListData = [];

  Future<void> _onSearch(String value) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 900), () {
      print('Search: $value');
      if (value.isNotEmpty) {
        context.read<NovelsearchBloc>().add(SearchNovelByName(value));
        if (lastSearch.isEmpty) {
          lastSearch.add(value);
        } else {
          if (lastSearch.contains(value)) {
            lastSearch.remove(value);
          }
          lastSearch.insert(0, value);
        }
        novelBox.put('lastSearch', lastSearch);

        setState(() {
          lastSearch;
          selectCate = 0;
        });
      } else {
        focusNode.unfocus();
        print('Search: $value');
        _onFetchLastSearch();
        setState(() {});
      }
    });
  }

  Future<void> _onClear() async {
    setState(() {
      lastSearch.clear();
      novelBox.put('lastSearch', lastSearch);
      Logger().i('lastSearch: $lastSearch');
    });
  }

  Future<void> _onRemove(String value) async {
    setState(() {
      lastSearch.remove(value);
      novelBox.put('lastSearch', lastSearch);
      Logger().i('lastSearch: $lastSearch');
    });
  }

  void testallsearch(List<Searchnovel> searchnovel) {
    print('searchnovelxxx: ${searchnovel[0].name}');
    novelSearch = searchnovel;
  }

  void changSearch(String value) {
    searchController.text = value;
    _onSearch(value);
  }

  Future<void> _onFetch() async {
    List<dynamic> cateList = json.decode(await novelBox.get('categoryData'));
    cate = parseList<Cate>(cateList, Cate.fromJson);
    final List<String> lastSearchList =
        await novelBox.get('lastSearch', defaultValue: <String>[]);
    setState(() {
      lastSearch.addAll(lastSearchList);
      cate = cate;
    });
  }

  Future<void> _onFetchLastSearch() async {
    List<Searchnovel> lastSearchNovel = [];
    if (novelBox.containsKey('lastsearchnoval')) {
      lastSearchNovel = (json.decode(novelBox.get('lastsearchnoval')) as List)
          .map((e) => Searchnovel.fromJson(e))
          .toList();
    }
    lastSearchNovel
        .forEach((element) => print('lastSearchNovel: ${element.name}'));
    print('lastSearchNovel: ${lastSearchNovel.length}');
    setState(() {
      lastSearchListData = lastSearchNovel;
    });
  }

  String getCategoryName(String id) => id.isEmpty
      ? ''
      : cate
          .firstWhere((e) => e.id == int.parse(id),
              orElse: () => Cate(id: -1, name: '', des: '', img: ''))
          .name;

  @override
  void initState() {
    super.initState();
    // novelBox.delete('lastSearch');
    novelBox.delete('searchDatabyName');
    _onFetch();
    _onFetchLastSearch();
  }

  Future<void> _clearcach() async {
    await novelBox.delete('searchDatabyName');
    await novelBox.delete('searchData');
    // await novelBox.delete('cateID');
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _clearcach();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: true,
              leadingWidth: 40,
              snap: true,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme(
                    brightness: Brightness.light,
                    primary: Colors.black, // Use single color directly
                    onPrimary: Colors.white,
                    secondary: Colors.blue,
                    onSecondary: Colors.white,
                    surface: Colors.grey[200]!,
                    onSurface: Colors.black,
                    error: Colors.red,
                    onError: Colors.white,
                  ),
                  textSelectionTheme:
                      const TextSelectionThemeData(cursorColor: Colors.blue),
                ),
                child: SizedBox(
                  child: TextField(
                    style: GoogleFonts.athiti(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    onChanged: _onSearch,
                    focusNode: focusNode,
                    controller: searchController,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      hintText: 'ค้นหา',
                      hintStyle: GoogleFonts.athiti(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      prefixIcon: const Icon(Iconsax.search_normal_1),
                      suffixIconConstraints: const BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      suffixIcon: searchController.text.isNotEmpty
                          ? DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                isExpanded: true,
                                customButton: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    child: SvgPicture.asset(
                                      'assets/svg/Filter@3x.svg',
                                      width: 25,
                                      height: 25,
                                    ),
                                  ),
                                ),
                                buttonStyleData: ButtonStyleData(
                                  overlayColor: WidgetStateProperty.all(
                                    Colors.white,
                                  ),
                                ),
                                items: [
                                  ...[
                                    'ล้างการค้นหา',
                                    'ยอดการดู',
                                    'จำนวนตอน',
                                    'อัพเดทล่าสุด'
                                  ].map(
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
                                  // print('value: $value');
                                  if (value == 'ล้างการค้นหา') {
                                    searchController.clear();
                                    _onSearch('');
                                    focusNode.unfocus();
                                    setState(() {});
                                    return;
                                  }
                                  context.read<NovelsearchBloc>().add(
                                        SortNovel(
                                          sort: value.toString(),
                                          searchnovel: novelSearch,
                                        ),
                                      );
                                },
                                dropdownStyleData: DropdownStyleData(
                                  width: 160,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.black,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        blurRadius: 6,
                                        spreadRadius: 0.1,
                                        offset: const Offset(4, 5),
                                      ),
                                    ],
                                  ),
                                  offset: const Offset(-120, -10),
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  padding: EdgeInsets.only(left: 16, right: 16),
                                ),
                              ),
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide(
                          color: Colors.grey[400]!,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide(
                          color: Colors.grey[300]!,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: searchController.text.isEmpty
                    ? const Size.fromHeight(20)
                    : const Size.fromHeight(50),
                child: searchController.text.isNotEmpty
                    ? Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 10),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: cate.asMap().entries.map((e) {
                              return Card(
                                key: ValueKey('catemenu-${e.key}'),
                                elevation: 0,
                                color: selectCate == e.key
                                    ? Colors.black
                                    : Colors.grey[200],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                margin: EdgeInsets.only(
                                  right: 10,
                                  left: e.key == 0 ? 20 : 0,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Logger().i('cate: ${novelSearch.length}');
                                    if (selectCate != e.key) {
                                      context.read<NovelsearchBloc>().add(
                                            FilterNovelByGenre(
                                              e.value.id.toString(),
                                              novelSearch,
                                              query: searchController.text,
                                            ),
                                          );
                                      setState(() {
                                        selectCate = e.key;
                                      });
                                    } else {
                                      print('cate: ${e.key}');
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    child: Text(
                                      e.value.name,
                                      style: GoogleFonts.athiti(
                                        color: selectCate == e.key
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: searchController.text.isEmpty
              ? InitLastSearch(
                  lastSearch: lastSearch,
                  onClear: _onClear,
                  onRemove: _onRemove,
                  changeSearch: changSearch,
                  lastSearchListData: lastSearchListData,
                  context: context,
                )
              : SearchDatawidget(
                  width: width,
                  searchController: searchController,
                  getCategoryName: getCategoryName,
                  testallsearch: testallsearch,
                ),
        ),
      ),
    );
  }
}

class SearchDatawidget extends StatelessWidget {
  final double width;
  final TextEditingController searchController;
  final String Function(String id) getCategoryName;
  final Function(List<Searchnovel>)? testallsearch;
  const SearchDatawidget({
    super.key,
    required this.width,
    required this.searchController,
    required this.getCategoryName,
    this.testallsearch,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: BlocBuilder<NovelsearchBloc, NovelsearchState>(
        builder: (context, state) {
          // print('state: $state');
          if (state is NovelsearchLoading) {
            return gridskeleton(width: width);
          } else if (state is NovelsearchLoaded) {
            testallsearch!(state.searchnovel);
            // print('state: ${state.searchnovel[0].name}');
            return ItemNovelSearch(
              width: width,
              getCategoryName: getCategoryName,
              searchnovel: state.searchnovel,
            );
          } else if (state is NovelsearchError) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Image.asset(
                    'assets/mascot/error.png',
                    width: 200,
                  ).animate().shakeX(),
                  const SizedBox(height: 15),
                  Text(
                    'เกิดข้อผิดพลาด',
                    style: GoogleFonts.athiti(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          } else if (state is NovelsearchEmpty) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Image.asset(
                    'assets/mascot/nodata.png',
                    width: 200,
                  ).animate().shakeX(),
                  const SizedBox(height: 15),
                  Text(
                    'ไม่พบข้อมูล',
                    style: GoogleFonts.athiti(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          } else if (state is NovelsearchFilter) {
            return ItemNovelSearch(
              width: width,
              getCategoryName: getCategoryName,
              searchnovel: state.searchnovel,
            );
          }
          return Text('Search: ${searchController.text}');
        },
      ),
    );
  }
}
