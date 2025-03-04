import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      body: Obx(() => SizedBox(
        height: 1.sh - 60.h, // Ensures body takes full remaining space
        width: 1.sw,
        child: controller.pages[controller.selectedIndex.value],
      )),

      /// ✅ Responsive Bottom Navigation Bar - Fixed height & proper icon sizing
      bottomNavigationBar: Obx(() => SizedBox(
        height: 60.h, // Ensuring fixed height for bottom nav
        width: 1.sw, // Full screen width
        child: BottomNavigationBar(
          backgroundColor: Colors.white70,
          type: BottomNavigationBarType.fixed, // Prevents shifting
          selectedLabelStyle: GoogleFonts.outfit(
            fontSize: 10.sp, // Reduced font size for better proportion
            fontWeight: FontWeight.w400,
          ),

          unselectedLabelStyle: GoogleFonts.outfit(
            fontSize: 10.sp,
            fontWeight: FontWeight.w400,
          ),
          currentIndex: controller.selectedIndex.value,
          onTap: controller.onItemTapped,
          selectedItemColor: Colors.pink,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          elevation: 5, // Slight shadow for better visibility
          items: List.generate(controller.svgIcons.length, (index) {
            return BottomNavigationBarItem(
              icon: SvgPicture.asset(
                controller.svgIcons[index],
                color: controller.selectedIndex.value == index ? Colors.pink : Colors.grey,
                width: 18.w, // ✅ Reduced size
                height: 18.h,
              ),
              label: controller.labels[index],
            );
          }),
        ),
      )),
    );
  }
}
