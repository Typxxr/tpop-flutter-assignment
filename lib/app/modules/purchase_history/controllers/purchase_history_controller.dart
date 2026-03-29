import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pack_mate/app/data/purchase_history_model.dart';
import 'package:pack_mate/app/shared/errors/app_error.dart';
import 'package:pack_mate/app/shared/errors/error_mapper.dart';
import 'package:pack_mate/config/app_env.dart';

class PurchaseHistoryController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final AppEnv env;

  PurchaseHistoryController({required this.env});

  final histories = <PurchaseHistoryModel>[].obs;
  final isLoading = true.obs;
  final appError = Rxn<AppError>();

  final waitingMessage = ''.obs;
  final togglingPurchaseId = ''.obs;
  RxString get processingPurchaseId => togglingPurchaseId;
  final RxSet<String> expandedPurchaseIds = <String>{}.obs;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;
  Timer? _waitingTimer;

  String? get userId => env.currentUserIdOrNull;

  String? focusPurchaseId;
  bool waitForNewPurchase = false;

  @override
  void onInit() {
    super.onInit();
    bindPurchaseHistory();
  }

  bool _ensureLoggedIn() {
  final uid = userId;
  if (uid != null && uid.isNotEmpty) {
    return true;
  }

  appError.value = AppError(
    type: AppErrorType.unauthorized,
    message: 'not_logged_in_message',
  );
  isLoading.value = false;
  waitingMessage.value = '';
  return false;
}

  bool _isExpired(PurchaseHistoryModel item) {
    if (item.status.toLowerCase() == 'expired') {
      return true;
    }

    final expireAt = item.expireAt;
    if (expireAt == null) return false;

    return expireAt.isBefore(DateTime.now());
  }

  bool _isCurrentlyActive(PurchaseHistoryModel item) {
    if (_isExpired(item)) return false;
    return item.status.toLowerCase() == 'active';
  }

  bool _isInactive(PurchaseHistoryModel item) {
    if (_isExpired(item)) return false;
    return item.status.toLowerCase() == 'inactive';
  }

  bool isExpired(PurchaseHistoryModel item) => _isExpired(item);
  bool isCurrentlyActive(PurchaseHistoryModel item) => _isCurrentlyActive(item);
  bool isInactive(PurchaseHistoryModel item) => _isInactive(item);

  List<PurchaseHistoryModel> get activeHistories =>
      histories.where(_isCurrentlyActive).toList()..sort((a, b) {
        final aDate = a.purchasedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bDate = b.purchasedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bDate.compareTo(aDate);
      });

  List<PurchaseHistoryModel> get inactiveHistories =>
      histories.where(_isInactive).toList()..sort((a, b) {
        final aDate = a.purchasedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bDate = b.purchasedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bDate.compareTo(aDate);
      });

  List<PurchaseHistoryModel> get expiredHistories =>
      histories.where(_isExpired).toList()..sort((a, b) {
        final aDate =
            a.expiredAt ?? a.expireAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bDate =
            b.expiredAt ?? b.expireAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bDate.compareTo(aDate);
      });

  void toggleExpanded(String purchaseId) {
    if (expandedPurchaseIds.contains(purchaseId)) {
      expandedPurchaseIds.remove(purchaseId);
    } else {
      expandedPurchaseIds.add(purchaseId);
    }
  }

  void startWaitingForPurchase(String purchaseId) {
    focusPurchaseId = purchaseId;
    waitForNewPurchase = true;
    waitingMessage.value = (Get.locale?.languageCode ?? 'th') == 'th'
        ? 'กำลังยืนยันการซื้อ...'
        : 'Confirming your purchase...';
    bindPurchaseHistory();
  }

  void bindPurchaseHistory() {
    appError.value = null;
    isLoading.value = true;

    _subscription?.cancel();
    _waitingTimer?.cancel();

    if (!_ensureLoggedIn()) {
      return;
    }

    if (waitForNewPurchase && focusPurchaseId != null) {
      _waitingTimer = Timer(const Duration(seconds: 10), () {
        if (isLoading.value) {
          final isThai = (Get.locale?.languageCode ?? 'th') == 'th';
          appError.value = AppError(
            type: AppErrorType.timeout,
            message: isThai
                ? 'กำลังรอข้อมูลการซื้ออัปเดตนานเกินไป กรุณาลองรีเฟรชอีกครั้ง'
                : 'Purchase update is taking too long. Please refresh and try again.',
          );
          isLoading.value = false;
        }
      });
    }

    _subscription = firestore
        .collection('user_package_history')
        .where('user_id', isEqualTo: userId)
        .snapshots()
        .listen(
          (snapshot) {
            final list = snapshot.docs
                .map((doc) => PurchaseHistoryModel.fromMap(doc.id, doc.data()))
                .toList();

            histories.assignAll(list);

            if (!waitForNewPurchase) {
              isLoading.value = false;
              waitingMessage.value = '';
              return;
            }

            final foundItem = list.where(
              (e) => e.purchaseId == focusPurchaseId,
            );
            if (foundItem.isNotEmpty) {
              waitForNewPurchase = false;
              isLoading.value = false;
              waitingMessage.value = '';
              _waitingTimer?.cancel();
            }
          },
          onError: (e, s) {
            appError.value = ErrorMapper.map(e);
            isLoading.value = false;
            waitingMessage.value = '';
            debugPrint('bindPurchaseHistory error: $e');
            debugPrintStack(stackTrace: s is StackTrace ? s : null);
          },
        );
  }

  Future<void> togglePackageStatus(PurchaseHistoryModel item) async {
    try {
      if (!_ensureLoggedIn()) return;

      if (_isExpired(item)) {
        final isThai = (Get.locale?.languageCode ?? 'th') == 'th';
        Get.snackbar(
          isThai ? 'ไม่สามารถเปลี่ยนสถานะได้' : 'Unable to update status',
          isThai ? 'แพ็กเกจนี้หมดอายุแล้ว' : 'This package has expired.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      togglingPurchaseId.value = item.purchaseId;

      final selectedQuery = await firestore
          .collection('user_package_history')
          .where('user_id', isEqualTo: userId)
          .where('purchase_id', isEqualTo: item.purchaseId)
          .limit(1)
          .get();

      if (selectedQuery.docs.isEmpty) {
        throw Exception('Selected package history not found');
      }

      final selectedDoc = selectedQuery.docs.first;
      final selectedData = selectedDoc.data();

      final currentStatus = (selectedData['status'] ?? '')
          .toString()
          .toLowerCase();
      final now = DateTime.now();

      final userRef = firestore.collection('users').doc(userId);
      final batch = firestore.batch();

      if (currentStatus == 'active') {
        batch.update(selectedDoc.reference, {
          'status': 'inactive',
          'updated_at': FieldValue.serverTimestamp(),
        });

        batch.set(userRef, {
          'current_package_id': FieldValue.delete(),
          'current_package_status': 'inactive',
          'current_purchase_id': FieldValue.delete(),
          'package_start_at': FieldValue.delete(),
          'package_expire_at': FieldValue.delete(),
          'updated_at': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } else {
        final activeQuery = await firestore
            .collection('user_package_history')
            .where('user_id', isEqualTo: userId)
            .where('status', isEqualTo: 'active')
            .get();

        for (final doc in activeQuery.docs) {
          if (doc.id != selectedDoc.id) {
            batch.update(doc.reference, {
              'status': 'inactive',
              'updated_at': FieldValue.serverTimestamp(),
            });
          }
        }

        batch.update(selectedDoc.reference, {
          'status': 'active',
          'start_at': selectedData['start_at'] ?? Timestamp.fromDate(now),
          'updated_at': FieldValue.serverTimestamp(),
        });

        batch.set(userRef, {
          'current_package_id': selectedData['package_id'],
          'current_package_status': 'active',
          'current_purchase_id': selectedData['purchase_id'],
          'package_start_at':
              selectedData['start_at'] ?? Timestamp.fromDate(now),
          'package_expire_at': selectedData['expire_at'],
          'updated_at': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      await batch.commit();

      final isThai = (Get.locale?.languageCode ?? 'th') == 'th';
      final activated = currentStatus != 'active';

      Get.snackbar(
        isThai ? 'สำเร็จ' : 'Success',
        activated
            ? (isThai
                  ? 'เปิดใช้งานแพ็กเกจเรียบร้อยแล้ว'
                  : 'Package has been activated successfully.')
            : (isThai
                  ? 'ปิดการใช้งานแพ็กเกจเรียบร้อยแล้ว'
                  : 'Package has been inactivated successfully.'),
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e, s) {
      final error = ErrorMapper.map(e);
      appError.value = error;
      debugPrint('togglePackageStatus error: $e');
      debugPrintStack(stackTrace: s);

      Get.snackbar(
        error.type.name,
        error.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      togglingPurchaseId.value = '';
    }
  }

  Future<void> activatePackage(PurchaseHistoryModel item) async {
    await togglePackageStatus(item);
  }

  Future<void> deactivatePackage(PurchaseHistoryModel item) async {
    await togglePackageStatus(item);
  }

  Future<void> refreshPurchaseHistory() async {
    bindPurchaseHistory();
  }

  @override
  void onClose() {
    _subscription?.cancel();
    _waitingTimer?.cancel();
    super.onClose();
  }
}
