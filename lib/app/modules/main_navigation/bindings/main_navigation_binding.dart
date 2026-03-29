import 'package:get/get.dart';
import 'package:pack_mate/app/modules/package/controllers/package_controller.dart';
import 'package:pack_mate/app/modules/purchase_history/controllers/purchase_history_controller.dart';
import 'package:pack_mate/config/app_env.dart';

import '../controllers/main_navigation_controller.dart';

class MainNavigationBinding extends Bindings {
  @override
  void dependencies() {
    final env = Get.find<AppEnv>();

    Get.lazyPut<MainNavigationController>(
      () => MainNavigationController(),
    );

    Get.lazyPut<PackageController>(
      () => PackageController(env: env),
      fenix: true,
    );

    Get.lazyPut<PurchaseHistoryController>(
      () => PurchaseHistoryController(env: env),
      fenix: true,
    );
  }
}