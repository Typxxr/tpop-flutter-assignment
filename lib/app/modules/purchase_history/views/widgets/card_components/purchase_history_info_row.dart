import 'package:flutter/material.dart';
import 'package:pack_mate/config/responsive_config.dart';

class PurchaseHistoryInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final ResponsiveConfig responsive;

  const PurchaseHistoryInfoRow({
    super.key,
    required this.label,
    required this.value,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: responsive.tinyGap),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 138,
            child: Text(
              label,
              style: TextStyle(
                fontSize: responsive.bodyFontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: responsive.bodyFontSize),
            ),
          ),
        ],
      ),
    );
  }
}