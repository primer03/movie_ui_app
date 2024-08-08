import 'package:bloctest/pages/movie_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimeCard extends StatefulWidget {
  const AnimeCard({
    super.key,
    required List<String> items,
  }) : _items = items;
  final List<String> _items;

  @override
  State<AnimeCard> createState() => _AnimeCardState();
}

class _AnimeCardState extends State<AnimeCard> {
  final ScrollController _scrollController = ScrollController();
  final int _maxItems = 100;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    print(widget._items.length);
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels == 0) {
        _addItemsToStart();
      } else {
        _addItemsToEnd();
      }
    }
  }

  void _addItemsToStart() {
    setState(() {
      int itemsToAdd = widget._items.length < 5 ? widget._items.length : 5;
      List<String> newItems =
          widget._items.sublist(widget._items.length - itemsToAdd);
      widget._items.insertAll(0, newItems);

      if (widget._items.length > _maxItems) {
        widget._items.removeRange(_maxItems, widget._items.length);
      }

      Future.delayed(const Duration(milliseconds: 50), () {
        if (mounted && !_scrollController.position.isScrollingNotifier.value) {
          _scrollController
              .jumpTo(_scrollController.position.maxScrollExtent / 2);
        }
      });
    });
  }

  void _addItemsToEnd() {
    setState(() {
      int itemsToAdd = widget._items.length < 5 ? widget._items.length : 5;
      List<String> newItems = widget._items.sublist(0, itemsToAdd);
      widget._items.addAll(newItems);

      if (widget._items.length > _maxItems) {
        print('remove ${widget._items.length - _maxItems}');
        widget._items.removeRange(0, widget._items.length - _maxItems);
      }

      Future.delayed(const Duration(milliseconds: 50), () {
        if (mounted && !_scrollController.position.isScrollingNotifier.value) {
          _scrollController
              .jumpTo(_scrollController.position.maxScrollExtent / 2);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const SizedBox(width: 20),
            ...widget._items.map((item) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const MovieDetail();
                  })).then((_) {
                    print('back to home');
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      SystemChrome.setSystemUIOverlayStyle(
                          const SystemUiOverlayStyle(
                        statusBarColor: Colors.white,
                        statusBarIconBrightness: Brightness.dark,
                      ));
                    });
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 20),
                  width: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(item),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Kimi to Boku no Saigo no Senjou',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
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
              );
            }),
          ],
        ),
      ),
    );
  }
}
