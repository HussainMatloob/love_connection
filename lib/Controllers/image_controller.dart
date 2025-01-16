import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageController extends GetxController {

  final RxList<File?> images = List<File?>.filled(3, null).obs;

  final ImagePicker picker = ImagePicker();

  Future<void> pickImage(int index) async {

    var status = await Permission.photos.request();
    if (status.isGranted) {
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        images[index] = File(pickedFile.path);
      }
    } else {
      Get.snackbar('Permission Denied', 'Gallery permission is required to upload images.');
    }
  }

  bool areAllImagesSelected() {
    return images.every((element) => element != null);
  }
}
