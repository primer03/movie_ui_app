import 'package:bloctest/bloc/page/page_bloc.dart';
import 'package:bloctest/pages/explore_page.dart';
import 'package:bloctest/pages/movie_home.dart';
import 'package:bloctest/pages/search_page.dart';
import 'package:bloctest/widgets/IconBottombar.dart';
import 'package:bloctest/widgets/SlideLeftPageRoute.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Mainpage extends StatelessWidget {
  const Mainpage({super.key});

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
                  title: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hi, John Doe',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Let\'s find a movie',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
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
              child: _getPage(state.tabIndex),
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
                    icon: 'assets/svg/arrow-square-down.svg',
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

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const MovieHome();
      case 1:
        return const ExplorePage();
      case 2:
        return const Center(child: Text('Profile'));
      default:
        return const SizedBox.shrink();
    }
  }
}
