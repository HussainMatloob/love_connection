import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controllers/onboardingController.dart';
import 'OnboardingPage.dart';

class OnboardingScreen extends StatelessWidget {
  final OnboardingController controller = Get.put(OnboardingController());

  final List<Map<String, String>> pages = [
    {
      "image": "assets/images/onboarding1.jpg",
      "title": "Welcome To\n Love Connection",
      "subtitle": "Your Journey to Forever Starts Here\nFind Your Perfect Match!"
    },
    {
      "image": "assets/images/onboarding2.jpg",
      "title": "Tailored Matches\n Just For You",
      "subtitle": "Connect with people who share\nyour values and interests.\nEasily find profiles that align with\nyour preferences."
    },
    {
      "image": "assets/images/onboarding3.png",
      "title": "Safe And Secure\nConnections",
      "subtitle": "We prioritize your security.\nAll profiles are verified, and\nyour data is protected to\nensure a safe and\ntrustworthy experience"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => OnboardingPage(
        imagePath: pages[controller.currentPage.value]['image']!,
        title: pages[controller.currentPage.value]['title']!,
        subtitle: pages[controller.currentPage.value]['subtitle']!,
        onNext: controller.goToNextPage,
        onSkip: controller.skipOnboarding,
      ),
    );
  }
}
