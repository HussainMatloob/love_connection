import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:love_connection/Controllers/AuthController.dart';
import 'package:love_connection/Controllers/document_upload_controller.dart';
import 'package:love_connection/Controllers/selfie_upload_controller.dart';
import 'package:love_connection/Controllers/update_profile_controller.dart';
import 'package:love_connection/Widgets/PinkButton.dart';

class VerificationDocument extends StatefulWidget {
  const VerificationDocument({super.key});

  @override
  State<VerificationDocument> createState() => _VerificationDocumentState();
}

class _VerificationDocumentState extends State<VerificationDocument> {
  final SelfieImageController controller = Get.put(SelfieImageController());
  final DocumentUploadController docController =
      Get.put(DocumentUploadController());
  final ProfileController profileController = Get.put(ProfileController());
  final AuthController authController = Get.put(AuthController());

  void initState() {
    // TODO: implement initState
    super.initState();
    docController.clearAllDocuments();
    controller.clearSelfieImage();
    profileController.fetchUserDetails(context);
  }

  @override
  Widget build(BuildContext context) {
    final String baseUrl =
        'https://projects.funtashtechnologies.com/gomeetapi/';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Update Documents",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: Obx(() {
        return profileController.isProfileloading.value
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.pink,
                ),
              )
            : profileController.userData.value != null
                ? SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 16),
                              child: Text(
                                "Your uploaded ID and passport images are securely protected and used solely for verification purposes.",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.pink.withOpacity(0.8)),
                              )),
                          _buildSectionTitle("ID Card Upload"),
                          _buildIdCardUploadCard(
                            title: "Front Image",
                            image: docController.idCardFrontImage,
                            onTap: () => docController.pickImage(
                              isIdCard: true,
                              isFront: true,
                            ),
                            apiImage:
                                profileController.userData.value?['cnic_front'],
                          ),
                          SizedBox(height: 16),
                          _buildIdCardUploadCard(
                            title: "Back Image",
                            image: docController.idCardBackImage,
                            onTap: () => docController.pickImage(
                                isIdCard: true, isFront: false),
                            apiImage:
                                profileController.userData.value?['cnic_back'],
                          ),
                          SizedBox(height: 18),
                          Divider(),
                          _buildSectionTitle("Passport Upload (Optional)"),
                          _buildUploadCard(
                            title: "Front Image",
                            image: docController.passportFrontImage,
                            onTap: () => docController.pickImage(
                                isIdCard: false, isFront: true),
                            apiImage: profileController
                                .userData.value?['passport_front'],
                          ),
                          SizedBox(height: 16),
                          _buildUploadCard(
                            title: "Back Image",
                            image: docController.passportBackImage,
                            onTap: () => docController.pickImage(
                                isIdCard: false, isFront: false),
                            apiImage: profileController
                                .userData.value?['passport_back'],
                          ),
                          SizedBox(height: 16),
                          _buildSectionTitle("Selfie Upload"),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 16.r, right: 16.r, bottom: 16.r),
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
                                          color: controller.selfieImage.value ==
                                                      null &&
                                                  profileController
                                                              .userData.value?[
                                                          'selfieimage'] ==
                                                      null
                                              ? Colors.pink[50]
                                              : null,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: Colors.pinkAccent),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.pink.withOpacity(0.2),
                                              blurRadius: 8,
                                              spreadRadius: 2,
                                              offset: Offset(2, 4),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: controller.selfieImage.value !=
                                                  null
                                              ? Image.file(
                                                  controller.selfieImage.value!,
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                )
                                              : profileController
                                                              .userData.value?[
                                                          'selfieimage'] !=
                                                      null
                                                  ? Image.network(
                                                      "$baseUrl${profileController.userData.value?['selfieimage']}",
                                                      fit: BoxFit.cover,
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                      loadingBuilder: (context,
                                                          child,
                                                          loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) return child;
                                                        return Stack(
                                                          fit: StackFit.expand,
                                                          children: [
                                                            Container(
                                                                color: Colors
                                                                    .pink[50]),
                                                            Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                                color:
                                                                    Colors.pink,
                                                                value: loadingProgress
                                                                            .expectedTotalBytes !=
                                                                        null
                                                                    ? loadingProgress
                                                                            .cumulativeBytesLoaded /
                                                                        (loadingProgress.expectedTotalBytes ??
                                                                            1)
                                                                    : null,
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                      errorBuilder: (context,
                                                              error,
                                                              stackTrace) =>
                                                          Center(
                                                        child: Icon(Icons.error,
                                                            color: Colors.red),
                                                      ),
                                                    )
                                                  : Center(
                                                      child: Text(
                                                        "No Selfie Captured",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .pinkAccent),
                                                      ),
                                                    ),
                                        ),
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
                                                  color: Colors.black
                                                      .withOpacity(0.2),
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

                                SizedBox(height: 15),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                          profileController.isDocumentLoading.value
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.pink,
                                  ),
                                )
                              : PinkButton(
                                  text: "Update",
                                  onTap: () {
                                    profileController.updateDocuments();
                                  }),
                        ],
                      ),
                    ),
                  )
                : Center(
                    child: FadeIn(
                      duration: Duration(milliseconds: 500),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Something went wrong ",
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: Text(
                              "Please check your connection and try again.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          SizedBox(height: 20.h),
                          ElevatedButton.icon(
                            onPressed: () {
                              profileController.fetchUserDetails(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pinkAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24.w, vertical: 14.h),
                              elevation: 5,
                              shadowColor: Colors.pinkAccent.withOpacity(0.3),
                            ),
                            icon: Icon(Icons.refresh,
                                color: Colors.white, size: 20.sp),
                            label: Text(
                              "Retry",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.sp),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
        ;
      }),
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
    required String? apiImage,
  }) {
    final String baseUrl =
        'https://projects.funtashtechnologies.com/gomeetapi/';
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: image.value != null
                  ? Image.file(
                      image.value!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    )
                  : apiImage != null
                      ? Image.network(
                          "$baseUrl$apiImage",
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Stack(
                              fit: StackFit.expand,
                              children: [
                                Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.pink,
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            (loadingProgress
                                                    .expectedTotalBytes ??
                                                1)
                                        : null,
                                  ),
                                ),
                              ],
                            );
                          },
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Icon(Icons.error, color: Colors.red),
                          ),
                        )
                      : Container(
                          child: Center(child: Text("Upload $title")),
                        ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIdCardUploadCard({
    required String title,
    required Rx<File?> image,
    required VoidCallback onTap,
    required String? apiImage,
  }) {
    final String baseUrl =
        'https://projects.funtashtechnologies.com/gomeetapi/';
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: image.value != null
                    ? Image.file(
                        image.value!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      )
                    : apiImage != null
                        ? Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                "$baseUrl$apiImage",
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.pink,
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
                                                      1)
                                              : null,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) =>
                                    Center(
                                        child: Icon(Icons.error,
                                            color: Colors.pink)),
                              ),
                            ],
                          )
                        : Container(
                            color: Colors.grey[200],
                            child: Center(child: Text("Upload $title")),
                          ),
              ),
            ),
          )),
    );
  }
}
