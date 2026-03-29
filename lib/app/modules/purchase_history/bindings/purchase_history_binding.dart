import 'package:get/get.dart';
import 'package:pack_mate/config/app_env.dart';

import '../controllers/purchase_history_controller.dart';

class PurchaseHistoryBinding extends Bindings {
  @override
  void dependencies() {
    final env = Get.find<AppEnv>();

    Get.lazyPut<PurchaseHistoryController>(
      () => PurchaseHistoryController(env: env),
      fenix: true,
    );
  }
}