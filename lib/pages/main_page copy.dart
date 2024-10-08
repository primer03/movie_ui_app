import 'package:bloctest/bloc/page/page_bloc.dart';
import 'package:bloctest/pages/explore_page.dart';
import 'package:bloctest/pages/home/novel_home.dart';
import 'package:bloctest/pages/search/search_page.dart';
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
          body: Column(
            children: [
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  child: state is ScrollPage && state.showAppBar
                      ? AppBar(
                          key: const ValueKey('appbar'),
                          backgroundColor: Colors.white,
                          surfaceTintColor: Colors.white,
                          leadingWidth: 70,
                          leading: Container(
                            margin: const EdgeInsets.only(left: 20),
                            child: const CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey,
                              backgroundImage: NetworkImage(
                                  'https://avatar.iran.liara.run/public'),
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
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
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
                        )
                      : const SizedBox(
                          key: ValueKey('emptyAppBar'),
                          height: 0,
                        ),
                ),
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                  child: _getPage(state.tabIndex),
                ),
              ),
            ],
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
