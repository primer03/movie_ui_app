import 'dart:async';
import 'dart:convert';
import 'package:bloctest/bloc/novelsearch/novelsearch_bloc.dart';
import 'package:bloctest/function/app_function.dart';
import 'package:bloctest/main.dart';
import 'package:bloctest/models/novel_allsearch_model.dart';
import 'package:bloctest/models/novel_model.dart';
import 'package:bloctest/widgets/ContainerSkeltion.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/web.dart';
import 'package:shimmer/shimmer.dart';

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
    _onFetch();
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
                      prefixIcon: const Icon(Icons.search),
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
            return Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: const Text('Loading...'),
            );
          } else if (state is NovelsearchLoaded) {
            testallsearch!(state.searchnovel);
            // print('state: ${state.searchnovel[0].name}');
            return ItemNovelSearch(
              width: width,
              getCategoryName: getCategoryName,
              searchnovel: state.searchnovel,
            );
          } else if (state is NovelsearchError) {
            return Text('Error: ${state.message}');
          } else if (state is NovelsearchEmpty) {
            return const Text('Empty');
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
    return Column(
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

class InitLastSearch extends StatelessWidget {
  final List<String> lastSearch;
  final VoidCallback onClear;
  final ValueChanged<String> onRemove;
  final ValueChanged<String> changeSearch;

  const InitLastSearch({
    super.key,
    required this.lastSearch,
    required this.onRemove,
    required this.onClear,
    required this.changeSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        _buildHeader(),
        const SizedBox(height: 10),
        _buildSearchChips(),
        const SizedBox(height: 20),
        _buildRecentReads(),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'ค้นหาล่าสุด',
            style: GoogleFonts.athiti(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onClear,
            child: Text(
              'ลบทั้งหมด',
              style: GoogleFonts.athiti(
                color: Colors.red[900],
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchChips() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        spacing: 5,
        runSpacing: -10,
        children: lastSearch.map((value) {
          return GestureDetector(
            onTap: () => changeSearch(value),
            child: Chip(
              deleteButtonTooltipMessage: 'ลบ',
              padding: const EdgeInsets.symmetric(horizontal: 5),
              label: Text(
                value,
                style: GoogleFonts.athiti(
                  color: const Color(0xFF96979B),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              backgroundColor: Colors.white,
              onDeleted: () => onRemove(value),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              deleteIcon: SvgPicture.asset(
                'assets/svg/close_ring_duotone_line@3x.svg',
                width: 25,
                height: 25,
                color: const Color(0xff96979B),
              ),
              side: const BorderSide(
                color: Color(0xFF9D9D9D9),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRecentReads() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 10,
        itemBuilder: (context, index) {
          return _buildRecentReadCard();
        },
      ),
    );
  }

  Widget _buildRecentReadCard() {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          _buildImage(),
          const SizedBox(width: 15),
          Expanded(
            child: _buildCardContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Container(
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
        child: Image.asset(
          'assets/images/20240708021924.png',
          height: 120,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildCardContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'หวนกลับมาเป็นคนโปรดของฮ่องเต้',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'ความแค้นในใจนั้นยากจะลบเลือน... หากมีโอกาสอีกคราผู้ใดเล่าจะไม่คิดหวนคืนมา ความชิงชังที่สุมอยู่เต็มทรวงของ \'อันหรูอี้\' นั้นมิเคยเสื่อมคลาย โอกาสที่ฟ้าประทานมานางย่อมคว้าไว้ไม่ให้หลุดมือ ทว่าท่ามกลางไฟแค้นที่ลุกโชนกลับมีตัวแปรอื่นที่ทำให้นางผันเปลี่ยนไป',
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 5),
        _buildStatsRow(),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatItemx(Icons.remove_red_eye, '1.2k'),
        const SizedBox(width: 10),
        _buildStatItemx(Icons.list, '1,250'),
        const SizedBox(width: 10),
        _buildStatItemx(Icons.thumb_up, '100'),
      ],
    );
  }

  Widget _buildStatItemx(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16),
        const SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
