import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:love_connection/Controllers/ProfilePictureController.dart';

import '../Screens/bottom_nav/BottomNavbar.dart';
import 'AuthController.dart';

class BasicInfoController extends GetxController {
// Initialize the controller

  // get the image from profileimagecontroller
  // add isLoading and errorMessage to manage loading state and error messages
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var userData = {}.obs;


  final currentFormPage = 0.obs;



  final currentPage = 0.obs;
  final MatchescurrentPage = 0.obs;


  void nextPage() => currentPage.value = 1;
  void previousPage() => currentPage.value = 0;


  // Options lists







// create a function to post basic info data to auth controller data for registraion
//   Future<void> registerUser() async {
//     // Get the AuthController instance
//     final authController = Get.put(AuthController());
//
//     final validationError = validateFields();
//     if (validationError.isNotEmpty) {
//       Get.snackbar(
//         'Error',
//         validationError,
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red.withOpacity(0.8),
//         colorText: Colors.white,
//       );
//       return;
//     }
//
//
//     // Post the data to the AuthController
//     try {
//       isLoading(true);
//       errorMessage('');
//
//       print("First Name: ${firstName.value}");
//       print("Last Name: ${lastName.value}");
//       print("Date of birth: ${dateOfBirth.value}");
//       print("Gender : ${gender.value}");
//
//       profileImage= profilepictureController.profileImage;
//
//
//       await authController.registerUser(
//         firstname: firstName.value.toString(),
//         lastname: lastName.value.toString(),
//         height: height.value.toString(),
//         cast: caste.value.toString(),
//         subcast: subCaste.value.toString(),
//         sect: sect.value.toString(),
//         subsect: subSect.value.toString(),
//         castlookingfor: lookingForCaste.value.toString(),
//         city: cityOfResidence.value.toString(),
//         citylookingfor: lookingForCity.value.toString(),
//         dateofbirth: dateOfBirth.value.toString(),
//         education: educationLevel.value.toString(),
//         educationlookingfor: lookingForEducation.value.toString(),
//         ethnicity: ethnicity.value.toString(),
//         ethnicitylookingfor: lookingForEthnicity.value.toString(),
//         gender: gender.value.toString(),
//         maritalstatus: maritalStatus.value.toString(),
//         nationality: nationality.value.toString(),
//         nationalitylookingfor: lookingForNationality.value.toString(),
//         profileimage: File(profileImage.value!.path),
//         religion: religion.value.toString(),
//         religionlookingfor: lookingForReligion.value.toString(),
//         sectlookingfor: lookingForSect.value.toString(),
//         subcastlookingfor: lookingForCaste.value.toString(),
//         subsectlookingfor: lookingForSubSect.value.toString(),
//       );
//
//
//     } catch (e) {
//       errorMessage(e.toString());
//       Get.snackbar(
//         'Error',
//         'An error occurred: $e',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red.withOpacity(0.8),
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading(false);
//     }
//   }

}
