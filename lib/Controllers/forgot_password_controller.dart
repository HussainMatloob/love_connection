import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:love_connection/ApiService/Auth_Service.dart';
import 'package:love_connection/Screens/auth/Login.dart';

class ForgotPasswordController extends GetxController {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  var isEmailVerified = false.obs;
  var isLoadingVerify = false.obs;
  var isLoadingUpdate = false.obs;
  var isPasswordHidden = true.obs;
  var passwordErrorMessage = "".obs;

  // Toggle Password Visibility
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // Validate Password Strength
  void validatePassword(String password) {
    if (password.length < 8) {
      passwordErrorMessage.value = "Password must be at least 8 characters long.";
    } else if (!RegExp(r'(?=.*[A-Z])').hasMatch(password)) {
      passwordErrorMessage.value = "Include at least one uppercase letter.";
    } else if (!RegExp(r'(?=.*\d)').hasMatch(password)) {
      passwordErrorMessage.value = "Include at least one number.";
    } else if (!RegExp(r'(?=.*[@$!%*?&])').hasMatch(password)) {
      passwordErrorMessage.value = "Include at least one special character.";
    } else {
      passwordErrorMessage.value = "";
    }
  }

  // Verify Email
  Future<void> verifyEmail() async {
    isLoadingVerify.value = true;
    var response = await AuthService.verifyEmail(emailController.text);
    isLoadingVerify.value = false;

    if (response['status']) {
      isEmailVerified.value = true;
      Get.snackbar("Success", "Email verified successfully!", backgroundColor: Colors.green, colorText: Colors.white);
    } else {
      Get.snackbar("Error", "Email not found!", backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // Update Password
  Future<void> updatePassword() async {
    if (passwordErrorMessage.value.isNotEmpty) {
      Get.snackbar("Weak Password", passwordErrorMessage.value, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoadingUpdate.value = true;
    var response = await AuthService.updatePassword(emailController.text, passwordController.text);
    isLoadingUpdate.value = false;

    if (response['status']) {
      Get.snackbar("Success", "Password updated successfully!", backgroundColor: Colors.green, colorText: Colors.white);
      Get.offAll(LoginScreen());
    } else {
      Get.snackbar("Error", "Password update failed!", backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
