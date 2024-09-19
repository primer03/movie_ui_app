import 'dart:convert';
import 'dart:math';
import 'package:bloctest/bloc/noveldetail/novel_detail_bloc.dart';
import 'package:bloctest/function/app_function.dart';
import 'package:bloctest/main.dart';
import 'package:bloctest/models/novel_bookmark_model.dart';
import 'package:bloctest/models/novel_detail_model.dart';
import 'package:bloctest/models/user_model.dart';
import 'package:bloctest/service/BookmarkManager.dart';
import 'package:bloctest/widgets/ContainerSkeltion.dart';
import 'package:bloctest/widgets/Epview.dart';
import 'package:bloctest/widgets/ExpansionTileEpisode.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:logger/web.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

class NovelDetailNew extends StatefulWidget {
  const NovelDetailNew({
    super.key,
    required this.novelId,
    required this.allep,
    required this.user,
  });
  final int novelId;
  final int allep;
  final User user;

  @override
  State<NovelDetailNew> createState() => _NovelDetailNewState();
}

class _NovelDetailNewState extends State<NovelDetailNew>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late final TabController _tabController;
  final PageController _pageController = PageController();
  final PageController _pageController2 = PageController();
  bool isExpanded = false;
  int _selectedIndex = 0;
  bool isAtTop = true;
  double maxHeight = 200;
  GlobalKey _htmlKey = GlobalKey();
  int count = 0;
  int idxcount = 0;
  int groupEp = 0;
  bool isBookmark = false;
  int allEP = 0;
  late BookmarkManager _bookmarkManager;
  List<String> groupList = [];
  List<int> epList = [];
  Map<String, dynamic> readLast = {};

  final PageStorageKey pageKey = PageStorageKey('pageViewKey');

  @override
  void initState() {
    super.initState();

    getnoveldetail();
    _scrollController.addListener(_checkIfAtTop);
    _tabController = TabController(length: 3, vsync: this);
    // print(widget.allep);
    // allEP = widget.allep;

    _bookmarkManager = BookmarkManager(context, _updateBookmarkState);
    // _bookmarkManager.fToast.init(context);
    // Logger().i(groupList);
  }

  void _updateBookmarkState(bool newState) {
    setState(() {
      isBookmark = newState;
    });
  }

  Future<void> getnoveldetail() async {
    try {
      // print('password: ${getPassword()}');
      // var password = await getPassword();
      // print('password: $password');
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

  void _checkIfAtTop() {
    if (_scrollController.hasClients) {
      final position = _scrollController.position;
      bool atTop = position.pixels <= 0.0;
      if (atTop != isAtTop) {
        setState(() {
          isAtTop = atTop;
        });
      }
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

  String formatDate(String originalDate) {
    DateTime dateTime = DateTime.parse(originalDate);
    DateFormat dateFormat = DateFormat('d MMM yyyy', 'th_TH');
    return dateFormat.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<NovelDetailBloc, NovelDetailState>(
        listener: (context, state) {
          if (state is NovelDetailLoaded) {
            setState(() {
              var allEPList = state.dataNovel.novelEp.where((element) {
                DateTime publishDateTime =
                    combineDateTime(element.publishDate, element.publishTime);
                return publishDateTime.isBefore(DateTime.now()) ||
                    publishDateTime.isAtSameMomentAs(DateTime.now());
              });
              allEP = allEPList.where((element) {
                return !element.name.contains('ประกาศ');
              }).length;
              epList = List.generate(allEP, (index) => index + 1);
              groupEp = (epList.length / 100).ceil();
              for (var i = 0; i < groupEp; i++) {
                if (i == groupEp - 1) {
                  groupList
                      .add('ตอนที่ ${epList[i * 100]} - ตอนที่ ${epList.last}');
                } else {
                  groupList.add(
                      'ตอนที่ ${epList[i * 100]} - ตอนที่ ${epList[(i + 1) * 100 - 1]}');
                }
              }
            });
            print('allEP: $allEP');
            state.dataNovel.novelEp.reversed.toList().sublist(0, 5).forEach(
              (element) {
                print(
                    'ID: ${element.name} publishDate : ${element.publishDate} publishtimw : ${element.publishTime}');
              },
            );
          }
        },
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
            Logger().i('readLast: ${state.hisRead}');
            return Stack(
              children: [
                ListView(
                  controller: _scrollController,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  children: [
                    _buildImageHeader(state.dataNovel.novel.btBgimg),
                    _buildNovelInfoSection(
                      state.dataNovel,
                    ),
                    const SizedBox(height: 60),
                    _buildSegmentedControl(),
                    const SizedBox(height: 15),
                    _buildExpandablePageView(state.dataNovel),
                  ],
                ),
                _buildAppBar(state.dataNovel),
              ],
            );
          } else if (state is NovelDetailError) {
            return Center(
              child: Text(state.message),
            );
          }
          return Center(
            child: LoadingAnimationWidget.discreteCircle(
              color: Colors.grey,
              secondRingColor: Colors.black,
              thirdRingColor: Colors.red[900]!,
              size: 50,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
        elevation: 2,
        onPressed: () async {
          // print('Read Last: $readLast');
          // Navigator.pushNamed(context, 'reader', arguments: readLast);
          var ReadlastXD = await novelBox.get('ReadLast');
          print('ReadlastXD: $ReadlastXD');
        },
        tooltip: 'อ่านตอนล่าสุด',
        child: const Icon(Iconsax.book_1),
      ),
    );
  }

  /// ฟังก์ชันสำหรับสร้างแถบรูปภาพหัวเรื่องนิยาย
  Widget _buildImageHeader(String imageurl) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: imageurl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: Colors.grey[400]!,
              highlightColor: Colors.grey[100]!,
              period: const Duration(milliseconds: 1000),
              child: const ContainerSkeltion(
                height: double.infinity,
                width: double.infinity,
                borderRadius: BorderRadius.zero,
              ),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.1),
                  Colors.white.withOpacity(0.6),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ฟังก์ชันสำหรับแสดงข้อมูลนิยาย (ปก, ชื่อ, ประเภท)
  Widget _buildNovelInfoSection(DataNovel dataNovel) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 80,
          width: double.infinity,
          color: Colors.white,
        ),
        Positioned(
          top: -70,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildCoverImage(dataNovel.novel.img),
                const SizedBox(width: 10),
                _buildNovelDetail(
                  dataNovel.novel.btName,
                  'Fantasy',
                  allEP.toString(),
                  dataNovel.novel.btView.toString(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// ฟังก์ชันสำหรับแสดงรูปปกนิยาย
  Widget _buildCoverImage(String imageurl) {
    return Container(
      width: 130,
      height: 180,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        // color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: CachedNetworkImage(
        imageUrl: imageurl,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) => const Icon(Icons.error),
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: Colors.grey[400]!,
          highlightColor: Colors.grey[100]!,
          period: const Duration(milliseconds: 1000),
          child: const ContainerSkeltion(
            height: double.infinity,
            width: double.infinity,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
    );
  }

  /// ฟังก์ชันสำหรับแสดงรายละเอียดนิยาย
  Widget _buildNovelDetail(
      String name, String cate, String allEp, String view) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: 75),
          SizedBox(
            height: 55,
            child: Text(
              name,
              style:
                  GoogleFonts.athiti(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          const SizedBox(height: 5),
          Text(
            'จำนวนตอน: $allEp',
            style: GoogleFonts.athiti(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 5),
          Text(
            'จำนวนการอ่าน: ${abbreviateNumber(int.parse(view))}',
            style: GoogleFonts.kanit(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  /// ฟังก์ชันสำหรับสร้าง Custom Sliding Segmented Control
  Widget _buildSegmentedControl() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: CustomSlidingSegmentedControl<int>(
        isStretch: true,
        initialValue: _selectedIndex + 1,
        children: {
          1: Text(
            'เกี่ยวกับ',
            style:
                GoogleFonts.athiti(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          2: Text(
            'ตอน',
            style:
                GoogleFonts.athiti(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        },
        decoration: BoxDecoration(
          color: CupertinoColors.lightBackgroundGray,
          borderRadius: BorderRadius.circular(8),
        ),
        thumbDecoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        onValueChanged: (v) {
          _pageController2.animateToPage(
            v - 1,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOutCubic,
          );
        },
      ),
    );
  }

  /// ฟังก์ชันสำหรับสร้าง Expandable Page View
  Widget _buildExpandablePageView(DataNovel dataNovel) {
    return ExpandablePageView(
      controller: _pageController2,
      onPageChanged: (v) {
        setState(() {
          _selectedIndex = v;
        });
      },
      children: [
        _buildAboutSection(dataNovel),
        _buildEpisodeSection(dataNovel),
      ],
    );
  }

  /// ฟังก์ชันสำหรับส่วนเกี่ยวกับนิยาย
  Widget _buildAboutSection(DataNovel dataNovel) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 0),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: dataNovel.novel.btTag.split(',').asMap().entries.map((e) {
              return Container(
                margin: EdgeInsets.only(left: e.key == 0 ? 20 : 5),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: CupertinoColors.lightBackgroundGray,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  e.value,
                  style: GoogleFonts.athiti(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'ข้อมูลลิขสิทธิ์นิยาย',
            style:
                GoogleFonts.athiti(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _buildHtmlContent(dataNovel.novel.btDes),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '5 ตอนล่าสุด',
            style:
                GoogleFonts.athiti(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        ..._buildEpisodeList(dataNovel),
      ],
    );
  }

  DateTime combineDateTime(DateTime publishDate, String publishTime) {
    return DateTime(
        publishDate.year,
        publishDate.month,
        publishDate.day,
        int.parse(publishTime.split(':')[0]),
        int.parse(publishTime.split(':')[1]),
        int.parse(publishTime.split(':')[2]));
  }

  List<Widget> _buildEpisodeList(DataNovel dataNovel) {
    var list = dataNovel.novelEp.reversed.toList();
    DateTime now = DateTime.now();
    var filteredList = list.where((element) {
      DateTime publishDateTime =
          combineDateTime(element.publishDate, element.publishTime);
      return publishDateTime.isBefore(now) ||
          publishDateTime.isAtSameMomentAs(now);
    }).toList();
    filteredList = filteredList.sublist(0, min(5, filteredList.length));
    return List.generate(filteredList.length, (index) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListTile(
          onTap: () {
            print('Tap Episode $index');
            print(filteredList[index].publishDate.toString());
            Navigator.pushNamed(
              context,
              'reader',
              arguments: {
                'bookId': dataNovel.novel.bookId,
                'epId': filteredList[index].epId,
                'bookName': dataNovel.novel.btName,
                'novelEp': dataNovel.novelEp,
              },
            );
          },
          contentPadding: EdgeInsets.zero,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  filteredList[index].name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.athiti(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          subtitle: Text(
            formatDate(filteredList[index].publishDate.toString()),
            style: GoogleFonts.athiti(fontSize: 14, color: Colors.grey),
          ),
          trailing: filteredList[index].typeRead.name == 'FREE'
              ? Text(
                  'อ่านฟรี',
                  style: GoogleFonts.athiti(fontSize: 14, color: Colors.grey),
                )
              : (widget.user.detail.roles[1] == 'public')
                  ? Text(
                      'อ่าน',
                      style: GoogleFonts.athiti(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.yellow[700],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        'VIP',
                        style: GoogleFonts.athiti(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
        ),
      );
    });
  }

  Widget _buildHtmlContent(String html) {
    print(html);
    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutExpo,
          height: isExpanded ? maxHeight : 160,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Html(
              key: _htmlKey,
              data: html,
              style: {
                'body': Style(
                  fontSize: FontSize(16),
                  color: Colors.grey[800],
                  fontFamily: GoogleFonts.athiti().fontFamily,
                ),
                'br': Style(
                  display: Display.none,
                ),
                'p': Style(
                  lineHeight: const LineHeight(1.5),
                  fontSize: FontSize(16),
                  color: Colors.grey[800],
                  fontFamily: GoogleFonts.athiti().fontFamily,
                ),
              },
            ),
          ),
        ),
        _buildExpandCollapseButton(),
      ],
    );
  }

  /// ฟังก์ชันสำหรับปุ่มขยาย/ย่อ
  Widget _buildExpandCollapseButton() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: GestureDetector(
        onTap: () {
          final renderBox =
              _htmlKey.currentContext!.findRenderObject() as RenderBox;
          setState(() {
            isExpanded = !isExpanded;
            maxHeight = renderBox.size.height + 40;
          });
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withOpacity(0.0),
                Colors.white.withOpacity(0.9),
              ],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  /// ฟังก์ชันสำหรับส่วนตอนของนิยาย
  Widget _buildEpisodeSection(DataNovel dataNovel) {
    return Epview(
      groupList: groupList,
      novelEp: dataNovel.novelEp,
      bookname: dataNovel.novel.btName,
      role: widget.user.detail.roles[1] ?? '',
    );
  }

  /// ฟังก์ชันสำหรับสร้าง AppBar
  Widget _buildAppBar(DataNovel dataNovel) {
    var bytes = utf8.encode(dataNovel.novel.btId.toString());
    String url =
        'https://bookfet.com/noveldetail/${base64.encode(bytes)}_${Uri.encodeComponent(dataNovel.novel.btName)}';
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AppBar(
        backgroundColor: isAtTop ? Colors.transparent : Colors.white,
        foregroundColor: isAtTop ? Colors.white : Colors.black,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              Share.share(url);
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
                ? _bookmarkManager.addBookmark(dataNovel)
                : _bookmarkManager.removeBookmark(dataNovel.novel.bookId),
          ),
        ],
      ),
    );
  }
}
