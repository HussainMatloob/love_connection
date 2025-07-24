import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfilepictureController extends GetxController {
  Rx<File?> profileImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImageFromGallery() async {
    try {
      if (Platform.isAndroid) {
        // First, try to request photos permission (works for Android 13+)
        PermissionStatus status = await Permission.photos.request();

        if (!status.isGranted) {
          // Fallback for Android 12 or lower
          status = await Permission.storage.request();
        }

        if (!status.isGranted) {
          Get.snackbar(
            'Permission Denied',
            'Gallery permission is required to upload images.',
            snackPosition: SnackPosition.BOTTOM,
            colorText: Colors.white,
            backgroundColor: Colors.red,
          );
          return;
        }
      } else if (Platform.isIOS) {
        // iOS uses photos permission
        PermissionStatus status = await Permission.photos.request();

        if (!status.isGranted) {
          Get.snackbar(
            'Permission Denied',
            'Photos permission is required to upload images.',
            snackPosition: SnackPosition.BOTTOM,
            colorText: Colors.white,
            backgroundColor: Colors.red,
          );
          return;
        }
      }

      // Pick image from gallery
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        profileImage.value = File(pickedFile.path);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error while picking image: $e',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    }
  }
}
