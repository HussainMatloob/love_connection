import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:love_connection/Controllers/document_upload_controller.dart';
import 'package:love_connection/Controllers/selfie_upload_controller.dart';
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

  final DocumentUploadController documentUploadController =
      Get.put(DocumentUploadController());
  final SelfieImageController selfieImageController =
      Get.put(SelfieImageController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    documentUploadController.clearAllDocuments();
    selfieImageController.clearSelfieImage();
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
        child: GetBuilder<AuthController>(
          init: AuthController(),
          builder: (authController) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(20.w),
                  child: FormWidgets.buildHomeTabs(controller,
                      authController.pageController, 'Basic', 'Preferences'),
                ),
                Expanded(
                  child: PageView(
                    controller: authController.pageController,
                    onPageChanged: authController.onPageChanged,
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
                      controller: authController.pageController,
                      count: 4,
                      effect: WormEffect(
                        dotHeight: 8.h,
                        dotWidth: 8.w,
                        activeDotColor: Colors.pinkAccent,
                        dotColor: Colors.grey,
                      ),
                      onDotClicked: authController.onDotClicked,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
