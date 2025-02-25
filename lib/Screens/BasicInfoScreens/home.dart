import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../Controllers/AuthController.dart';
import '../../Controllers/BasicInfoController.dart';
import '../../Widgets/FormWidgets.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final BasicInfoController controller = Get.put(BasicInfoController());
  final AuthController authController = Get.put(AuthController());
  final PageController pageController = PageController();
  int currentPageIndex = 0; // Track current page

  /// **Validation Function for Each Form**
  bool validateCurrentPage(int pageIndex) {
    // ✅ **Validation for Page 1 (First Form)**
    if (pageIndex == 1) {
      if (authController.firstNameController.text.isEmpty ||
          authController.lastNameController.text.isEmpty ||
          authController.emailController.text.isEmpty ||
          authController.passwordController.text.isEmpty ||
          authController.gender.value == null) {
        Get.snackbar(
          'Error',
          'Please fill in all required fields before proceeding.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
        return false; // Stop navigation
      }
    }

    // ✅ **Validation for Page 2 (Second Form)**
    if (pageIndex == 2) {
      if (authController.religion.value == null ||
          authController.lookingForReligion.value == null ||
          authController.height.value == null ||
          authController.maritalStatus.value == null ||
          authController.dateOfBirth.value == null) {
        Get.snackbar(
          'Error',
          'Please complete the required details before proceeding.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
        return false; // Stop navigation
      }
    }

    // ✅ **Validation for Page 3 (Third Form)**
    if (pageIndex == 3) {
      if (authController.educationLevel.value == null ||
          authController.lookingForEducation.value == null ||
          authController.currentResidence.value == null ||
          authController.lookingForResidence.value == null ||
          authController.employmentStatus.value == null) {
        Get.snackbar(
          'Error',
          'Please fill in all required education and residence details.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
        return false; // Stop navigation
      }
    }

    return true; // Allow page change
  }

  /// **Page Change Handler**
  void onPageChanged(int index) {
    if (!validateCurrentPage(index)) {
      pageController.jumpToPage(currentPageIndex); // Stay on the same page
      return;
    }

    setState(() {
      currentPageIndex = index; // Update current page if validation passes
    });
  }

  /// **Dot Navigation Handler**
  void onDotClicked(int index) {
    if (validateCurrentPage(index)) {
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Basic Information',
          style: GoogleFonts.outfit(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(Get.width * 0.05),
              child: FormWidgets.buildHomeTabs(
                  controller, pageController, 'Basic', 'Preferences'),
            ),
            Expanded(
              child: PageView(
                controller: pageController,
                onPageChanged: onPageChanged, // Validate when swiping
                children: [
                  FormWidgets.buildForm(controller), // Page 0
                  FormWidgets().buildSecondForm(), // Page 1
                  FormWidgets.buildPreferencesForm(controller), // Page 2
                  FormWidgets.buildPreferencesForm2(controller), // Page 3
                ],
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SmoothPageIndicator(
                  controller: pageController,
                  count: 4,
                  effect: const WormEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    activeDotColor: Colors.pinkAccent,
                    dotColor: Colors.grey,
                  ),
                  onDotClicked: onDotClicked, // Validate when clicking dots
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
