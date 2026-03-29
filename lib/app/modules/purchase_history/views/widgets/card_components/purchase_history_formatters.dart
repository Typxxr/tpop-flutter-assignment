import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PurchaseHistoryFormatters {
  static String label(
    String langCode, {
    required String th,
    required String en,
  }) {
    return langCode == 'th' ? th : en;
  }

  static String formatDateTime(DateTime? date, String langCode) {
    if (date == null) return '-';
    final locale = langCode == 'th' ? 'th_TH' : 'en_US';
    return DateFormat('dd/MM/yyyy HH:mm', locale).format(date);
  }

  static String paymentMethodLabel(String method) {
    switch (method.toLowerCase()) {
      case 'promptpay':
        return 'promptpay'.tr;
      case 'credit_card':
        return 'credit_card'.tr;
      case 'mobile_banking':
        return 'mobile_banking'.tr;
      case 'bank_transfer':
        return 'bank_transfer'.tr;
      default:
        return 'other_payment'.tr;
    }
  }

  static String paymentStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return 'paid'.tr;
      case 'pending':
        return 'pending'.tr;
      case 'failed':
        return 'failed'.tr;
      default:
        return status;
    }
  }
}