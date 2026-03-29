import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pack_mate/config/responsive_config.dart';

class HistoryEmptyState extends StatelessWidget {
  final String title;
  final String? description;
  final VoidCallback onRetry;

  const HistoryEmptyState({
    super.key,
    required this.title,
    this.description,
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
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.history_toggle_off_rounded,
                    size: responsive.isTablet || responsive.isDesktop ? 72 : 64,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize:
                          responsive.isTablet || responsive.isDesktop ? 18 : 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (description != null && description!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      description!,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: responsive.bodyFontSize),
                    ),
                  ],
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
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
