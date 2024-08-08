import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CardSkeleton extends StatelessWidget {
  const CardSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 7,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[400]!,
          highlightColor: Colors.grey[100]!,
          period: const Duration(milliseconds: 1000),
          child: Container(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 12,
                      color: Colors.grey[200],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: 10,
                      color: Colors.grey[200],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
