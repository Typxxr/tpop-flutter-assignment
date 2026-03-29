import 'package:flutter/material.dart';
import 'package:pack_mate/config/responsive_config.dart';

class PurchaseHistorySectionTitle extends StatelessWidget {
  final String title;
  final ResponsiveConfig responsive;

  const PurchaseHistorySectionTitle({
    super.key,
    required this.title,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: responsive.labelFontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}