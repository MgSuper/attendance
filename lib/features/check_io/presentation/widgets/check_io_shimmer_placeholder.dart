import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CheckIOShimmerPlaceholder extends StatelessWidget {
  const CheckIOShimmerPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Title shimmer
            Container(
              width: double.infinity,
              height: 24,
              color: Colors.white,
            ),
            const SizedBox(height: 24),

            // Location row shimmer
            Row(
              children: [
                Container(width: 24, height: 24, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(height: 16, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Distance shimmer
            Container(height: 16, width: 180, color: Colors.white),
            const SizedBox(height: 32),

            // Button shimmer
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
