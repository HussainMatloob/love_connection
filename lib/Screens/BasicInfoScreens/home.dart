import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  int currentPageIndex = 0;

  bool validateCurrentPage(int pageIndex) {
    if (pageIndex == 1) {
      if (authController.firstNameController.text.isEmpty ||
          authController.lastNameController.text.isEmpty ||
          authController.emailController.text.isEmpty ||
          authController.passwordController.text.isEmpty ||
          authController.gender.value == null) {
        showErrorSnackbar(
            'Please fill in all required fields before proceeding.');
        return false;
      }
    }
    if (pageIndex == 2) {
      if (authController.religion.value == null ||
          authController.lookingForReligion.value == null ||
          authController.height.value == null ||
          authController.maritalStatus.value == null ||
          authController.dateOfBirth.value == null) {
        showErrorSnackbar(
            'Please complete the required details before proceeding.');
        return false;
      }
    }
    if (pageIndex == 3) {
      if (authController.educationLevel.value == null ||
          authController.lookingForEducation.value == null ||
          authController.currentResidence.value == null ||
          authController.lookingForResidence.value == null ||
          authController.employmentStatus.value == null) {
        showErrorSnackbar(
            'Please fill in all required education and residence details.');
        return false;
      }
    }
    return true;
  }

  void showErrorSnackbar(String message) {
    Get.snackbar('Error', message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white);
  }

  void onPageChanged(int index) {
    if (!validateCurrentPage(index)) {
      pageController.jumpToPage(currentPageIndex);
      return;
    }
    setState(() {
      currentPageIndex = index;
    });
  }

  void onDotClicked(int index) {
    if (validateCurrentPage(index)) {
      pageController.animateToPage(index,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Basic Information',
          style: GoogleFonts.outfit(color: Colors.black, fontSize: 18.sp),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(20.w),
              child: FormWidgets.buildHomeTabs(
                  controller, pageController, 'Basic', 'Preferences'),
            ),
            Expanded(
              child: PageView(
                controller: pageController,
                onPageChanged: onPageChanged,
                children: [
                  FormWidgets.buildForm(controller),
                  FormWidgets().buildSecondForm(),
                  FormWidgets.buildPreferencesForm(controller),
                  FormWidgets().buildPreferencesForm2(controller),
                ],
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: SmoothPageIndicator(
                  controller: pageController,
                  count: 4,
                  effect: WormEffect(
                    dotHeight: 8.h,
                    dotWidth: 8.w,
                    activeDotColor: Colors.pinkAccent,
                    dotColor: Colors.grey,
                  ),
                  onDotClicked: onDotClicked,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
