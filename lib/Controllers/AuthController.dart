import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:love_connection/Screens/bottom_nav/BottomNavbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ApiService/ApiService.dart';
import 'ProfilePictureController.dart';

class AuthController extends GetxController {

  final ProfilepictureController profilepictureController =
  Get.put(ProfilepictureController());
  // Observables
  var isLoading = false.obs; // To manage loading state
  var errorMessage = ''.obs; // To manage error messages
  var userData = {}.obs; // Store user data if needed (e.g., user profile)
  Rx<File?> profileImage = Rx<File?>(null);

  final firstName = ''.obs;
  final lastName = ''.obs;
  final gender = Rxn<String>();
  final dateOfBirth = Rxn<DateTime>();

  // Second form fields
  final height = Rxn<String>();
  final maritalStatus = Rxn<String>();
  final religion = Rxn<String>();
  final lookingForReligion = Rxn<String>();
  final nationality = Rxn<String>();
  final lookingForNationality = Rxn<String>();

  // Page control
  void setGender(String? value) => gender.value = value;
  void setDateOfBirth(DateTime? value) => dateOfBirth.value = value;

  // New fields for preferences
  final educationLevel = Rxn<String>();
  final lookingForEducation = Rxn<String>();
  final employmentStatus = Rxn<String>();
  final monthlyIncome = Rxn<String>();
  final currentResidence = Rxn<String>();
  final lookingForResidence = Rxn<String>();

  // Method to update the profile image
  void updateProfileImage(File image) {
    profileImage.value = image;
  }

  Rx<File?> getprofileimage(){
    return profilepictureController.profileImage;
  }

  final List<String> educationOptions = [
    'High School',
    'Bachelor\'s Degree',
    'Master\'s Degree',
    'Doctorate',
    'Other'
  ];

  final List<String> employmentOptions = [
    'Employed',
    'Self-Employed',
    'Business Owner',
    'Student',
    'Unemployed'
  ];

  final List<String> incomeOptions = [
    'Less than 1000',
    'Greater than 1000, less than 3000',
    'Greater than 3000'
  ];

  final List<String> countryOptions = [
    'United States',
    'United Kingdom',
    'Canada',
    'Australia',
    'Other'
  ];

  // Dropdown options
  final List<String> heightOptions = [ '4\'8"', '4\'9"', '4\'10"', '4\'11"', '5\'0"', '5\'1"', '5\'2"', '5\'3"', '5\'4"', '5\'5"', '5\'6"', '5\'7"', '5\'8"', '5\'9"', '5\'10"', '5\'11"', '6\'0"', '6\'1"', '6\'2"', '6\'3"', '6\'4"', '6\'5"', '6\'6"', '6\'7"', '6\'8"', '6\'9"', '6\'10"', '6\'11"', '7\'0"'];
  final List<String> maritalStatusOptions = ['Single', 'Divorced', 'Widowed', 'Separated'];
  final List<String> religionOptions = ['Islam', 'Christianity', 'Judaism', 'Hinduism', 'Buddhism', 'Other'];
  final List<String> nationalityOptions = ['American', 'British', 'Canadian', 'Australian', 'Indian', 'Pakistani', 'Other'];

  // Preferences fields
  final cityOfResidence = Rxn<String>();
  final lookingForCity = Rxn<String>();
  final caste = Rxn<String>();
  final lookingForCaste = Rxn<String>();
  final subCaste = Rxn<String>();
  final lookingForSubCaste = Rxn<String>();
  final sect = Rxn<String>();
  final lookingForSect = Rxn<String>();
  final subSect = Rxn<String>();
  final lookingForSubSect = Rxn<String>();
  final ethnicity = Rxn<String>();
  final lookingForEthnicity = Rxn<String>();

  // Dropdown options
  final cityOptions = ['New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix'];
  final casteOptions = ['Brahmin', 'Kshatriya', 'Vaishya', 'Shudra'];
  final subCasteOptions = ['Sub-Caste 1', 'Sub-Caste 2', 'Sub-Caste 3'];
  final sectOptions = ['Sunni', 'Shia', 'Ahmadiyya', 'Ibadi'];
  final subSectOptions = ['Sub-Sect 1', 'Sub-Sect 2', 'Sub-Sect 3'];
  final ethnicityOptions = ['Asian', 'African', 'European', 'Hispanic'];

  String validateFields() {
    // get the image from profilepicturecontroller
    profileImage = profilepictureController.profileImage;
    if (firstName.value.isEmpty) return 'First Name is required.';
    if (lastName.value.isEmpty) return 'Last Name is required.';
    if (height.value == null) return 'Height is required.';
    if (caste.value == null) return 'Caste is required.';
    if (cityOfResidence.value == null) return 'City of Residence is required.';
    if (dateOfBirth.value == null) return 'Date of Birth is required.';
    if (educationLevel.value == null) return 'Education Level is required.';
    if (gender.value == null) return 'Gender is required.';
    if (maritalStatus.value == null) return 'Marital Status is required.';
    if (nationality.value == null) return 'Nationality is required.';
    if (religion.value == null) return 'Religion is required.';
    if (profileImage.value == null) return 'Profile Image is required.';
    return ''; // No errors
  }

  final ApiService _apiService = ApiService();

  Future<void> registerUser() async {
    // Validate the required fields before submitting
    final validationError = validateFields();
    if (validationError.isNotEmpty) {
      Get.snackbar(
        'Error',
        validationError,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    // Ensure that the profile image is not null
    if (profileImage.value == null) {
      Get.snackbar(
        'Error',
        'Please upload a profile image.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }
    // Start loading state
    isLoading(true);
    errorMessage('');

    try {
      // Send the registration request to the API service
      final response = await _apiService.registerUser(
        firstname: firstName.value.toString(),
        lastname: lastName.value.toString(),
        height: height.value.toString(),
        cast: caste.value.toString(),
        subcast: subCaste.value.toString(),
        sect: sect.value.toString(),
        subsect: subSect.value.toString(),
        castlookingfor: lookingForCaste.value.toString(),
        city: cityOfResidence.value.toString(),
        citylookingfor: lookingForCity.value.toString(),
        dateofbirth: dateOfBirth.value.toString(),
        education: educationLevel.value.toString(),
        educationlookingfor: lookingForEducation.value.toString(),
        ethnicity: ethnicity.value.toString(),
        ethnicitylookingfor: lookingForEthnicity.value.toString(),
        gender: gender.value.toString(),
        maritalstatus: maritalStatus.value.toString(),
        nationality: nationality.value.toString(),
        nationalitylookingfor: lookingForNationality.value.toString(),
        profileimage:File(profileImage.value!.path), // Send the profile image
        religion: religion.value.toString(),
        religionlookingfor: lookingForReligion.value.toString(),
        sectlookingfor: lookingForSect.value.toString(),
        subcastlookingfor: lookingForCaste.value.toString(),
        subsectlookingfor: lookingForSubSect.value.toString(),
      );

      // Handle the response from the API service
      if ( response['ResponseCode'] == '200') {

        Get.snackbar(
          'Success',
          'Registration successful!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
        );
        // Save the user ID to shared preferences
        // Navigate to next screen or show confirmation
        Get.offAll(Bottomnavbar());
      } else {
        Get.snackbar(
          'Error',
          response['error'] ?? 'An unknown error occurred',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Handle any errors that occur during the API call
      errorMessage(e.toString());
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      // Always stop loading state
      isLoading(false);
    }
  }

  // Example of logout method
  void logout() {
    userData({}); // Clear user data
    Get.snackbar('Logged out', 'You have been logged out.');
  }
}
