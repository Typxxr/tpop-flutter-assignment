import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pack_mate/app/controllers/language_controller.dart';
import 'package:pack_mate/app/modules/package/views/package_view.dart';
import 'package:pack_mate/app/modules/purchase_history/views/purchase_history_view.dart';

import '../controllers/main_navigation_controller.dart';

class MainNavigationView extends GetView<MainNavigationController> {
  MainNavigationView({super.key});

  @override
  final MainNavigationController controller =
      Get.put(MainNavigationController(), permanent: true);

  final LanguageController languageController = Get.find<LanguageController>();

  late final List<Widget> pages = [
    PackageView(),
    PurchaseHistoryView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTab,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.shopping_bag_outlined),
              activeIcon: const Icon(Icons.shopping_bag),
              label: 'packages'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.history_outlined),
              activeIcon: const Icon(Icons.history),
              label: 'purchase_history'.tr,
            ),
          ],
        ),
      );
    });
  }
}