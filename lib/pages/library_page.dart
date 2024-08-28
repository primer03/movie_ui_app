import 'dart:convert';

import 'package:bloctest/bloc/novelbookmark/novelbookmark_bloc.dart';
import 'package:bloctest/bloc/novelsearch/novelsearch_bloc.dart';
import 'package:bloctest/function/app_function.dart';
import 'package:bloctest/main.dart';
import 'package:bloctest/models/novel_model.dart';
import 'package:bloctest/repositories/novel_repository.dart';
import 'package:bloctest/widgets/ItemGridBookmark.dart';
import 'package:bloctest/widgets/gridskeleton.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:logger/web.dart';

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

  @override
  void initState() {
    super.initState();
    _onFetch();
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

  @override
  void dispose() {
    searchController.dispose();
    focusNode.dispose();
    if (kDebugMode) {
      print('close library page');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          // Replace this delay with the code to be executed during refresh
          // and return asynchronous code
          // return Future<void>.delayed(const Duration(seconds: 3));
        },
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
                            NovelRepository().getBookmark();
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
                    return Center(
                      child: Text(state.message),
                    );
                  } else if (state is BookmarkEmpty) {
                    return const Center(
                      child: Text('BookmarkEmpty'),
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
            suffixIcon: DropdownButtonHideUnderline(
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
                  ...['ล้างการค้นหา', 'ยอดการดู', 'จำนวนตอน', 'อัพเดทล่าสุด']
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
                },
                dropdownStyleData: DropdownStyleData(
                  width: 160,
                  padding: const EdgeInsets.symmetric(vertical: 0),
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
