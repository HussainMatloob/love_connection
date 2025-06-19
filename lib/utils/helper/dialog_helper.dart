import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:love_connection/Widgets/custom_text.dart';

class DialogHelper {
  static void showLoading({String message = "Processing..."}) {
    Get.dialog(
      Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0.r)),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16.h),
              CustomText(
                message,
                size: 16.sp,
              )
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static void hideDialog() {
    if (Get.isDialogOpen!) Get.back();
  }

  static void showSuccessDialog(String message) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 40.sp),
              SizedBox(height: 10.h),
              CustomText(
                "Success",
                fw: FontWeight.w800,
                size: 18.sp,
              ),
              SizedBox(height: 5.h),
              CustomText(
                message,
                textAlign: TextAlign.center,
                size: 12.sp,
                fw: FontWeight.w700,
              ),
              SizedBox(height: 10.h),
              ElevatedButton(
                onPressed: () => Get.back(),
                child: CustomText(
                  "OK",
                  fw: FontWeight.w700,
                  size: 14.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void showErrorDialog(String message, {String? headText}) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error, color: Colors.red, size: 40.sp),
              SizedBox(height: 10),
              CustomText(
                headText ?? "Error",
                fw: FontWeight.w800,
                size: 18.sp,
              ),
              SizedBox(height: 5.h),
              CustomText(
                message,
                textAlign: TextAlign.center,
                size: 12.sp,
                fw: FontWeight.w700,
              ),
              SizedBox(height: 10.h),
              ElevatedButton(
                onPressed: () => Get.back(),
                child: CustomText(
                  "OK",
                  fw: FontWeight.w700,
                  size: 14.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void showInfoDialog(String message) {
    Get.dialog(
      Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.info, color: Colors.blue, size: 50.sp),
              SizedBox(height: 10.h),
              CustomText(
                "Info",
                fw: FontWeight.bold,
                size: 18.sp,
              ),
              SizedBox(height: 5.h),
              CustomText(message, textAlign: TextAlign.center),
              SizedBox(height: 10.h),
              ElevatedButton(
                onPressed: () => Get.back(),
                child: CustomText(
                  "OK",
                  fw: FontWeight.w400,
                  size: 14.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
