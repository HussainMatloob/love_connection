import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
}
