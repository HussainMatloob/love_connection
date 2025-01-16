import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  var currentPage = 0.obs;
  final PageController pageController = PageController(); // PageController to manage page navigation

  void goToNextPage() {
    if (currentPage.value < 2) {
      currentPage.value++; // Increment page index
      pageController.animateToPage(
        currentPage.value, // Move to the next page
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut, // Smooth page transition
      );
    } else {
      Get.offAllNamed('/login'); // Navigate to BasicInfoScreens or another route
    }
  }

  void skipOnboarding() {
    Get.offAllNamed('/login'); // Navigate to BasicInfoScreens or another route
  }
}
