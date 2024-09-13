import 'package:bloctest/bloc/page/page_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:io' show Platform;

class IconBottombar extends StatelessWidget {
  final PageState state;
  final int tabIndex;
  final String icon;
  final double? size;

  const IconBottombar({
    super.key,
    required this.state,
    required this.tabIndex,
    required this.icon,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        IconButton(
          onPressed: () {
            context.read<PageBloc>().add(PageChanged(tabIndex: tabIndex));
            context.read<PageBloc>().add(const PageScroll(isScrolling: true));
          },
          style: ButtonStyle(
            padding: WidgetStateProperty.all(const EdgeInsets.all(17)),
          ),
          icon: SvgPicture.asset(
            icon,
            width: size,
            height: size,
            colorFilter: ColorFilter.mode(
              state.tabIndex == tabIndex ? Colors.black : Colors.grey,
              BlendMode.srcIn,
            ),
          ),
        ),
        Platform.isAndroid
            ? Positioned(
                bottom: 0,
                left: 7,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: state.tabIndex == tabIndex ? 45 : 0,
                  height: 4,
                  decoration: BoxDecoration(
                    color: state.tabIndex == tabIndex
                        ? Colors.black
                        : Colors.transparent,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                ),
              )
            : Positioned(
                bottom: 2,
                left: 0,
                right: 0,
                child: Container(
                  alignment: Alignment.center,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    alignment: Alignment.center,
                    width: state.tabIndex == tabIndex ? 8 : 0,
                    height: state.tabIndex == tabIndex ? 8 : 0,
                    decoration: BoxDecoration(
                      color: state.tabIndex == tabIndex
                          ? Colors.black
                          : Colors.transparent,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(100),
                      ),
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
