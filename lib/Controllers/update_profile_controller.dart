import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:love_connection/ApiService/ApiService.dart';
import 'package:love_connection/Controllers/document_upload_controller.dart';
import 'package:love_connection/Controllers/sect_controller.dart';
import 'package:love_connection/Controllers/selfie_upload_controller.dart';
import 'package:love_connection/utils/date_time_util.dart';
import 'package:love_connection/utils/helper/dialog_helper.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AuthController.dart';

class ProfileController extends GetxController {
  var isBack = false.obs;
  var isProfileloading = false.obs;
  final ApiService _apiService = ApiService();
  var isLoading = false.obs;
  var isDocumentLoading = false.obs;
  var userId = ''.obs;
  final dateOfBirth = Rxn<DateTime>();
  final AuthController authController = Get.put(AuthController());
  final SectController sectController = Get.put(SectController());
  var userID = '';

  var religions = <String>[].obs;
  var religionsLookingFor = <String>[].obs;
  var isReligionLoading =
      false.obs; // Start as false to prevent unnecessary loading

  final RxList<Map<String, dynamic>> castList = <Map<String, dynamic>>[].obs;
  final RxBool isCasteLoading = true.obs;
  final RxString errorMessage = ''.obs;

  final RxList<String> sectList = <String>[].obs;
  final RxBool isSectLoading = true.obs;
  final RxString sectErrorMessage = ''.obs;

  var countryList = <String>[].obs;
  var isCountryLoading = true.obs;

  var cityOptions = <String>[].obs; // Cities for current residence

  var isCityLoading = false.obs;

  var educationList = <String>[].obs;

  var isEducationLoading = true.obs;

