import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Widgets/BasicinfoBottom.dart';
import '../../Widgets/ProfileExplorWidget.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  PageController _pageController = PageController();
  List<Map<String, String>> profiles = [
    {
      'name': 'Samina',
      'age': '28',
      'details': 'Software Developer from Pakistan',
      'location': 'Islamabad, Pakistan',
      'image': 'assets/images/profile.jpg',
    },
    {
      'name': 'Ali',
      'age': '30',
      'details': 'Graphic Designer from Lahore',
      'location': 'Lahore, Pakistan',
      'image': 'assets/images/PROFILE.png',
    },
    {
      'name': 'Ayesha',
      'age': '26',
      'details': 'Marketing Specialist from Karachi',
      'location': 'Karachi, Pakistan',
      'image': 'assets/images/image2.jpg',
    },

    {
      'name': 'Sara',
      'age': '29',
      'details': 'Fashion Designer from Lahore',
      'location': 'Lahore, Pakistan',
      'image': 'assets/images/image1.jpg',
    },
    {
      'name': 'Sajal Ali',
      'age': '30',
      'details': 'Actress from Karachi',
      'location': 'Karachi, Pakistan',
      'image': 'assets/images/image3.jpg',
    },
    // Add more profiles as needed
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Top header section
            Positioned(
              top: 0,
              child: Container(
                width: Get.width,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.pink.shade100],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Text(
                    'Explore',
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),

            // PageView for swipeable profiles
            Positioned.fill(
              top: 60, // Offset to avoid overlapping with the AppBar
              child: PageView.builder(
                itemCount: profiles.length,
                controller: _pageController,
                scrollDirection: Axis.vertical, // Vertical swipe
                itemBuilder: (context, index) {
                  final profile = profiles[index];
                  return ProfileInfoWidget(
                    name: profile['name']!,
                    age: profile['age']!,
                    details: profile['details']!,
                    location: profile['location']!,
                    image: profile['image']!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
