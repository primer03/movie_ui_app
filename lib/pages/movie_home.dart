import 'package:bloctest/pages/home_page.dart';
import 'package:bloctest/widgets/AnimatedVisibilityWidget.dart';
import 'package:bloctest/widgets/AnimeCard.dart';
import 'package:bloctest/widgets/CarouselAnime.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

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

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white, // สีของ status bar
      statusBarIconBrightness: Brightness.dark, // สี icon ของ status bar
    ));
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(
                            'https://avatar.iran.liara.run/public'),
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi, John Doe',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Let\'s find a movie',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.search)),
                      IconButton(
                        onPressed: () {},
                        icon: Stack(
                          children: [
                            const Icon(Icons.notifications_none),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Text(
                                  '1',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const CarouselAnime(),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      const Text(
                        'Recommended for you',
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
                          overlayColor:
                              const Color(0xFF685CF0).withOpacity(0.1),
                        ),
                        child: const Text(
                          "See All",
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF685CF0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                AnimeCard(items: _items).animate().fadeIn(
                      duration: 500.ms,
                    ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const SizedBox(width: 20),
                    const Text(
                      'Top Searches',
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
                        overlayColor: const Color(0xFF685CF0).withOpacity(0.1),
                      ),
                      child: const Text(
                        "See All",
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF685CF0),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
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
                        .expand(
                            (element) => [element, const SizedBox(height: 20)])
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
