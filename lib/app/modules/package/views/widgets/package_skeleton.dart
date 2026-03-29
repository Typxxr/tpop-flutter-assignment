import 'package:flutter/material.dart';
import 'package:pack_mate/config/responsive_config.dart';

class PackageSkeleton extends StatelessWidget {
  const PackageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final responsive = ResponsiveConfig.fromWidth(constraints.maxWidth);

        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: responsive.maxContentWidth,
            ),
            child: GridView.builder(
              padding: EdgeInsets.all(responsive.pagePadding),
              itemCount: responsive.crossAxisCount == 1 ? 2 : 4,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: responsive.crossAxisCount,
                crossAxisSpacing: responsive.spacing,
                mainAxisSpacing: responsive.spacing,
                childAspectRatio: responsive.cardAspectRatio,
              ),
              itemBuilder: (_, __) => PackageSkeletonCard(
                responsive: responsive,
              ),
            ),
          ),
        );
      },
    );
  }
}

class PackageSkeletonCard extends StatelessWidget {
  final ResponsiveConfig responsive;

  const PackageSkeletonCard({
    super.key,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(responsive.cardRadius),
      ),
      child: Padding(
        padding: EdgeInsets.all(responsive.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _skeletonBox(height: 22, width: 180),
            SizedBox(height: responsive.sectionGap),
            _skeletonBox(height: 30, width: 110),
            SizedBox(height: responsive.tinyGap),
            _skeletonBox(height: 14, width: 120),
            SizedBox(height: responsive.sectionGap),
            _skeletonBox(height: 14, width: 100),
            SizedBox(height: responsive.tinyGap),
            _skeletonBox(height: 14, width: double.infinity),
            SizedBox(height: responsive.tinyGap),
            _skeletonBox(height: 14, width: double.infinity),
            SizedBox(height: responsive.sectionGap),
            _skeletonBox(height: 14, width: 80),
            SizedBox(height: responsive.tinyGap),
            _skeletonBox(height: 14, width: double.infinity),
            SizedBox(height: responsive.tinyGap),
            _skeletonBox(height: 14, width: 220),
            const Spacer(),
            _skeletonBox(
              height: responsive.buttonHeight,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }

  Widget _skeletonBox({
    required double height,
    required double width,
  }) {
    return Container(
      height: height,
      width: width == double.infinity ? double.infinity : width,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}