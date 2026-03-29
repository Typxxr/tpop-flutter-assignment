import 'package:get/get.dart';
import 'package:pack_mate/config/app_env.dart';

import '../controllers/package_controller.dart';

class PackageBinding extends Bindings {
  @override
  void dependencies() {
    final env = Get.find<AppEnv>();

    Get.lazyPut<PackageController>(
      () => PackageController(env: env),
    );
  }
}