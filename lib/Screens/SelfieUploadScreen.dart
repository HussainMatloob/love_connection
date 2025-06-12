import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:love_connection/Widgets/PinkButton.dart';
import '../Controllers/AuthController.dart';
import '../Controllers/selfie_upload_controller.dart';
import 'Service_selection_screen.dart';

class SelfieImageScreen extends StatelessWidget {
  final SelfieImageController controller = Get.put(SelfieImageController());
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Selfie Upload", style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Selfie Image Display
            Obx(() {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Selfie Display or Placeholder
                  Container(
                    width: double.infinity,
                    height: Get.height * 0.7,
                    decoration: BoxDecoration(
                      color: controller.selfieImage.value == null
                          ? Colors.pink[50]
                          : null,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.pinkAccent),
                      image: controller.selfieImage.value != null
                          ? DecorationImage(
                              image: FileImage(controller.selfieImage.value!),
                              fit: BoxFit.cover,
                            )
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pink.withOpacity(0.2),
                          blurRadius: 8,
                          spreadRadius: 2,
                          offset: Offset(2, 4),
                        ),
                      ],
                    ),
                    child: controller.selfieImage.value == null
                        ? Center(
                            child: Text(
                              "No Selfie Captured",
                              style: TextStyle(color: Colors.pinkAccent),
                            ),
                          )
                        : null,
                  ),

                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: GestureDetector(
                      onTap: () {
                        controller
                            .captureSelfie(); // Call your camera function here
                      },
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.pinkAccent,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),

            SizedBox(height: 20),
            Obx(
              () => authController.isLoading.value
                  ? CircularProgressIndicator()
                  : PinkButton(
                      text: "Continue",
                      onTap: () async {
                        await authController.registerUser();
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
