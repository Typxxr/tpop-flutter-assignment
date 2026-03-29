class BenefitItem {
  final String en;
  final String th;

  BenefitItem({
    required this.en,
    required this.th,
  });

  factory BenefitItem.fromMap(Map<String, dynamic> map) {
    return BenefitItem(
      en: map['en']?.toString() ?? '',
      th: map['th']?.toString() ?? '',
    );
  }

  String byLocale(String languageCode) {
    if (languageCode == 'th') {
      return th.isNotEmpty ? th : en;
    }
    return en.isNotEmpty ? en : th;
  }
}

class PackageModel {
  final String docId;
  final String id;
  final String currency;
  final int durationDays;
  final bool isActive;
  final String descriptionEn;
  final String descriptionTh;
  final String nameEn;
  final String nameTh;
  final double price;
  final int sortOrder;
  final List<BenefitItem> benefits;

  PackageModel({
    required this.docId,
    required this.id,
    required this.currency,
    required this.durationDays,
    required this.isActive,
    required this.descriptionEn,
    required this.descriptionTh,
    required this.nameEn,
    required this.nameTh,
    required this.price,
    required this.sortOrder,
    required this.benefits,
  });

  factory PackageModel.fromMap(String docId, Map<String, dynamic> map) {
    final benefitsRaw = map['benefits'] as List<dynamic>? ?? [];

    return PackageModel(
      docId: docId,
      id: map['id']?.toString() ?? '',
      currency: map['currency']?.toString() ?? '',
      durationDays: (map['duration_days'] ?? 0) is int
          ? (map['duration_days'] ?? 0)
          : int.tryParse(map['duration_days'].toString()) ?? 0,
      isActive: map['is_active'] ?? false,
      descriptionEn: (map['description']?['en'] ?? '').toString(),
      descriptionTh: (map['description']?['th'] ?? '').toString(),
      nameEn: (map['name']?['en'] ?? '').toString(),
      nameTh: (map['name']?['th'] ?? '').toString(),
      price: (map['price'] ?? 0) is double
          ? (map['price'] ?? 0)
          : int.tryParse(map['price'].toString()) ?? 0,
      sortOrder: (map['sort_order'] ?? 0) is int
          ? (map['sort_order'] ?? 0)
          : int.tryParse(map['sort_order'].toString()) ?? 0,
      benefits: benefitsRaw
          .map((e) => BenefitItem.fromMap(Map<String, dynamic>.from(e)))
          .toList(),
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