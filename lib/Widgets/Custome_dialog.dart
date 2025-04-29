import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void showBeautifulRatingDialog(
    BuildContext context, String categoryName, double rating) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8), // Blur effect
      child: Dialog(
        backgroundColor: Colors.white.withOpacity(0.9), // Slightly transparent
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Total Rating",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.h),
              Text(
                "Your $categoryName rating is:",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              SizedBox(height: 8.h),
              // Beautiful Gradient Rating Display
              Text(
                "${rating.toStringAsFixed(2)}%",
                style: TextStyle(
                  fontSize: 40.sp,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..shader = LinearGradient(
                      colors: [Colors.pinkAccent, Colors.deepPurple],
                    ).createShader(Rect.fromLTWH(0, 0, 200, 50)),
                ),
              ),
              SizedBox(height: 16.h),
              // Full-Width Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                  child: Text("OK",
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
