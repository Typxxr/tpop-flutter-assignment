import 'package:cloud_firestore/cloud_firestore.dart';

class PurchaseHistoryBenefitItem {
  final String th;
  final String en;

  const PurchaseHistoryBenefitItem({
    required this.th,
    required this.en,
  });

  factory PurchaseHistoryBenefitItem.fromMap(Map<String, dynamic> map) {
    return PurchaseHistoryBenefitItem(
      th: map['th']?.toString() ?? '',
      en: map['en']?.toString() ?? '',
    );
  }

  String byLocale(String languageCode) {
    if (languageCode == 'th') {
      return th.isNotEmpty ? th : en;
    }
    return en.isNotEmpty ? en : th;
  }
}

class PurchaseHistoryPackageSnapshot {
  final String id;
  final String nameTh;
  final String nameEn;
  final String descriptionTh;
  final String descriptionEn;
  final List<PurchaseHistoryBenefitItem> benefits;
  final num price;
  final String currency;
  final int durationDays;

  const PurchaseHistoryPackageSnapshot({
    required this.id,
    required this.nameTh,
    required this.nameEn,
    required this.descriptionTh,
    required this.descriptionEn,
    required this.benefits,
    required this.price,
    required this.currency,
    required this.durationDays,
  });

  factory PurchaseHistoryPackageSnapshot.fromMap(Map<String, dynamic> map) {
    final rawBenefits = map['benefits'] as List<dynamic>? ?? [];

    return PurchaseHistoryPackageSnapshot(
      id: map['id']?.toString() ?? '',
      nameTh: map['name']?['th']?.toString() ?? '',
      nameEn: map['name']?['en']?.toString() ?? '',
      descriptionTh: map['description']?['th']?.toString() ?? '',
      descriptionEn: map['description']?['en']?.toString() ?? '',
      benefits: rawBenefits
          .map((e) => PurchaseHistoryBenefitItem.fromMap(
                Map<String, dynamic>.from(e as Map),
              ))
          .toList(),
      price: map['price'] ?? 0,
      currency: map['currency']?.toString() ?? 'THB',
      durationDays: (map['duration_days'] ?? 0) is int
          ? map['duration_days'] as int
          : int.tryParse(map['duration_days'].toString()) ?? 0,
    );
  }

  String nameByLocale(String languageCode) {
    if (languageCode == 'th') {
      return nameTh.isNotEmpty ? nameTh : nameEn;
    }
    return nameEn.isNotEmpty ? nameEn : nameTh;
  }

  String descriptionByLocale(String languageCode) {
    if (languageCode == 'th') {
      return descriptionTh.isNotEmpty ? descriptionTh : descriptionEn;
    }
    return descriptionEn.isNotEmpty ? descriptionEn : descriptionTh;
  }
}

class PurchaseHistoryModel {
  final String docId;
  final String userId;
  final String packageId;
  final String purchaseId;
  final String status;
  final String paymentStatus;
  final String paymentMethod;
  final String paymentChannel;
  final String paymentReference;
  final num amount;
  final String currency;
  final DateTime? purchasedAt;
  final DateTime? paidAt;
  final DateTime? startAt;
  final DateTime? expireAt;
  final DateTime? expiredAt;
  final PurchaseHistoryPackageSnapshot? packageSnapshot;

  const PurchaseHistoryModel({
    required this.docId,
    required this.userId,
    required this.packageId,
    required this.purchaseId,
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.paymentChannel,
    required this.paymentReference,
    required this.amount,
    required this.currency,
    required this.purchasedAt,
    required this.paidAt,
    required this.startAt,
    required this.expireAt,
    required this.expiredAt,
    required this.packageSnapshot,
  });

  factory PurchaseHistoryModel.fromMap(String docId, Map<String, dynamic> map) {
    return PurchaseHistoryModel(
      docId: docId,
      userId: map['user_id']?.toString() ?? '',
      packageId: map['package_id']?.toString() ?? '',
      purchaseId: map['purchase_id']?.toString() ?? '',
      status: map['status']?.toString() ?? '',
      paymentStatus: map['payment_status']?.toString() ?? '',
      paymentMethod: map['payment_method']?.toString() ?? '',
      paymentChannel: map['payment_channel']?.toString() ?? '',
      paymentReference: map['payment_reference']?.toString() ?? '',
      amount: map['amount'] ?? 0,
      currency: map['currency']?.toString() ?? 'THB',
      purchasedAt: _parseDate(map['purchased_at']),
      paidAt: _parseDate(map['paid_at']),
      startAt: _parseDate(map['start_at']),
      expireAt: _parseDate(map['expire_at']),
      expiredAt: _parseDate(map['expired_at']),
      packageSnapshot: map['package_snapshot'] != null
          ? PurchaseHistoryPackageSnapshot.fromMap(
              Map<String, dynamic>.from(map['package_snapshot'] as Map),
            )
          : null,
    );
  }

  bool get isActive {
    if (status.toLowerCase() == 'active') return true;
    if (expireAt == null) return false;
    return expireAt!.isAfter(DateTime.now());
  }

  bool get isExpired {
    if (status.toLowerCase() == 'expired') return true;
    if (expireAt == null) return false;
    return expireAt!.isBefore(DateTime.now());
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value)?.toLocal();
    }
    return null;
  }
}