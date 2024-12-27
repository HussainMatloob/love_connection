import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../Controllers/onboardingController.dart';
import 'OnboardingPage.dart';

class OnboardingScreen extends StatelessWidget {
  final OnboardingController controller = Get.put(OnboardingController());

  final List<Map<String, String>> onboardingData = [
    {
      'image': 'assets/images/onboarding1.jpg',
      'title': 'Welcome To\n Love Connection',
      'subtitle': 'Your Journey to Forever\n Starts Here\nFind Your Perfect Match!'
    },
    {
      'image': 'assets/images/onboarding2.jpg',
      'title': 'Tailored Matches\n Just For You',
      'subtitle': 'Connect with people who share \nyour values and interests.\n Easily find profiles that align with\nyour preferences'
    },
    {
      'image': 'assets/images/onboarding3.png',
      'title': 'Safe And Secure\nConnections',
      'subtitle': 'We prioritize your security.\nAll profiles are verified, and\nyour data is protected ton\nensure a safe and\n trustworthy experience'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView for onboarding screens
          PageView.builder(
            itemCount: onboardingData.length,
            onPageChanged: (index) => controller.currentPage.value = index,
            controller:  controller.pageController,
            itemBuilder: (context, index) {
              final data = onboardingData[index];
              return OnboardingPage(
                imagePath: data["image"]!,
                title: data['title']!,
                subtitle: data['subtitle']!,
              );
            },
          ),

          // Bottom indicator for pages
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  onboardingData.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    width: controller.currentPage.value == index ? 12 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: controller.currentPage.value == index
                          ? Colors.pinkAccent
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      controller.skipOnboarding();
                    }, child: const Text('Skip', style: TextStyle(color: Colors.white)),
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      controller.goToNextPage();
                    },
                    backgroundColor: Colors.pinkAccent,
                    // add raduis to the button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                ],
              ),
            ),

          ),

        ],

      ),
    );
  }
}
