import 'dart:io';
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
    var status = await Permission.storage.request();
    if (status.isGranted) {
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        images[index] = File(pickedFile.path);
      }
    } else {
      Get.snackbar('Permission Denied',
          'Gallery permission is required to upload images.');
    }
  }

  bool areAllImagesSelected() {
    return images.every((element) => element != null);
  }
}
