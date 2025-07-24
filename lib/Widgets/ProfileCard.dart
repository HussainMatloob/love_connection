import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:love_connection/Widgets/custom_button.dart';

class ProfileCard extends StatelessWidget {
  final completeRequestData;
  VoidCallback? onTap;
  final String imageUrl;
  final String name;
  final String profession;
  String? ignoreButtonText;
  String? acceptButtonText;
  final VoidCallback? onIgnore;
  final VoidCallback? onAccept;
  final bool isRequestScreen;
  final VoidCallback? unfollowTab;
  bool? isChatModule = false;

  ProfileCard({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.profession,
    this.ignoreButtonText,
    this.acceptButtonText,
    this.onIgnore,
    this.onAccept,
    this.onTap,
    this.completeRequestData,
    this.isRequestScreen = false,
    this.unfollowTab,
    this.isChatModule,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: Get.width,
            height: Get.height * 0.22,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: isRequestScreen
                  ? BorderRadius.circular(12.r)
                  : BorderRadius.only(
                      topLeft: Radius.circular(12.r),
                      topRight: Radius.circular(12.r)),
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
                  borderRadius: isRequestScreen
                      ? BorderRadius.circular(12.r)
                      : BorderRadius.only(
                          topLeft: Radius.circular(12.r),
                          topRight: Radius.circular(12.r)),
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
                isChatModule == true
                    ? Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          height: 36.h,
                          width: 36.h,
                          decoration: BoxDecoration(
                              color: Colors.pink,
                              borderRadius: BorderRadius.circular(100.r)),
                          child: Center(
                            child: IconButton(
                                onPressed: onAccept,
                                icon: Icon(
                                  Icons.chat_bubble_outline,
                                  color: Colors.white,
                                  size: 18.sp,
                                )),
                          ),
                        ))
                    : SizedBox(),
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
        ),
        isRequestScreen
            ? SizedBox()
            : CustomButton(
                onTap: unfollowTab,
                circularBottomLeft: 12.r,
                circulatBottomRight: 12.r,
                iscustomCircular: true,
                width: Get.width,
                height: 40,
                bordercircular: 0.r,
                borderColor: Colors.transparent,
                text: "Unfollow",
                textColor: Colors.white,
                boxColor: Colors.pink,
              ),
        SizedBox(height: 12),
        onIgnore == null
            ? SizedBox()
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: onIgnore,
                    child: Container(
                      width: 60.w,
                      height: 40.h,
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Center(
                        child: Text(
                          ignoreButtonText ?? "",
                          style: GoogleFonts.outfit(
                            color: Colors.pink,
                            fontSize: 12.sp,
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
                      height: 40.h,
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      decoration: BoxDecoration(
                        color: Colors.pinkAccent,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Center(
                        child: Text(
                          acceptButtonText ?? "",
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 12.sp,
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
