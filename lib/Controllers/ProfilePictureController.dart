import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfilepictureController extends GetxController {
  Rx<File?> profileImage = Rx<File?>(null); // Reactive state for the selected image
  final ImagePicker _picker = ImagePicker(); // Image picker instance

  // Function to directly pick an image from the gallery
  Future<void> pickImageFromGallery() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        profileImage.value = File(pickedFile.path); // Update the selected image
      } else {
        Get.snackbar(
          'No Image Selected',
          'Please select an image from the gallery.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred while picking the image: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
