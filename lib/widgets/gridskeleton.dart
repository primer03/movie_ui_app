import 'package:bloctest/widgets/ContainerSkeltion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';

class gridskeleton extends StatelessWidget {
  const gridskeleton({
    super.key,
    required this.width,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    return AlignedGridView.count(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: width > 600 ? 4 : 3,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      itemCount: 12,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey[400]!,
              highlightColor: Colors.grey[100]!,
              period: const Duration(milliseconds: 1000),
              child: ContainerSkeltion(
                height: 170,
                width: double.infinity,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 5),
            Shimmer.fromColors(
              baseColor: Colors.grey[400]!,
              highlightColor: Colors.grey[100]!,
              period: const Duration(milliseconds: 1000),
              child: ContainerSkeltion(
                height: 12,
                width: double.infinity,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 5),
            Shimmer.fromColors(
              baseColor: Colors.grey[400]!,
              highlightColor: Colors.grey[100]!,
              period: const Duration(milliseconds: 1000),
              child: ContainerSkeltion(
                height: 10,
                width: 90,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        );
      },
    );
  }
}
