import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Controllers/AuthController.dart';
import '../Controllers/ProfilePictureController.dart';
import '../Controllers/image_controller.dart';
import '../Widgets/PinkButton.dart';
import 'DocumentUpload.dart';

class Profilepicture extends StatefulWidget {
  @override
  _ProfilepictureState createState() => _ProfilepictureState();
}

class _ProfilepictureState extends State<Profilepicture> {
  final ProfilepictureController controller = Get.put(ProfilepictureController());
  final AuthController authController = Get.put(AuthController());
  final ImageController imageController = Get.put(ImageController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Profile Picture',
            style: GoogleFonts.outfit(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.w400,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: Get.width * 0.05, horizontal: Get.width * 0.06),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Mandatory*',
                  style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
                ),
              ),
            ),
            Obx(
                  () => GestureDetector(
                onTap: () => controller.pickImageFromGallery(),
                child: DottedBorder(
                  color: Colors.pink.shade300,
                  borderType: BorderType.RRect,
                  radius: Radius.circular(8),
                  dashPattern: [6, 4],
                  strokeWidth: 2,
                  child: Container(
                    width: Get.width * 0.8,
                    height: Get.height * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: controller.profileImage.value == null
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt_outlined, size: 40, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('Upload Image', style: GoogleFonts.outfit(color: Colors.grey, fontSize: 16)),
                      ],
                    )
                        : ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        controller.profileImage.value!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Upload your images*',
              style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(3, (index) {
                return GestureDetector(
                  onTap: () => imageController.pickImage(index),
                  child: Obx(() {
                    return DottedBorder(
                      color: Colors.pink.shade300,
                      borderType: BorderType.RRect,
                      radius: Radius.circular(8),
                      dashPattern: [6, 4],
                      strokeWidth: 2,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 3,
                              offset: Offset(0, 2),
                            ),
                          ],
                          image: imageController.images[index] != null
                              ? DecorationImage(
                            image: FileImage(imageController.images[index]!),
                            fit: BoxFit.cover,
                          )
                              : null,
                        ),
                        child: imageController.images[index] == null
                            ? Icon(Icons.add, color: Colors.black54, size: 40)
                            : null,
                      ),
                    );
                  }),
                );
              }),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.all(Get.width * 0.10),
              child: PinkButton(
                text: "Continue",
                onTap: () {
                  if (imageController.areAllImagesSelected() && controller.profileImage.value != null) {
                    Get.to(DocumentUploadScreen());
                  } else {
                    Get.snackbar('Incomplete', 'Please select all images.', snackPosition: SnackPosition.BOTTOM);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
