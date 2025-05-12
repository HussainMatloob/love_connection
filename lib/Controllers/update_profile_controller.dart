import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:love_connection/ApiService/ApiService.dart';
import 'package:love_connection/Controllers/sect_controller.dart';
import 'package:love_connection/utils/date_time_util.dart';
import 'package:love_connection/utils/flush_messages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AuthController.dart';

class ProfileController extends GetxController {
  var isBack = false.obs;
  var isProfileloading = false.obs;
  final ApiService _apiService = ApiService();
  var isLoading = false.obs;
  var userId = ''.obs;
  final dateOfBirth = Rxn<DateTime>();
  final AuthController authController = Get.put(AuthController());
  final SectController sectController = Get.put(SectController());
  var userID = '';

  @override
  void onInit() {
    super.onInit();
    loadUserId();
  }

  Future<void> loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId.value = prefs.getString("userid")!;
  }

  final Map<String, TextEditingController> controllers = {
    'firstname': TextEditingController(),
    'lastname': TextEditingController(),
    'email': TextEditingController(),
    'password': TextEditingController(),
    'gender': TextEditingController(),
    'height': TextEditingController(),
  };

  /*-------------------------------------------------------*/
  /*                      get user details                 */
  /*-------------------------------------------------------*/

  var userData = Rxn<Map<String, dynamic>?>(); // Stores the user data

  // Method to fetch user data
  Future<void> fetchUserDetails(BuildContext context) async {
    try {
      isProfileloading(true);

      final response = await _apiService.GetUserInfo();

      if (response['ResponseCode'] == '200' && response['Result'] == 'true') {
        userData.value = response['UserData']; // Set user data
        controllers['firstname']?.text = userData.value?['firstname'] ?? '';
        controllers['lastname']?.text = userData.value?['lastname'] ?? '';
        controllers['email']?.text = userData.value?['email'] ?? '';
        controllers['password']?.text = userData.value?['password'] ?? '';
        controllers['gender']?.text = userData.value?['gender'] ?? '';
        controllers['height']?.text = userData.value?['height'] ?? '';
        dateOfBirth.value = DateTimeUtil.setDateOfBirth(
            userData.value?['dateofbirth'] ?? "02/03/2000");

        authController.educationLevel.value =
            userData.value?['education'] ?? '';

        authController.lookingForEducation.value =
            userData.value?['educationlookingfor'] ?? '';

        authController.religion.value = userData.value?['religion'] ?? '';

        authController.lookingForReligion.value =
            userData.value?['religionlookingfor'] ?? '';

        authController.caste.value = userData.value?['cast'] ?? '';

        authController.lookingForCaste.value =
            userData.value?['castlookingfor'] ?? '';

        authController.sect.value = userData.value?['sect'] ?? '';

        authController.lookingForSect.value =
            userData.value?['sectlookingfor'] ?? '';

        authController.currentResidence.value =
            userData.value?['country'] ?? '';

        authController.lookingForResidence.value =
            userData.value?['countrylookingfor'] ?? '';

        authController.cityOfResidence.value = userData.value?['city'] ?? '';

        authController.lookingForCity.value =
            userData.value?['citylookingfor'] ?? '';

        authController.ethnicity.value = userData.value?['ethnicity'] ?? '';

        authController.lookingForEthnicity.value =
            userData.value?['ethnicitylookingfor'] ?? '';

        isProfileloading(false);
      } else {
        FlushMessages.snackBarMessage("Error",
            "Error fetching details ,please refresh page", context, Colors.red);
        isProfileloading(false);
      }
    } catch (e) {
      FlushMessages.snackBarMessage("Error",
          "Error fetching details ,please refresh page:", context, Colors.red);
      isProfileloading(false);
    } finally {
      isProfileloading(false);
    }
  }

// Image file map
  final Map<String, Rx<File?>> imageFiles = {
    'selfieimage': Rx<File?>(null),
  };

// Pick image from gallery or camera
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
    if (authController.cityOfResidence.value == null ||
        authController.cityOfResidence.value!.trim().isEmpty) {
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
      Get.snackbar("Error", "All fields are required",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('userid');
    if (userId == null || userId.isEmpty) {
      return;
    }

    isLoading(true);
    var uri = Uri.parse(
        "https://projects.funtashtechnologies.com/gomeetapi/updateprofile.php");
    var request = http.MultipartRequest('POST', uri);
    request.fields.addAll(getProfileData());

    for (var entry in imageFiles.entries) {
      if (entry.value.value != null) {
        request.files.add(await http.MultipartFile.fromPath(
            entry.key, entry.value.value!.path));
      }
    }

    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseBody);

      if (jsonResponse["ResponseCode"] == "200") {
        Get.snackbar("Success", "Profile updated successfully!",
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar("Error", jsonResponse["ResponseMsg"],
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to update profile. Try again.",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading(false);
    }
  }

  Map<String, String> getProfileData() {
    return {
      'id': userId.toString(),
      ...controllers
          .map((key, controller) => MapEntry(key, controller.text.trim())),
      'dateofbirth': authController.dateOfBirth.value != null
          ? authController.dateOfBirth.value!.toIso8601String().trim()
          : '',
      'education': authController.educationLevel.value?.trim() ?? '',
      ' educationlookingfor':
          authController.lookingForEducation.value?.trim() ?? '',
      'religion': authController.religion.value?.trim() ?? '',
      'religionlookingfor':
          authController.lookingForReligion.value?.trim() ?? '',
      'cast': authController.caste.value?.trim() ?? '',
      'castlookingfor': authController.lookingForCaste.value?.trim() ?? '',
      'sect': authController.sect.value?.trim() ?? '',
      'sectlookingfor': authController.lookingForSect.value?.trim() ?? '',
      'country': authController.currentResidence.value?.trim() ?? '',
      'countrylookingfor':
          authController.lookingForResidence.value?.trim() ?? '',
      'city': authController.cityOfResidence.value?.trim().isNotEmpty == true
          ? authController.cityOfResidence.value!.trim()
          : "Unknown", // Default if empty
      'citylookingfor':
          authController.lookingForCity.value?.trim().isNotEmpty == true
              ? authController.lookingForCity.value!.trim()
              : "Unknown", // Default if empty
      'ethnicity': authController.ethnicity.value?.trim() ?? '',
      'ethnicitylookingfor':
          authController.lookingForEthnicity.value?.trim() ?? '',
    };
  }
}
