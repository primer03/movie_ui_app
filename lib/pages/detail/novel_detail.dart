import 'dart:convert';
import 'dart:ffi';
import 'dart:math';
import 'package:bloctest/bloc/noveldetail/novel_detail_bloc.dart';
import 'package:bloctest/function/app_function.dart';
import 'package:bloctest/main.dart';
import 'package:bloctest/models/novel_bookmark_model.dart';
import 'package:bloctest/models/novel_detail_model.dart';
import 'package:bloctest/models/novel_read_model.dart';
import 'package:bloctest/models/user_model.dart';
import 'package:bloctest/repositories/novel_repository.dart';
import 'package:bloctest/service/BookmarkManager.dart';
import 'package:bloctest/widgets/ContainerSkeltion.dart';
import 'package:bloctest/widgets/NovelCard.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:logger/web.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';

class NovelDetail extends StatefulWidget {
  const NovelDetail(
      {super.key,
      required this.novelId,
      required this.allep,
      required this.user});
  final int novelId;
  final int allep;
  final User user;

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
  List<int> epList = [];
  // List<List<NovelEp>> novelEpisode = [];
  List<String> groupList = [];
  int count = 0;
  int idxcount = 0;
  int groupEp = 0;
  bool isBookmark = false;
  int allEP = 0;
  late BookmarkManager _bookmarkManager;

  @override
  void initState() {
    super.initState();

    getnoveldetail();
    // getRoleUser();
    _scrollController.addListener(_checkIfAtTop);
    _tabController = TabController(length: 3, vsync: this);
    print(widget.allep);
    allEP = widget.allep;
    epList = List.generate(widget.allep, (index) => index + 1);
    groupEp = (epList.length / 100).ceil();
    for (var i = 0; i < groupEp; i++) {
      if (i == groupEp - 1) {
        groupList.add('ตอนที่ ${epList[i * 100]} - ตอนที่ ${epList.last}');
      } else {
        groupList.add(
            'ตอนที่ ${epList[i * 100]} - ตอนที่ ${epList[(i + 1) * 100 - 1]}');
      }
    }
    _bookmarkManager = BookmarkManager(context, _updateBookmarkState);
    // _bookmarkManager.fToast.init(context);
    Logger().i(groupList);
  }

  // Future<void> getRoleUser() async {
  //   try {
  //     final userData = await novelBox.get('user');
  //     if (userData != null) {
  //       user = User.fromJson(json.decode(userData));
  //       setState(() {
  //         user = user;
  //       });
  //       print('User Role: ${user?.detail.roles}');
  //     }
  //   } catch (e) {
  //     print('Error loading user data: $e');
  //   }
  // }

  void _updateBookmarkState(bool newState) {
    setState(() {
      isBookmark = newState;
    });
  }

  Future<void> getnoveldetail() async {
    try {
      context.read<NovelDetailBloc>().add(FetchNovelDetail(widget.novelId));
      final bookmarks = parseList<Bookmark>(
          json.decode(await novelBox.get('bookmarkData') ?? '[]'),
          Bookmark.fromJson);
      setState(
          () => isBookmark = bookmarks.any((b) => b.sbtId == widget.novelId));
    } catch (e) {
      print('Error fetching novel details: $e');
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_checkIfAtTop);
    _scrollController.dispose();
    _tabController.dispose();
    _pageController.dispose();
    novelBox.delete('cateID');
    super.dispose();
  }

