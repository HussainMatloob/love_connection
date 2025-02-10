import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../Controllers/BasicInfoController.dart';
import '../BasicInfo.dart';
import '../Preferences.dart';
import '../../Widgets/FormWidgets.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final BasicInfoController controller = Get.put(BasicInfoController());
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Basic Information',
          style: GoogleFonts.outfit(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView( // Wrap in scrollable container
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(Get.width * 0.05),
                child: FormWidgets.buildHomeTabs(controller, pageController, 'Basic', 'Preferences'),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7, // Limit height
                child: PageView(
                  controller: pageController,
                  onPageChanged: (index) {
                    if (index < 2) {
                      controller.currentPage.value = 0; // Basic
                    } else {
                      controller.currentPage.value = 2; // Preferences
                    }
                  },
                  children: [
                    FormWidgets.buildForm(controller),
                    FormWidgets().buildSecondForm(),
                    FormWidgets.buildPreferencesForm(controller),
                    FormWidgets.buildPreferencesForm2(controller),
                  ],
                ),

              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SmoothPageIndicator(
                    controller: pageController,
                    count: 4,
                    effect: WormEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      activeDotColor: Colors.pinkAccent,
                      dotColor: Colors.grey,
                    ),
                    onDotClicked: (index) {
                      controller.currentPage.value = index;
                      pageController.animateToPage(
                        index,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
