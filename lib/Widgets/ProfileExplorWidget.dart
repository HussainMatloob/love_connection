import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'BasicinfoBottom.dart';

class ProfileInfoWidget extends StatelessWidget {
  final String name;
  final String age;
  final String details;
  final String location;
  final String image;

  // Constructor to accept profile data
  ProfileInfoWidget({
    required this.name,
    required this.age,
    required this.details,
    required this.location,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image
        Container(
          width: Get.width,
          height: Get.height,
          child: Image.asset(
            image ?? 'assets/images/profile.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 8, // 8% from the top
          right: 5, // 5% from the left
          child: Row(
            spacing: 10,
            children: [
              // Container for the Favorite Icon with text
              Container(
                width: Get.width * 0.2, // 20% of the screen width
                height: Get.height * 0.03, // 3% of the screen height
                decoration: BoxDecoration(
                  color: Colors.white, // Background color is white
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 3), // Shadow position, bottom
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20), // Rounded corners
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
                        size: 16, // Icon color is pink
                      ),
                    ),
                    Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.black, // Text color is black
                      ),
                    ),
                  ],
                ),
              ),
              // Container for the Menu Icon
              Container(
                width: 30, // Adjust the width as needed
                height: 30, // Adjust the height as needed
                decoration: BoxDecoration(
                  color: Colors.white, // Background color
                  shape: BoxShape.circle, // Circular shape
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: Offset(0, 3), // Shadow position
                    ),
                  ],
                ),
                child: Center(
                  // Ensures the icon is centered inside the container
                  child: IconButton(
                    onPressed: () {
                      // Menu button action
                    },
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.black,
                      size: 15, // Icon color
                    ),
                  ),
                ),
              )
            ],
          ),
        ),

        // Close and Check buttons
        Positioned(
          bottom: Get.height * 0.25,
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
                    onPressed: () {
                      // Handle close action
                    },
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
                    onPressed: () {
                      // Handle check action
                    },
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
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$name - $age',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  details,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  location,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 20),
              ],
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
                    width: 50, // Line width of 50
                    height: 2, // Line thickness
                    color: Colors.black, // Line color
                  ),
                  SizedBox(height: 5), // Space between the line and the text
                  // Text below the line
                  Text(
                    'Basic Info',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
      isScrollControlled: true, // Allows the bottom sheet to expand fully
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return BasicInfoBottomSheet(
          personalInfo: {
            'name': 'Sara Sara',
            'maritalStatus': 'Single',
            'sect': 'Sunni',
            'caste': 'Malik',
            'height': '5\'6"',
            'dob': '01 Jan 1999',
            'religion': 'Islam',
            'nationality': 'Pakistani',
          },
          educationInfo: {
            'education': 'Bachelors in Computer Science',
            'monthlyIncome': '\$2000',
            'employmentStatus': 'Employed',
          },
        );
      },
    );
  }
}
