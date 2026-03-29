import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pack_mate/app/controllers/language_controller.dart';
import 'package:pack_mate/config/app_translations.dart';
import '../config/app_env.dart';
import 'routes/app_pages.dart';

class MyApp extends StatelessWidget {
  final AppEnv env;

  const MyApp({super.key, required this.env});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: env.appName,
      initialBinding: BindingsBuilder(() {
        Get.put(LanguageController(), permanent: true);
      }),
      translations: AppTranslations(),
      locale: const Locale('th', 'TH'),
      fallbackLocale: const Locale('en', 'US'),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        if (env.isStaging) {
          return Banner(
            message: 'STAGING',
            location: BannerLocation.topEnd,
            child: child ?? const SizedBox.shrink(),
          );
        }
        return child ?? const SizedBox.shrink();
      },
    );
  }
}