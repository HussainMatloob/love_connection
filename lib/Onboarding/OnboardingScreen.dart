import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controllers/onboardingController.dart';

class OnboardingScreen extends StatelessWidget {
  final OnboardingController controller = Get.put(OnboardingController());

  final List<Map<String, String>> onboardingData = [
    {
      'image': 'assets/images/onboarding1.jpg',
      'title': 'Welcome To\n Love Connection',
      'subtitle': 'Your Journey to Forever\n Starts Here\nFind Your Perfect Match!',
    },
    {
      'image': 'assets/images/onboarding2.jpg',
      'title': 'Tailored Matches\n Just For You',
      'subtitle':
      'Connect with people who share \nyour values and interests.\nEasily find profiles that align with\nyour preferences',
    },
    {
      'image': 'assets/images/onboarding3.png',
      'title': 'Safe And Secure\nConnections',
      'subtitle':
      'We prioritize your security.\nAll profiles are verified, and\nyour data is protected to\nensure a safe and\ntrustworthy experience',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // PageView: Moves only the image, title, and description
            PageView.builder(
              itemCount: onboardingData.length,
              onPageChanged: (index) => controller.currentPage.value = index,
              controller: controller.pageController,
              itemBuilder: (context, index) {
                final data = onboardingData[index];

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    // Full-Screen Background Image
                    Image.asset(
                      data["image"]!,
                      fit: BoxFit.cover,
                    ),

                    // Dark Overlay for Better Readability
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.3),
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Square Title & Description Container (Centered)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 120),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.65, // 75% of screen width
                          height: MediaQuery.of(context).size.width * 0.65, // Equal height
                          // margin: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                data['title']!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 15), // Space between text
                              Text(
                                data['subtitle']!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            // Page Indicator (Fixed)
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Obx(
                    () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    onboardingData.length,
                        (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      width: controller.currentPage.value == index ? 14 : 8,
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

            // Skip and Next Buttons (Fixed)
            Positioned(
              bottom: 24,
              left: 24,
              right: 24,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: controller.skipOnboarding,
                    child: const Text(
                      'Skip',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: controller.goToNextPage,
                    backgroundColor: Colors.pinkAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
