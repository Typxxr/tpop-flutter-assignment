import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pack_mate/app/shared/errors/app_error.dart';
import 'package:pack_mate/app/shared/errors/error_icon_mapper.dart';
import 'package:pack_mate/config/responsive_config.dart';

class HistoryErrorState extends StatelessWidget {
  final AppError error;
  final VoidCallback onRetry;

  const HistoryErrorState({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final responsive = ResponsiveConfig.fromWidth(constraints.maxWidth);

        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.isTablet || responsive.isDesktop ? 32 : 24,
              vertical: 24,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    ErrorIconMapper.iconFor(error.type),
                    size: responsive.isTablet || responsive.isDesktop ? 72 : 64,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'failed_to_load_purchase_history'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize:
                          responsive.isTablet || responsive.isDesktop ? 18 : 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.message.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: responsive.bodyFontSize),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh),
                    label: Text('retry'.tr),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}