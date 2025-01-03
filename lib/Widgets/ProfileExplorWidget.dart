import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'BasicinfoBottom.dart';

class ProfileInfoWidget extends StatelessWidget {
  final String name;
  final String age;
  final String details;
  final String location;
  final String image;

  // New parameters for bottom sheet data
  final Map<String, String> personalInfo;
  final Map<String, String> educationInfo;

  final VoidCallback onClose;
  final VoidCallback onCheck;


  // Constructor to accept profile data and bottom sheet data
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
    return Stack(
      children: [
        // Background image
        Container(
          width: Get.width,
          height: Get.height,
          child: Image.network(
            image,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 8,
          right: 5,
          child: Row(
            children: [
              // Favorite icon with text
              Container(
                width: Get.width * 0.2,
                height: Get.height * 0.03,
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
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        // Favorite button action
                      },
                      icon: Icon(
                        Icons.favorite,
                        color: Colors.pink,
                        size: 16,
                      ),
                    ),
                    Text(
                      'Save',
                      style: GoogleFonts.outfit(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              // Menu icon
              Container(
                width: 30,
                height: 30,
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
                child: Center(
                  child: IconButton(
                    onPressed: () {
                      // Menu button action
                    },
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.black,
                      size: 15,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),

        // Close and Check buttons
        Positioned(
          bottom: Get.height * 0.2,
          left: Get.width * 0.05,
          right: Get.width * 0.05,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Close Button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: onClose,
                    icon: Icon(
                      Icons.close,
                      color: Colors.pink,
                    ),
                  ),
                ),
                // Check Button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.pink.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: onCheck,
                    icon: Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Bottom Information Panel
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.9),
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.2),
                  Colors.black.withOpacity(0.1),
                  Colors.black.withOpacity(0.05),
                  Colors.black.withOpacity(0.025),
                  Colors.black.withOpacity(0.0125),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$name - $age',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    details,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    location,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),

        // Swipe-Up Gesture Detector
        Positioned(
          bottom: 0,
          right: Get.width * 0.1,
          left: Get.width * 0.1,
          child: GestureDetector(
            onVerticalDragUpdate: (details) {
              if (details.primaryDelta! < -10) {
                // Trigger the bottom sheet to open on swipe up
                showBasicInfoBottomSheet(context);
              }
            },
            child: Container(
              width: Get.width * 0.6,
              height: Get.height * 0.04,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Line above the text
                  Container(
                    width: 50,
                    height: 2,
                    color: Colors.black,
                  ),
                  SizedBox(height: 5),
                  // Text below the line
                  Text(
                    'Basic Info',
                    style: GoogleFonts.outfit(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Method to show bottom sheet
  void showBasicInfoBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return BasicInfoBottomSheet(
          personalInfo: personalInfo,
          educationInfo: educationInfo,
        );
      },
    );
  }
}
