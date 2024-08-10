import 'package:bloctest/widgets/AnimatedVisibilityWidget.dart';
import 'package:bloctest/widgets/AnimeCard.dart';
import 'package:bloctest/widgets/CarouselExplore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final List<String> _items = [
    "https://i.imgur.com/jdZK3b4.jpeg",
    "https://i.imgur.com/BS2bXTu.jpeg",
    "https://i.imgur.com/Yx9dcco.jpeg",
    "https://i.imgur.com/p2xwVIC.jpeg",
    "https://i.imgur.com/jHmdK55.jpeg"
  ];
  final List<String> _categories = [
    'ทั้งหมด',
    'โรแมนติก',
    'แฟนตาซี',
    'ย้อนยุค จีนโบราณ',
    'กำลังภายใน',
    'แนวระบบ',
    'ผจญภัย',
  ];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white, // สีของ status bar
      statusBarIconBrightness: Brightness.dark, // สี icon ของ status bar
    ));
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme(
                  brightness: Brightness.light,
                  primary: Colors.black, // Use single color directly
                  onPrimary: Colors.white,
                  secondary: Colors.blue,
                  onSecondary: Colors.white,
                  surface: Colors.grey[200]!,
                  onSurface: Colors.black,

                  error: Colors.red,
                  onError: Colors.white,
                ),
                textSelectionTheme:
                    const TextSelectionThemeData(cursorColor: Colors.blue),
              ),
              child: TextField(
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  hintText: 'ค้นหา',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                  ),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: const Icon(Icons.filter_list),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(
                      color: Colors.grey[200]!,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // const SizedBox(height: 20),
          const CarouselExplore().animate().fadeIn(
                delay: 100.ms,
              ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'หมวดหมู่',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(width: 20),
                ..._categories.asMap().entries.map((entry) {
                  int index = entry.key;
                  String e = entry.value;

                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: AnimatedVisibilityWidget(
                      key: ValueKey(e),
                      beforeChild: const SizedBox(
                        width: 100,
                        height: 45,
                      ),
                      child: Chip(
                        label: Text(
                          e,
                          style: TextStyle(
                            color: index == 0 ? Colors.white : Colors.black,
                          ),
                        ),
                        backgroundColor:
                            index == 0 ? Colors.black : Colors.white,
                        side: BorderSide.none,
                      ).animate().fadeIn(
                            delay: 200.ms,
                          ),
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Most Popular',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          AnimeCard(items: _items).animate().fadeIn(
                delay: 500.ms,
              ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
