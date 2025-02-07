import 'package:flutter/material.dart';
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Selfie Image Display
            Obx(() {
              return controller.selfieImage.value == null
                  ? Container(
                      width: double.infinity,
                      height: Get.height * 0.6,
                      decoration: BoxDecoration(
                        color: Colors.pink[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.pinkAccent),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pink.withOpacity(0.2),
                            blurRadius: 8,
                            spreadRadius: 2,
                            offset: Offset(2, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "No Selfie Captured",
                          style: TextStyle(color: Colors.pinkAccent),
                        ),
                      ),
                    )
                  : Container(
                      width: double.infinity,
                      height: Get.height * 0.6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: FileImage(controller.selfieImage.value!),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pink.withOpacity(0.2),
                            blurRadius: 8,
                            spreadRadius: 2,
                            offset: Offset(2, 4),
                          ),
                        ],
                      ),
                    );
            },),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.captureSelfie,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Open Camera",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),

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
