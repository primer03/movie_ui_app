import 'package:bloctest/bloc/page/page_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class IconBottombar extends StatelessWidget {
  final PageState state;
  final int tabIndex;
  final String icon;

  const IconBottombar({
    super.key,
    required this.state,
    required this.tabIndex,
    required this.icon,
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
            padding: MaterialStateProperty.all(const EdgeInsets.all(17)),
          ),
          icon: SvgPicture.asset(
            icon,
            width: 24,
            height: 24,
            color: state.tabIndex == tabIndex ? Colors.black : Colors.grey,
          ),
        ),
        Positioned(
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
        ),
      ],
    );
  }
}
