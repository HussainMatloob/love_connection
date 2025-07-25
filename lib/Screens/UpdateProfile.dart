import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:love_connection/Controllers/AuthController.dart';
import 'package:love_connection/Controllers/city_controller.dart';
import 'package:love_connection/Controllers/country_controller.dart';
import 'package:love_connection/Controllers/religion_controller.dart';
import 'package:love_connection/Controllers/sect_controller.dart';
import 'package:love_connection/Screens/verification_document.dart';
import 'package:love_connection/Widgets/FormWidgets.dart';
import 'package:love_connection/Widgets/custom_button.dart';
import 'package:love_connection/Widgets/custom_dialogs.dart';
import '../Controllers/cast_controller.dart';
import '../Controllers/update_profile_controller.dart';

class Updateprofile extends StatefulWidget {
  const Updateprofile({super.key});

  @override
  State<Updateprofile> createState() => _UpdateprofileState();
}

class _UpdateprofileState extends State<Updateprofile> {
  final ProfileController controller = Get.put(ProfileController());
  final ReligionController religionController = Get.put(ReligionController());
  final AuthController authController = Get.put(AuthController());
  final CountryController countryController = Get.put(CountryController());
  final CityController cityController = Get.put(CityController());
  final CastController castController = Get.put(CastController());
  final SectController sectController = Get.put(SectController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.fetchUserDetails(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
        onWillPop: () async {
          CustomDialogs.showQuitDialog(context,
              height: 210.h,
              width: 200.w,
              radius: 10.r,
              headText: "Quit Screen?",
              messageText:
                  "Are you sure you want to quit this screen? Any unsaved changes will be lost.",
              quitText: "Quit",
              cancelText: 'Cancel', onTap: () {
            Navigator.of(context).pop(); // Close dialog
            Navigator.of(context).pop(); // Quit screen
          });
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title:
                Text("Update Profile", style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.pink,
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: Obx(() {
            if (controller.isProfileloading.value) {
              return Center(
                  child: CircularProgressIndicator(color: Colors.pink));
            } else if (controller.userData.value == null) {
              return Center(
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
                          controller.fetchUserDetails(context, false);
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
                          style:
                              TextStyle(color: Colors.white, fontSize: 16.sp),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: _buildProfileImage()),
                  SizedBox(height: 20),
                  Center(
                    child: CustomButton(
                      bordercircular: 5.r,
                      boxColor: Colors.pink,
                      text: controller.userData.value?['status'] == "verified"
                          ? "Verified"
                          : "Unverified",
                      textColor: Colors.white,
                      fontSize: 12.sp,
                      fw: FontWeight.w600,
                      height: 30.h,
                      width: 80.h,
                      horizontalPadding: 5.w,
                      borderColor: Colors.transparent,
                      onTap: () {
                        if (controller.userData.value?['status'] ==
                            "unverified") {
                          Get.to(() => VerificationDocument());
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildTextField("First Name",
                      controller.controllers['firstname']!, Icons.person),
                  _buildTextField("Last Name",
                      controller.controllers['lastname']!, Icons.person),
                  _buildTextField(
                      "Email", controller.controllers['email']!, Icons.email,
                      isReadOnly: true),
                  _buildTextField("Password",
                      controller.controllers['password']!, Icons.lock,
                      obscureText: authController.obsecureText.value,
                      isSuffix: true, onTap: () {
                    authController.changeObsecureText();
                  }),
                  SizedBox(height: 8),
                  FormWidgets.buildDateOfBirth(
                      authController, controller.dateOfBirth.value!, true),
                  SizedBox(height: 10),
                  FormWidgets.buildDropdownField(
                    label: 'Height',
                    value: authController.height,
                    itemsList: authController.heightOptions,
                  ),
                  SizedBox(height: 10),
                  FormWidgets.buildDropdownField(
                    label: 'Gender',
                    value: authController.selectedGender,
                    itemsList: authController.genderOptions,
                  ),
                  FormWidgets.buildDropdownPair(
                    label1: 'Your Education',
                    label2: 'Looking For',
                    value: authController.educationLevel,
                    lookingForValue: authController.lookingForEducation,
                    yourList: controller.educationList
                        .where((item) => item.toLowerCase() != "any")
                        .toList(),
                    lookingForList: controller.educationList,
                    hinttext: 'Select Education',
                  ),
                  FormWidgets.buildDropdownPair(
                      label1: 'Your Religion',
                      label2: 'Looking For',
                      value: authController
                          .religion, // Fallback value to avoid errors
                      lookingForValue: authController.lookingForReligion,
                      yourList: controller.religions
                          .where((religion) => religion.toLowerCase() != "any")
                          .toList(),
                      lookingForList: controller.religions,
                      hinttext: 'Select Religion',
                      fetchData: "Fetch Cast"),
                  controller.isCasteLoading.value
                      ? Center(
                          child: CircularProgressIndicator(
                          color: Colors.pink,
                        ))
                      : FormWidgets.buildDropdownPair(
                          label1: 'Your Caste',
                          label2: 'Looking For',
                          value: authController.caste,
                          lookingForValue: authController.lookingForCaste,
                          yourList: controller.casteNames
                              .where((caste) => caste.toLowerCase() != "any")
                              .toList(),
                          lookingForList: controller.casteNames,
                          hinttext: controller.casteNames.isEmpty
                              ? 'No Cast found'
                              : 'Select Cast',
                          fetchData: "Fetch Sect"),
                  SizedBox(height: 8.h),
                  controller.isSectLoading.value
                      ? Center(
                          child: CircularProgressIndicator(
                          color: Colors.pink,
                        ))
                      : FormWidgets.buildDropdownPair(
                          label1: 'Your Sect',
                          label2: 'Looking For',
                          value: authController.sect,
                          lookingForValue: authController.lookingForSect,
                          yourList: controller.sectList
                              .where((sect) => sect.toLowerCase() != "any")
                              .toList(),
                          lookingForList: controller.sectList,
                          hinttext: controller.sectList.isEmpty
                              ? 'No Sect found'
                              : 'Select Sect',
                        ),
                  SizedBox(height: 10),
                  controller.isCountryLoading.value
                      ? Center(
                          child: CircularProgressIndicator(
                          color: Colors.pink,
                        ))
                      : FormWidgets.buildDropdownPair(
                          label1: 'Your Country',
                          label2: 'Looking For',
                          value: authController.currentResidence,
                          lookingForValue: authController.lookingForResidence,
                          yourList: controller.countryList
                              .where(
                                  (country) => country.toLowerCase() != "any")
                              .toList(),
                          lookingForList: controller.countryList,
                          hinttext: 'Select Country',
                          fetchData: "Fetch Cities"),
                  SizedBox(height: 10),
                  controller.isCityLoading.value
                      ? Center(
                          child: CircularProgressIndicator(
                          color: Colors.pink,
                        ))
                      : FormWidgets.buildDropdownPair1(
                          label1: 'Your City',
                          label2: 'Looking For',
                          value: authController.cityOfResidence,
                          lookingForValue: authController.lookingForCity,
                          selfItems: controller.cityOptions
                              .where((city) => city.toLowerCase() != "any")
                              .toList(),
                          lookingForItems: controller.cityOptions,
                          hinttext: 'Select City',
                        ),
                  SizedBox(height: 8.h),
                  FormWidgets.buildDropdownPair(
                      label1: 'Your Ethnicity',
                      label2: 'Looking For',
                      value: authController.ethnicity,
                      lookingForValue: authController.lookingForEthnicity,
                      yourList: controller.ethnicityList
                          .where(
                              (ethnicity) => ethnicity.toLowerCase() != "any")
                          .toList(),
                      lookingForList: controller.ethnicityList,
                      hinttext: "Select Ethnicity"),
                  SizedBox(height: 20.h),
                  controller.isLoading.value
                      ? Center(
                          child: CircularProgressIndicator(
                          color: Colors.pink,
                        ))
                      : SizedBox(
                          width: 1.sw,
                          child: ElevatedButton(
                            onPressed: controller.updateUserProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              padding: EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 40),
                            ),
                            child: Text("Update Profile",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white)),
                          ),
                        ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

// Profile image widget
  final String baseUrl = 'https://projects.funtashtechnologies.com/gomeetapi/';

  Widget _buildProfileImage() {
    return Obx(() {
      final File? pickedFile = controller.imageFiles['profileimage']?.value;
      final String? selfiePath = controller.userData.value?['profileimage'];
      final String? fullImageUrl = (selfiePath != null && selfiePath.isNotEmpty)
          ? '$baseUrl$selfiePath'
          : null;
      return Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.blueGrey[100],
            backgroundImage: pickedFile != null
                ? FileImage(pickedFile)
                : (fullImageUrl != null ? NetworkImage(fullImageUrl) : null)
                    as ImageProvider?,
            child: pickedFile == null &&
                    (fullImageUrl == null || fullImageUrl.isEmpty)
                ? Icon(Icons.camera_alt, size: 40, color: Colors.grey[600])
                : null,
          ),
          Positioned(
            left: 0,
            child: Container(
              height: 30.h,
              width: 30.w,
              decoration: BoxDecoration(
                color: Colors.pink, // Background color
                shape: BoxShape.circle, // Makes it circular (optional)
              ),
              child: IconButton(
                onPressed: () {
                  controller.pickImage(ImageSource.gallery, 'profileimage');
                },
                icon: Icon(
                  Icons.edit_outlined,
                  color: Colors.white,
                  size: 15.sp,
                ),
              ),
            ),
          )
        ],
      );
    });
  }

  Widget _buildTextField(
      String hint, TextEditingController controller, IconData icon,
      {bool obscureText = false,
      isReadOnly = false,
      isSuffix = false,
      VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        readOnly: isReadOnly,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.pink),
          suffixIcon: isSuffix
              ? IconButton(
                  onPressed: onTap,
                  icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.pink),
                )
              : null,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
