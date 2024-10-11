import 'dart:async';
import 'dart:convert';
import 'package:bloctest/bloc/novelbookmark/novelbookmark_bloc.dart';
import 'package:bloctest/function/app_function.dart';
import 'package:bloctest/main.dart';
import 'package:bloctest/models/novel_bookmark_model.dart';
import 'package:bloctest/models/novel_model.dart';
import 'package:bloctest/service/BookmarkManager.dart';
import 'package:bloctest/widgets/ItemGridBookmark.dart';
import 'package:bloctest/widgets/gridskeleton.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:logger/web.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  TextEditingController searchController = TextEditingController();
  FocusNode focusNode = FocusNode();
  int selectCate = 0;
  List<Cate> cate = [];
  DateTime? lastRefreshTime;
  List<Bookmark> bookmarkList = [];
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  Timer? _debounce;
  @override
  void initState() {
    super.initState();
    _onFetch();
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 700), () {
      context.read<NovelbookmarkBloc>().add(
            BoolmarkSearchEvent(
              search: searchController.text,
              cateId: selectCate.toString(),
              bookmarkList: bookmarkList,
            ),
          );
    });
  }

  Future<void> _onFetch() async {
    List<dynamic> cateList = json.decode(await novelBox.get('categoryData'));
    cate = parseList<Cate>(cateList, Cate.fromJson);
    setState(() {
      cate = cate;
    });
    context.read<NovelbookmarkBloc>().add(const FetchBookmark());
    Logger().i('cate: $cate');
  }

  Future<void> _handleRefresh() async {
    final now = DateTime.now();
    if (lastRefreshTime == null ||
        now.difference(lastRefreshTime!) > const Duration(seconds: 5)) {
      lastRefreshTime = now;
      novelBox.delete('bookmarkData');
      context.read<NovelbookmarkBloc>().add(const FetchBookmark());
      _refreshController.refreshCompleted();
    } else {
      BookmarkManager(context, (bool checkAdd) {})
          .showToast('กรุณารอสักครู่ก่อนดำเนินการอีกครั้ง');
      _refreshController.refreshCompleted();
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    focusNode.dispose();
    _debounce?.cancel();
    if (kDebugMode) {
      print('close library page');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: false,
        header: WaterDropMaterialHeader(
          backgroundColor: Colors.grey[200],
          color: Colors.black,
          distance: 60,
        ),
        physics: const BouncingScrollPhysics(),
        onRefresh: _handleRefresh,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: _myTextfield(),
              ),
              Container(
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
                            setState(() {
                              selectCate = e.key;
                            });
                            _onSearchChanged();
                            // print('cate: ${e.key}');
                            // print('cate: ${bookmarkList.length}');
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
              ),
              BlocBuilder<NovelbookmarkBloc, NovelbookmarkState>(
                builder: (context, state) {
                  if (state is BookmarkLoading) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: gridskeleton(width: width),
                    );
                  } else if (state is BookmarkLoaded) {
                    bookmarkList = state.bookmarkList;
                    // print('bookmarkList: ${bookmarkList.length}');
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Itemgridbookmark(
                        bookmarkList: state.bookmarkList,
                        width: width,
                      ),
                    );
                  } else if (state is BookmarkError) {
                    return Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height - 400,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/mascot/error.png',
                            width: 200,
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: () {
                              context.read<NovelbookmarkBloc>().add(
                                    const FetchBookmark(),
                                  );
                            },
                            child: Text(
                              'ลองใหม่อีกครั้ง',
                              style: GoogleFonts.athiti(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (state is BookmarkEmpty) {
                    bookmarkList = [];
                    return Container(
                      height: MediaQuery.of(context).size.height - 400,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/mascot/error.png',
                            width: 200,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'คุณยังไม่ได้เพิ่มหนังสือในชั้น',
                            style: GoogleFonts.athiti(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (state is BookmarlSearching) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Itemgridbookmark(
                        bookmarkList: state.bookmarkList,
                        width: width,
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text('BookmarkInitial'),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _myTextfield() {
    return Theme(
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
          // onChanged: _onSearch,
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
            suffixIcon: IconButton(
              icon: const Icon(Iconsax.close_circle),
              onPressed: () {
                searchController.clear();
                _onSearchChanged();
              },
            ),
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
    );
  }
}
