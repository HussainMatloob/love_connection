import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:love_connection/Controllers/AuthController.dart';
import 'package:love_connection/Controllers/BasicInfoController.dart';
import 'package:love_connection/Controllers/ProfilePictureController.dart';
import 'package:love_connection/Widgets/PinkButton.dart';
import 'bottom_nav/BottomNavbar.dart';

class Profilepicture extends StatefulWidget {
  @override
  _ProfilepictureState createState() => _ProfilepictureState();
}

class _ProfilepictureState extends State<Profilepicture> {
  final ProfilepictureController controller =
      Get.put(ProfilepictureController()); // Initialize the controller
  final AuthController authController =
      Get.put(AuthController()); // Find the BasicInfoController

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
              padding: EdgeInsets.only(
                left: Get.width * 0.06,
                top: Get.width * 0.05,
                bottom: Get.width * 0.05,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Mandatory*',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Obx(
              () => GestureDetector(
                onTap: () {
                  print("Container tapped");
                  controller.pickImageFromGallery();
                }, // Request permission
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
                              Icon(
                                Icons.camera_alt_outlined,
                                size: 40,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Upload Image',
                                style: GoogleFonts.outfit(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              controller.profileImage.value!,
                              fit: BoxFit.cover,
                              width: Get.width * 0.8,
                              height: Get.height * 0.2,
                            ),
                          ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(Get.width * 0.10),
              child: Obx(
                () => authController.isLoading.value
                    ? CircularProgressIndicator()
                    : PinkButton(
                        text: "Continue",
                        onTap: () async {
                          await authController.registerUser();
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
