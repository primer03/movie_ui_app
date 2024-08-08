import 'package:flutter/material.dart';

class DynamicTabBarPage extends StatefulWidget {
  @override
  _DynamicTabBarPageState createState() => _DynamicTabBarPageState();
}

class _DynamicTabBarPageState extends State<DynamicTabBarPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  bool _isScrolling = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (_isScrolling) return;

    double scrollOffset = _scrollController.offset;
    int tabIndex = 0;

    if (scrollOffset >= 0 && scrollOffset < 300) {
      tabIndex = 0;
    } else if (scrollOffset >= 300 && scrollOffset < 600) {
      tabIndex = 1;
    } else if (scrollOffset >= 600) {
      tabIndex = 2;
    }

    if (_tabController.index != tabIndex) {
      _tabController.animateTo(tabIndex, duration: Duration(milliseconds: 300));
    }
  }

  void _handleTabChange() {
    if (_isScrolling) return;

    _isScrolling = true;
    double scrollOffset = 0;

    switch (_tabController.index) {
      case 0:
        scrollOffset = 0;
        break;
      case 1:
        scrollOffset = 300;
        break;
      case 2:
        scrollOffset = 600;
        break;
    }

    _scrollController
        .animateTo(
      scrollOffset,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    )
        .then((_) {
      _isScrolling = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              pinned: true,
              floating: true,
              expandedHeight: 200.0,
              bottom: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: "Tab 1"),
                  Tab(text: "Tab 2"),
                  Tab(text: "Tab 3"),
                ],
                onTap: (index) => _handleTabChange(),
              ),
            ),
          ];
        },
        body: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notification) {
            _handleScroll();
            return false;
          },
          child: ListView.builder(
            itemCount: 9,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 300.0,
                color: index % 3 == 0
                    ? Colors.red
                    : (index % 3 == 1 ? Colors.green : Colors.blue),
                child: Center(
                  child: Text(
                    'Item $index',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// void main() => runApp(MaterialApp(home: DynamicTabBarPage()));
