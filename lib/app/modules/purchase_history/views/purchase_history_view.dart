import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pack_mate/app/controllers/language_controller.dart';
import 'package:pack_mate/config/responsive_config.dart';

import '../controllers/purchase_history_controller.dart';
import 'widgets/history_empty_state.dart';
import 'widgets/history_error_state.dart';
import 'widgets/history_section.dart';
import 'widgets/history_skeleton.dart';

class PurchaseHistoryView extends GetView<PurchaseHistoryController> {
  PurchaseHistoryView({super.key});

  final LanguageController languageController = Get.find<LanguageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('purchase_history'.tr),
        centerTitle: true,
        actions: [
          Obx(() {
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: TextButton(
                onPressed: languageController.toggleLanguage,
                child: Text(
                  languageController.isThai ? 'EN' : 'TH',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            );
          }),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return HistorySkeleton(
              message: controller.waitingMessage.value.isNotEmpty
                  ? controller.waitingMessage.value
                  : null,
            );
          }

          if (controller.appError.value != null) {
            return HistoryErrorState(
              error: controller.appError.value!,
              onRetry: controller.refreshPurchaseHistory,
            );
          }

          if (controller.histories.isEmpty) {
            return HistoryEmptyState(
              title: languageController.isThai
                  ? 'ยังไม่มีประวัติการซื้อแพ็กเกจ'
                  : 'No purchase history yet.',
              description: languageController.isThai
                  ? 'เมื่อคุณซื้อแพ็กเกจ รายการจะมาแสดงที่หน้านี้'
                  : 'Your purchased packages will appear here.',
              onRetry: controller.refreshPurchaseHistory,
            );
          }

          return RefreshIndicator(
            onRefresh: controller.refreshPurchaseHistory,
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
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.all(responsive.pagePadding),
                      children: [
                        SizedBox(height: responsive.spacing),
                        HistorySection(
                          title: languageController.isThai
                              ? 'แพ็กเกจที่กำลังใช้งานอยู่'
                              : 'Active packages',
                          emptyTitle: languageController.isThai
                              ? 'ยังไม่มีแพ็กเกจที่กำลังใช้งาน'
                              : 'No active packages.',
                          items: controller.activeHistories,
                          responsive: responsive,
                        ),
                        SizedBox(height: responsive.spacing),
                        HistorySection(
                          title: languageController.isThai
                              ? 'แพ็กเกจที่ไม่ได้ใช้งาน'
                              : 'Inactive packages',
                          emptyTitle: languageController.isThai
                              ? 'ยังไม่มีแพ็กเกจที่ไม่ได้ใช้งาน'
                              : 'No inactive packages.',
                          items: controller.inactiveHistories,
                          responsive: responsive,
                        ),
                        SizedBox(height: responsive.spacing),
                        HistorySection(
                          title: languageController.isThai
                              ? 'แพ็กเกจที่หมดอายุแล้ว'
                              : 'Expired packages',
                          emptyTitle: languageController.isThai
                              ? 'ยังไม่มีแพ็กเกจที่หมดอายุ'
                              : 'No expired packages.',
                          items: controller.expiredHistories,
                          responsive: responsive,
                        ),
                      ],
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