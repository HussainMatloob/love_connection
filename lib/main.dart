import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:love_connection/Screens/Coaching%20Service/CoachingServiceProvider.dart';
import 'package:love_connection/Screens/DocumentUpload.dart';
import 'package:love_connection/Screens/Preferences.dart';
import 'package:love_connection/Screens/Profilepicture.dart';
import 'package:love_connection/Screens/SelfieUploadScreen.dart';
import 'package:love_connection/Screens/Service_selection_screen.dart';
import 'package:love_connection/Screens/auth/Login.dart';
import 'package:love_connection/Splash.dart';
import 'Screens/BasicInfoScreens/home.dart';
import 'Onboarding/OnboardingScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();  // ✅ Ensures proper initialization
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),  // Base size (iPhone X)
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: '/splash',
          getPages: [
            GetPage(name: '/splash', page: () => SplashScreen()),
            GetPage(name: '/onboarding', page: () => OnboardingScreen()),
            GetPage(name: '/login', page: () => LoginScreen()),
            GetPage(name: '/BasicInfoScreens', page: () => Home()),
            GetPage(name: '/selfieuploadscreen', page: () => SelfieImageScreen()),
            GetPage(name: '/preferences', page: () => Preferences()),
            GetPage(name: '/profilepicture', page: () => ProfilePicture()),
            GetPage(name: '/documentupload', page: () => DocumentUploadScreen()),
            GetPage(name: '/serviceselection', page: () => ServiceSelectionScreen()),
            GetPage(name: '/coachingservices', page: () => CoachingServiceProviderScreen()),
          ],
        );
      },
    );
  }
}
