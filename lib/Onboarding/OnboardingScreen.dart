import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import ScreenUtil
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
                        padding: EdgeInsets.only(bottom: 120.h),
                        child: Container(
                          width: 0.75.sw, // 75% of screen width
                          height: 0.75.sw, // Square box based on width
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                data['title']!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 15.h), // Space between text
                              Text(
                                data['subtitle']!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16.sp,
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
              bottom: 100.h,
              left: 0,
              right: 0,
              child: Obx(
                    () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    onboardingData.length,
                        (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      width: controller.currentPage.value == index ? 14.w : 8.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: controller.currentPage.value == index
                            ? Colors.pinkAccent
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Skip and Next Buttons (Fixed)
            Positioned(
              bottom: 24.h,
              left: 24.w,
              right: 24.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: controller.skipOnboarding,
                    child: Text(
                      'Skip',
                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: controller.goToNextPage,
                    backgroundColor: Colors.pinkAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    child: Icon(Icons.arrow_forward, color: Colors.white, size: 24.sp),
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
