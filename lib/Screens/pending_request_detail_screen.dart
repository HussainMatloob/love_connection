import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:love_connection/Widgets/custom_text.dart';

class PendingRequestDetailScreen extends StatefulWidget {
  final String imageUrl;
  final pendingRequestData;
  PendingRequestDetailScreen(
      {super.key, this.pendingRequestData, required this.imageUrl});

  @override
  State<PendingRequestDetailScreen> createState() =>
      _PendingRequestDetailScreenState();
}

class _PendingRequestDetailScreenState
    extends State<PendingRequestDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CustomText(
          "${widget.pendingRequestData['firstname']} ${widget.pendingRequestData['lastname']}",
          color: Colors.black,
          fw: FontWeight.w400,
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10.r),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: widget.imageUrl.isNotEmpty
                        ? widget.imageUrl
                        : 'assets/images/logo2.png',
                    width: 100.h,
                    height: 100.w,
                    placeholder: (context, url) => Center(
                      child: Lottie.asset(
                        'assets/animations/registerloading.json',
                        width: Get.width * 0.3,
                        height: Get.height * 0.3,
                        fit: BoxFit.contain,
                      ),
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/images/logo2.png',
                      fit: BoxFit.cover,
                      width: Get.width,
                      height: Get.height,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            CustomText(
              "Name",
              color: Colors.black,
              fw: FontWeight.w400,
            ),
            SizedBox(height: 10.h),
            CustomText(
              "Marital Status",
              color: Colors.black,
              fw: FontWeight.w400,
            ),
            SizedBox(height: 10.h),
            CustomText(
              "Sect",
              color: Colors.black,
              fw: FontWeight.w400,
            ),
            SizedBox(height: 10.h),
            CustomText(
              "Caste",
              color: Colors.black,
              fw: FontWeight.w400,
            ),
            SizedBox(height: 10.h),
            CustomText(
              "Height",
              color: Colors.black,
              fw: FontWeight.w400,
            ),
            SizedBox(height: 10.h),
            CustomText(
              "Date Of Birth",
              color: Colors.black,
              fw: FontWeight.w400,
            ),
            SizedBox(height: 10.h),
            CustomText(
              "Religion",
              color: Colors.black,
              fw: FontWeight.w400,
            ),
            SizedBox(height: 10.h),
            CustomText(
              "nationality",
              color: Colors.black,
              fw: FontWeight.w400,
            ),
            SizedBox(height: 10.h),
            CustomText(
              "Education",
              color: Colors.black,
              fw: FontWeight.w400,
            ),
            SizedBox(height: 10.h),
            CustomText(
              "Employment Status",
              color: Colors.black,
              fw: FontWeight.w400,
            ),
            SizedBox(height: 10.h),
            CustomText(
              "Monthly Income",
              color: Colors.black,
              fw: FontWeight.w400,
            ),
            SizedBox(height: 10.h),
            CustomText(
              "Employment Status",
              color: Colors.black,
              fw: FontWeight.w400,
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}
