import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'BasicinfoBottom.dart';

class ProfileInfoWidget extends StatelessWidget {
  final String name;
  final String age;
  final String details;
  final String location;
  final String image;

  final Map<String, String> personalInfo;
  final Map<String, String> educationInfo;

  final VoidCallback onClose;
  final VoidCallback onCheck;

  ProfileInfoWidget({
    required this.name,
    required this.age,
    required this.details,
    required this.location,
    required this.image,
    required this.personalInfo,
    required this.educationInfo,
    required this.onClose,
    required this.onCheck,
  });

  @override
  Widget build(BuildContext context) {
    // Get full screen height and width
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // 📌 Background Image (Full-Screen)
          Container(
            width: screenWidth,
            height: screenHeight,
            child: CachedNetworkImage(
              imageUrl: image,
              placeholder: (context, url) => Center(
                child: Lottie.asset(
                  'assets/animations/registerloading.json',
                  width: 150.w,
                  height: 150.h,
                  fit: BoxFit.contain,
                ),
              ),
              fit: BoxFit.cover,
            ),
          ),


          Positioned(
            top: 10.h, // Responsive positioning
            right: 10.w,
            child: Row(
              children: [
                // Save Button Container
                Container(
                  width: 80.w, // Responsive width
                  height: 30.h, // Responsive height
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(0, 3),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20.r), // Responsive border radius
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 8.w), // Responsive padding
                        child: Icon(
                          Icons.favorite,
                          color: Colors.pink,
                          size: 16.sp, // Responsive icon size
                        ),
                      ),
                      SizedBox(width: 5.w), // Responsive spacing
                      Text(
                        'Save',
                        style: GoogleFonts.outfit(
                          color: Colors.black,
                          fontSize: 14.sp, // Responsive font size
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 8.w), // Responsive spacing between items

                // Menu Icon Button
                Container(
                  width: 30.w, // Responsive width
                  height: 30.h, // Responsive height
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {
                      // Menu button action
                    },
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.black,
                      size: 16.sp, // Responsive icon size
                    ),
                    padding: EdgeInsets.zero, // Ensures correct button sizing
                  ),
                ),
              ],
            ),
          ),

          // 📌 Name, Details & Location at the bottom (Full width)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.9),
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$name - $age",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    details,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    location,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),

          // 📌 Like & Dislike Buttons at the bottom
          Positioned(
            bottom: screenHeight * 0.2,
            left: 20.w,
            right: 20.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCircleButton(Icons.close, onClose, color: Colors.white),
                _buildCircleButton(Icons.check, onCheck, color: Colors.pink.shade300),
              ],
            ),
          ),

          // 📌 Swipe-Up Gesture for More Info (Full width)
          Positioned(
            bottom: 0,
            left: screenWidth * 0.1,
            right: screenWidth * 0.1,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.primaryDelta! < -10) {
                  showBasicInfoBottomSheet(context);
                }
              },
              child: _buildSwipeUpIndicator(),
            ),
          ),
        ],
      ),
    );
  }

  // 📌 Method to Show Bottom Sheet
  void showBasicInfoBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return BasicInfoBottomSheet(
          personalInfo: personalInfo,
          educationInfo: educationInfo,
        );
      },
    );
  }

  // 📌 Helper Widget: Favorite & Save Button
  Widget _buildTopButton({required IconData icon, required String label, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.4), blurRadius: 4.r),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(icon, color: Colors.pink, size: 18.sp),
            onPressed: onPressed,
          ),
          Text(
            label,
            style: GoogleFonts.outfit(fontSize: 14.sp, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  // 📌 Helper Widget: Circle Button
  Widget _buildCircleButton(IconData icon, VoidCallback onPressed, {Color color = Colors.white}) {
    return Container(
      width: 50.r,
      height: 50.r,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.4), blurRadius: 4.r),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: icon == Icons.close ? Colors.pink : Colors.white, size: 24.sp),
        onPressed: onPressed,
      ),
    );
  }

  // 📌 Helper Widget: Swipe-Up Indicator
  Widget _buildSwipeUpIndicator() {
    return Container(
      width: 120.w,
      height: 30.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(width: 50.w, height: 3.h, color: Colors.black),
          SizedBox(height: 5.h),
          Text(
            "Basic Info",
            style: GoogleFonts.outfit(fontSize: 16.sp, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
