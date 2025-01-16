import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:love_connection/Screens/Coaching%20Service/CoachingServiceProvider.dart';
import 'package:love_connection/Screens/DocumentUpload.dart';
import 'package:love_connection/Screens/Preferences.dart';
import 'package:love_connection/Screens/Profilepicture.dart';
import 'package:love_connection/Screens/SelfieUploadScreen.dart';
import 'package:love_connection/Screens/Service_selection_screen.dart';
import 'package:love_connection/Screens/auth/Login.dart';
import 'package:love_connection/Splash.dart';
import 'Onboarding/OnboardingScreen.dart';
import 'Screens/BasicInfoScreens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => SplashScreen()), // Define your home screen
        GetPage(name: '/onboarding', page: () => OnboardingScreen()),
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/BasicInfoScreens', page: () => Home()), // Define your home screen
        GetPage(name: '/selfieuploadscreen', page: () => SelfieImageScreen()),
        GetPage(name: '/preferences', page: () =>Preferences()),
        GetPage(name: '/profilepicture', page: () =>Profilepicture()),
        GetPage(name: '/documentupload', page: () =>DocumentUploadScreen()),
        GetPage(name: '/serviceselection', page: () =>ServiceSelectionScreen()),
        GetPage(name: '/coachingservices', page: () =>CoachingServiceProviderScreen()),
      ],
    );
  }
}

