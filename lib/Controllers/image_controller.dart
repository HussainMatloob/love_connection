import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageController extends GetxController {
  final RxList<File?> images = List<File?>.filled(3, null).obs;
  final ImagePicker picker = ImagePicker();

  Future<void> pickImage(int index) async {
    try {
      if (Platform.isAndroid) {
        // Try photos permission (Android 13+)
        final photoStatus = await Permission.photos.request();
        if (!photoStatus.isGranted) {
          // Fallback to storage permission (Android 12 or lower)
          final storageStatus = await Permission.storage.request();
          if (!storageStatus.isGranted) {
            Get.snackbar(
              'Permission Denied',
              'Gallery permission is required to upload images.',
              snackPosition: SnackPosition.BOTTOM,
              colorText: Colors.white,
              backgroundColor: Colors.red,
            );
            return;
          }
        }
      }

      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        images[index] = File(pickedFile.path);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred.',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    }
  }

  bool areAllImagesSelected() {
    return images.every((element) => element != null);
  }
}
