import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var userId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserId();
  }

  Future<void> loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId.value = prefs.getString("userid") ?? "";
  }

  // TextEditingControllers for all required fields
  final Map<String, TextEditingController> controllers = {
    'firstname': TextEditingController(),
    'lastname': TextEditingController(),
    'email': TextEditingController(),
    'password': TextEditingController(),
    'gender': TextEditingController(),
    'dateofbirth': TextEditingController(),
    'height': TextEditingController(),
    'maritalstatus': TextEditingController(),
    'religion': TextEditingController(),
    'religionlookingfor': TextEditingController(),
    'country': TextEditingController(),
    'countrylookingfor': TextEditingController(),
    'education': TextEditingController(),
    'educationlookingfor': TextEditingController(),
    'employmentstatus': TextEditingController(),
    'monthlyincome': TextEditingController(),
    'city': TextEditingController(),
    'citylookingfor': TextEditingController(),
    'cast': TextEditingController(),
    'castlookingfor': TextEditingController(),
    'subcast': TextEditingController(),
    'subcastlookingfor': TextEditingController(),
    'sect': TextEditingController(),
    'sectlookingfor': TextEditingController(),
    'subsect': TextEditingController(),
    'subsectlookingfor': TextEditingController(),
    'ethnicity': TextEditingController(),
    'ethnicitylookingfor': TextEditingController(),
  };

  // Image files
  final Map<String, Rx<File?>> imageFiles = {
    'profileimage': Rx<File?>(null),
    'cnic_front': Rx<File?>(null),
    'cnic_back': Rx<File?>(null),
    'passport_front': Rx<File?>(null),
    'passport_back': Rx<File?>(null),
    'selfieimage': Rx<File?>(null),
  };

  Future<void> pickImage(ImageSource source, String field) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      imageFiles[field]?.value = File(pickedFile.path);
    }
  }

  Future<void> captureSelfie() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      imageFiles['selfieimage']?.value = File(pickedFile.path);
    }
  }

  bool validateAllFields() {
    return controllers.values.every((controller) => controller.text.isNotEmpty);
  }

  Future<void> updateUserProfile() async {
    if (!validateAllFields()) {
      Get.snackbar("Error", "All fields are required", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (userId.value.isEmpty) {
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
      'userid': userId.value,
      ...controllers.map((key, controller) => MapEntry(key, controller.text)),
    };
  }
}
