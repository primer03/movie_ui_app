import 'package:carousel_slider/carousel_slider.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:interactive_slider/interactive_slider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:screen_brightness/screen_brightness.dart';

class ReaderPage extends StatefulWidget {
  const ReaderPage({super.key});

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  ScrollController _scrollController = ScrollController();
  final GlobalKey _containerKey = GlobalKey();
  double _scrollPercentage = 0.0;
  double _brightness = 0.5;
  bool _isToggled = false;
  double currentBrightness = 0.5;
  int _currentSelectedFont = 0;
  double _currentSelectedFontSize = 0.16;
  final List<Map<String, dynamic>> _fontFamily = [
    {
      'fontName': GoogleFonts.athiti().fontFamily?.split('_')[0],
      'fontFamily': GoogleFonts.athiti().fontFamily,
    },
    {
      'fontName': GoogleFonts.kanit().fontFamily?.split('_')[0],
      'fontFamily': GoogleFonts.kanit().fontFamily,
    },
    {
      'fontName': GoogleFonts.prompt().fontFamily?.split('_')[0],
      'fontFamily': GoogleFonts.prompt().fontFamily,
    },
    {
      'fontName': GoogleFonts.mitr().fontFamily?.split('_')[0],
      'fontFamily': GoogleFonts.mitr().fontFamily,
    },
    {
      'fontName': 'Noto Sans',
      'fontFamily': GoogleFonts.notoSans().fontFamily,
    },
    {
      'fontName': GoogleFonts.roboto().fontFamily?.split('_')[0],
      'fontFamily': GoogleFonts.roboto().fontFamily,
    },
    {
      'fontName': GoogleFonts.sarabun().fontFamily?.split('_')[0],
      'fontFamily': GoogleFonts.sarabun().fontFamily,
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_calculateScrollPercentage);
    _initializeBrightness();
    getcurrentBrightness();
  }

  void _initializeBrightness() async {}

  @override
  void dispose() {
    _scrollController.removeListener(_calculateScrollPercentage);
    _scrollController.dispose();
    resetBrightness();
    super.dispose();
  }

