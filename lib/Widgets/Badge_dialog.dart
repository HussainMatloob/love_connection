import 'dart:ui'; // ✅ Required for blur
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

Widget buildBadgeDialog(BuildContext context, dynamic controller) {
  return Obx(() {
    if (!controller.badgeChecked.value) return SizedBox.shrink();

    return Stack(
      children: [
        // 🔥 Smooth Blur Background
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              color: Colors.transparent.withOpacity(0.5),
            ),
          ),
        ),

        // 🎖️ Badge Display
        Center(
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            child: controller.badgePoints.value == -1
                ? buildIncompleteBadge(controller)
                : buildAchievedBadge(controller),
          ),
        ),

        // 🎉 Confetti Animation for a Premium Feel
        if (controller.badgePoints.value != -1)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Lottie.asset(
              "assets/animations/confetti.json",
              height: double.infinity,
              repeat: false,
            ),
          ),
      ],
    );
  });
}

// 🎯 If Goals Are Not Met - Show This
Widget buildIncompleteBadge(dynamic controller) {
  return ElasticIn(
    key: ValueKey("incomplete"),
    duration: Duration(milliseconds: 800),
    child: Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black.withOpacity(0.3), // 🔥 Glass Effect
        boxShadow: [
          BoxShadow(
            color: Colors.pinkAccent.withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🚀 Warning Icon
          Icon(Icons.warning_rounded, size: 50, color: Colors.amberAccent),

          SizedBox(height: 12),

          // 📜 Title
          Text(
            "Oops! Task Incomplete",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              shadows: [
                Shadow(
                    blurRadius: 5, color: Colors.black45, offset: Offset(1, 1))
              ],
            ),
          ),
          SizedBox(height: 8),

          // 🔍 Description
          Text(
            "Complete all assessments before unlocking this badge.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.sp, color: Colors.white70),
          ),
          SizedBox(height: 16),

          // 🔄 "Check Again" Button
          Obx(() => ElevatedButton.icon(
                onPressed: controller.recheckProgress,
                icon: Icon(Icons.sync, color: Colors.white),
                label:
                    Text("Check Again", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r)),
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.w, vertical: 14.h),
                  elevation: 6,
                ),
              )),
        ],
      ),
    ),
  );
}

// 🏆 If Badge is Achieved - Show This
Widget buildAchievedBadge(dynamic controller) {
  return FadeInUp(
    key: ValueKey("badge"),
    duration: Duration(milliseconds: 700),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 🏅 Shiny Badge Design
        Obx(() => Container(
              width: 160.w,
              height: 160.h,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFFFB3879), Color(0xFFFB9918)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pinkAccent.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  controller.badgeImageUrl.value.isNotEmpty
                      ? controller.badgeImageUrl.value
                      : 'assets/images/badge.png',
                  fit: BoxFit.contain,
                ),
              ),
            )),
        SizedBox(height: 16),

        // 🎖️ Badge Title
        Obx(() => AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 500),
              style: TextStyle(
                fontSize: 26.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Text(
                controller.badgeTitle.value.isNotEmpty
                    ? controller.badgeTitle.value
                    : "Congratulations! 🎉",
                textAlign: TextAlign.center,
              ),
            )),
        SizedBox(height: 8),

        // 📜 Badge Description
        Obx(() => AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 500),
              style: TextStyle(
                fontSize: 18.sp,
                fontStyle: FontStyle.italic,
                color: Colors.white70,
              ),
              child: Text(
                controller.badgeDescription.value.isNotEmpty
                    ? controller.badgeDescription.value
                    : "You have unlocked a new badge!",
                textAlign: TextAlign.center,
              ),
            )),
        SizedBox(height: 20.h),
      ],
    ),
  );
}
