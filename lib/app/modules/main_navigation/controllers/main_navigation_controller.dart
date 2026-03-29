import 'package:get/get.dart';

class MainNavigationController extends GetxController {
  final currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }

  void goToPurchaseHistory() {
    currentIndex.value = 1;
  }

  void goToPackages() {
    currentIndex.value = 0;
  }
}