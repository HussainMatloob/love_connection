import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class DocumentUploadController extends GetxController {
  // final ImagePicker picker = ImagePicker();
  // Rx<File?> idCardFrontImage = Rx<File?>(null);
  // Rx<File?> idCardBackImage = Rx<File?>(null);
  // Rx<File?> passportFrontImage = Rx<File?>(null);
  // Rx<File?> passportBackImage = Rx<File?>(null);

  // // Function to pick an image
  // Future<void> pickImage({required bool isIdCard, required bool isFront}) async {
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  //   if (pickedFile != null) {
  //     if (pickedFile.path.endsWith(".jpg") || pickedFile.path.endsWith(".jpeg") || pickedFile.path.endsWith(".png")) {
  //       if (isIdCard) {
  //         isFront ? idCardFrontImage.value = File(pickedFile.path) : idCardBackImage.value = File(pickedFile.path) ;
  //       } else {
  //         isFront ? passportFrontImage.value =File(pickedFile.path) : passportBackImage.value = File(pickedFile.path);
  //       }
  //     } else {
  //       Get.snackbar("Invalid File", "Please upload a valid image file (JPG or PNG).",
  //           snackPosition: SnackPosition.BOTTOM);
  //     }
  //   }
  // }

  final ImagePicker picker = ImagePicker();
  Rx<File?> idCardFrontImage = Rx<File?>(null);
  Rx<File?> idCardBackImage = Rx<File?>(null);
  Rx<File?> passportFrontImage = Rx<File?>(null);
  Rx<File?> passportBackImage = Rx<File?>(null);

  // Function to pick an image
  Future<void> pickImage({
    required bool isIdCard,
    required bool isFront,
  }) async {
    // Runtime permission check
    if (Platform.isAndroid) {
      PermissionStatus status = await Permission.photos.request();

      // If not granted, fallback to storage (Android 12 and below)
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }

      if (!status.isGranted) {
        Get.snackbar(
          "Permission Denied",
          "Storage permission is required to pick image.",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
        return;
      }
    }

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final path = pickedFile.path.toLowerCase();
      if (path.endsWith(".jpg") ||
          path.endsWith(".jpeg") ||
          path.endsWith(".png")) {
        final selectedFile = File(pickedFile.path);

        if (isIdCard) {
          isFront
              ? idCardFrontImage.value = selectedFile
              : idCardBackImage.value = selectedFile;
        } else {
          isFront
              ? passportFrontImage.value = selectedFile
              : passportBackImage.value = selectedFile;
        }
      } else {
        Get.snackbar(
          "Invalid File",
          "Please upload a valid image file (JPG or PNG).",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      }
    }
  }
}
