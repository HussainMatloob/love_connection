import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart'; // Import GoogleFonts

class OnboardingPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;


  const OnboardingPage({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
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
                width: Get.width,
                height: Get.height,
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
              left: Get.width * 0.15,
              child: Container(
                //add box decoration to the container with border radius of 16 and color of white with opacity of 0.2
                width: Get.width * 0.7,
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
                        style: GoogleFonts.outfit(  // Use the Outfit font
                          fontSize: 31,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,

                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 22),

                      Text(
                        subtitle,
                        style: GoogleFonts.outfit(  // Use the Outfit font
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



          ],
        ),
      ),
    );
  }
}
