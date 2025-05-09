import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:love_connection/Screens/image_view_screen.dart';
import 'package:love_connection/Widgets/custom_text.dart';
import 'package:love_connection/Widgets/Requested_connection_detail_widget.dart';
import 'package:love_connection/constants/api_url_constants.dart';
import 'package:love_connection/utils/date_time_util.dart';

class RequestedConnectionDetailScreen extends StatefulWidget {
  final String imageUrl;
  final pendingRequestData;
  RequestedConnectionDetailScreen(
      {super.key, this.pendingRequestData, required this.imageUrl});

  @override
  State<RequestedConnectionDetailScreen> createState() =>
      _RequestedConnectionDetailScreenState();
}

class _RequestedConnectionDetailScreenState
    extends State<RequestedConnectionDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.red,
        centerTitle: true,
        title: CustomText(
          "Profile Details",
          color: Colors.white,
          fw: FontWeight.w400,
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20.r),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(() => ImageViewScreen(
                            image:
                                '${ApiUrlConstants.baseUrl}${widget.imageUrl}',
                          ));
                    },
                    child: Container(
                      width: 100.w, // must be equal
                      height: 100.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: CachedNetworkImage(
                        imageUrl: widget.imageUrl.isNotEmpty &&
                                widget.imageUrl.contains('.')
                            ? '${ApiUrlConstants.baseUrl}${widget.imageUrl}'
                            : '',
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: Lottie.asset(
                            'assets/animations/registerloading.json',
                            width: 50.w,
                            height: 50.w,
                            fit: BoxFit.contain,
                          ),
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/images/logo2.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  CustomText(
                    "Name: ",
                    color: Colors.black,
                    fw: FontWeight.w700,
                  ),
                  CustomText(
                    "${widget.pendingRequestData['firstname']} ${widget.pendingRequestData['lastname']}",
                    color: Colors.black,
                    fw: FontWeight.w400,
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  CustomText(
                    "Marital Status: ",
                    color: Colors.black,
                    fw: FontWeight.w700,
                  ),
                  CustomText(
                    "${widget.pendingRequestData['maritalstatus']}",
                    color: Colors.black,
                    fw: FontWeight.w400,
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  CustomText(
                    "Height: ",
                    color: Colors.black,
                    fw: FontWeight.w700,
                  ),
                  CustomText(
                    "${widget.pendingRequestData['height']}",
                    color: Colors.black,
                    fw: FontWeight.w400,
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  CustomText(
                    "Date of birth: ",
                    color: Colors.black,
                    fw: FontWeight.w700,
                  ),
                  CustomText(
                    DateTimeUtil.getDate(
                        widget.pendingRequestData['dateofbirth']),
                    color: Colors.black,
                    fw: FontWeight.w400,
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  CustomText(
                    "Age: ",
                    color: Colors.black,
                    fw: FontWeight.w700,
                  ),
                  CustomText(
                    "${DateTimeUtil.calculateAge(widget.pendingRequestData['dateofbirth'])}",
                    color: Colors.black,
                    fw: FontWeight.w400,
                  ),
                ],
              ),
              Column(
                children: [],
              ),
              SizedBox(height: 20.h),
              RequestedConnectionDetailWidget(
                paddingHorizontal: 30.w,
                height: 40.h,
                borderRadius: 10.r,
                borderColor: Colors.grey,
                headText: "Sect",
                text: "${widget.pendingRequestData['sect']}",
                headText1: "Looking For",
                text1: "${widget.pendingRequestData['sectlookingfor']}",
                headTextFw: FontWeight.w700,
                headTextSize: 18.sp,
                textColor: Colors.black,
                textFw: FontWeight.w400,
                textSize: 14,
              ),
              SizedBox(height: 10.h),
              RequestedConnectionDetailWidget(
                paddingHorizontal: 30.w,
                height: 40.h,
                borderRadius: 10.r,
                borderColor: Colors.grey,
                headText: "Caste",
                text: "${widget.pendingRequestData['cast']}",
                headText1: "Looking For",
                text1: "${widget.pendingRequestData['castlookingfor']}",
                headTextFw: FontWeight.w700,
                headTextSize: 18.sp,
                textColor: Colors.black,
                textFw: FontWeight.w400,
                textSize: 14,
              ),
              SizedBox(height: 10.h),
              RequestedConnectionDetailWidget(
                paddingHorizontal: 30.w,
                height: 40.h,
                borderRadius: 10.r,
                borderColor: Colors.grey,
                headText: "Religion",
                text: "${widget.pendingRequestData['religion']}",
                headText1: "Looking For",
                text1: "${widget.pendingRequestData['religionlookingfor']}",
                headTextFw: FontWeight.w700,
                headTextSize: 18.sp,
                textColor: Colors.black,
                textFw: FontWeight.w400,
                textSize: 14,
              ),
              SizedBox(height: 10.h),
              RequestedConnectionDetailWidget(
                paddingHorizontal: 30.w,
                height: 40.h,
                borderRadius: 10.r,
                borderColor: Colors.grey,
                headText: "Nationality",
                text: "${widget.pendingRequestData['country']}",
                headText1: "Looking For",
                text1: "${widget.pendingRequestData['countrylookingfor']}",
                headTextFw: FontWeight.w700,
                headTextSize: 18.sp,
                textColor: Colors.black,
                textFw: FontWeight.w400,
                textSize: 14,
              ),
              SizedBox(height: 10.h),
              RequestedConnectionDetailWidget(
                paddingHorizontal: 30.w,
                height: 40.h,
                borderRadius: 10.r,
                borderColor: Colors.grey,
                headText: "Education",
                text: "${widget.pendingRequestData['education']}",
                headText1: "Looking For",
                text1: "${widget.pendingRequestData['educationlookingfor']}",
                headTextFw: FontWeight.w700,
                headTextSize: 18.sp,
                textColor: Colors.black,
                textFw: FontWeight.w400,
                textSize: 14,
              ),
              SizedBox(height: 10.h),
              RequestedConnectionDetailWidget(
                paddingHorizontal: 30.w,
                height: 40.h,
                borderRadius: 10.r,
                borderColor: Colors.grey,
                headText: "Employment Status",
                text: "${widget.pendingRequestData['employmentstatus']}",
                headTextFw: FontWeight.w700,
                headTextSize: 18.sp,
                textColor: Colors.black,
                textFw: FontWeight.w400,
                textSize: 14,
              ),
              SizedBox(height: 10.h),
              RequestedConnectionDetailWidget(
                paddingHorizontal: 30.w,
                height: 40.h,
                borderRadius: 10.r,
                borderColor: Colors.grey,
                headText: "Monthly Income",
                text: "${widget.pendingRequestData['monthlyincome']}",
                headTextFw: FontWeight.w700,
                headTextSize: 18.sp,
                textColor: Colors.black,
                textFw: FontWeight.w400,
                textSize: 14,
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