  final RxList<String> ethnicityList = <String>[].obs;
  final RxBool isEthnicityLoading = true.obs;
  final RxString ethnicityerrorMessage = ''.obs;
  var casteNames = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadUserId();
  }

  Future<void> loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId.value = prefs.getString("userid") ?? "";
  }

  final Map<String, TextEditingController> controllers = {
    'firstname': TextEditingController(),
    'lastname': TextEditingController(),
    'email': TextEditingController(),
    'password': TextEditingController(),
  };

  /*-------------------------------------------------------*/
  /*                      get user details                 */
  /*-------------------------------------------------------*/

  var userData = Rxn<Map<String, dynamic>?>(); // Stores the user data

  // Method to fetch user data
  Future<void> fetchUserDetails(BuildContext context, bool isOpenScreen) async {
    try {
      isProfileloading(true);

      final response = await _apiService.GetUserInfo();

      if (response['ResponseCode'] == '200' && response['Result'] == 'true') {
        userData.value = response['UserData']; // Set user data
        controllers['firstname']?.text = userData.value?['firstname'] ?? '';
        controllers['lastname']?.text = userData.value?['lastname'] ?? '';
        controllers['email']?.text = userData.value?['email'] ?? '';
        controllers['password']?.text = userData.value?['password'] ?? '';
        authController.selectedGender.value = userData.value?['gender'] ?? '';
        authController.height.value = userData.value?['height'] ?? '';
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

        await fetchEducationList();
        await fetchReligions();
        await fetchCastData(authController.religion.value ?? '', false);
        await fetchSectData(authController.religion.value ?? '',
            authController.caste.value ?? '', false);
        await fetchCountryList();
        await loadCities(
          authController.currentResidence.value ?? "",
          false,
        );
        await fetchEthnicityData();

        isProfileloading(false);

        final prefs = await SharedPreferences.getInstance();
        final isFirstTimeVerifiedDialog =
            prefs.getBool('isFirstTimeVerifiedDialog');
//
        if (isOpenScreen) {
          if (userData.value?['status'] == "verified" &&
              (isFirstTimeVerifiedDialog == false ||
                  isFirstTimeVerifiedDialog == null)) {
            prefs.setBool('isFirstTimeVerifiedDialog', true);
            DialogHelper.showSuccessDialog(
                "You're now a verified member of our app. Thank you!");
          } else if (userData.value?['status'] == "unverified") {
            DialogHelper.showErrorDialog(
                "You're not yet verified. Kindly upload your documents or contact the admin to proceed",
                headText: "Attention");
          }
        }
      } else {
        // FlushMessages.snackBarMessage("Error",
        //     "Error fetching details ,please refresh page", context, Colors.red);
        isProfileloading(false);
      }
    } catch (e) {
      // FlushMessages.snackBarMessage("Error",
      //     "Error fetching details ,please refresh page:", context, Colors.red);
      //isProfileloading(false);
    } finally {
      isProfileloading(false);
    }
  }

  Future<void> fetchEducationList() async {
    isEducationLoading.value = true;
    var education = await _apiService.fetchEducation(); // Call instance method\
    // print all the countries with Good response message
    print("================== Education  ==================");
    print(education);

    if (education.isNotEmpty) {
      educationList.clear();

      educationList.assignAll(education);
      educationList.add("Any");
    }
    isEducationLoading.value = false;
  }

  Future<void> fetchReligions() async {
    try {
      isReligionLoading.value = true;
      var fetchedReligions = await _apiService.fetchReligions();
      religions.clear();
      // religionsLookingFor.clear();

      if (fetchedReligions.isNotEmpty) {
        religions.assignAll(fetchedReligions);
        religions.add("Any");
        //religions.add("Other");
        // religionsLookingFor.assignAll(fetchedReligions);
      } else {
        print('No religions found.');
      }
    } catch (e) {
      print('Error fetching religions: $e');
    } finally {
      isReligionLoading.value =
          false; // Ensure loading stops even if an error occurs
    }
  }

  Future<void> fetchCastData(String religion, bool isValuesClear) async {
    try {
      if (isValuesClear) {
        authController.caste.value = null;
        authController.lookingForCaste.value = null;
      }
      isCasteLoading(true);
      final data = await _apiService.fetchCastData(religion);
      castList.clear();
      castList.assignAll(data);
      casteNames.clear();
      casteNames.value =
          castList.map<String>((cast) => cast["cast"].toString()).toList();
      // castList.add({'cast': 'Other'});
      isCasteLoading(false);

      errorMessage('');
    } catch (e) {
      isCasteLoading(false);

      errorMessage(e.toString());
    } finally {
      isCasteLoading(false);
    }
  }

  Future<void> fetchSectData(
      String religion, String caste, bool isValuesClear) async {
    try {
      if (isValuesClear) {
        authController.sect.value = null;
        authController.lookingForSect.value = null;
      }
      isSectLoading(true);
      final data =
          await _apiService.fetchSectData(religion: religion, caste: caste);
      sectList.clear();
      sectList.assignAll(data);
      sectList.add("Any");
      isSectLoading(false);
    } catch (e) {
      isSectLoading(false);
      sectErrorMessage(e.toString());
    } finally {
      isSectLoading(false);
    }
  }

  Future<void> fetchCountryList() async {
    isCountryLoading.value = true;
    var countries = await _apiService.fetchCountries(); // Call instance method\
    // print all the countries with Good response message
    countryList.clear();

    if (countries.isNotEmpty) {
      countryList.assignAll(countries);
      countryList.add("Any");
    }
    isCountryLoading.value = false;
  }

  // Fetch cities based on the selected country
  Future<void> loadCities(String countryName, bool isValuesClear) async {
    isCityLoading.value = true;
    try {
      if (isValuesClear) {
        authController.cityOfResidence.value = null;
        authController.lookingForCity.value = null;
      }
      List<String> cities = await _apiService.fetchCities(countryName);

      cityOptions.clear();

      cityOptions.assignAll(cities);
      cityOptions.add("Any");
    } catch (e) {
      cityOptions.assignAll([]);
    } finally {
      isCityLoading.value = false;
    }
  }

  Future<void> fetchEthnicityData() async {
    try {
      isEthnicityLoading(true);
      final ApiService _apiService = ApiService();
      final data = await _apiService.fetchEthenicityList();
      ethnicityList.clear();
      ethnicityList.assignAll(data);
      ethnicityList.add("Any");
      isEthnicityLoading(false);
    } catch (e) {
      isEthnicityLoading(false);
      errorMessage(e.toString());
    } finally {
      isEthnicityLoading(false);
    }
  }

// Image file map
  final Map<String, Rx<File?>> imageFiles = {
    'profileimage': Rx<File?>(null),
  };

// Pick image from gallery only
  Future<void> pickImage(ImageSource source, String field) async {
    if (!await _handleGalleryPermission()) {
      Get.snackbar('Permission Denied', 'Permission denied to access gallery.',
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red);
      return;
    }

    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      imageFiles[field]?.value = File(pickedFile.path);
    }
  }

