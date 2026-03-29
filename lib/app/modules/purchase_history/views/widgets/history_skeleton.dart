import 'package:flutter/material.dart';
import 'package:pack_mate/config/responsive_config.dart';

class HistorySkeleton extends StatelessWidget {
  final String? message;

  const HistorySkeleton({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final responsive = ResponsiveConfig.fromWidth(constraints.maxWidth);

        return ListView(
          padding: EdgeInsets.all(responsive.pagePadding),
          children: [
            if (message != null && message!.isNotEmpty) ...[
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    message!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: responsive.bodyFontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
            _cardSkeleton(responsive, lines: const [26, 14, 14]),
            SizedBox(height: responsive.spacing),
            _sectionHeader(responsive),
            SizedBox(height: responsive.sectionGap),
            _cardSkeleton(responsive, lines: const [20, 14, 14, 14, 40]),
            SizedBox(height: responsive.spacing),
            _sectionHeader(responsive),
            SizedBox(height: responsive.sectionGap),
            _cardSkeleton(responsive, lines: const [20, 14, 14, 14, 40]),
            SizedBox(height: responsive.spacing),
            _sectionHeader(responsive),
            SizedBox(height: responsive.sectionGap),
            _cardSkeleton(responsive, lines: const [20, 14, 14]),
          ],
        );
      },
    );
  }

  Widget _sectionHeader(ResponsiveConfig responsive) {
    return _box(height: 18, width: 170, radius: 8);
  }

  Widget _cardSkeleton(
    ResponsiveConfig responsive, {
    required List<double> lines,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(responsive.cardRadius),
      ),
      child: Padding(
        padding: EdgeInsets.all(responsive.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < lines.length; i++) ...[
              _box(
                height: lines[i],
                width: i == lines.length - 1 && lines[i] == 40
                    ? double.infinity
                    : (i.isEven ? 180 : 260),
                radius: 8,
              ),
              if (i != lines.length - 1) SizedBox(height: responsive.tinyGap),
            ],
          ],
        ),
      ),
    );
  }

  Widget _box({
    required double height,
    required double width,
    required double radius,
  }) {
    return Container(
      height: height,
      width: width == double.infinity ? double.infinity : width,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}