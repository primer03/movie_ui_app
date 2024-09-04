import 'dart:convert';

import 'package:bloctest/bloc/novelread/readnovel_bloc.dart';
import 'package:bloctest/main.dart';
import 'package:bloctest/models/novel_detail_model.dart';
import 'package:bloctest/models/novel_read_model.dart';
import 'package:bloctest/service/BookmarkManager.dart';
import 'package:bloctest/service/SecurityManager.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:interactive_slider/interactive_slider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ReaderPage extends StatefulWidget {
  const ReaderPage({
    Key? key,
    required this.bookId,
    required this.bookName,
    required this.epId,
    required this.novelEp,
  }) : super(key: key);
  final String bookId;
  final String epId;
  final String bookName;
  final List<NovelEp> novelEp;

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _nestedScrollController = ScrollController();
  final ScrollController _listViewController = ScrollController();
  final GlobalKey _containerKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double _scrollPercentage = 0.0;
  double _brightness = 0.5;
  bool _isToggled = false;
  double _currentBrightness = 0.5;
  int _currentSelectedFont = 0;
  double _currentSelectedFontSize = 0.16;
  double _previousScrollPosition = 0.0;
  bool _isScrollingDown = true;
  int _toggleCount = 0;
  TextEditingController _fontSizeController = TextEditingController();
  late GoogleFonts _selectedFont;
  BookfetNovelRead? _bookfetRead;
  DateTime? lastPressed;
  bool _isThick = false;
  bool _isMaxPage = false;
  String EpID = '';
  List<Map<String, dynamic>> TheamSetting = [
    {
      'bg': Colors.white,
      'fg': Colors.black,
      'name': 'Light',
    },
    {
      'bg': const Color(0xFF18191A),
      // 'bg': const Color(0xFF3C3C3C),
      'fg': const Color(0xFFE0E0E0),
      'name': 'Dark',
    },
    {
      'bg': const Color(0xFFE3F2FD),
      'fg': const Color(0xFF0D47A1),
      'name': 'Blue',
    },
    {
      'bg': const Color(0xFFFAF3E0),
      'fg': const Color(0xFF6F4F28),
      'name': 'Sepia',
    },
  ];
  late Map<String, dynamic> _selectedTheam = TheamSetting[0];
  final List<Map<String, dynamic>> _fontFamily = [
    {
      'fontName': GoogleFonts.kanit().fontFamily?.split('_')[0],
      'fontFamily': GoogleFonts.kanit()
    },
    {
      'fontName': GoogleFonts.athiti().fontFamily?.split('_')[0],
      'fontFamily': GoogleFonts.athiti()
    },
    {
      'fontName': GoogleFonts.prompt().fontFamily?.split('_')[0],
      'fontFamily': GoogleFonts.prompt()
    },
    {
      'fontName': GoogleFonts.mitr().fontFamily?.split('_')[0],
      'fontFamily': GoogleFonts.mitr()
    },
    {
      'fontName': GoogleFonts.sarabun().fontFamily?.split('_')[0],
      'fontFamily': GoogleFonts.sarabun()
    },
  ];

  @override
  void initState() {
    super.initState();
    setTheme();
    _scrollController.addListener(_calculateScrollPercentage);
    _initializeBrightness();
    setWindowFlags();
    // _getCurrentBrightness();
    _fontSizeController.text = '16';
    print('Book ID: ${widget.bookId}');
    print('Episode ID: ${widget.epId}');
    context.read<ReadnovelBloc>().add(
          FetchReadnovel(
            bookId: widget.bookId,
            epId: widget.epId,
          ),
        );
  }

  void setWindowFlags() async {
    SecurityManager.enableSecurity(); // ปิดการแสดงหน้าต่างและการถ่ายภาพ
  }

  void disableWindowFlags() async {
    SecurityManager.disableSecurity(); // เปิดการแสดงหน้าต่างและการถ่ายภาพ
  }

  @override
  void dispose() {
    _scrollController.removeListener(_calculateScrollPercentage);
    _scrollController.dispose();
    _resetBrightness();
    disableWindowFlags();
    super.dispose();
  }

  Future<void> setTheme() async {
    final theme = await novelBox.get('theme');
    final fontthick = await novelBox.get('fontStyle');
    final fontSize = await novelBox.get('fontSize');
    final fontFamily = await novelBox.get('fontFamily');
    final brightness = await novelBox.get('brightness');
    if (brightness != null) {
      _brightness = brightness;
      await ScreenBrightness().setScreenBrightness(brightness);
    }
    if (fontFamily != null) {
      _currentSelectedFont = _fontFamily.indexWhere(
        (element) => element['fontName'] == fontFamily,
      );
    }
    if (fontSize != null) {
      _fontSizeController.text = fontSize;
    }
    if (fontthick != null) {
      if (fontthick == 'bold') {
        _isThick = true;
      } else {
        _isThick = false;
      }
    }
    if (theme != null) {
      setState(() {
        _selectedTheam = TheamSetting.firstWhere(
          (element) => element['name'] == theme,
          orElse: () => TheamSetting[0],
        );
      });
    }
  }

  void setDefaultTheme() async {
    final double result = await ScreenBrightness().current;
    setState(() {
      _selectedTheam = TheamSetting[0];
      _brightness = result;
      _currentBrightness = result;
      _currentSelectedFont = 0;
      _fontSizeController.text = '16';
      _isThick = false;
    });
  }

  Future<void> _initializeBrightness() async {}

  Future<void> _getCurrentBrightness() async {
    try {
      final double result = await ScreenBrightness().current;
      setState(() {
        _currentBrightness = result;
        _brightness = result;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _resetBrightness() async {
    try {
      await ScreenBrightness().resetScreenBrightness();
    } catch (e) {
      print(e);
      throw 'Failed to reset brightness';
    }
  }

  void _calculateScrollPercentage() {
    final maxScrollExtent = _scrollController.position.maxScrollExtent;
    final currentScrollPosition = _scrollController.position.pixels;
    // print('Scroll Position: $currentScrollPosition');
    setState(() {
      _isScrollingDown = currentScrollPosition < _previousScrollPosition;
      _scrollPercentage =
          (currentScrollPosition / maxScrollExtent).clamp(0.0, 1.0) * 100;
      _isMaxPage = currentScrollPosition == maxScrollExtent;
      _previousScrollPosition = currentScrollPosition;
      _toggleCount = 0;
      _isToggled = false;
    });
    // print('Scroll Percentage: $_scrollPercentage');
    // print('Scrolling Down: $_isScrollingDown');
  }

  void _MoveScrollListEP() {
    var index = widget.novelEp.indexWhere((element) => element.epId == EpID);
    var length = widget.novelEp.length;
    var positionmove = _listViewController.position.maxScrollExtent / length;
    // print('Position: ${MediaQuery.of(context).size.height}');
    _listViewController.animateTo(
      ((index + 1) * positionmove) - 50,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        final now = DateTime.now();
        const maxDuration = Duration(seconds: 2);
        final isWarning =
            lastPressed == null || now.difference(lastPressed!) > maxDuration;

        if (isWarning) {
          lastPressed = DateTime.now();
          BookmarkManager(context, (bool checkAdd) {})
              .showToast('กดอีกครั้งเพื่อออกจากหน้านี้');
          return;
        }
        Navigator.pop(context);
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          backgroundColor: _selectedTheam['bg'],
          child: ListView.builder(
            controller: _listViewController,
            itemCount: widget.novelEp.length,
            itemBuilder: (context, index) {
              return ListTile(
                key: Key('item-$index'),
                title: Text(
                  widget.novelEp[index].name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _selectedTheam['fg'],
                    fontFamily: _fontFamily[_currentSelectedFont]['fontName'],
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                tileColor: EpID == widget.novelEp[index].epId
                    ? _selectedTheam['fg']?.withOpacity(0.1)
                    : _selectedTheam['bg'],
                trailing: widget.novelEp[index].typeRead.name == 'FREE'
                    ? Text(
                        'อ่านฟรี',
                        style: TextStyle(
                            color: _selectedTheam['fg']?.withOpacity(0.5),
                            fontWeight: FontWeight.w600,
                            fontFamily: _fontFamily[_currentSelectedFont]
                                ['fontName'],
                            fontSize: 14,
                            fontStyle: FontStyle.italic),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellow[700],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          'VIP',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontFamily: _fontFamily[_currentSelectedFont]
                                  ['fontName'],
                              fontSize: 14,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                onTap: () {
                  context.read<ReadnovelBloc>().add(
                        FetchReadnovel(
                          bookId: widget.bookId,
                          epId: widget.novelEp[index].epId,
                        ),
                      );
                  setState(() {
                    _isToggled = false;
                    _toggleCount = 0;
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
        backgroundColor: _selectedTheam['bg'],
        body: Stack(children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                floating: true,
                snap: true,
                pinned: false,
                surfaceTintColor: _selectedTheam['bg'],
                backgroundColor: _selectedTheam['bg'],
                foregroundColor: _selectedTheam['fg'],
                leadingWidth: 40,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(
                  widget.bookName,
                  style: GoogleFonts.athiti(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _selectedTheam['fg'],
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Iconsax.setting_2),
                    onPressed: () {
                      _showSettingsModal();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () async {
                      var bytesbookId = utf8.encode(widget.bookId);
                      var base64StrbookId = base64.encode(bytesbookId);
                      var bytesepId = utf8.encode(".${widget.epId}");
                      var base64StrepId = base64.encode(bytesepId);
                      var shareText =
                          'https://bookfet.com/novelread/$base64StrbookId$base64StrepId';
                      final result = await Share.share(
                        shareText,
                        subject: 'Check out this novel',
                      );
                      if (result.status == ShareResultStatus.success) {
                        print('Thank you for sharing my website!');
                      }
                    },
                  ),
                ],
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    BlocBuilder<ReadnovelBloc, ReadnovelState>(
                      buildWhen: (previous, current) => previous != current,
                      builder: (context, state) {
                        if (state is ReadnovelLoading) {
                          return Container(
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.height - 100,
                            child: LoadingAnimationWidget.discreteCircle(
                              color: Colors.grey,
                              secondRingColor: Colors.black,
                              thirdRingColor: Colors.red[900]!,
                              size: 50,
                            ),
                          );
                        } else if (state is ReadnovelLoaded) {
                          _bookfetRead = state.bookfetNovelRead;
                          EpID = state.bookfetNovelRead.readnovel.novelEp.epId;
                          print(
                              'EpID: ${state.bookfetNovelRead.readnovel.novelEp.epId}');
                          return _buildContent(state.bookfetNovelRead);
                        } else if (state is ReadnovelError) {
                          return Center(
                            child: Text(
                              state.message.split(':').last,
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_isScrollingDown || _isMaxPage) ...[
            BlocBuilder<ReadnovelBloc, ReadnovelState>(
                builder: (context, state) {
              if (state is ReadnovelLoaded) {
                return _buildFooter(state.bookfetNovelRead);
              } else {
                return const SizedBox.shrink();
              }
            }),
            BlocBuilder<ReadnovelBloc, ReadnovelState>(
                builder: (context, state) {
              if (state is ReadnovelLoaded) {
                return _buildCircularMenu();
              } else {
                return const SizedBox.shrink();
              }
            }),
          ],
        ]),
      ),
    );
  }

  Widget _buildContent(BookfetNovelRead bookfetNovelRead) {
    return GestureDetector(
      onTap: () {
        print('Tapped');
        _scrollController.animateTo(
          _scrollController.offset + 150,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      },
      child: Container(
        color: _selectedTheam['bg'],
        padding: const EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: 80,
        ),
        child: HtmlWidget(
          bookfetNovelRead.readnovel.novelEp.detail ?? '',
          customWidgetBuilder: (element) {
            if (element.localName == 'br') {
              return const SizedBox(height: 5);
            }
            return null;
          },
          textStyle: GoogleFonts.getFont(
            _fontFamily[_currentSelectedFont]['fontName'],
            fontSize: double.parse(_fontSizeController.text),
            color: _selectedTheam['fg'],
            fontWeight: _isThick ? FontWeight.bold : FontWeight.normal,
          ),
          renderMode: RenderMode.column,
        ),
      ),
    );
  }

  Positioned _buildFooter(BookfetNovelRead bookfet) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.only(
          left: 0,
          right: 10,
        ),
        width: MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
          color: _selectedTheam['bg'],
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: _selectedTheam['name'] == 'Dark'
                  ? Colors.black
                  : _selectedTheam['name'] == 'Light'
                      ? Colors.grey
                      : _selectedTheam['name'] == 'Blue'
                          ? Colors.blue[200] ?? Colors.blue
                          : const Color(0xFFDABF8C),
              spreadRadius: 1,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: _selectedTheam['fg'],
              ),
              onPressed: () async {
                if (bookfet.readnovel.previousOrNext.previous != null) {
                  context.read<ReadnovelBloc>().add(
                        FetchReadnovel(
                          bookId: bookfet.readnovel.novelBook.bookId,
                          epId: bookfet.readnovel.previousOrNext.previous!.epId,
                        ),
                      );
                  _scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 1),
                    curve: Curves.ease,
                  );
                } else {
                  BookmarkManager(context, (bool checkAdd) {}).showToast(
                    'ไม่มีตอนก่อนหน้านี้',
                    gravity: ToastGravity.CENTER,
                  );
                }
              },
            ),
            Text(
              '${bookfet.readnovel.novelEp.ep} / ${bookfet.readnovel.allep.length}',
              style: GoogleFonts.athiti(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _selectedTheam['fg'],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.arrow_forward_ios,
                color: _selectedTheam['fg'],
              ),
              onPressed: () {
                if (bookfet.readnovel.previousOrNext.next != null) {
                  context.read<ReadnovelBloc>().add(
                        FetchReadnovel(
                          bookId: bookfet.readnovel.novelBook.bookId,
                          epId: bookfet.readnovel.previousOrNext.next!.epId,
                        ),
                      );
                  _scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 1),
                    curve: Curves.ease,
                  );
                } else {
                  BookmarkManager(context, (bool checkAdd) {}).showToast(
                    'ไม่มีตอนถัดไป',
                    gravity: ToastGravity.CENTER,
                  );
                }
              },
            ),
            const Spacer(),
            Text(
              'บทที่ ${bookfet.readnovel.novelEp.ep} / ${_scrollPercentage.toStringAsFixed(0)} %',
              style: GoogleFonts.athiti(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _selectedTheam['fg'],
              ),
            ),
          ],
        ).animate().fade(),
      ),
    );
  }

  Positioned _buildCircularMenu() {
    final isDarkTheme = _selectedTheam['name'] == 'Dark';
    final isLightTheme = _selectedTheam['name'] == 'Light';
    final toggleButtonColor = isDarkTheme
        ? _selectedTheam['bg']
        : (isLightTheme ? Colors.white : _selectedTheam['fg']);
    final toggleButtonIconColor = isDarkTheme
        ? _selectedTheam['fg']
        : (isLightTheme ? Colors.black : _selectedTheam['bg']);
    final boxShadowColor = isDarkTheme
        ? Colors.black
        : (isLightTheme
            ? Colors.grey
            : (_selectedTheam['name'] == 'Blue'
                ? Colors.blue[100] ?? Colors.blue
                : const Color(0xFFF4E4C1)));

    return Positioned(
      bottom: 30,
      left: 0,
      right: 0,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          color: Colors.transparent,
          width: _isToggled ? 210 : 73,
          height: _isToggled ? 170 : 73,
          child: CircularMenu(
            toggleButtonOnPressed: () {
              setState(() {
                _toggleCount++;
                _isToggled = _toggleCount % 2 != 0;
              });
              print('Toggle: $_isToggled');
            },
            alignment: Alignment.bottomCenter,
            startingAngleInRadian: 1.25 * 3.14,
            endingAngleInRadian: 1.75 * 3.14,
            radius: 100,
            toggleButtonColor: toggleButtonColor,
            toggleButtonSize: 35,
            toggleButtonIconColor: toggleButtonIconColor,
            toggleButtonBoxShadow: [
              BoxShadow(
                color: boxShadowColor,
                spreadRadius: 1,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
            items: [
              //open drawer
              _buildMenuItem(Icons.list, onTap: () {
                _scaffoldKey.currentState?.openDrawer();
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _MoveScrollListEP();
                });
              }),
              _buildMenuItem(Iconsax.message_text),
              _buildMenuItem(Iconsax.setting_2, onTap: _showSettingsModal),
            ],
          ),
        ).animate().fade(),
      ),
    );
  }

  CircularMenuItem _buildMenuItem(IconData icon, {VoidCallback? onTap}) {
    final isDarkTheme = _selectedTheam['name'] == 'Dark';
    final isLightTheme = _selectedTheam['name'] == 'Light';
    final itemColor = isDarkTheme
        ? const Color(0xFF121212)
        : (isLightTheme ? Colors.grey[300] : _selectedTheam['fg']);
    final iconColor = isDarkTheme
        ? Colors.white
        : (isLightTheme ? Colors.black : _selectedTheam['bg']);

    return CircularMenuItem(
      icon: icon,
      onTap: onTap ?? () {},
      color: itemColor,
      iconColor: iconColor,
    );
  }

  Color getBackgroundColor(Map<String, dynamic> selectedTheme) {
    switch (selectedTheme['name']) {
      case 'Dark':
        return const Color(0xFF121212);
      case 'Light':
        return Colors.grey[200] ?? const Color(0xFFF5F5F5);
      case 'Blue':
        return Colors.blue[100] ?? const Color(0xFFBBDEFB);
      case 'Sepia':
        return const Color(0xFFF4E4C1);
      default:
        return Colors.grey[200] ?? const Color(0xFFE0E0E0);
    }
  }

  void _showSettingsModal() {
    showMaterialModalBottomSheet(
      duration: const Duration(milliseconds: 500),
      animationCurve: Curves.fastOutSlowIn,
      barrierColor: Colors.black.withOpacity(0.5),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, states) {
            return SingleChildScrollView(
              controller: ModalScrollController.of(context),
              child: Container(
                padding: const EdgeInsets.only(
                    top: 20, left: 10, right: 10, bottom: 10),
                decoration: BoxDecoration(
                  color: _selectedTheam['bg'],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildBrightnessSlider(states),
                    const SizedBox(height: 20),
                    _buildFontCarousel(states),
                    _buildIndicator(states),
                    const SizedBox(height: 15),
                    _buildFontSizeControls(states),
                    const SizedBox(height: 10),
                    _buildThemeSelectors(states),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     ElevatedButton.icon(
                    //       onPressed: () async {
                    //         await novelBox.delete('theme');
                    //         await novelBox.delete('fontFamily');
                    //         await novelBox.delete('fontSize');
                    //         await novelBox.delete('fontStyle');
                    //         await novelBox.delete('brightness');
                    //         setDefaultTheme();
                    //         Navigator.pop(context);
                    //         states(() {});
                    //       },
                    //       style: ElevatedButton.styleFrom(
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(10),
                    //         ),
                    //         backgroundColor: getBackgroundColor(_selectedTheam),
                    //         foregroundColor: _selectedTheam['fg'],
                    //         padding: const EdgeInsets.symmetric(
                    //             horizontal: 10, vertical: 5),
                    //         // minimumSize: const Size(double.infinity, 55),
                    //       ),
                    //       icon:
                    //           const Icon(Iconsax.refresh_left_square, size: 20),
                    //       label: Text(
                    //         'คืนค่าเริ่มต้น',
                    //         style: GoogleFonts.athiti(
                    //           fontSize: 16,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildIndicator(StateSetter states) {
    return AnimatedSmoothIndicator(
      activeIndex: _currentSelectedFont,
      count: _fontFamily.length,
      onDotClicked: (inedx) {
        print('Font Family: ${_fontFamily[inedx]['fontName']}');
        setState(() {
          _currentSelectedFont = inedx;
        });
        states(() {
          _currentSelectedFont = inedx;
        });
      },
      effect: JumpingDotEffect(
        // verticalOffset: 15,
        activeDotColor: _selectedTheam['fg'],
        dotColor: _selectedTheam['fg'].withOpacity(0.5),
        dotHeight: 10,
        dotWidth: 10,
      ),
    );
  }

  Widget _buildBrightnessSlider(StateSetter states) {
    return InteractiveSlider(
      padding: const EdgeInsets.all(0),
      startIcon: const Icon(CupertinoIcons.sun_max),
      endIcon: const Icon(CupertinoIcons.sun_max_fill),
      backgroundColor: getBackgroundColor(_selectedTheam),
      foregroundColor: _selectedTheam['name'] == 'Dark'
          ? _selectedTheam['bg']
          : _selectedTheam['name'] == 'Light'
              ? Colors.grey[800]
              : _selectedTheam['fg'],
      iconColor: _selectedTheam['fg'],
      min: 0.0,
      max: 1.0,
      initialProgress: _brightness,
      onChanged: (value) async {
        setState(() {
          _brightness = value;
        });
        await ScreenBrightness().setScreenBrightness(value);
        novelBox.put('brightness', value);
        print('Brightness: $_brightness');
      },
    );
  }

  Widget _buildFontCarousel(StateSetter states) {
    return Stack(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 40,
            viewportFraction: 0.27,
            enlargeFactor: 0.2,
            initialPage: _currentSelectedFont,
            onPageChanged: (index, reason) {
              setState(() {
                print('Font Family: ${_fontFamily[index]['fontName']}');
                _currentSelectedFont = index;
              });
              states(() {
                _currentSelectedFont = index;
              });
              novelBox.put('fontFamily', _fontFamily[index]['fontName']);
            },
          ),
          items: _fontFamily.asMap().entries.map((e) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  alignment: Alignment.topCenter,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(
                    e.value['fontName'],
                    style: GoogleFonts.getFont(
                      e.value['fontName'],
                      fontSize: 18,
                      color: _currentSelectedFont == e.key
                          ? _selectedTheam['fg']
                          : Colors.grey,
                      fontWeight: _currentSelectedFont == e.key
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        Positioned(
          top: 0,
          left: 0,
          bottom: 0,
          child: Container(
            height: 40,
            width: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _selectedTheam['bg'],
                  _selectedTheam['bg'].withOpacity(0.0),
                ],
                stops: const [0.0, 1.0],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: 40,
            width: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _selectedTheam['bg'].withOpacity(0.0),
                  _selectedTheam['bg'],
                ],
                stops: const [0.0, 1.0],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFontSizeControls(StateSetter states) {
    return Row(
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.center,
            height: 55,
            margin: const EdgeInsets.only(left: 10),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            decoration: BoxDecoration(
              color: getBackgroundColor(_selectedTheam),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () async {
                    _isThick = false;
                    await novelBox.put('fontStyle', 'normal');
                    setState(() {});
                    states(() {});
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.black,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  ),
                  child: Text(
                    'Aa',
                    style: GoogleFonts.athiti(
                      fontSize: 25,
                      color: _selectedTheam['fg'],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                  child: VerticalDivider(
                    width: 20,
                    thickness: 1,
                    color: Colors.black,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    _isThick = true;
                    await novelBox.put('fontStyle', 'bold');
                    setState(() {});
                    states(() {});
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.black,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  ),
                  child: Text(
                    'Aa',
                    style: GoogleFonts.athiti(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: _selectedTheam['fg'],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            height: 55,
            margin: const EdgeInsets.only(right: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      _fontSizeController.text =
                          (int.parse(_fontSizeController.text) + 1).toString();
                      // print('Font Size: ${_fontSizeController.text}');
                      await novelBox.put('fontSize', _fontSizeController.text);
                      setState(() {});
                      states(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: getBackgroundColor(_selectedTheam),
                      foregroundColor: _selectedTheam['fg'],
                      shadowColor: _selectedTheam['name'] == 'Dark'
                          ? Colors.black
                          : _selectedTheam['fg'],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      minimumSize: const Size(double.infinity, 55),
                    ),
                    child: const Icon(Iconsax.add, size: 20),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _fontSizeController,
                    readOnly: true,
                    style: GoogleFonts.athiti(
                      fontSize: 20,
                      color: _selectedTheam['fg'],
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          width: 2,
                          color: _selectedTheam['name'] == 'Dark'
                              ? Colors.black
                              : _selectedTheam['name'] == 'Light'
                                  ? Colors.grey
                                  : _selectedTheam['fg'],
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(10),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (int.parse(_fontSizeController.text) > 14) {
                        _fontSizeController.text =
                            (int.parse(_fontSizeController.text) - 1)
                                .toString();
                        print('Font Size: ${_fontSizeController.text}');
                        await novelBox.put(
                            'fontSize', _fontSizeController.text);
                        setState(() {});
                        states(() {});
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: getBackgroundColor(_selectedTheam),
                      foregroundColor: _selectedTheam['fg'],
                      shadowColor: _selectedTheam['name'] == 'Dark'
                          ? Colors.black
                          : _selectedTheam['fg'],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      minimumSize: const Size(double.infinity, 55),
                    ),
                    child: const Icon(Iconsax.minus, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThemeSelectors(StateSetter states) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: TheamSetting.asMap()
            .entries
            .map((e) {
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTheam = e.value;
                    });
                    states(() {
                      _selectedTheam = e.value;
                    });
                    novelBox.put('theme', e.value['name']);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        height: 80,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: e.value['bg'],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _selectedTheam['name'] == e.value['name']
                                ? Colors.black
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Iconsax.textalign_justifycenter,
                          size: 60,
                          color: e.value['fg'],
                        ),
                      ),
                      Text(
                        e.value['name'],
                        style: GoogleFonts.athiti(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _selectedTheam['fg'],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            })
            .toList()
            .expand((element) => [
                  const SizedBox(width: 10),
                  element,
                ])
            .toList(),
      ),
    );
  }
}
