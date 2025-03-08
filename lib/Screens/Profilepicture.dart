import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  final ProfilepictureController controller =
  Get.put(ProfilepictureController());
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
              fontSize: 22.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Mandatory*',
                        style: GoogleFonts.outfit(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Obx(
                          () => GestureDetector(
                        onTap: () => controller.pickImageFromGallery(),
                        child: DottedBorder(
                          color: Colors.pink.shade300,
                          borderType: BorderType.RRect,
                          radius: Radius.circular(8.r),
                          dashPattern: [6, 4],
                          strokeWidth: 2,
                          child: Container(
                            width: 0.85.sw,
                            height: 0.50.sh, // Adjusted height for better fit
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: controller.profileImage.value == null
                                ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt_outlined,
                                    size: 40.sp, color: Colors.grey),
                                SizedBox(height: 8.h),
                                Text('Upload Image',
                                    style: GoogleFonts.outfit(
                                        color: Colors.grey,
                                        fontSize: 16.sp)),
                              ],
                            )
                                : ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
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
                    SizedBox(height: 20.h),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Upload your images*',
                        style: GoogleFonts.outfit(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(3, (index) {
                        return GestureDetector(
                          onTap: () => imageController.pickImage(index),
                          child: Obx(() {
                            return DottedBorder(
                              color: Colors.pink.shade300,
                              borderType: BorderType.RRect,
                              radius: Radius.circular(8.r),
                              dashPattern: [6, 4],
                              strokeWidth: 2,
                              child: Container(
                                width: 100.w,
                                height: 100.h,
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
                                    image: FileImage(
                                        imageController.images[index]!),
                                    fit: BoxFit.cover,
                                  )
                                      : null,
                                ),
                                child: imageController.images[index] == null
                                    ? Icon(Icons.add,
                                    color: Colors.black54, size: 40.sp)
                                    : null,
                              ),
                            );
                          }),
                        );
                      }),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: PinkButton(
                text: "Continue",
                onTap: () {
                  if (imageController.areAllImagesSelected() &&
                      controller.profileImage.value != null) {
                    Get.to(DocumentUploadScreen());
                  } else {
                    Get.snackbar('Incomplete', 'Please select all images.',
                        snackPosition: SnackPosition.BOTTOM);
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
