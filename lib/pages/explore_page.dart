import 'package:bloctest/bloc/page/page_bloc.dart';
import 'package:bloctest/pages/home_page.dart';
import 'package:bloctest/pages/search_page.dart';
import 'package:bloctest/widgets/AnimatedVisibilityWidget.dart';
import 'package:bloctest/widgets/AnimeCard.dart';
import 'package:bloctest/widgets/CarouselAnime.dart';
import 'package:bloctest/widgets/CarouselExplore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(() {
        if (_scrollController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          print('down');
          context.read<PageBloc>().add(const PageScroll(isScrolling: false));
        } else {
          print('up');
          context.read<PageBloc>().add(const PageScroll(isScrolling: true));
        }
        if (_scrollController.offset <= 0) {
          print('top');
          context.read<PageBloc>().add(const PageScroll(isScrolling: true));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white, // สีของ status bar
      statusBarIconBrightness: Brightness.dark, // สี icon ของ status bar
    ));
    print('ExplorePage');
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
          const CarouselExplore(),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Categories',
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
                SizedBox(width: 20),
                ...List.generate(10, (context) {
                  return ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: const Text('All'),
                  );
                }).expand((element) => [
                      element,
                      const SizedBox(width: 10),
                    ]),
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
          AnimeCard(items: _items),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
