import 'package:flutter/material.dart';

class Testslivernes extends StatelessWidget {
  const Testslivernes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              leading: Icon(Icons.wallpaper),
              title:
                  Container(color: Colors.blue, child: Text("Hidden AppBar")),
              elevation: 10.0,
              automaticallyImplyLeading: false,
              expandedHeight: 50,
              floating: true,
              snap: true,
            )
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            children: List.generate(
              100,
              (index) => ListTile(
                title: Text("Item $index"),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
