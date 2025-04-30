import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String? text;
  final FontWeight? fw;
  final Color? color;
  final double? size;
  final TextAlign? textAlign;
  final TextOverflow? textOverflow;
  final FontStyle? fontStyle;
  final String? fontFamily;
  final int? maxLines;
  final TextStyle? textStyle;
  final TextDecoration? textDecoration;
  CustomText(this.text,
      {super.key,
      this.fw,
      this.color,
      this.size,
      this.textAlign,
      this.textOverflow,
      this.fontStyle,
      this.fontFamily,
      this.maxLines,
      this.textStyle,
      this.textDecoration});

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? "",
      maxLines: maxLines,
      overflow: textOverflow,
      textAlign: textAlign,
      style: textStyle ??
          GoogleFonts.lato(
            fontSize: size,
            fontWeight: fw,
            color: color ?? Colors.black,
            decoration:
                textDecoration ?? TextDecoration.none, // Apply underline
            decorationColor: Colors.black, // Set underline color
            decorationThickness: 1.0, // Optional: Adjust thickness
          ),
    );
  }
}
