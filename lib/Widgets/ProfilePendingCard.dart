import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePendingCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String profession;
  final VoidCallback? onClose;

  const ProfilePendingCard({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.profession,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height * 0.22,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueGrey), // Grey border
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
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    profession,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Close Button
          Positioned(
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
