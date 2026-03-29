import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pack_mate/app/shared/errors/app_error.dart';
import 'package:pack_mate/app/shared/errors/error_icon_mapper.dart';
import 'package:pack_mate/config/responsive_config.dart';

class PackageErrorState extends StatelessWidget {
  final AppError error;
  final VoidCallback onRetry;

  const PackageErrorState({
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
                    error.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize:
                          responsive.isTablet || responsive.isDesktop ? 18 : 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
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