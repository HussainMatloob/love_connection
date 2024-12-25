import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class OnboardingPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const OnboardingPage({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.onNext,
    required this.onSkip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
            // Dark overlay
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
            // Onboarding Content
            Positioned(
              bottom: Get.height * 0.15,
              left: Get.width * 0.2,
              child: Container(
                //add box decoration to the container with border radius of 16 and color of white with opacity of 0.2
                width: Get.width * 0.6,
                height: Get.height * 0.3,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Title
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      // Subtitle
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Bottom Navigation (Skip and Next)

            // add linear gradient container to the bottom of the screen and add top white color with opacity of 0.2 and bottom color of black with opacity of 0.3
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 200, // Adjust height as needed
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent, // Top color with opacity 0.2
                      Colors.black.withOpacity(0.8), // Bottom color with opacity 0.3
                    ],
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: onSkip,
                      child: const Text(
                        "Skip",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    FloatingActionButton(
                      onPressed: onNext,
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
      ),
    );
  }
}
