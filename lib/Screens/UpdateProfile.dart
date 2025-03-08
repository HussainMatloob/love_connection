import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:love_connection/Controllers/AuthController.dart';
import 'package:love_connection/Controllers/city_controller.dart';
import 'package:love_connection/Controllers/country_controller.dart';
import 'package:love_connection/Controllers/religion_controller.dart';
import 'package:love_connection/Controllers/sect_controller.dart';
import 'package:love_connection/Widgets/FormWidgets.dart';

import '../Controllers/cast_controller.dart';
import '../Controllers/update_profile_controller.dart';

class UpdateProfileScreen extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());
  final ReligionController religionController = Get.put(ReligionController());
  final AuthController authController = Get.put(AuthController());
  final CountryController countryController = Get.put(CountryController());
  final CityController cityController = Get.put(CityController());
  final CastController castController = Get.put(CastController());
  final SectController sectController = Get.put(SectController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pink,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: _buildProfileImage()),
            SizedBox(height: 20),
            _buildTextField("First Name", controller.controllers['firstname']!,
                Icons.person),
            _buildTextField("Last Name", controller.controllers['lastname']!,
                Icons.person_outline),
            _buildTextField(
                "Email", controller.controllers['email']!, Icons.email),
            _buildTextField(
                "Password", controller.controllers['password']!, Icons.lock,
                obscureText: true),
            _buildTextField(
                "Gender", controller.controllers['gender']!, Icons.male),
            _buildTextField(
                "Height", controller.controllers['height']!, Icons.height),
            FormWidgets.buildDateOfBirth(authController),
            SizedBox(height: 10),
            FormWidgets.buildDropdownPair(
              label: 'Education Level',
              value: authController.educationLevel,
              lookingForValue: authController.lookingForEducation,
              items: authController.educationOptions,
              hinttext: 'Select Education',
            ),
            Obx(() {
              final religions = religionController.religions;
              final _ = religions.length; // Ensure reactivity
              return FormWidgets.buildDropdownPair(
                hinttext: 'Select Religion',
                items: religions,
                label: 'Religion',
                value: authController.religion,
                lookingForValue: authController.lookingForReligion,
              );
            }),
            Obx(() {
              if (castController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              final List<String> casteNames = castController.castList
                  .map<String>((cast) => cast["cast"].toString())
                  .toList();
              if (castController.errorMessage.isNotEmpty) {
                return FormWidgets.buildDropdownPair(
                  label: 'Caste',
                  value: authController.caste,
                  lookingForValue: authController.lookingForCaste,
                  items: casteNames,
                  hinttext: castController.errorMessage.isNotEmpty
                      ? 'No Cast found'
                      : 'Select Cast',
                );
              }

              return FormWidgets.buildDropdownPair(
                label: 'Caste',
                value: authController.caste,
                lookingForValue: authController.lookingForCaste,
                items: casteNames,
                hinttext: casteNames.isEmpty ? 'No Cast found' : 'Select Cast',
              );
            }),
            SizedBox(height: 8.h),
            Obx(() {
              if (sectController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }
              if (sectController.errorMessage.isNotEmpty) {
                return Center(
                  child: Text(
                    sectController.errorMessage.value,
                    style: TextStyle(color: Colors.red),
                  ),
                );
              }
              return FormWidgets.buildDropdownPair(
                label: 'Sect',
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
              final countries = ["Any", ...countryController.countryList];
              final _ = countries.length;

              if (countryController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }
              return FormWidgets.buildDropdownPair(
                label: 'Country of Current Residence',
                value: authController.currentResidence,
                lookingForValue: authController.lookingForResidence,
                items: countries,
                hinttext: 'Select Country',
              );
            }),
            SizedBox(height: 10),
            Obx(() {
              final cities = ["Any", ...cityController.cityOptions];
              final _ = cities.length; // Forces UI rebuild when cities update

              if (cityController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }
              if (cityController.cityOptions.isEmpty) {
                return FormWidgets.buildDropdownPair(
                  label: 'City of Current Residence',
                  value: cities.contains(authController.cityOfResidence.value)
                      ? authController.cityOfResidence
                      : Rxn<String>(),
                  lookingForValue:
                      cities.contains(authController.lookingForCity.value)
                          ? authController.lookingForCity
                          : Rxn<String>(),
                  items: [],
                  hinttext: 'No Cities found',
                );
              }

              return FormWidgets.buildDropdownPair(
                label: 'City of Current Residence',
                value: cities.contains(authController.cityOfResidence.value)
                    ? authController.cityOfResidence
                    : Rxn<String>(),
                lookingForValue:
                    cities.contains(authController.lookingForCity.value)
                        ? authController.lookingForCity
                        : Rxn<String>(),
                items: cities,
                hinttext: 'Select City',
              );
            }),
            SizedBox(height: 8.h),
            FormWidgets.buildDropdownPair(
                label: 'Ethnicity',
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
                        padding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                      ),
                      child: Text("Update Profile",
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  )),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: () => controller.pickImage(ImageSource.gallery, 'profileimage'),
      child: Obx(() => CircleAvatar(
            radius: 60,
            backgroundColor: Colors.blueGrey[100],
            backgroundImage:
                controller.imageFiles['profileimage']?.value != null
                    ? FileImage(controller.imageFiles['profileimage']!.value!)
                    : null,
            child: controller.imageFiles['profileimage']?.value == null
                ? Icon(Icons.camera_alt, size: 40, color: Colors.grey[600])
                : null,
          )),
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
