import 'package:flutter/material.dart';

class ContainerSkeltion extends StatelessWidget {
  final double height;
  final double width;
  final BorderRadius borderRadius;
  const ContainerSkeltion({
    super.key,
    required this.height,
    required this.width,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: borderRadius,
      ),
    );
  }
}
