import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pack_mate/app/data/package_model.dart';
import 'package:pack_mate/app/modules/main_navigation/controllers/main_navigation_controller.dart';
import 'package:pack_mate/app/modules/purchase_history/controllers/purchase_history_controller.dart';
import 'package:pack_mate/app/shared/errors/app_error.dart';
import 'package:pack_mate/app/shared/errors/error_mapper.dart';
import 'package:pack_mate/config/app_env.dart';

class PackageController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final AppEnv env;

  PackageController({required this.env});

  final isLoading = false.obs;
  final packages = <PackageModel>[].obs;
  final buyingPackageId = ''.obs;

  final Rxn<AppError> appError = Rxn<AppError>();

  String? get userId => env.currentUserIdOrNull;

  @override
  void onInit() {
    super.onInit();
    fetchPackages();
  }

  Future<void> fetchPackages() async {
    try {
      isLoading.value = true;
      appError.value = null;

      final snapshot = await firestore
          .collection('packages')
          .orderBy('sort_order')
          .get();

      final list = snapshot.docs
          .map((doc) => PackageModel.fromMap(doc.id, doc.data()))
          .where((item) => item.isActive)
          .toList();

      packages.assignAll(list);
    } catch (e, s) {
      appError.value = ErrorMapper.map(e);
      debugPrint('fetchPackages error: $e');
      debugPrintStack(stackTrace: s);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onTapBuy(PackageModel item) async {
    try {
      final resolvedUserId = userId;
      final isThai = (Get.locale?.languageCode ?? 'th') == 'th';

      if (resolvedUserId == null || resolvedUserId.isEmpty) {
        Get.snackbar(
          isThai ? 'ยังไม่ได้เข้าสู่ระบบ' : 'Not logged in',
          isThai
              ? 'กรุณาเข้าสู่ระบบก่อนทำรายการ'
              : 'Please sign in before making a purchase.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      buyingPackageId.value = item.docId;

      final now = DateTime.now();
      final expireAt = now.add(Duration(days: item.durationDays));

      final historyRef = firestore.collection('user_package_history').doc();

      await historyRef.set({
        'user_id': resolvedUserId,
        'package_id': item.id,
        'purchase_id': historyRef.id,
        'status': 'inactive',
        'payment_status': 'paid',
        'payment_method': 'promptpay',
        'payment_channel': 'mobile_banking',
        'payment_reference': 'TEMP-${historyRef.id}',
        'amount': item.price,
        'currency': item.currency,
        'purchased_at': Timestamp.fromDate(now),
        'paid_at': Timestamp.fromDate(now),
        'start_at': null,
        'expire_at': Timestamp.fromDate(expireAt),
        'expired_at': null,
        'package_snapshot': {
          'id': item.id,
          'name': {
            'th': item.nameTh,
            'en': item.nameEn,
          },
          'description': {
            'th': item.descriptionTh,
            'en': item.descriptionEn,
          },
          'benefits': item.benefits
              .map(
                (benefit) => {
                  'th': benefit.th,
                  'en': benefit.en,
                },
              )
              .toList(),
          'price': item.price,
          'currency': item.currency,
          'duration_days': item.durationDays,
        },
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      });

      await Get.dialog(
        AlertDialog(
          title: Text(isThai ? 'สำเร็จ' : 'Success'),
          content: Text(isThai ? 'สั่งซื้อเสร็จสิ้น' : 'Purchase completed'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text(isThai ? 'ตกลง' : 'OK'),
            ),
          ],
        ),
        barrierDismissible: false,
      );

      final historyController = Get.find<PurchaseHistoryController>();
      historyController.startWaitingForPurchase(historyRef.id);

      final navController = Get.find<MainNavigationController>();
      navController.goToPurchaseHistory();
    } catch (e, s) {
      final error = ErrorMapper.map(e);
      debugPrint('onTapBuy error: $e');
      debugPrintStack(stackTrace: s);

      Get.snackbar(
        error.type.name,
        error.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      buyingPackageId.value = '';
    }
  }
}