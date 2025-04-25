import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

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
                child: CachedNetworkImage(
                  imageUrl: imageUrl.isEmpty
                      ? 'assets/images/fallback.png'
                      : imageUrl,
                  width: Get.width,
                  height: Get.height,
                  placeholder: (context, url) => Center(
                    child: Lottie.asset(
                      'assets/animations/registerloading.json',
                      width: Get.width * 0.3,
                      height: Get.height * 0.3,
                      fit: BoxFit.contain,
                    ),
                  ),
                  errorWidget: (context, url, error) => Center(
                    child: Image.asset(
                      'assets/images/fallback.png',
                      // Replace with your fallback image path
                      fit: BoxFit.cover,
                      width: Get.width,
                      height: Get.height,
                    ),
                  ),
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: onIgnore,
              child: Container(
                width: 60.w,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.all(Radius.circular(8.r)),
                ),
                child: Center(
                  child: Text(
                    ignoreButtonText,
                    style: GoogleFonts.outfit(
                      color: Colors.pink,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            GestureDetector(
              onTap: onAccept,
              child: Container(
                width: 60.w,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.pinkAccent,
                  borderRadius: BorderRadius.all(Radius.circular(8.r)),
                ),
                child: Center(
                  child: Text(
                    acceptButtonText,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
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
