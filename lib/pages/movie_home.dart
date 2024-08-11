import 'package:bloctest/pages/home_page.dart';
import 'package:bloctest/pages/movie_detail.dart';
import 'package:bloctest/pages/search_page.dart';
import 'package:bloctest/widgets/AnimatedVisibilityWidget.dart';
import 'package:bloctest/widgets/AnimeCard.dart';
import 'package:bloctest/widgets/CarouselAnime.dart';
import 'package:bloctest/widgets/NovelCard.dart';
import 'package:bloctest/widgets/ToptenNovel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class MovieHome extends StatefulWidget {
  const MovieHome({super.key});

  @override
  State<MovieHome> createState() => _MovieHomeState();
}

class _MovieHomeState extends State<MovieHome> {
  final List<String> _items = [
    "https://i.imgur.com/jdZK3b4.jpeg",
    "https://i.imgur.com/BS2bXTu.jpeg",
    "https://i.imgur.com/Yx9dcco.jpeg",
    "https://i.imgur.com/p2xwVIC.jpeg",
    "https://i.imgur.com/jHmdK55.jpeg"
  ];
  final List<Map<String, dynamic>> _items2 = [
    {
      'image':
          'https://www.saiumporn5.com/buffet-api/20230913045243.jpg?w=128&q=100?webp',
      'title': 'Kimi to Boku no Saigo no Senjou',
      'description': 'Action, Adventure, Fantasy',
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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // _scrollController.addListener(() {
    //   if (_scrollController.position.userScrollDirection ==
    //       ScrollDirection.reverse) {
    //     print('down');
    //     context.read<PageBloc>().add(const PageScroll(isScrolling: false));
    //   } else {
    //     print('up');
    //     context.read<PageBloc>().add(const PageScroll(isScrolling: true));
    //   }
    //   if (_scrollController.offset <= 0) {
    //     print('top');
    //     context.read<PageBloc>().add(const PageScroll(isScrolling: true));
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white, // สีของ status bar
      statusBarIconBrightness: Brightness.dark, // สี icon ของ status bar
    ));

    return SingleChildScrollView(
      controller: _scrollController,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CarouselAnime(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Text(
                    'นิยายแนะนำ',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      minimumSize: const Size(0, 0),
                      overlayColor: Colors.black.withOpacity(0.1),
                    ),
                    child: const Text(
                      "ดูทั้งหมด",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Novelcard(items: _items2).animate().fadeIn(
                  duration: 500.ms,
                ),
            const SizedBox(height: 20),
            HeaderNovel(
              title: '10 นิยายยอดนิยม',
              route: MaterialPageRoute(builder: (context) {
                return const SearchPage();
              }),
            ),
            const SizedBox(height: 5),
            ToptenNovel(items: _items2).animate().fadeIn(
                  duration: 500.ms,
                ),
            const SizedBox(height: 20),
            HeaderNovel(
              title: 'Top Searches',
              route: MaterialPageRoute(builder: (context) {
                return const SearchPage();
              }),
            ),
            // const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              child: Column(
                children: List.generate(5, (index) {
                  return AnimatedVisibilityWidget(
                    key: Key('s-$index'),
                    beforeChild: const SizedBox(
                      width: 120,
                      height: 80,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(_items[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const SizedBox(
                          width: 150,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Kimi to Boku no Saigo no Senjou',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Action, Adventure, Fantasy',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const MyHomePage();
                            }));
                          },
                          icon: const Icon(Icons.play_circle_outlined),
                        ),
                      ],
                    ).animate().slideX(
                          curve: Curves.easeInOut,
                          duration: 500.ms,
                          begin: -1.0,
                          end: 0.0,
                        ),
                  );
                })
                    .expand((element) => [element, const SizedBox(height: 20)])
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderNovel extends StatelessWidget {
  final String title;
  // route
  final MaterialPageRoute route;
  const HeaderNovel({super.key, required this.title, required this.route});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 20),
        Text(
          title,
          style: GoogleFonts.athiti(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {
            Navigator.push(context, route);
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            minimumSize: const Size(0, 0),
            overlayColor: Colors.black.withOpacity(0.1),
          ),
          child: Text(
            "ดูทั้งหมด",
            style: GoogleFonts.athiti(
              fontSize: 13,
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 20),
      ],
    );
  }
}
