import 'package:get/get.dart';

class OnboardingController extends GetxController {
  var currentPage = 0.obs;

  void goToNextPage() {
    if (currentPage < 2) {
      currentPage++;
    } else {
      Get.offAllNamed('/BasicInfoScreens'); // Navigate to BasicInfoScreens or another route
    }
  }

  void skipOnboarding() {
    Get.offAllNamed('/BasicInfoScreens'); // Navigate to BasicInfoScreens or another route
  }
}
