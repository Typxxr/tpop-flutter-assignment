import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pack_mate/config/responsive_config.dart';

class PackageEmptyState extends StatelessWidget {
  final String title;
  final VoidCallback onRetry;

  const PackageEmptyState({
    super.key,
    required this.title,
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
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: responsive.isTablet || responsive.isDesktop ? 72 : 64,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize:
                          responsive.isTablet || responsive.isDesktop ? 18 : 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: onRetry,
                    child: Text('retry'.tr),
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