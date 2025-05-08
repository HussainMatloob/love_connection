import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:love_connection/constants/api_url_constants.dart';

class ProfilePendingCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String profession;
  final VoidCallback? onClose;
  final VoidCallback? onTap;

  const ProfilePendingCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.profession,
    this.onClose,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: imageUrl.isNotEmpty && imageUrl.contains('.')
                      ? '${ApiUrlConstants.baseUrl}$imageUrl'
                      : '',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                    child: Lottie.asset(
                      'assets/animations/registerloading.json',
                      fit: BoxFit.cover,
                    ),
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/images/logo2.png',
                    fit: BoxFit.cover,
                  ),
                ),
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
      ),
    );
  }
}
