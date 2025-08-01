import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';
import 'package:love_connection/Onboarding/OnboardingScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screens/Service_selection_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserLogin();
  }

  Future<void> _checkUserLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userid');

    // Simulate a delay to show the splash screen
    await Future.delayed(Duration(seconds: 5));
    if (userId != null && userId.isNotEmpty) {
      Get.offAll(ServiceSelectionScreen());
    } else {
      // Navigate to Onboarding screen if userId doesn't exist
      Get.offAll(OnboardingScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50, // Light pink background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/intro.json',
              width: 250,
              height: 250,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20), // Space between animation and title
            Text(
              "Love Connection", // Replace with your app's title
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.pink.shade700, // Vibrant pink for the title
              ),
            ),
            Text(
              "Where souls meet and stories begin", // Subtitle (optional)
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.pink.shade400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
