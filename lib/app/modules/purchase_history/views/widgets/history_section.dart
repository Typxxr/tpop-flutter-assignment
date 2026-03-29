import 'package:flutter/material.dart';
import 'package:pack_mate/app/data/purchase_history_model.dart';
import 'package:pack_mate/config/responsive_config.dart';

import 'purchase_history_card.dart';

class HistorySection extends StatelessWidget {
  final String title;
  final String emptyTitle;
  final List<PurchaseHistoryModel> items;
  final ResponsiveConfig responsive;

  const HistorySection({
    super.key,
    required this.title,
    required this.emptyTitle,
    required this.items,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: responsive.titleFontSize,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: responsive.sectionGap),
        if (items.isEmpty)
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(responsive.cardRadius),
            ),
            child: Padding(
              padding: EdgeInsets.all(responsive.cardPadding),
              child: Text(
                emptyTitle,
                style: TextStyle(fontSize: responsive.bodyFontSize),
              ),
            ),
          )
        else
          ...items.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: responsive.spacing),
              child: PurchaseHistoryCard(
                item: item,
                responsive: responsive,
              ),
            ),
          ),
      ],
    );
  }
}
