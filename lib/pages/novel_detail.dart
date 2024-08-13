import 'package:bloctest/pages/movie_home.dart';
import 'package:bloctest/widgets/NovelCard.dart';
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
  final List<Map<String, dynamic>> _items2 = [
    {
      'image':
          'https://www.saiumporn5.com/buffet-api/20230913045243.jpg?w=128&q=100?webp',
      'title': 'Kimi to Boku no Saigo no Senjou',
      'description':
          'ฉินจิ่นแพทย์หญิงจากศตวรรษที่ 21 ขับรถชนรถสิบล้อ แล้วทะลุเข้ามายังร่างของสาวนาตัวน้อยที่กระโดดน้ำตาย สาเหตุนะเหรอ เรื่องนี้คงต้องเล่ากันยาว เริ่มจาก นางมีฉายา คร่า สามี 7 ศพ ! เพราะอะไรน่ะเหรอ ฉินจิ่นถูกขายให้เป็นสะใภ้ของ 7 ครอบครัว พอตกลงที่จะแต่งงาน เจ้าบ่าวของฉินจิ่นก็จะต้องมีเหตุต้องตาย ทุกสารพัดวิธี',
    },
    {
      'image':
          'https://admin.buffetebook.com/images/novel/20240526233131.jpg?w=128&q=100?webp',
      'title': 'Kimi to Boku no Saigo no Senjou',
      'description': 'Action, Adventure, Fantasy',
    },
    {
      'image':
          'https://admin.buffetebook.com/images/novel/20240404012824.jpg?w=128&q=100?webp',
      'title': 'Kimi to Boku no Saigo no Senjou',
      'description': 'Action, Adventure, Fantasy',
    },
    {
      'image':
          'https://admin.buffetebook.com/images/novel/20240611231729.jpg?w=128&q=100?webp',
      'title': 'Kimi to Boku no Saigo no Senjou',
      'description': 'Action, Adventure, Fantasy',
    },
    {
      'image': 'https://i.imgur.com/jHmdK55.jpeg',
      'title': 'Kimi to Boku no Saigo no Senjou',
      'description': 'Action, Adventure, Fantasy',
    },
    {
      'image': 'https://i.imgur.com/jHmdK55.jpeg',
      'title': 'Kimi to Boku no Saigo no Senjou',
      'description': 'Action, Adventure, Fantasy',
    },
    {
      'image': 'https://i.imgur.com/jHmdK55.jpeg',
      'title': 'Kimi to Boku no Saigo no Senjou',
      'description': 'Action, Adventure, Fantasy',
    },
    {
      'image': 'https://i.imgur.com/jHmdK55.jpeg',
      'title': 'Kimi to Boku no Saigo no Senjou',
      'description': 'Action, Adventure, Fantasy',
    },
    {
      'image': 'https://i.imgur.com/jHmdK55.jpeg',
      'title': 'Kimi to Boku no Saigo no Senjou',
      'description': 'Action, Adventure, Fantasy',
    },
    {
      'image': 'https://i.imgur.com/jHmdK55.jpeg',
      'title': 'Kimi to Boku no Saigo no Senjou',
      'description': 'Action, Adventure, Fantasy',
    },
  ];

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
                    labelStyle: GoogleFonts.athiti(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
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
            controller: _pageController,
            onPageChanged: (index) {
              _tabController.animateTo(index);
            },
            children: [
              Container(
                color: Colors.white,
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ExpansionTileEpisode(
                          initiallyExpanded: true,
                          index: 0,
                        ),
                        SizedBox(height: 10),
                        ExpansionTileEpisode(
                          index: 1,
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                key: const PageStorageKey<String>('novel_recommend'),
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        width: double.infinity,
                        child: Text(
                          'นิยายแนะนำ',
                          style: GoogleFonts.athiti(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Novelcard(items: _items2),
                    ],
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const TextAbout(
                            title:
                                'เกิดใหม่เป็นภรรยาอ้วนของหัวหน้ากองพันสุดฮอต ยุค 80'),
                        const TextAbout(title: '重生八零嫁给全军第一硬汉'),
                        const TextAbout(
                            title:
                                '*** ลิขสิทธิ์ถูกต้องภายใต้บริษัท โอลลี่บุ๊คส์ จำกัด ***'),
                        const TextAbout(
                            title:
                                'ได้รับลิขสิทธิ์ออนไลน์ (Digital license) สำหรับแปลขายลงบนเว็บไซต์ได้อย่างถูกลิขสิทธิ์ 100%'),
                        const TextAbout(title: 'สงวนลิขสิทธิ์'),
                        const TextAbout(
                            title: 'ผู้แต่ง : 九羊猪猪   ผู้แปล : ทีมงาน onlybook'),
                        const SizedBox(height: 10),
                        const TextAbout(title: 'เรื่องย่อ'),
                        const TextAbout(
                            title:
                                'โดนคนรักที่กำลังแต่งงานไปนอกใจกับเพื่อนรักและโยนลงจากชั้น 14 แต่กลับมาเกิดใหม่เป็นหญิงอ้วนหนักกว่า 150 กิโลกรัม ที่พาลูกเลี้ยงของสามีไปขายแลกหนี้ จนสามีรู้เข้าจะหย่ากับเธอภายในเจ็ดเดือน แบบนี้ ‘เจียงหว่าน’ จะอยู่ยังไงเมื่อเจ้าของร่างเดิมแสนโฉดชั่วไปทำเรื่องให้คนขุ่นเคืองใจมากมาย แต่สามีที่กำลังจะหย่ากลับยื่นมือเข้ามาช่วยเสมอ อย่ามาทำแบบนี้นะรู้ไหมมัน น่ากิน... เอ้ย หวั่นไหว!'),
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
            ],
          ),
        ),
      ),
    );
  }
}

class TextAbout extends StatelessWidget {
  final String title;
  const TextAbout({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: GoogleFonts.athiti(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class ExpansionTileEpisode extends StatefulWidget {
  final bool initiallyExpanded;
  final int index;
  const ExpansionTileEpisode(
      {super.key, this.initiallyExpanded = false, required this.index});

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
          print(widget.index);
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
