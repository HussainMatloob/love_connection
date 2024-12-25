import 'package:get/get.dart';

class OnboardingController extends GetxController {
  var currentPage = 0.obs;

  void goToNextPage() {
    if (currentPage < 2) {
      currentPage++;
    } else {
      Get.offAllNamed('/home'); // Navigate to home or another route
    }
  }

  void skipOnboarding() {
    Get.offAllNamed('/home'); // Navigate to home or another route
  }
}
