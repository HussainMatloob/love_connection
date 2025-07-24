import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FlushMessages {
  static void snackBarMessage(
      String headingText, String message, BuildContext context, Color color) {
    Get.snackbar(
      headingText,
      message,
      colorText: Colors.white,
      backgroundColor: color,
      snackPosition: SnackPosition.TOP,
    );
  }

  static Future<void> commonToast(String msg, Color backGroundColor) {
    return Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: backGroundColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
