import 'dart:convert';

import 'package:bloctest/bloc/novel/novel_bloc.dart';
import 'package:bloctest/bloc/user/user_bloc.dart';
import 'package:bloctest/models/user_model.dart';
import 'package:bloctest/widgets/ContainerSkeltion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloctest/bloc/page/page_bloc.dart';
import 'package:bloctest/pages/explore_page.dart';
import 'package:bloctest/pages/movie_home.dart';
import 'package:bloctest/pages/search_page.dart';
import 'package:bloctest/widgets/IconBottombar.dart';
import 'package:bloctest/widgets/SlideLeftPageRoute.dart';
import 'package:bloctest/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:shimmer/shimmer.dart'; // ตรวจสอบให้แน่ใจว่า path ถูกต้อง

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print(novelBox.get('user'));
    getUser();
  }

  void getUser() async {
    String userstr = novelBox.get('user');
    User user = User.fromJson(jsonDecode(userstr));
    print(user.username);
    BlocProvider.of<UserBloc>(context).add(UserLoginremember(user: user));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PageBloc, PageState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  surfaceTintColor: Colors.white,
                  backgroundColor: Colors.white,
                  leading: Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey,
                      backgroundImage:
                          NetworkImage('https://avatar.iran.liara.run/public'),
                    ),
                  ),
                  title: BlocBuilder<UserBloc, UserState>(
                    builder: (context, state) {
                      if (state is UserLoginrememberSate) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.user.username,
                              style: GoogleFonts.kanit(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'มาหานิยายที่คุณชื่นชอบกันเถอะ',
                              style: GoogleFonts.kanit(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        );
                      }
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[400]!,
                        highlightColor: Colors.grey[100]!,
                        period: const Duration(milliseconds: 1000),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ContainerSkeltion(
                              height: 12,
                              width: 90,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            const SizedBox(height: 5),
                            ContainerSkeltion(
                              height: 10,
                              width: 170,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          SlideLeftRoute(page: const SearchPage()),
                        );
                      },
                      icon: const Icon(Icons.search),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Stack(
                        children: [
                          const Icon(Icons.notifications_none),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Text(
                                '1',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                  elevation: 10.0,
                  automaticallyImplyLeading: false,
                  expandedHeight: 50,
                  floating: true,
                  snap: true,
                )
              ];
            },
            body: SingleChildScrollView(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
                child: _getPage(state.tabIndex, context),
              ),
            ),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconBottombar(
                    state: state,
                    tabIndex: 0,
                    icon: 'assets/svg/home-line.svg',
                  ),
                  IconBottombar(
                    state: state,
                    tabIndex: 1,
                    icon: 'assets/svg/search-lg.svg',
                  ),
                  IconBottombar(
                    state: state,
                    tabIndex: 2,
                    icon: 'assets/svg/library-book-svgrepo-com.svg',
                  ),
                  IconBottombar(
                    state: state,
                    tabIndex: 3,
                    icon: 'assets/svg/user-01.svg',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _getPage(int index, BuildContext context) {
    switch (index) {
      case 0:
        return const MovieHome();
      case 1:
        return const ExplorePage();
      case 2:
        return Center(
          child: ElevatedButton(
            onPressed: () async {
              // ลบข้อมูลจาก Hive
              String token = novelBox.get('usertoken');
              print(token);
              await novelBox.clear();

              // นำทางไปที่หน้าแรก
              BlocProvider.of<PageBloc>(context)
                  .add(const PageChanged(tabIndex: 0));
              // BlocProvider.of<NovelBloc>(context).add(ResetNovels());
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            child: const Text('Library'),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
