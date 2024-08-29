import 'package:bloctest/widgets/ContainerSkeltion.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';

class MovieHomeSkeleton extends StatefulWidget {
  const MovieHomeSkeleton({super.key});

  @override
  State<MovieHomeSkeleton> createState() => _MovieHomeSkeletonState();
}

class _MovieHomeSkeletonState extends State<MovieHomeSkeleton> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white, // สีของ status bar
      statusBarIconBrightness: Brightness.dark, // สี icon ของ status bar
    ));

    return SingleChildScrollView(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[400]!,
        highlightColor: Colors.grey[100]!,
        period: const Duration(milliseconds: 1000),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ContainerSkeltion(
                  height: 150,
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(10)),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(10, (index) {
                return ContainerSkeltion(
                  height: 8,
                  width: index == 0 ? 40 : 8,
                  borderRadius: BorderRadius.circular(100),
                );
              })
                  .expand((element) => [element, const SizedBox(width: 5)])
                  .toList(),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ContainerSkeltion(
                    height: 12,
                    width: 100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  ContainerSkeltion(
                    height: 12,
                    width: 30,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const SizedBox(width: 20),
                    ...List.generate(4, (index) {
                      return const NovelCardSkeltion();
                    }).expand(
                        (element) => [element, const SizedBox(width: 10)]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ContainerSkeltion(
                height: 12,
                width: 90,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 15),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  ...List.generate(6, (index) {
                    return ContainerSkeltion(
                        height: 30,
                        width: 100,
                        borderRadius: BorderRadius.circular(5));
                  }).expand((element) => [element, const SizedBox(width: 10)]),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ContainerSkeltion(
                    height: 12,
                    width: 100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  ContainerSkeltion(
                    height: 12,
                    width: 30,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const SizedBox(width: 20),
                    ...List.generate(4, (index) {
                      return const NovelCardSkeltion();
                    }).expand(
                        (element) => [element, const SizedBox(width: 10)]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NovelCardSkeltion extends StatelessWidget {
  const NovelCardSkeltion({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ContainerSkeltion(
          height: 170,
          width: 115,
          borderRadius: BorderRadius.circular(10),
        ),
        const SizedBox(height: 10),
        ContainerSkeltion(
          height: 6,
          width: 115,
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 5),
        ContainerSkeltion(
          height: 6,
          width: 100,
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 5),
        ContainerSkeltion(
          height: 6,
          width: 90,
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            ContainerSkeltion(
              height: 9,
              width: 30,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(width: 5),
            ContainerSkeltion(
              height: 9,
              width: 30,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      ],
    );
  }
}
