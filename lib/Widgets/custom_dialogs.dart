import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:love_connection/Widgets/custom_button.dart';
import 'package:love_connection/Widgets/custom_text.dart';

class CustomDialogs {
  static void showQuitDialog(
    BuildContext context, {
    double? height,
    double? width,
    double? radius,
    String? headText,
    String? messageText,
    String? quitText,
    String? cancelText,
    VoidCallback? onTap,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  radius ?? 0.r)), // <- Proper corner radius
          child: Container(
              padding: EdgeInsets.all(5.r),
              height: height,
              width: width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radius ?? 0.r)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        size: 50, color: Colors.redAccent),
                    SizedBox(height: 20.h),
                    CustomText(
                      headText,
                      size: 16.sp,
                      fw: FontWeight.w700,
                      color: Colors.black,
                    ),
                    SizedBox(height: 10.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.r),
                      child: CustomText(
                        messageText,
                        size: 10.sp,
                        fw: FontWeight.w600,
                        textAlign: TextAlign.center,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomButton(
                            bordercircular: 10.r,
                            boxColor: Colors.redAccent,
                            text: quitText,
                            textColor: Colors.white,
                            fontSize: 12.sp,
                            fw: FontWeight.w600,
                            height: 30.h,
                            width: 80.h,
                            horizontalPadding: 5.w,
                            borderColor: Colors.transparent,
                            onTap: onTap),
                        CustomButton(
                          bordercircular: 10.r,
                          text: cancelText,
                          textColor: Colors.black,
                          fontSize: 12.sp,
                          fw: FontWeight.w600,
                          height: 30.h,
                          width: 80.h,
                          horizontalPadding: 5.w,
                          borderColor: Colors.black,
                          onTap: () {
                            Navigator.of(context).pop(); // Just close dialog
                          },
                        ),
                      ],
                    )
                  ])),
        );
      },
    );
  }
}
