import 'dart:async';
import 'dart:convert';

import 'package:bloctest/bloc/novelsearch/novelsearch_bloc.dart';
import 'package:bloctest/function/app_function.dart';
import 'package:bloctest/main.dart';
import 'package:bloctest/models/novel_model.dart';
import 'package:bloctest/widgets/ContainerSkeltion.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  Future<void> _onSearch(String value) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
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
        });
      } else {
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

  void changSearch(String value) {
    setState(() {
      searchController.text = value;
    });
  }

  List<T> _parseList<T>(
      List<dynamic> list, T Function(Map<String, dynamic>) fromJson) {
    return list.map<T>((item) => fromJson(item)).toList();
  }

  Future<void> _onFetch() async {
    // final List<Cate> cateList = json.decode(await novelBox.get('categoryData'));
    print('cateList: ${novelBox.get('categoryData').runtimeType}');
    List<dynamic> cateList = json.decode(await novelBox.get('categoryData'));
    // Logger().i('cateList: $cateList');
    cate = _parseList<Cate>(cateList, Cate.fromJson);
    // Logger().i('cate: ${cate[0].name}');
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
    double height = MediaQuery.of(context).size.height;
    print('width: $width, height: $height');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'ค้นหานิยายที่คุณสนใจ',
          style: GoogleFonts.athiti(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Theme(
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
                  child: TextField(
                    onChanged: _onSearch,
                    controller: searchController,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      hintText: 'ค้นหา',
                      hintStyle: GoogleFonts.athiti(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: SvgPicture.asset('assets/svg/Filter@3x.svg'),
                        onPressed: () {},
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide(
                          color: Colors.grey[200]!,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              //init last search
              const SizedBox(height: 10),
              searchController.text.isEmpty
                  ? InitlastSearch(
                      lastSearch: lastSearch,
                      onClear: _onClear,
                      onRemove: _onRemove,
                      changSearch: changSearch,
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: BlocBuilder<NovelsearchBloc, NovelsearchState>(
                        builder: (context, state) {
                          print('state: $state');
                          if (state is NovelsearchLoading) {
                            return Text('Loading...');
                          } else if (state is NovelsearchLoaded) {
                            print('state: ${state.searchnovel[0].name}');
                            return AlignedGridView.count(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              crossAxisCount: width > 600 ? 4 : 3,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              itemCount: state.searchnovel.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          width: 120,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  state.searchnovel[index].img,
                                              fit: BoxFit.fill,
                                              width: double.infinity,
                                              height: 170,
                                              placeholder: (context, url) =>
                                                  Shimmer.fromColors(
                                                baseColor: Colors.grey[400]!,
                                                highlightColor:
                                                    Colors.grey[100]!,
                                                period: const Duration(
                                                    milliseconds: 1000),
                                                child: ContainerSkeltion(
                                                  height: 170,
                                                  width: double.infinity,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        state.searchnovel[index].end.name ==
                                                'END'
                                            ? Positioned(
                                                top: 10,
                                                left: -25,
                                                child: Transform.rotate(
                                                  angle: -0.8,
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    width: 80,
                                                    padding:
                                                        const EdgeInsets.all(2),
                                                    decoration: BoxDecoration(
                                                      color: Colors.red[700],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: Text(
                                                      'จบแล้ว',
                                                      style: GoogleFonts.athiti(
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          left: 0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              gradient: LinearGradient(
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.topCenter,
                                                colors: [
                                                  Colors.black,
                                                  Colors.transparent,
                                                ],
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 5,
                                                vertical: 5,
                                              ),
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons
                                                        .remove_red_eye_rounded,
                                                    size: 10,
                                                    color: Colors.white,
                                                  ),
                                                  const SizedBox(width: 2),
                                                  Text(
                                                    abbreviateNumber(
                                                      state.searchnovel[index]
                                                          .view,
                                                    ),
                                                    style: GoogleFonts.athiti(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      shadows: [
                                                        const Shadow(
                                                          color: Colors.black,
                                                          offset: Offset(1, 1),
                                                          blurRadius: 1,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  const Icon(
                                                    Icons.list,
                                                    size: 10,
                                                    color: Colors.white,
                                                  ),
                                                  const SizedBox(width: 2),
                                                  Text(
                                                    abbreviateNumber(
                                                      state.searchnovel[index]
                                                          .allep,
                                                    ),
                                                    style: GoogleFonts.athiti(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      shadows: [
                                                        const Shadow(
                                                          color: Colors.black,
                                                          offset: Offset(1, 1),
                                                          blurRadius: 1,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        state.searchnovel[index].name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.athiti(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '${getCategoryName(state.searchnovel[index].cat1)} ${getCategoryName(state.searchnovel[index].cat2)}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.athiti(
                                          color: Colors.grey,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else if (state is NovelsearchError) {
                            return Text('Error: ${state.message}');
                          } else if (state is NovelsearchEmpty) {
                            return Text('Empty');
                          }
                          return Text('Search: ${searchController.text}');
                        },
                      )),
            ],
          ),
        ),
      ),
    );
  }
}

class InitlastSearch extends StatelessWidget {
  final List<String> lastSearch;
  final Function() onClear; // Changed from _onClear
  final Function(String value) onRemove; // Changed from _onRemove
  final Function(String value) changSearch; // Changed from changSearch

  const InitlastSearch({
    super.key,
    required this.lastSearch,
    required this.onRemove,
    required this.onClear,
    required this.changSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
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
              Spacer(),
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
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Wrap(
            spacing: 5,
            runSpacing: -10,
            children: [
              ...lastSearch.map((value) {
                return GestureDetector(
                  onTap: () => changSearch(value),
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
              }),
            ],
          ),
        ),
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              'อ่านล่าสุด',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 10,
            itemBuilder: (context, index) {
              return Card(
                elevation: 0,
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 20),
                child: Row(
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
                        child: Image.asset(
                          'assets/images/20240708021924.png',
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'หวนกลับมาเป็นคนโปรดของฮ่องเต้',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'ความแค้นในใจนั้นยากจะลบเลือน... หากมีโอกาสอีกคราผู้ใดเล่าจะไม่คิดหวนคืนมา ความชิงชังที่สุมอยู่เต็มทรวงของ \'อันหรูอี้\' นั้นมิเคยเสื่อมคลาย โอกาสที่ฟ้าประทานมานางย่อมคว้าไว้ไม่ให้หลุดมือ ทว่าท่ามกลางไฟแค้นที่ลุกโชนกลับมีตัวแปรอื่นที่ทำให้นางผันเปลี่ยนไป',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.remove_red_eye,
                                size: 16,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '1.2k',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Icon(
                                Icons.list,
                                size: 16,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '1,250',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(width: 10),
                              Icon(
                                Icons.thumb_up,
                                size: 16,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '100',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
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
        ),
      ],
    );
  }
}
