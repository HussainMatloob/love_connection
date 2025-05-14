import 'dart:io';

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
import 'package:love_connection/Widgets/FormWidgets.dart';
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
    controller.fetchUserDetails(context);
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
              height: 300.h,
              width: 200.w,
              radius: 20.r,
              headText: "Quit Screen?",
              messageText:
                  "Are you sure you want to quit this screen? Any unsaved changes will be lost.",
              quitText: "quit",
              cancelText: 'cancel', onTap: () {
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
              return Center(child: CircularProgressIndicator());
            } else if (controller.userData.value == null) {
              return Center(
                  child: TextButton(
                      onPressed: () {
                        controller.fetchUserDetails(context);
                      },
                      child: Text(
                        "Refresh",
                        style: TextStyle(fontSize: 16.sp),
                      )));
            }
            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: _buildProfileImage()),
                  SizedBox(height: 20),
                  _buildTextField("First Name",
                      controller.controllers['firstname']!, Icons.person),
                  _buildTextField(
                      "Last Name",
                      controller.controllers['lastname']!,
                      Icons.person_outline),
                  _buildTextField(
                      "Email", controller.controllers['email']!, Icons.email),
                  _buildTextField("Password",
                      controller.controllers['password']!, Icons.lock,
                      obscureText: true),
                  _buildTextField(
                      "Gender", controller.controllers['gender']!, Icons.male),
                  _buildTextField("Height", controller.controllers['height']!,
                      Icons.height),
                  FormWidgets.buildDateOfBirth(
                      authController, controller.dateOfBirth.value!, true),
                  SizedBox(height: 10),
                  FormWidgets.buildDropdownPair(
                    label1: 'Your Education',
                    label2: 'Looking For',
                    value: authController.educationLevel,
                    lookingForValue: authController.lookingForEducation,
                    items: authController.educationOptions,
                    hinttext: 'Select Education',
                  ),
                  Obx(() {
                    print(
                        "Religion value: ${authController.religion.value}"); // Debugging
                    return FormWidgets.buildDropdownPair(
                      label1: 'Your Religion',
                      label2: 'Looking For',
                      value: authController
                          .religion, // Fallback value to avoid errors
                      lookingForValue: authController.lookingForReligion,
                      items: religionController.religions,
                      hinttext: 'Select Religion',
                    );
                  }),
                  Obx(() {
                    if (castController.isLoading.value)
                      return Center(child: CircularProgressIndicator());
                    final casteNames = castController.castList
                        .map<String>((cast) => cast["cast"].toString())
                        .toList();
                    return FormWidgets.buildDropdownPair(
                      label1: 'Your Caste',
                      label2: 'Looking For',
                      value: authController.caste,
                      lookingForValue: authController.lookingForCaste,
                      items: casteNames,
                      hinttext:
                          casteNames.isEmpty ? 'No Cast found' : 'Select Cast',
                    );
                  }),
                  SizedBox(height: 8.h),
                  Obx(() {
                    if (sectController.isLoading.value)
                      return Center(child: CircularProgressIndicator());
                    return FormWidgets.buildDropdownPair(
                      label1: 'Your Sect',
                      label2: 'Looking For',
                      value: authController.sect,
                      lookingForValue: authController.lookingForSect,
                      items: sectController.sectList,
                      hinttext: sectController.sectList.isEmpty
                          ? 'No Sect found'
                          : 'Select Sect',
                    );
                  }),
                  SizedBox(height: 10),
                  Obx(() {
                    if (countryController.isLoading.value)
                      return Center(child: CircularProgressIndicator());
                    return FormWidgets.buildDropdownPair(
                      label1: 'Your Country',
                      label2: 'Looking For',
                      value: authController.currentResidence,
                      lookingForValue: authController.lookingForResidence,
                      items: ["Any", ...countryController.countryList],
                      hinttext: 'Select Country',
                    );
                  }),
                  SizedBox(height: 10),
                  Obx(() {
                    if (cityController.isLoading.value)
                      return Center(child: CircularProgressIndicator());

                    return FormWidgets.buildDropdownPair1(
                      label1: 'Your City',
                      label2: 'Looking For',

                      value: authController.cityOfResidence,
                      lookingForValue: authController.lookingForCity,
                      selfItems: [
                        "Any",
                        ...cityController.cityOptions
                      ], // Cities for Residence
                      lookingForItems: [
                        "Any",
                        ...cityController.lookingForCityOptions
                      ], // Cities for Looking For Residence
                      hinttext: 'Select City',
                    );
                  }),
                  SizedBox(height: 8.h),
                  FormWidgets.buildDropdownPair(
                      label1: 'Your Ethnicity',
                      label2: 'Looking For',
                      value: authController.ethnicity,
                      lookingForValue: authController.lookingForEthnicity,
                      items: authController.ethnicityOptions,
                      hinttext: "Select Ethnicity"),
                  SizedBox(height: 20.h),
                  Obx(() => controller.isLoading.value
                      ? Center(child: CircularProgressIndicator())
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
                        )),
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
    return GestureDetector(
      onTap: () => controller.pickImage(ImageSource.gallery, 'selfieimage'),
      child: Obx(() {
        final File? pickedFile = controller.imageFiles['selfieimage']?.value;
        final String? selfiePath = controller.userData.value?['selfieimage'];
        final String? fullImageUrl =
            (selfiePath != null && selfiePath.isNotEmpty)
                ? '$baseUrl$selfiePath'
                : null;

        return CircleAvatar(
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
        );
      }),
    );
  }

  Widget _buildTextField(
      String hint, TextEditingController controller, IconData icon,
      {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.pink),
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
