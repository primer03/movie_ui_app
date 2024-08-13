import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

class NovelDetail extends StatefulWidget {
  const NovelDetail({super.key});

  @override
  State<NovelDetail> createState() => _NovelDetailState();
}

class _NovelDetailState extends State<NovelDetail>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late final TabController _tabController;
  final PageController _pageController = PageController();
  bool isAtTop = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_checkIfAtTop);
    _tabController = TabController(length: 3, vsync: this);
  }

  void _checkIfAtTop() {
    if (_scrollController.hasClients) {
      final position = _scrollController.position;
      setState(() {
        isAtTop = position.pixels < position.maxScrollExtent / 2;
      });
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
                expandedHeight: 400,
                floating: false,
                pinned: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () async {
                      final result = await Share.share(
                        'https://bookfet.com/noveldetail/MTIz_%E0%B9%80%E0%B8%82%E0%B8%B5%E0%B8%A2%E0%B8%99%E0%B8%A3%E0%B8%B1%E0%B8%81%E0%B9%83%E0%B8%AB%E0%B8%A1%E0%B9%88%E0%B8%94%E0%B9%89%E0%B8%A7%E0%B8%A2%E0%B8%AB%E0%B8%B1%E0%B8%A7%E0%B9%83%E0%B8%88%E0%B8%94%E0%B8%A7%E0%B8%87%E0%B9%80%E0%B8%94%E0%B8%B4%E0%B8%A1',
                        subject: 'Check out this novel',
                      );
                      if (result.status == ShareResultStatus.success) {
                        print('Thank you for sharing my website!');
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.bookmark_border),
                    onPressed: () {},
                  ),
                ],
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new),
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
                        opacity: 0.4,
                        image: NetworkImage(
                          'https://admin.buffetebook.com/images/novel/20240401160819.jpg?w=128&q=100?webp',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'เกิดใหม่เป็นภรรยาอ้วนของหัวหน้ากองพันสุดฮอต ยุค 80',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.athiti(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '##นิยายแปล ##นิยายแปลจีน ##เกิดใหม่ ##ย้อนยุค ##นิยายรัก ##นางเองสู้คน ##พระเอกคลั่งรัก ##ครอบครัว ##ทะลุมิติ ##นิยายยุค80 ##โรแมนติก ##นางเอกเก่ง ##กองทัพ ##พระเอกอบอุ่น ##นางเอกอ้วน ##นิยายแปลนางเอกเก่ง ##Onlybook',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.athiti(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.remove_red_eye,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '123.2k',
                              style: GoogleFonts.athiti(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Icon(
                              Icons.list,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '233 ตอน',
                              style: GoogleFonts.athiti(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFd2060b),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                'assets/svg/read-svgrepo-com.svg',
                                color: Colors.white,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                'อ่านเลย',
                                style: GoogleFonts.athiti(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]
                          .expand((element) => [
                                const SizedBox(height: 10),
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
                      await _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    tabs: const [
                      Tab(text: 'ตอน'),
                      Tab(text: 'นิยายแนะนำ'),
                      Tab(text: 'เกี่ยวกับ'),
                    ],
                    indicatorColor: Colors.black,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    indicatorSize: TabBarIndicatorSize.tab,
                  ),
                ),
              ),
            ];
          },
          body: PageView(
            onPageChanged: (index) {
              _tabController.animateTo(index);
            },
            controller: _pageController,
            children: [
              Container(
                color: Colors.white,
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ExpansionTileEpisode(initiallyExpanded: true),
                        SizedBox(height: 10),
                        ExpansionTileEpisode(),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                child: const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Episodes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                child: const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Reviews',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExpansionTileEpisode extends StatefulWidget {
  final bool initiallyExpanded;
  const ExpansionTileEpisode({super.key, this.initiallyExpanded = false});

  @override
  _ExpansionTileEpisodeState createState() => _ExpansionTileEpisodeState();
}

class _ExpansionTileEpisodeState extends State<ExpansionTileEpisode> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        dividerColor: Colors.transparent,
        splashFactory: InkRipple.splashFactory,
        splashColor: Colors.black.withOpacity(0.4),
      ),
      child: ExpansionTile(
        key: const PageStorageKey<String>('expansion_tile_key'),
        initiallyExpanded: _isExpanded,
        onExpansionChanged: (bool expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
        title: Text(
          'ตอนที่ 1 - ตอนที่ 10',
          style: GoogleFonts.athiti(
            fontWeight: FontWeight.w700,
          ),
        ),
        collapsedIconColor: Colors.black,
        iconColor: Colors.white,
        textColor: Colors.white,
        collapsedBackgroundColor: Colors.grey[200],
        backgroundColor: Colors.black,
        collapsedTextColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.grey[200]!,
              ),
            ),
            child: Column(children: [
              ...List.generate(5, (index) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey[200]!,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'บทที่ 1 เขาแต่งงานกับเธอ แต่ไม่รักเธอ',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.athiti(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'อ่านฟรี',
                        style: GoogleFonts.athiti(
                          color: Colors.grey[400],
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                );
              })
            ]),
          ),
        ],
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
