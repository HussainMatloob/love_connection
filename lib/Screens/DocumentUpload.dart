import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:love_connection/Screens/SelfieUploadScreen.dart';
import 'package:love_connection/Widgets/PinkButton.dart';
import '../Controllers/document_upload_controller.dart';

class DocumentUploadScreen extends StatelessWidget {
  final DocumentUploadController controller =
      Get.put(DocumentUploadController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Upload Documents",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Text(
                    "Your uploaded ID and passport images are securely protected and used solely for verification purposes.",
                    style: TextStyle(
                        fontSize: 14, color: Colors.pink.withOpacity(0.8)),
                  )),
              _buildSectionTitle("ID Card Upload"),
              _buildIdCardUploadCard(
                title: "Front Image",
                image: controller.idCardFrontImage,
                onTap: () =>
                    controller.pickImage(isIdCard: true, isFront: true),
              ),
              SizedBox(height: 16),
              _buildIdCardUploadCard(
                title: "Back Image",
                image: controller.idCardBackImage,
                onTap: () =>
                    controller.pickImage(isIdCard: true, isFront: false),
              ),
              SizedBox(height: 18),
              Divider(),
              _buildSectionTitle("Passport Upload"),
              _buildUploadCard(
                title: "Front Image",
                image: controller.passportFrontImage,
                onTap: () =>
                    controller.pickImage(isIdCard: false, isFront: true),
              ),
              SizedBox(height: 16),
              _buildUploadCard(

                title: "Back Image",
                image: controller.passportBackImage,
                onTap: () =>
                    controller.pickImage(isIdCard: false, isFront: false),
              ),
              SizedBox(height: 16),
              PinkButton(
                  text: "Next",
                  onTap: () {
                    Get.to(SelfieImageScreen());
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 16.0, left: 16),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          title,
          style: TextStyle(
            color: Colors.pinkAccent,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildUploadCard({
    required String title,
    required Rx<File?> image,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Obx(
            () => DottedBorder(
          color: Colors.pink.shade300,
          borderType: BorderType.RRect,
          radius: Radius.circular(8),
          dashPattern: [6, 4],
          strokeWidth: 2,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            width: Get.width * 0.8,
            height: 220,
            decoration: BoxDecoration(
              color: Colors.pink[50],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.pink.withOpacity(0.2),
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: Offset(2, 4),
                ),
              ],
              image: image.value != null
                  ? DecorationImage(
                image: FileImage(image.value!),
                fit: BoxFit.cover,
              )
                  : null,
            ),
            child: image.value == null
                ? Center(
              child: Image.asset(
                "assets/images/Psp.jpg",
                fit: BoxFit.fill,
                width: double.infinity,
                height: double.infinity,
              ),
            )
                : null,
          ),
        ),
      ),
    );
  }


  Widget _buildIdCardUploadCard({
    required String title,
    required Rx<File?> image,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Obx(() => DottedBorder(
        color: Colors.pink.shade300,
        borderType: BorderType.RRect,
        radius: Radius.circular(8),
        dashPattern: [6, 4],
        strokeWidth: 2,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          width: Get.width * 0.8,
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: image.value != null
                ? DecorationImage(
              image: FileImage(image.value!),
              fit: BoxFit.cover,
            )
                : null,
          ),
          child: image.value == null
              ? Center(child: Text("Upload $title"))
              : null,
        ),
      )),
    );
  }

}
