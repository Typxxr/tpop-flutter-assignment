import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageController extends GetxController {
  final Rx<Locale> currentLocale = const Locale('th', 'TH').obs;

  bool get isThai => currentLocale.value.languageCode == 'th';

  void changeToThai() {
    const locale = Locale('th', 'TH');
    currentLocale.value = locale;
    Get.updateLocale(locale);
  }

  void changeToEnglish() {
    const locale = Locale('en', 'US');
    currentLocale.value = locale;
    Get.updateLocale(locale);
  }

  void toggleLanguage() {
    if (isThai) {
      changeToEnglish();
    } else {
      changeToThai();
    }
  }
}