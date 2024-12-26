import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../Controllers/BottomNavController.dart';

class Bottomnavbar extends StatefulWidget {
  const Bottomnavbar({super.key});

  @override
  State<Bottomnavbar> createState() => _BottomnavbarState();
}

class _BottomnavbarState extends State<Bottomnavbar> {
  final BottomNavControllerLogic controller = Get.put(BottomNavControllerLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => controller.pages[controller.selectedIndex.value]),  // Display the corresponding page
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: controller.selectedIndex.value,
        onTap: controller.onItemTapped,  // Update the selected index
        selectedItemColor: Colors.pink,  // Selected icon color
        unselectedItemColor: Colors.grey,  // Unselected icon color
        showUnselectedLabels: true,  // Show labels for unselected items
        items: List.generate(controller.svgIcons.length, (index) {
          return BottomNavigationBarItem(
            icon: SvgPicture.asset(
              controller.svgIcons[index],
              color: controller.selectedIndex.value == index ? Colors.pink : Colors.grey,
              width: 24,
              height: 24,
            ),
            label: controller.labels[index],  // Text label for each item
          );
        }),
      )),
    );

  }
}
