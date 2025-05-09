import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:love_connection/Widgets/custom_text.dart';

class RequestedConnectionDetailWidget extends StatelessWidget {
  double? height;
  double? width;
  double? borderRadius;
  Color? borderColor;
  String? headText;
  String? headText1;
  double? headTextSize;
  FontWeight? headTextFw;
  String? text;
  String? text1;
  double? textSize;
  FontWeight? textFw;
  Color? textColor;
  double? paddingHorizontal;
  RequestedConnectionDetailWidget(
      {super.key,
      this.height,
      this.width,
      this.borderRadius,
      this.borderColor,
      this.headText,
      this.headText1,
      this.headTextSize,
      this.headTextFw,
      this.text,
      this.text1,
      this.textSize,
      this.textFw,
      this.textColor,
      this.paddingHorizontal});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                headText,
                color: textColor,
                fw: headTextFw,
                size: headTextSize,
              ),
              SizedBox(
                height: 5.h,
              ),
              CustomText(
                text,
                color: textColor,
                fw: textFw,
                size: textSize,
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                headText1,
                color: textColor,
                fw: headTextFw,
                size: headTextSize,
              ),
              SizedBox(
                height: 5.h,
              ),
              CustomText(
                text1,
                color: textColor,
                fw: textFw,
                size: textSize,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
