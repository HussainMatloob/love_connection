import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:love_connection/Screens/bottom_nav/Explore.dart';

class BottomNavControllerLogic extends GetxController {
  // Reactive variable to hold the selected index
  RxInt selectedIndex = 0.obs;

  // List of SVG icons for the bottom navigation
  final List<String> svgIcons = [
    'assets/svg/explore.svg',  // Replace with your SVG asset paths
    'assets/svg/requests.svg',
    'assets/svg/matches.svg',
    'assets/svg/profile.svg',
  ];

  // Corresponding labels for each tab
  final List<String> labels = ['Explore', 'Request', 'Matches', 'Profile'];

  // Pages corresponding to each tab
  final List<Widget> pages = [
    Explore(),
    Center(child: Text('Request Page')),
    Center(child: Text('Matches Page')),
    Center(child: Text('Profile Page')),
  ];

  // Method to handle bottom navigation item tap
  void onItemTapped(int index) {
    selectedIndex.value = index;  // Update the selected index
  }
}