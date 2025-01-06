import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class ProfilePendingCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String profession;
  final VoidCallback? onClose;

  const ProfilePendingCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.profession,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              width:Get.width ,
              height: Get.height,
              placeholder: (context, url) => Center(
                child: Lottie.asset(
                  'assets/animations/registerloading.json',
                  // Path to your Lottie file
                  width: Get.width * 0.3,
                  height: Get.height * 0.3,
                  fit: BoxFit.contain,
                ),
              ),
              fit: BoxFit.cover,
            ),
          ),
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
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ),
          // Close Button
          Positioned(
            // Position the close button at the top rightL
            top: 8,
            left: 8,
            child: GestureDetector(
              onTap: onClose,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.pink,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
          // Profile Details Section
        ],
      ),
    );
  }
}
