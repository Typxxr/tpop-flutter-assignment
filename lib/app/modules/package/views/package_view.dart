import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pack_mate/app/controllers/language_controller.dart';
import 'package:pack_mate/config/responsive_config.dart';

import '../controllers/package_controller.dart';
import 'widgets/package_card.dart';
import 'widgets/package_empty_state.dart';
import 'widgets/package_error_state.dart';
import 'widgets/package_skeleton.dart';

class PackageView extends GetView<PackageController> {
  PackageView({super.key});

  final LanguageController languageController = Get.find<LanguageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('packages'.tr),
        centerTitle: true,
        actions: [
          Obx(() {
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: TextButton(
                onPressed: languageController.toggleLanguage,
                child: Text(
                  languageController.isThai ? 'EN' : 'TH',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const PackageSkeleton();
          }

          if (controller.appError.value != null) {
            return PackageErrorState(
              error: controller.appError.value!,
              onRetry: controller.fetchPackages,
            );
          }

          if (controller.packages.isEmpty) {
            return PackageEmptyState(
              title: 'no_package_data'.tr,
              onRetry: controller.fetchPackages,
            );
          }

          return RefreshIndicator(
            onRefresh: controller.fetchPackages,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final responsive =
                    ResponsiveConfig.fromWidth(constraints.maxWidth);

                return Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: responsive.maxContentWidth,
                    ),
                    child: GridView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.all(responsive.pagePadding),
                      itemCount: controller.packages.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: responsive.crossAxisCount,
                        crossAxisSpacing: responsive.spacing,
                        mainAxisSpacing: responsive.spacing,
                        childAspectRatio: responsive.cardAspectRatio,
                      ),
                      itemBuilder: (context, index) {
                        final item = controller.packages[index];
                        return PackageCard(
                          item: item,
                          responsive: responsive,
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}