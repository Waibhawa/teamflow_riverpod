import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
class ShimmerLoader extends StatelessWidget {
  const ShimmerLoader({super.key, this.itemCount = 6});
  final int itemCount;
  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).colorScheme.surfaceContainerHighest;
    final highlight = Theme.of(context).colorScheme.surface;
    return Shimmer.fromColors(
      baseColor: base, highlightColor: highlight,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount, padding: const EdgeInsets.all(16),
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, __) => Container(
          height: 110,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
