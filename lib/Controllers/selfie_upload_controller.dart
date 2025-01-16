import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'dart:io';

class SelfieImageController extends GetxController {
  var selfieImage = Rxn<File>();
  final ImagePicker picker = ImagePicker();

  // Function to request permission and capture selfie
  Future<void> captureSelfie() async {
    // Request Camera Permission
    if (await Permission.camera.request().isGranted) {
      // Open front camera to capture selfie
      final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
      );

      if (pickedFile != null) {
        selfieImage.value = File(pickedFile.path);
      } else {
        Get.snackbar(
          "Selfie Capture Cancelled",
          "Please try again to capture your selfie.",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      // Show message if permission is denied
      Get.snackbar(
        "Camera Permission Denied",
        "Please allow camera access from settings.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}