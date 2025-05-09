import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:love_connection/Widgets/custom_text.dart';

class CutomEmptyScreenMessage extends StatelessWidget {
  final String? headText;
  final String? subtext;
  final Icon icon;
  const CutomEmptyScreenMessage(
      {super.key, this.headText, this.subtext, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon,
          SizedBox(height: 10.h),
          CustomText(
            headText,
            fw: FontWeight.bold,
            size: 18.sp,
            color: Colors.grey,
          ),
          SizedBox(height: 5),
          CustomText(
            subtext,
            size: 14.sp,
            color: Colors.grey,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