// Handle permissions properly for gallery
  Future<bool> _handleGalleryPermission() async {
    if (Platform.isAndroid) {
      // Request READ_MEDIA_IMAGES for Android 13+ or fallback to storage
      var photosPermission = await Permission.photos.request();

      if (photosPermission.isGranted) {
        return true;
      }

      // Fallback for Android 12 and below
      var storagePermission = await Permission.storage.request();
      return storagePermission.isGranted;
    } else if (Platform.isIOS) {
      // iOS uses photos permission
      PermissionStatus photosPermission = await Permission.photos.request();
      return photosPermission.isGranted;
    }

    return false;
  }

  bool validateAllFields() {
    bool allFieldsValid = true;

    controllers.forEach((key, controller) {
      if (controller.text.trim().isEmpty) {
        allFieldsValid = false;
      }
    });

    if (authController.height.value?.trim().isEmpty ?? true) {
      allFieldsValid = false;
    }

    if (authController.selectedGender.value?.trim().isEmpty ?? true) {
      allFieldsValid = false;
    }

    if (authController.educationLevel.value?.trim().isEmpty ?? true) {
      allFieldsValid = false;
    }
    if (authController.religion.value?.trim().isEmpty ?? true) {
      allFieldsValid = false;
    }
    if (authController.caste.value?.trim().isEmpty ?? true) {
      allFieldsValid = false;
    }
    if (authController.sect.value?.trim().isEmpty ?? true) {
      allFieldsValid = false;
    }
    if (authController.currentResidence.value?.trim().isEmpty ?? true) {
      allFieldsValid = false;
    }

    // FIX: Preserve value, only assign default if NULL or empty
    if (authController.cityOfResidence.value == null ||
        authController.cityOfResidence.value!.trim().isEmpty) {
      authController.cityOfResidence.value = "Unknown";
      allFieldsValid = false;
    }

    if (authController.ethnicity.value?.trim().isEmpty ?? true) {
      allFieldsValid = false;
    }

    return allFieldsValid;
  }

  bool isPasswordValid(String password) {
    final passwordRegex =
        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$');
    return passwordRegex.hasMatch(password);
  }

  Future<void> updateUserProfile() async {
    if (!validateAllFields()) {
      Get.snackbar("Error", "All fields are required",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    } else if (!isPasswordValid(controllers['password']!.text)) {
      Get.snackbar("Error",
          "Password must be at least 8 characters long and include at least one uppercase letter, one lowercase letter, one number, and one special character",
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
      'gender': authController.selectedGender.value?.trim() ?? '',
      'height': authController.height.value?.trim() ?? '',
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

  Rx<File?> selfieimage = Rx<File?>(null);
  Rx<File?> cninfront = Rx<File?>(null);
  Rx<File?> cninback = Rx<File?>(null);
  Rx<File?> passportfront = Rx<File?>(null);
  Rx<File?> passportback = Rx<File?>(null);
  final DocumentUploadController documentUploadController =
      Get.put(DocumentUploadController());

  final SelfieImageController _selfieImageController =
      Get.put(SelfieImageController());
  /*--------------------------------------------------------------*/
  /*                      update documents                        */
  /*--------------------------------------------------------------*/
  Future<void> updateDocuments(String status) async {
    isDocumentLoading(true);
    cninfront = documentUploadController.idCardFrontImage;
    cninback = documentUploadController.idCardBackImage;
    passportfront = documentUploadController.passportFrontImage;
    passportback = documentUploadController.passportBackImage;
    selfieimage = _selfieImageController.selfieImage;
    final prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('userid');
    if (userId == null || userId.isEmpty) {
      isDocumentLoading(false);
      return;
    }

    if (cninfront.value == null ||
        cninback.value == null ||
        selfieimage.value == null) {
      DialogHelper.showErrorDialog(
          "Please upload your clear and recent documents");

      isDocumentLoading(false);
      return;
    }

    var uri = Uri.parse(
        "https://projects.funtashtechnologies.com/gomeetapi/updateprofile.php");
    var request = http.MultipartRequest('POST', uri);
    request.fields['id'] = userId;
    request.fields['status'] = "verified";

    try {
      Future<void> addFile(String key, File? file) async {
        if (file != null && file.existsSync()) {
          request.files.add(await http.MultipartFile.fromPath(key, file.path));
        }
      }

      await addFile('cnic_front', cninfront.value);
      await addFile('cnic_back', cninback.value);
      await addFile('passport_front', passportfront.value);
      await addFile('passport_back', passportback.value);
      await addFile('selfieimage', selfieimage.value);

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseBody);

      if (jsonResponse["ResponseCode"] == "200") {
        DialogHelper.showSuccessDialog(
            "Your documents have been submitted successfully. Verification may take a moment to process");
      } else {
        DialogHelper.showErrorDialog(jsonResponse["ResponseMsg"]);
      }
    } catch (e) {
      DialogHelper.showErrorDialog(
          "Failed to upload your documents.Please try again");
    } finally {
      isDocumentLoading(false);
    }
  }
}
