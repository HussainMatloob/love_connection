import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:love_connection/Screens/home/home.dart';

import 'Onboarding/OnboardingScreen.dart';

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
      initialRoute: '/onboarding',
      getPages: [
        GetPage(name: '/onboarding', page: () => OnboardingScreen()),
        GetPage(name: '/home', page: () => Home()), // Define your home screen
      ],
    );
  }
}