  void _checkIfAtTop() {
    if (_scrollController.hasClients) {
      final position = _scrollController.position;
      print('position : ${position.pixels}');
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
        body: BlocBuilder<NovelDetailBloc, NovelDetailState>(
          builder: (context, state) {
            print(state);
            if (state is NovelDetailLoading) {
              return Center(
                child: LoadingAnimationWidget.discreteCircle(
                  color: Colors.grey,
                  secondRingColor: Colors.black,
                  thirdRingColor: Colors.red[900]!,
                  size: 50,
                ),
              );
            } else if (state is NovelDetailLoaded) {
              print(state.dataNovel.novelEp[0].typeRead.name);
              Logger().i(state.dataNovel);
              var bytes = utf8.encode(state.dataNovel.novel.btId.toString());
              String url =
                  'https://bookfet.com/noveldetail/${base64.encode(bytes)}_${Uri.encodeComponent(state.dataNovel.novel.btName)}';
              return NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      backgroundColor:
                          isAtTop ? Colors.transparent : Colors.white,
                      foregroundColor: isAtTop ? Colors.white : Colors.black,
                      surfaceTintColor: Colors.white,
                      expandedHeight: 190,
                      floating: false,
                      pinned: true,
                      actions: [
                        IconButton(
                          icon: Icon(
                            Icons.share,
                            shadows: isAtTop
                                ? [
                                    const BoxShadow(
                                      color: Colors.black,
                                      blurRadius: 20,
                                    ),
                                  ]
                                : null,
                          ),
                          onPressed: () async {
                            final result = await Share.share(
                              url,
                              subject: 'Check out this novel',
                            );
                            if (result.status == ShareResultStatus.success) {
                              print('Thank you for sharing my website!');
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            !isBookmark ? Iconsax.archive_add : Icons.bookmark,
                            shadows: isAtTop
                                ? [
                                    const BoxShadow(
                                      color: Colors.black,
                                      blurRadius: 15,
                                    ),
                                  ]
                                : null,
                          ),
                          onPressed: () async => isBookmark == false
                              ? _bookmarkManager.addBookmark(state.dataNovel)
                              : _bookmarkManager
                                  .removeBookmark(state.dataNovel.novel.bookId),
                        ),
                      ],
                      leading: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          shadows: isAtTop
                              ? [
                                  const BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 5,
                                  ),
                                ]
                              : null,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          // padding: const EdgeInsets.symmetric(
                          //   horizontal: 20,
                          //   vertical: 5,
                          // ),
                          alignment: Alignment.bottomCenter,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: Stack(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: state.dataNovel.novel.btBgimg,
                                  fit: BoxFit.cover,
                                  height: double.infinity,
                                  width: double.infinity,
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                    baseColor: Colors.grey[400]!,
                                    highlightColor: Colors.grey[100]!,
                                    period: const Duration(milliseconds: 1000),
                                    child: const ContainerSkeltion(
                                      height: double.infinity,
                                      width: double.infinity,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Colors.black.withOpacity(0.8),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.remove_red_eye,
                                              color: Colors.white,
                                              size: 30,
                                              shadows: [
                                                BoxShadow(
                                                  color: Colors.black,
                                                  blurRadius: 10,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              abbreviateNumber(
                                                  state.dataNovel.novel.btView),
                                              style: GoogleFonts.athiti(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                shadows: [
                                                  const BoxShadow(
                                                    color: Colors.black,
                                                    blurRadius: 10,
                                                    spreadRadius: 5,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            const Icon(
                                              Icons.list,
                                              color: Colors.white,
                                              size: 30,
                                              shadows: [
                                                BoxShadow(
                                                  color: Colors.black,
                                                  blurRadius: 5,
                                                  spreadRadius: 5,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              '${abbreviateNumber(widget.allep)} ตอน',
                                              style: GoogleFonts.athiti(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                shadows: [
                                                  const BoxShadow(
                                                    color: Colors.black,
                                                    blurRadius: 5,
                                                    spreadRadius: 5,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
                            Tab(text: 'เกี่ยวกับ'),
                            Tab(text: 'ตอน'),
                            Tab(text: 'นิยายแนะนำ'),
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
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 10,
                          bottom: 10,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text(state.dataNovel.novel.btDes),
                              Html(
                                data: state.dataNovel.novel.btDes,
                                style: {
                                  'body': Style(
                                    fontSize: FontSize(16),
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: GoogleFonts.athiti().fontFamily,
                                  ),
                                  'br': Style(
                                    display: Display.none,
                                  )
                                },
                              ),
                              Text(
                                state.dataNovel.novel.btTag,
                                textAlign: TextAlign.left,
                                style: GoogleFonts.athiti(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
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
                    Epview(
                      groupList: groupList,
                      novelEp: state.dataNovel.novelEp,
                      bookname: state.dataNovel.novel.btName,
                      role: widget.user.detail.roles[1] ?? '',
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
                  ],
                ),
              );
            } else if (state is NovelDetailError) {
              return Center(
                child: Text(state.message),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}

class Epview extends StatelessWidget {
  const Epview({
    super.key,
    required this.groupList,
    required this.novelEp,
    required this.bookname,
    required this.role,
  });

  final List<String> groupList;
  final List<NovelEp> novelEp;
  final String bookname;
  final String role;

  @override
  Widget build(BuildContext context) {
    print(novelEp.length);

    // Split the episodes into groups outside the build method
    final novelEpisode = _splitEpisodes(novelEp, 100);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: ListView.builder(
        padding: const EdgeInsets.all(0),
        itemCount: groupList.length,
        itemBuilder: (context, index) {
          final group = groupList[index];
          final episodes = novelEpisode[index];
          return Column(
            children: [
              ExpansionTileEpisode(
                key: ValueKey(group),
                novelEp: episodes,
                title: group,
                index: index,
                initiallyExpanded: index == 0,
                allEP: novelEp.length,
                bookname: bookname,
                novelEpAll: novelEp,
                role: role,
              ),
              const SizedBox(height: 10),
            ],
          );
        },
      ),
    );
  }

  List<List<NovelEp>> _splitEpisodes(List<NovelEp> episodes, int chunkSize) {
    return [
      for (var i = 0; i < episodes.length; i += chunkSize)
        episodes.skip(i).take(chunkSize).toList()
    ];
  }
}

class TextAbout extends StatelessWidget {
  final String title;
  const TextAbout({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      // alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: GoogleFonts.athiti(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class ExpansionTileEpisode extends StatefulWidget {
  final bool initiallyExpanded;
  final int index;
  final String title;
  final List<NovelEp> novelEp;
  final List<NovelEp> novelEpAll;
  final int allEP;
  final String bookname;
  final String role;

  const ExpansionTileEpisode({
    super.key,
    this.initiallyExpanded = false,
    required this.index,
    required this.title,
    required this.novelEp,
    required this.novelEpAll,
    required this.allEP,
    required this.bookname,
    required this.role,
  });

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
        key: PageStorageKey<String>('expansion_tile_key${widget.index}'),
        initiallyExpanded: _isExpanded,
        onExpansionChanged: (bool expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
        title: Text(
          widget.title,
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
            child: ListView.builder(
              padding: const EdgeInsets.all(0),
              key: PageStorageKey<String>('listview_key${widget.index}'),
              itemCount: widget.novelEp.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final episode = widget.novelEp[index];
                // Logger().i("Episode ${episode.publish.name}");
                // print('Episode ${episode.publish.name} tapped');
                return Material(
                  color: Colors.white,
                  child: InkWell(
                    splashColor: Colors.black12,
                    onTap: () async {
                      print('Episode ${episode.publishDate} tapped');
                      // BookfetNovelRead noep = await NovelRepository()
                      //     .getReadNovel(episode.bookId, episode.epId);
                      // Logger().i(noep.readnovel.previousOrNext.previous?.epId);
                      Navigator.pushNamed(
                        context,
                        'reader',
                        arguments: {
                          'bookId': episode.bookId,
                          'epId': episode.epId,
                          'bookName': widget.bookname,
                          'novelEp': widget.novelEpAll,
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(15),
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
                          Expanded(
                            child: Text(
                              episode.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.athiti(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          episode.typeRead.name == 'FREE'
                              ? Text(
                                  'อ่านฟรี',
                                  style: GoogleFonts.athiti(
                                    color: Colors.grey[400],
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.italic,
                                  ),
                                )
                              : widget.role == 'public'
                                  ? Text(
                                      'อ่าน',
                                      style: GoogleFonts.athiti(
                                        color: Colors.grey[400],
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    )
                                  : SvgPicture.asset(
                                      'assets/svg/crown-user-svgrepo-com.svg',
                                      width: 20,
                                    )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
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