  Future<void> getcurrentBrightness() async {
    try {
      final double result = await ScreenBrightness().current;
      final double resultx = await ScreenBrightness().system;
      print('current brightness: $result');
      setState(() {
        currentBrightness = result;
        _brightness = result;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> resetBrightness() async {
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

    // Ensure the percentage is capped at 100 when fully scrolled
    double scrollPercentage = (currentScrollPosition / maxScrollExtent) * 100;
    if (currentScrollPosition >= maxScrollExtent) {
      scrollPercentage = 100;
    }

    setState(() {
      _scrollPercentage = scrollPercentage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Reader Page'),
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.setting_2),
            style: IconButton.styleFrom(
              overlayColor: Colors.grey,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share),
            style: IconButton.styleFrom(
              overlayColor: Colors.grey,
            ),
            onPressed: () {
              final containerContext = _containerKey.currentContext;
              if (containerContext != null) {
                final containerRenderBox =
                    containerContext.findRenderObject() as RenderBox;
                final size = containerRenderBox.size;
                print('Width: ${size.width}, Height: ${size.height}');
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    _scrollController.animateTo(
                      _scrollController.offset + 100,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
                  },
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        key: _containerKey,
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                        style: TextStyle(
                          fontSize: 67,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new),
                    onPressed: () {
                      _scrollController.animateTo(
                        _scrollController.offset - 100,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    },
                  ),
                  const Text('1 / 100'),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      _scrollController.animateTo(
                        _scrollController.offset + 100,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    },
                  ),
                  const Spacer(),
                  Text(
                    'บทที่ 1 / ${_scrollPercentage.toStringAsFixed(0)} %',
                    style: GoogleFonts.athiti(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ).animate().slideY(),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.transparent,
                width: _isToggled ? 200 : 73,
                height: _isToggled ? 170 : 73,
                child: CircularMenu(
                    toggleButtonOnPressed: () {
                      setState(() {
                        _isToggled = !_isToggled;
                      });
                      print('Toggle: $_isToggled');
                    },
                    alignment: Alignment.bottomCenter,
                    startingAngleInRadian: 1.25 * 3.14,
                    endingAngleInRadian: 1.75 * 3.14,
                    radius: 100,
                    toggleButtonColor: Colors.white,
                    toggleButtonSize: 35,
                    toggleButtonIconColor: Colors.black,
                    toggleButtonBoxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    items: [
                      CircularMenuItem(
                        icon: Icons.list,
                        onTap: () {},
                        color: Colors.white,
                        iconColor: Colors.black,
                      ),
                      CircularMenuItem(
                        icon: Iconsax.message_text,
                        onTap: () {},
                        color: Colors.grey[200],
                        iconColor: Colors.black,
                      ),
                      CircularMenuItem(
                        icon: Iconsax.setting_2,
                        onTap: () {
                          showMaterialModalBottomSheet(
                            duration: const Duration(
                              milliseconds: 500,
                            ),
                            animationCurve: Curves.fastOutSlowIn,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            backgroundColor: Colors.white,
                            closeProgressThreshold: 0.6,
                            context: context,
                            builder: (context) => SingleChildScrollView(
                              controller: ModalScrollController.of(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 20,
                                ),
                                child: Column(
                                  children: [
                                    InteractiveSlider(
                                      padding: const EdgeInsets.all(0),
                                      startIcon:
                                          const Icon(CupertinoIcons.sun_max),
                                      endIcon: const Icon(
                                          CupertinoIcons.sun_max_fill),
                                      min: 0.0,
                                      max: 1.0,
                                      initialProgress: _brightness,
                                      onChanged: (value) async {
                                        setState(() {
                                          _brightness = value;
                                        });
                                        await ScreenBrightness()
                                            .setScreenBrightness(value);
                                        print('Brightness: ${_brightness}');
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    InteractiveSlider(
                                      padding: const EdgeInsets.all(0),
                                      startIcon: Text(
                                        'Aa ',
                                        style: GoogleFonts.athiti(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      endIcon: Text(
                                        'Aa',
                                        style: GoogleFonts.athiti(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      style: GoogleFonts.athiti(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      min: 0.0,
                                      max: 1.0,
                                      initialProgress: _currentSelectedFontSize,
                                      onChanged: (value) {
                                        print('Volume: ${value * 100}');
                                        setState(() {
                                          _currentSelectedFontSize = value;
                                        });
                                        print(
                                            'Font Size: ${_currentSelectedFontSize}');
                                      },
                                    ),
                                    const SizedBox(height: 15),
                                    Stack(
                                      children: [
                                        StatefulBuilder(
                                            builder: (context, setState) {
                                          return CarouselSlider(
                                            options: CarouselOptions(
                                              height: 40,
                                              viewportFraction: 0.27,
                                              enlargeFactor: 0.2,
                                              initialPage: 0,
                                              onPageChanged: (index, reason) {
                                                print('index: $index');
                                                setState(() {
                                                  _currentSelectedFont = index;
                                                });
                                              },
                                            ),
                                            items: _fontFamily
                                                .asMap()
                                                .entries
                                                .map((e) {
                                              print(e.value['fontFamily']);
                                              return Builder(
                                                builder:
                                                    (BuildContext context) {
                                                  return Container(
                                                    alignment:
                                                        Alignment.topCenter,
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 5.0),
                                                    child: Text(
                                                      e.value['fontName'],
                                                      style:
                                                          GoogleFonts.getFont(
                                                        e.value['fontName'],
                                                        fontSize: 18,
                                                        color:
                                                            _currentSelectedFont ==
                                                                    e.key
                                                                ? Colors.black
                                                                : Colors.grey,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            }).toList(),
                                          );
                                        }),
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
                                                  Colors.white,
                                                  Colors.white12,
                                                ],
                                                stops: [0.0, 1.0],
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
                                                  Colors.white12,
                                                  Colors.white,
                                                ],
                                                stops: [0.0, 1.0],
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        color: Colors.white,
                        iconColor: Colors.black,
                      ),
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
