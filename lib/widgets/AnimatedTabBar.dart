import 'package:flutter/material.dart';

class AnimatedTabBar extends StatefulWidget {
  final List<IconData> icons;
  final Function(int) onTap;
  final int intinitialIndex;

  AnimatedTabBar(
      {required this.icons, required this.onTap, this.intinitialIndex = 0});

  @override
  _AnimatedTabBarState createState() => _AnimatedTabBarState();
}

class _AnimatedTabBarState extends State<AnimatedTabBar>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(widget.icons.length, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                  widget.onTap(index);
                  _controller.reset();
                  _controller.forward();
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    widget.icons[index],
                    color: _selectedIndex == index ? Colors.blue : Colors.grey,
                    size: _selectedIndex == index ? 30 : 24,
                  ),
                ),
              );
            }),
          ),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Positioned(
                bottom: 0,
                left: MediaQuery.of(context).size.width /
                    widget.icons.length *
                    _selectedIndex,
                child: Transform.scale(
                  scale: 0.9 + (_animation.value * 0.1),
                  child: Container(
                    width:
                        MediaQuery.of(context).size.width / widget.icons.length,
                    height: 3,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(1.5),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
