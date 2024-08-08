import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MovieDetail extends StatefulWidget {
  const MovieDetail({super.key});

  @override
  State<MovieDetail> createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late final TabController _tabController;
  final ScrollController _scrollController2 = ScrollController();
  late ScrollNotification notification;
  bool isAtTop = true;
  bool isAtPage = true;

  final List<GlobalKey> pageCategories = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_checkIfAtTop);
    _tabController = TabController(length: 3, vsync: this);
    _scrollController2.addListener(() {
      print(_scrollController2.position.pixels);
      var position = _scrollController2.position;
      if (position.pixels == 0) {
        setState(() {
          isAtPage = true;
        });
      } else {
        setState(() {
          isAtPage = false;
        });
      }
    });
  }

  void _checkIfAtTop() {
    if (_scrollController.hasClients) {
      final position = _scrollController.position;
      if (position.pixels >= position.maxScrollExtent / 2) {
        setState(() {
          isAtTop = false;
          isAtPage = false;
        });
      } else {
        print('at top');
        setState(() {
          isAtTop = true;
          isAtPage = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.light,
    ));
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: isAtTop ? Colors.transparent : Colors.white,
                foregroundColor: isAtTop ? Colors.white : Colors.black,
                surfaceTintColor: Colors.white,
                expandedHeight: 350,
                floating: false,
                pinned: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.favorite_border),
                    onPressed: () {},
                  ),
                ],
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      image: DecorationImage(
                        opacity: 0.5,
                        image: NetworkImage('https://i.imgur.com/jdZK3b4.jpeg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          'Kimi to Boku no Saigo no Senjou',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec nec odio vitae nunc. Donec nec odio vitae nunc. Donec nec odio vitae nunc.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_month_rounded,
                              color: Colors.white,
                            ),
                            SizedBox(width: 5),
                            Text(
                              '2021',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(
                              Icons.timer_outlined,
                              color: Colors.white,
                            ),
                            SizedBox(width: 5),
                            Text(
                              '24 min | 12 eps',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(
                              Icons.local_movies_rounded,
                              color: Colors.white,
                            ),
                            SizedBox(width: 5),
                            SizedBox(
                              width: 100,
                              child: Text(
                                'Fantasy, Action, Adventure',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                backgroundColor: const Color(0xFF685CF0),
                                foregroundColor: const Color(0xFFF1F0FF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                // padding: const EdgeInsets.all(0),
                                minimumSize: const Size(120, 50),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.play_circle_outline_outlined,
                                    size: 25,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Play',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const moiveBtn(
                                icon: Icons.arrow_circle_down_outlined),
                            const moiveBtn(icon: Icons.cast_outlined),
                            const moiveBtn(icon: Icons.group_work_outlined),
                          ]
                              .expand((element) => [
                                    const SizedBox(width: 10),
                                    element,
                                  ])
                              .toList(),
                        ),
                      ]
                          .expand((element) => [
                                const SizedBox(height: 15),
                                element,
                              ])
                          .toList(),
                    ),
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    controller: _tabController,
                    onTap: (index) async {
                      var maxScroll =
                          _scrollController.position.maxScrollExtent;
                      _scrollController.animateTo(
                        maxScroll,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                      setState(() {
                        isAtPage = false;
                      });
                      if (!isAtPage) {
                        print('scrolling');
                        await Future.delayed(const Duration(milliseconds: 300));
                        if (index == 0) {
                          _scrollController2.animateTo(
                            0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else if (index == 1) {
                          _scrollController2.animateTo(
                            900,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          _scrollController2.animateTo(
                            2000,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      }
                    },
                    tabs: const [
                      Tab(text: 'Overview'),
                      Tab(text: 'Episodes'),
                      Tab(text: 'Reviews'),
                    ],
                    indicatorColor: const Color(0xFF685CF0),
                    labelColor: const Color(0xFF685CF0),
                    indicatorSize: TabBarIndicatorSize.tab,
                  ),
                ),
              ),
            ];
          },
          body: NotificationListener<ScrollNotification>(
            key: const Key('scrollable'),
            onNotification: (notification) {
              if (notification is ScrollUpdateNotification) {
                print(pageCategories[0].currentContext!.size!.height);
                if (notification.metrics.pixels >= 800 &&
                    notification.metrics.pixels <= 1600) {
                  _tabController.animateTo(1);
                } else if (notification.metrics.pixels >= 1600) {
                  _tabController.animateTo(2);
                } else {
                  _tabController.animateTo(0);
                }
              }
              return true;
            },
            child: SingleChildScrollView(
              controller: !isAtPage ? _scrollController2 : null,
              child: Column(
                children: [
                  Container(
                    key: pageCategories[0],
                    height: 1000,
                    // padding: const EdgeInsets.all(20),
                    color: Colors.red,
                  ),
                  Container(
                    key: pageCategories[1],
                    height: 1000,
                    color: Colors.blue,
                  ),
                  Container(
                    key: pageCategories[2],
                    height: 1000,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class moiveBtn extends StatelessWidget {
  final IconData icon;
  const moiveBtn({super.key, required this.icon});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        backgroundColor: const Color(0xFFF1F0FF),
        foregroundColor: const Color(0xFF685CF0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        padding: const EdgeInsets.all(0),
        minimumSize: const Size(50, 50),
      ),
      child: Icon(
        icon,
        size: 25,
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
