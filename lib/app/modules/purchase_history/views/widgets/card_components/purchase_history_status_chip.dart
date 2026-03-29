import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pack_mate/config/responsive_config.dart';

class PurchaseHistoryStatusChip extends StatelessWidget {
  final bool isActive;
  final bool isInactive;
  final bool isExpired;
  final ResponsiveConfig responsive;

  const PurchaseHistoryStatusChip({
    super.key,
    required this.isActive,
    required this.isInactive,
    required this.isExpired,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    final String label;
    if (isExpired) {
      label = 'expired'.tr;
    } else if (isActive) {
      label = 'active'.tr;
    } else if (isInactive) {
      label = 'inactive'.tr;
    } else {
      label = '-';
    }

    final Color backgroundColor;
    if (isExpired) {
      backgroundColor = Colors.red.shade50;
    } else if (isActive) {
      backgroundColor = Colors.green.shade50;
    } else {
      backgroundColor = Colors.grey.shade200;
    }

    return Chip(
      backgroundColor: backgroundColor,
      label: Text(
        label,
        style: TextStyle(
          fontSize: responsive.bodyFontSize - 1,
          fontWeight: FontWeight.w600,
        ),
      ),
      visualDensity: VisualDensity.compact,
    );
  }
}