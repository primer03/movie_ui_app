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
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _containerKey = GlobalKey();
  double _scrollPercentage = 0.0;
  double _brightness = 0.5;
  bool _isToggled = false;
  double _currentBrightness = 0.5;
  int _currentSelectedFont = 0;
  double _currentSelectedFontSize = 0.16;
  double _previousScrollPosition = 0.0;
  bool _isScrollingDown = true;
  int _toggleCount = 0;
  late GoogleFonts _selectedFont;
  List<Map<String, dynamic>> TheamSetting = [
    {
      'bg': Colors.white,
      'fg': Colors.black,
      'name': 'Light',
    },
    {
      'bg': const Color(0xFF3C3C3C),
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
      'fontName': GoogleFonts.athiti().fontFamily?.split('_')[0],
      'fontFamily': GoogleFonts.athiti()
    },
    {
      'fontName': GoogleFonts.kanit().fontFamily?.split('_')[0],
      'fontFamily': GoogleFonts.kanit()
    },
    {
      'fontName': GoogleFonts.prompt().fontFamily?.split('_')[0],
      'fontFamily': GoogleFonts.prompt()
    },
    {
      'fontName': GoogleFonts.mitr().fontFamily?.split('_')[0],
      'fontFamily': GoogleFonts.mitr()
    },
    {'fontName': 'Noto Sans', 'fontFamily': GoogleFonts.notoSans().fontFamily},
    {
      'fontName': GoogleFonts.roboto().fontFamily?.split('_')[0],
      'fontFamily': GoogleFonts.roboto()
    },
    {
      'fontName': GoogleFonts.sarabun().fontFamily?.split('_')[0],
      'fontFamily': GoogleFonts.sarabun()
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_calculateScrollPercentage);
    _initializeBrightness();
    _getCurrentBrightness();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_calculateScrollPercentage);
    _scrollController.dispose();
    _resetBrightness();
    super.dispose();
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

    setState(() {
      _isScrollingDown = currentScrollPosition < _previousScrollPosition;
      _scrollPercentage =
          (currentScrollPosition / maxScrollExtent).clamp(0.0, 1.0) * 100;
      _previousScrollPosition = currentScrollPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      backgroundColor: _selectedTheam['bg'],
      appBar: _isScrollingDown ? _buildAppBar() : null,
      body: Stack(
        children: [
          _buildContent(),
          if (_isScrollingDown) ...[
            _buildFooter(),
            _buildCircularMenu(),
          ],
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Reader Page'),
      surfaceTintColor: _selectedTheam['bg'],
      backgroundColor: _selectedTheam['bg'],
      foregroundColor: _selectedTheam['fg'],
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Iconsax.setting_2),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.share),
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
    );
  }

  Widget _buildContent() {
    return Column(
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
                    color: _selectedTheam['fg'],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Positioned _buildFooter() {
    return Positioned(
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
        ).animate().fade(),
      ),
    );
  }

  Positioned _buildCircularMenu() {
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
                  _showSettingsModal();
                },
                color: Colors.white,
                iconColor: Colors.black,
              ),
            ],
          ),
        ),
      ).animate().fade(),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: BoxDecoration(
                  color: _selectedTheam['bg'],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    InteractiveSlider(
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
                        print('Brightness: $_brightness');
                      },
                    ),
                    const SizedBox(height: 20),
                    Stack(
                      children: [
                        CarouselSlider(
                          options: CarouselOptions(
                            height: 40,
                            viewportFraction: 0.27,
                            enlargeFactor: 0.2,
                            initialPage: 0,
                            onPageChanged: (index, reason) {
                              setState(() {
                                print(
                                    'Font Family: ${_fontFamily[index]['fontName']}');
                                _currentSelectedFont = index;
                              });
                              states(() {
                                _currentSelectedFont = index;
                              });
                            },
                          ),
                          items: _fontFamily.asMap().entries.map((e) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  alignment: Alignment.topCenter,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: Text(
                                    e.value['fontName'],
                                    style: GoogleFonts.getFont(
                                      e.value['fontName'],
                                      fontSize: 18,
                                      color: _currentSelectedFont == e.key
                                          ? Colors.black
                                          : Colors.grey,
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
                            // color: _selectedTheam['bg'],
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  _selectedTheam['bg'],
                                  _selectedTheam['bg'].withOpacity(0.0),
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
                                  _selectedTheam['bg'].withOpacity(0.0),
                                  _selectedTheam['bg'],
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
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            height: 55,
                            margin: const EdgeInsets.only(left: 10),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: getBackgroundColor(_selectedTheam),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 5),
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
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
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
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      side: const BorderSide(
                                        color: Colors.grey,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      minimumSize:
                                          const Size(double.infinity, 55),
                                    ),
                                    child: const Icon(Iconsax.add, size: 20),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    readOnly: true,
                                    initialValue: '16',
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,
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
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      side: const BorderSide(
                                        color: Colors.grey,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      minimumSize:
                                          const Size(double.infinity, 55),
                                    ),
                                    child: const Icon(Iconsax.minus, size: 20),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Padding(
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: _selectedTheam['name'] ==
                                                    e.value['name']
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
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
