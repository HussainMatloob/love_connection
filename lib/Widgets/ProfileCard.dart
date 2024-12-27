import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String profession;
  final String ignoreButtonText;
  final String acceptButtonText;
  final VoidCallback? onIgnore;
  final VoidCallback? onAccept;

  const ProfileCard({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.profession,
    required this.ignoreButtonText,
    required this.acceptButtonText,
    this.onIgnore,
    this.onAccept,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: Get.width,
          height: Get.height * 0.22,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.pinkAccent), // Grey border
            boxShadow: [
              BoxShadow(
                color: Colors.grey[200]!,
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Profile Image as the background
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imageUrl,
                  width: Get.width,
                  height: Get.height,
                  fit: BoxFit.cover,
                ),
              ),
              // Profile Details Section
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.only(left: 10, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        profession,
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: onIgnore,
              child: Container(
                width: Get.width * 0.18,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Center(
                  child: Text(
                    ignoreButtonText,
                    style: GoogleFonts.outfit(color: Colors.pink),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: onAccept,
              child: Container(
                width: Get.width * 0.18,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.pinkAccent,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Center(
                  child: Text(
                    acceptButtonText,
                    style: GoogleFonts.outfit(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
