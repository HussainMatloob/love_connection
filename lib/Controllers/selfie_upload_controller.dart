import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'dart:io';

class SelfieImageController extends GetxController {
  var selfieImage = Rxn<File?>();
  final ImagePicker picker = ImagePicker();

  void clearSelfieImage() {
    selfieImage.value = null;
  }

  Future<void> captureSelfie() async {
    // Request camera permission
    final status = await Permission.camera.request();

    if (status.isGranted) {
      // Pick image from front camera
      final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
      );

      if (pickedFile != null) {
        selfieImage.value = File(pickedFile.path);
      }
    } else if (status.isPermanentlyDenied) {
      Get.snackbar(
        "Camera Permission Permanently Denied",
        "Please allow camera access from app settings.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        mainButton: TextButton(
          onPressed: () => openAppSettings(),
          child: const Text("Open Settings",
              style: TextStyle(color: Colors.white)),
        ),
      );
    } else {
      Get.snackbar(
        "Camera Permission Denied",
        "Camera access is required to take a selfie.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
