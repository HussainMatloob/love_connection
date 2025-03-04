import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AuthController.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var userId = ''.obs;
  final AuthController authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    loadUserId();
  }

  Future<void> loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId.value = prefs.getString("userid")! ;
  }

  final Map<String, TextEditingController> controllers = {
    'firstname': TextEditingController(),
    'lastname': TextEditingController(),
    'email': TextEditingController(),
    'password': TextEditingController(),
    'gender': TextEditingController(),
    'dateofbirth': TextEditingController(),
    'height': TextEditingController(),
  };

  final Map<String, Rx<File?>> imageFiles = {
    'profileimage': Rx<File?>(null),
  };

  Future<void> pickImage(ImageSource source, String field) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      imageFiles[field]?.value = File(pickedFile.path);
    }
  }

  bool validateAllFields() {
    bool allFieldsValid = true;

    controllers.forEach((key, controller) {
      if (controller.text.trim().isEmpty) {
        print("Missing field: $key");
        allFieldsValid = false;
      }
    });

    if (authController.educationLevel.value?.trim().isEmpty ?? true) {
      print("Missing field: educationLevel");
      allFieldsValid = false;
    }
    if (authController.religion.value?.trim().isEmpty ?? true) {
      print("Missing field: religion");
      allFieldsValid = false;
    }
    if (authController.caste.value?.trim().isEmpty ?? true) {
      print("Missing field: caste");
      allFieldsValid = false;
    }
    if (authController.sect.value?.trim().isEmpty ?? true) {
      print("Missing field: sect");
      allFieldsValid = false;
    }
    if (authController.currentResidence.value?.trim().isEmpty ?? true) {
      print("Missing field: currentResidence");
      allFieldsValid = false;
    }

    // FIX: Preserve value, only assign default if NULL or empty
    if (authController.cityOfResidence.value == null || authController.cityOfResidence.value!.trim().isEmpty) {
      print("Missing field: cityOfResidence. Assigning default.");
      authController.cityOfResidence.value = "Unknown";
      allFieldsValid = false;
    }

    if (authController.ethnicity.value?.trim().isEmpty ?? true) {
      print("Missing field: ethnicity");
      allFieldsValid = false;
    }

    return allFieldsValid;
  }


  Future<void> updateUserProfile() async {
    if (!validateAllFields()) {
      Get.snackbar("Error", "All fields are required", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('userid');
    if (userId == null || userId.isEmpty) {
      print("checkGoalRatingForGoals: userId not found");
      return;
    }

    if (userId.isEmpty) {
      Get.snackbar("Error", "User ID is missing", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading(true);
    var uri = Uri.parse("https://projects.funtashtechnologies.com/gomeetapi/updateprofile.php");
    var request = http.MultipartRequest('POST', uri);
    request.fields.addAll(getProfileData());

    for (var entry in imageFiles.entries) {
      if (entry.value.value != null) {
        request.files.add(await http.MultipartFile.fromPath(entry.key, entry.value.value!.path));
      }
    }

    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseBody);

      if (jsonResponse["ResponseCode"] == "200") {
        Get.snackbar("Success", "Profile updated successfully!", backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar("Error", jsonResponse["ResponseMsg"], backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to update profile. Try again.", backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading(false);
    }
  }

  Map<String, String> getProfileData() {
    return {
      'id': userId.toString(),
      ...controllers.map((key, controller) => MapEntry(key, controller.text.trim())),
      'education': authController.educationLevel.value?.trim() ?? '',
      'religion': authController.religion.value?.trim() ?? '',
      'cast': authController.caste.value?.trim() ?? '',
      'sect': authController.sect.value?.trim() ?? '',
      'country': authController.currentResidence.value?.trim() ?? '',
      'city': authController.cityOfResidence.value?.trim().isNotEmpty == true ? authController.cityOfResidence.value!.trim() : "Unknown", // Default if empty
      'ethnicity': authController.ethnicity.value?.trim() ?? '',
    };
  }
}