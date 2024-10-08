import 'dart:async';
import 'dart:convert';
import 'package:bloctest/bloc/novelread/readnovel_bloc.dart';
import 'package:bloctest/bloc/novelrec/novelrec_bloc.dart';
import 'package:bloctest/main.dart';
import 'package:bloctest/models/novel_detail_model.dart';
import 'package:bloctest/models/novel_read_model.dart';
import 'package:bloctest/models/user_model.dart';
import 'package:bloctest/service/BookmarkManager.dart';
import 'package:bloctest/service/SecurityManager.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:interactive_slider/interactive_slider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:logger/web.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:io' show Platform;
import 'package:html/parser.dart' as parser;

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
  TextEditingController _spacingController = TextEditingController();
  late GoogleFonts _selectedFont;
  BookfetNovelRead? _bookfetRead;
  DateTime? lastPressed;
  bool _isThick = false;
  bool _isMaxPage = false;
  bool _isMinPage = false;
  bool _isautoScroll = false;
  String EpID = '';
  Timer? _debounce;
  Timer? _timer;
  late User user;
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
    // {
    //   'bg': const Color(0xFFE3F2FD),
    //   'fg': const Color(0xFF0D47A1),
    //   'name': 'Blue',
    // },
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
  final Map<int, GlobalKey> itemKeys = {};
  int _scrollSpeed = 3000;
  String _scrollSpeedName = 'ปกติ';
  final List<Map<String, dynamic>> _speedscroll = [
    {
      'name': 'ช้ามาก',
      'speed': 5000,
    },
    {
      'name': 'ช้า',
      'speed': 4000,
    },
    {
      'name': 'ปกติ',
      'speed': 3000,
    },
    {
      'name': 'เร็ว',
      'speed': 2000,
    },
    {
      'name': 'เร็วมาก',
      'speed': 1000,
    },
  ];

  @override
  void initState() {
    super.initState();
    setTheme();
    _scrollController.addListener(_calculateScrollPercentage);
    _initializeBrightness();
    enableScreenSecurity();
    _fontSizeController.text = '16';
    _spacingController.text = '20';
    print('Book ID: ${widget.bookId}');
    print('Episode ID: ${widget.epId}');
    context.read<ReadnovelBloc>().add(
          FetchReadnovel(
            bookId: widget.bookId,
            epId: widget.epId,
          ),
        );
    for (var i = 0; i < widget.novelEp.length; i++) {
      itemKeys[i] = GlobalKey();
    }
    getUserData();
  }

  void startAutoScroll() {
    _timer = Timer.periodic(Duration(milliseconds: _scrollSpeed), (timer) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.offset + 100,
          duration: Duration(milliseconds: _scrollSpeed),
          curve: Curves.linear,
        );
      }
    });
  }

  void stopAutoScroll() {
    _timer?.cancel();
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.offset); // หยุดการเลื่อนทันที
    }
  }

  Future<void> getUserData() async {
    user = User.fromJson(json.decode(await novelBox.get('user')));
    Logger().i("User: $user");
  }

  Future<void> enableScreenSecurity() async {
    try {
      bool result = await NoScreenshot.instance.screenshotOff();
      debugPrint('Screenshot Off: $result');
    } on PlatformException catch (e) {
      print("Failed to enable screen security: '${e.message}'.");
    }
  }

  // Method to disable screen security
  Future<void> disableScreenSecurity() async {
    try {
      bool result = await NoScreenshot.instance.screenshotOn();
      debugPrint('Screenshot On: $result');
      print('Screen security disablexxxd');
    } on PlatformException catch (e) {
      print("Failed to disable screen security: '${e.message}'.");
    }
  }

  String removeStyleHTML(String strhtml) {
    // print('Remove Style HTML $strhtml');
    var document = parser.parse(strhtml);
    var str = "";
    var tageP = document.createElement('p');
    document.querySelectorAll('p').forEach((element) {
      // element.querySelector('p')?.attributes.remove('style');
      // element.querySelector('span')?.attributes.remove('style');
      // element.querySelector('span')?.attributes['style'] = 'color: black;';
      // print(element.innerHtml);
      // tageP.innerHtml += element.innerHtml;
      // str += element.innerHtml;
    });
    // var htmltostring = tageP.outerHtml;
    print('Remove Style HTML $strhtml');
    return strhtml;
  }

  void setWindowFlags() async {
    SecurityManager.enableSecurity();
  }

  void disableWindowFlags() async {
    SecurityManager.disableSecurity();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_calculateScrollPercentage);
    _scrollController.dispose();
    _listViewController.dispose();
    _nestedScrollController.dispose();
    _debounce?.cancel();
    _resetBrightness();
    disableScreenSecurity();
    if (Platform.isIOS) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: SystemUiOverlay.values);
    } else if (Platform.isAndroid) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: SystemUiOverlay.values);
    }
    super.dispose();
  }

  Future<void> setTheme() async {
    final theme = await novelBox.get('theme');
    final fontthick = await novelBox.get('fontStyle');
    final fontSize = await novelBox.get('fontSize');
    final fontFamily = await novelBox.get('fontFamily');
    final brightness = await novelBox.get('brightness');
    final spacing = await novelBox.get('spacing');
    if (spacing != null) {
      _spacingController.text = spacing.toString();
      print('Spacing: ${spacing.runtimeType}');
    }
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

  bool _isImmersiveModeSet =
      false; // ตัวแปรนี้ใช้ในการติดตามสถานะการตั้งค่า immersive mode

  void _calculateScrollPercentage() {
    final maxScrollExtent = _scrollController.position.maxScrollExtent;
    final currentScrollPosition = _scrollController.position.pixels;

    // คำนวณค่า scrollPercentage และสถานะการเลื่อน
    final scrollPercentage =
        (currentScrollPosition / maxScrollExtent).clamp(0.0, 1.0) * 100;
    final isMaxPage = currentScrollPosition == maxScrollExtent;
    final isMinPage = currentScrollPosition == 0;
    final isScrollingDown = currentScrollPosition < _previousScrollPosition;

    // Debounce การเรียก setState เพื่อลดการอัปเดตบ่อย ๆ
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 100), () {
      bool needsUpdate = false;

      // อัปเดตเฉพาะค่าที่เปลี่ยนแปลงเท่านั้น
      if (_scrollPercentage != scrollPercentage) {
        _scrollPercentage = scrollPercentage;
        needsUpdate = true;
      }
      if (_isScrollingDown != isScrollingDown) {
        _isScrollingDown = isScrollingDown;
        needsUpdate = true;
      }
      if (_isMaxPage != isMaxPage) {
        _isMaxPage = isMaxPage;
        needsUpdate = true;
      }
      if (_isMinPage != isMinPage) {
        _isMinPage = isMinPage;
        needsUpdate = true;
      }

      // หากมีค่าที่เปลี่ยนแปลง เรียก setState เพียงครั้งเดียว
      if (needsUpdate) {
        setState(() {
          _toggleCount = 0;
          _isToggled = false;
          _isautoScroll = false;
          stopAutoScroll();
          _previousScrollPosition = currentScrollPosition;
        });
      }

      // Handle immersive mode
      if (!_isScrollingDown) {
        _setImmersiveMode(false); // Scrolling up
      } else {
        _setImmersiveMode(true); // Scrolling down
      }

      if (_isMaxPage) {
        _setImmersiveMode(true);
      }
    });
  }

  void _setImmersiveMode(bool showOverlays) {
    if (_isImmersiveModeSet == showOverlays) {
      return;
    }
    _isImmersiveModeSet = showOverlays;

    if (Platform.isIOS) {
      if (showOverlays) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: SystemUiOverlay.values);
      } else {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
            overlays: []);
      }
    }
    // else if (Platform.isAndroid) {
    //   if (showOverlays) {
    //     SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    //         overlays: SystemUiOverlay.values);
    //   } else {
    //     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
    //         overlays: []);
    //   }
    // }
  }

  Future<void> _moveScrollListEP() async {
    var index = widget.novelEp.indexWhere((element) => element.epId == EpID);
    var length = widget.novelEp.length;

    if (index == -1 || length == 0) return; // ตรวจสอบกรณีที่ไม่พบหรือรายการว่าง

    // ปรับตำแหน่งเลื่อนตามดัชนีรายการที่ต้องการเลื่อน
    double positionToMove =
        (index / (length - 1)) * _listViewController.position.maxScrollExtent;

    if (Platform.isAndroid) {
      await _listViewController.animateTo(
        positionToMove - 30,
        duration: const Duration(milliseconds: 1),
        curve: Curves.easeInOut,
      );
    } else if (Platform.isIOS) {
      await _listViewController.animateTo(
        positionToMove - 30,
        duration: const Duration(milliseconds: 1),
        curve: Curves.easeInOut,
      );
    }
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
        onDrawerChanged: (isOpened) {
          if (isOpened) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (Platform.isAndroid) {
                _moveScrollListEP();
              } else {
                Future.delayed(const Duration(milliseconds: 200), () {
                  _moveScrollListEP();
                });
              }
            });
          }
        },
        drawer: Drawer(
          width: MediaQuery.of(context).size.width * 0.85,
          backgroundColor: _selectedTheam['bg'],
          child: ListView.builder(
            shrinkWrap: true,
            controller: _listViewController,
            itemCount: widget.novelEp.length,
            // itemExtent: 55,
            prototypeItem: ListTile(
              title: Text(
                'Prototype',
                style: TextStyle(
                  color: _selectedTheam['fg'],
                  fontFamily: _fontFamily[_currentSelectedFont]['fontName'],
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            itemBuilder: (context, index) {
              return RepaintBoundary(
                child: ListTile(
                  key: itemKeys[index],
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
                  trailing: IndexedStack(
                    alignment: Alignment.centerRight,
                    index: widget.novelEp[index].typeRead.name == 'FREE'
                        ? 0
                        : user.detail.roles[1] == 'public'
                            ? 1
                            : 2,
                    children: [
                      Text(
                        'อ่านฟรี',
                        style: TextStyle(
                          color: _selectedTheam['fg']?.withOpacity(0.5),
                          fontWeight: FontWeight.w600,
                          fontFamily: _fontFamily[_currentSelectedFont]
                              ['fontName'],
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      SvgPicture.asset(
                        'assets/svg/Unlock_duotone@3x.svg',
                        color: _selectedTheam['fg']?.withOpacity(0.5),
                      ),
                      SvgPicture.asset(
                        'assets/svg/Lock_duotone@3x.svg',
                        color: _selectedTheam['fg']?.withOpacity(0.5),
                      ),
                    ],
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
                ),
              );
            },
          ),
        ),
        backgroundColor: _selectedTheam['bg'],
        body: Stack(children: [
          CustomScrollView(
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
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
                    onPressed: () async {
                      _showSettingsModal();
                      // enableScreenSecurity();
                      // disableScreenSecurity();
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
                    BlocConsumer<ReadnovelBloc, ReadnovelState>(
                      listenWhen: (previous, current) => previous != current,
                      listener: (context, state) {
                        if (state is ReadnovelError) {
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(content: Text(state.message)),
                          // );
                        } else if (state is ReadnovelLoaded) {
                          setState(() {
                            _scrollPercentage = 0.0;
                          });
                          // _calculateScrollPercentage();
                        }
                      },
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
                          // removeStyleHTML(state.bookfetNovelRead.readnovel.novelEp.detail!);
                          return _buildContent(state.bookfetNovelRead);
                        } else if (state is ReadnovelError) {
                          return Center(
                            child: Text(
                              state.message.split(':').last,
                              style: GoogleFonts.athiti(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
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
          ...[
            BlocBuilder<ReadnovelBloc, ReadnovelState>(
                builder: (context, state) {
              if (state is ReadnovelLoaded) {
                return _buildFooter(state.bookfetNovelRead);
              } else {
                return const SizedBox.shrink();
              }
            }),
            // BlocBuilder<ReadnovelBloc, ReadnovelState>(
            //     builder: (context, state) {
            //   if (state is ReadnovelLoaded) {
            //     return _buildCircularMenu();
            //   } else {
            //     return const SizedBox.shrink();
            //   }
            // }),
          ],
        ]),
        floatingActionButton: _isautoScroll
            ? FloatingActionButton(
                onPressed: () {
                  if (_isautoScroll) {
                    stopAutoScroll();
                  } else {
                    startAutoScroll();
                  }
                  setState(() {
                    _isautoScroll = !_isautoScroll;
                  });
                },
                child: Icon(
                  _isautoScroll ? Icons.pause : Icons.play_arrow,
                  color: _selectedTheam['bg'],
                ),
                backgroundColor: _selectedTheam['fg'],
              )
            : null,
      ),
    );
  }

  Widget _buildContent(BookfetNovelRead bookfetNovelRead) {
    // Logger().i('Build Content ${bookfetNovelRead.readnovel.novelEp.detail}');
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
          bottom: 130,
        ),
        child: Html(
          data: bookfetNovelRead.readnovel.novelEp.detail ?? '',
          style: {
            'body': Style(
              backgroundColor: _selectedTheam['bg'],
              fontFamily:
                  _fontFamily[_currentSelectedFont]['fontFamily'].fontFamily,
              fontSize: FontSize(double.parse(_fontSizeController.text)),
              color: _selectedTheam['fg'],
              fontWeight: _isThick ? FontWeight.bold : FontWeight.normal,
            ),
            'p': Style(
              backgroundColor: _selectedTheam['bg'],
              // fontFamily: _fontFamily[_currentSelectedFont]['fontName'],
              fontSize: FontSize(double.parse(_fontSizeController.text)),
              color: _selectedTheam['fg'],
              fontWeight: _isThick ? FontWeight.bold : FontWeight.normal,
              margin: Margins(
                  bottom: Margin(double.parse(_spacingController.text))),
              textAlign: TextAlign.start,
              fontFamily:
                  _fontFamily[_currentSelectedFont]['fontFamily'].fontFamily,
            ),
            'span': Style(
              backgroundColor: _selectedTheam['bg'],
              // fontFamily: _fontFamily[_currentSelectedFont]['fontName'],
              fontSize: FontSize(double.parse(_fontSizeController.text)),
              color: _selectedTheam['fg'],
              fontWeight: _isThick ? FontWeight.bold : FontWeight.normal,
              fontFamily:
                  _fontFamily[_currentSelectedFont]['fontFamily'].fontFamily,
            ),
            'br': Style(
              display: Display.none,
            ),
          },
        ),
        // child: HtmlWidget(
        //   bookfetNovelRead.readnovel.novelEp.detail ?? '',
        //   customStylesBuilder: (element) {
        //     if (element.localName == 'p') {
        //       return {
        //         'font-family': _fontFamily[_currentSelectedFont]['fontName'],
        //         'font-size': '${double.parse(_fontSizeController.text)}px',
        //         'color': _selectedTheam['fg'].toString(),
        //         'font-weight': _isThick ? 'bold' : 'normal',
        //         'background-color': _selectedTheam['bg'].toString(),
        //       };
        //     }
        //     if (element.localName == 'span') {
        //       return {
        //         'font-family': _fontFamily[_currentSelectedFont]['fontName'],
        //         'font-size': '${double.parse(_fontSizeController.text)}px',
        //         'color': _selectedTheam['fg'].toString(),
        //         'font-weight': _isThick ? 'bold' : 'normal',
        //         'background-color': _selectedTheam['bg'].toString(),
        //       };
        //     }
        //     return null;
        //   },
        //   customWidgetBuilder: (element) {
        //     if (element.localName == 'br') {
        //       return const SizedBox(height: 5);
        //     }
        //     if (element.localName == 'span') {
        //       return Text(
        //         element.innerHtml,
        //         style: GoogleFonts.getFont(
        //           _fontFamily[_currentSelectedFont]['fontName'],
        //           fontSize: double.parse(_fontSizeController.text),
        //           color: _selectedTheam['fg'],
        //           fontWeight: _isThick ? FontWeight.bold : FontWeight.normal,
        //           backgroundColor: _selectedTheam['bg'],
        //         ),
        //       );
        //     }
        //     return null;
        //   },
        //   textStyle: GoogleFonts.getFont(
        //     _fontFamily[_currentSelectedFont]['fontName'],
        //     fontSize: double.parse(_fontSizeController.text),
        //     color: _selectedTheam['fg'],
        //     fontWeight: _isThick ? FontWeight.bold : FontWeight.normal,
        //   ),
        //   renderMode: RenderMode.column,
        // ),
      ),
    );
  }

  Positioned _buildFooter(BookfetNovelRead bookfet) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: AnimatedOpacity(
        opacity: !_isautoScroll
            ? (_isScrollingDown || _isMaxPage || _isMinPage)
                ? 1.0
                : 0.0
            : 0.0,
        duration: const Duration(milliseconds: 300),
        child: IgnorePointer(
          ignoring:
              !(_isScrollingDown || _isMaxPage || _isMinPage) || _isautoScroll,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Platform.isAndroid ? 5 : 0),
                topRight: Radius.circular(Platform.isAndroid ? 5 : 0),
              ),
              color: _selectedTheam['bg'],
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
            padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: Platform.isAndroid ? 0 : 10,
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    width: MediaQuery.of(context).size.width - 20,
                    decoration: BoxDecoration(
                      color: _selectedTheam['fg']?.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            bookfet.readnovel.novelEp.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.athiti(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _selectedTheam['fg'],
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        const SizedBox(width: 10),
                        SvgPicture.asset(
                          'assets/svg/up-and-down-arrows-svgrepo-com.svg',
                          colorFilter: ColorFilter.mode(
                            _selectedTheam['fg']!,
                            BlendMode.srcIn,
                          ),
                          width: 15,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                LinearPercentIndicator(
                  width: MediaQuery.of(context).size.width - 20,
                  lineHeight: 12.0,
                  percent: _scrollPercentage / 100,
                  backgroundColor: _selectedTheam['fg']?.withOpacity(0.2),
                  progressColor: _selectedTheam['fg'],
                  barRadius: const Radius.circular(10),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: IconButton(
                        alignment: Alignment.centerLeft,
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          color: _selectedTheam['fg'],
                        ),
                        onPressed: () async {
                          if (bookfet.readnovel.previousOrNext.previous !=
                              null) {
                            context.read<ReadnovelBloc>().add(
                                  FetchReadnovel(
                                    bookId: bookfet.readnovel.novelBook.bookId,
                                    epId: bookfet.readnovel.previousOrNext
                                        .previous!.epId,
                                  ),
                                );
                            _scrollController.animateTo(
                              0,
                              duration: const Duration(milliseconds: 1),
                              curve: Curves.ease,
                            );
                          } else {
                            BookmarkManager(context, (bool checkAdd) {})
                                .showToast(
                              'ไม่มีตอนก่อนหน้านี้',
                              gravity: ToastGravity.CENTER,
                            );
                          }
                        },
                      ),
                    ),
                    Text(
                      'บทที่ ${bookfet.readnovel.novelEp.ep} / ${bookfet.readnovel.allep.length}',
                      style: GoogleFonts.athiti(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _selectedTheam['fg'],
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        alignment: Alignment.centerRight,
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: _selectedTheam['fg'],
                        ),
                        onPressed: () async {
                          if (bookfet.readnovel.previousOrNext.next != null) {
                            context.read<ReadnovelBloc>().add(
                                  FetchReadnovel(
                                    bookId: bookfet.readnovel.novelBook.bookId,
                                    epId: bookfet
                                        .readnovel.previousOrNext.next!.epId,
                                  ),
                                );
                            _scrollController.animateTo(
                              0,
                              duration: const Duration(milliseconds: 1),
                              curve: Curves.ease,
                            );
                          } else {
                            BookmarkManager(context, (bool checkAdd) {})
                                .showToast(
                              'ไม่มีตอนถัดไป',
                              gravity: ToastGravity.CENTER,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
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
                // WidgetsBinding.instance.addPostFrameCallback((_) {
                //   _MoveScrollListEP();
                // });
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
                    const SizedBox(height: 5),
                    _buildSpacingRow(states),
                    const SizedBox(height: 5),
                    _buildScrollAuto(states),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const SizedBox(width: 20),
                        Text(
                          'ความเร็ว',
                          style: GoogleFonts.athiti(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _selectedTheam['fg'],
                          ),
                        ),
                        const Spacer(),
                        DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            value: _speedscroll
                                .where((element) =>
                                    element['speed'] == _scrollSpeed)
                                .first['name'],
                            items: _speedscroll
                                .map((e) => DropdownMenuItem(
                                      value: e['name'],
                                      child: Text(
                                        e['name'],
                                        style: GoogleFonts.athiti(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: _selectedTheam['fg'],
                                        ),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              print(_speedscroll.where(
                                  (element) => element['name'] == value));
                              setState(() {
                                _scrollSpeed = _speedscroll.where((element) {
                                  return element['name'] == value;
                                }).first['speed'];
                              });
                              states(() {
                                _scrollSpeed = _speedscroll.where((element) {
                                  return element['name'] == value;
                                }).first['speed'];
                              });
                            },
                            dropdownStyleData: DropdownStyleData(
                              decoration: BoxDecoration(
                                color: _selectedTheam['bg'],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              // elevation: 5,
                              padding: const EdgeInsets.all(10),
                            ),
                            style: GoogleFonts.athiti(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
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

  Widget _buildScrollAuto(StateSetter states) {
    return Row(
      children: [
        const SizedBox(width: 20),
        Text(
          'เลื่อนอัตโนมัติ',
          style: GoogleFonts.athiti(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _selectedTheam['fg'],
          ),
        ),
        const Spacer(),
        Switch(
          value: _isautoScroll,
          onChanged: (value) {
            value ? startAutoScroll() : stopAutoScroll();
            setState(() {
              _isautoScroll = value;
            });
            states(() {
              _isautoScroll = value;
            });
          },
          activeColor: _selectedTheam['fg'],
          activeTrackColor: _selectedTheam['fg']?.withOpacity(0.5),
          inactiveThumbColor: _selectedTheam['fg'],
          inactiveTrackColor: _selectedTheam['fg']?.withOpacity(0.5),
        ),
      ],
    );
  }

  Widget _buildSpacingRow(StateSetter states) {
    return Row(
      children: [
        const SizedBox(width: 20),
        Text(
          'ระยะห่าง',
          style: GoogleFonts.athiti(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _selectedTheam['fg'],
          ),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            final spacing = int.parse(_spacingController.text);
            final newSpacing = spacing + 1;
            _spacingController.text = newSpacing.toString();
            novelBox.put('spacing', newSpacing);
            states(() {
              _spacingController.text = newSpacing.toString();
            });
            setState(() {
              _spacingController.text = newSpacing.toString();
            });
          },
          color: _selectedTheam['fg'],
        ),
        Container(
          width: 50,
          child: TextFormField(
            controller: _spacingController,
            readOnly: true,
            style: GoogleFonts.athiti(
              fontSize: 20,
              color: _selectedTheam['fg'],
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.all(10),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () {
            final spacing = int.parse(_spacingController.text);
            if (spacing > 0) {
              final newSpacing = spacing - 1;
              _spacingController.text = newSpacing.toString();
              novelBox.put('spacing', newSpacing);
              states(() {
                _spacingController.text = newSpacing.toString();
              });
              setState(() {
                _spacingController.text = newSpacing.toString();
              });
            }
          },
          color: _selectedTheam['fg'],
        ),
      ],
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
                      setState(() {
                        _fontSizeController.text =
                            (int.parse(_fontSizeController.text)).toString();
                      });
                      states(() {
                        _fontSizeController.text =
                            (int.parse(_fontSizeController.text)).toString();
                      });
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
                        setState(() {
                          _fontSizeController.text =
                              (int.parse(_fontSizeController.text)).toString();
                        });
                        states(() {
                          _fontSizeController.text =
                              (int.parse(_fontSizeController.text)).toString();
                        });
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
                  child: Padding(
                    padding: e.key == 0
                        ? const EdgeInsets.only(right: 20)
                        : e.key == TheamSetting.length - 1
                            ? const EdgeInsets.only(left: 20)
                            : const EdgeInsets.symmetric(horizontal: 5),
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
                ),
              );
            })
            .toList()
            .expand((element) => [
                  const SizedBox(width: 0),
                  element,
                ])
            .toList(),
      ),
    );
  }
}
