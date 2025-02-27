import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:love_connection/Screens/auth/Login.dart';

class ForgotPasswordController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var isEmailVerified = false.obs;
  var isLoadingVerify = false.obs;
  var isLoadingUpdate = false.obs;

  Future<void> verifyEmail() async {
    String email = emailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar("Error", "Please enter your email");
      return;
    }

    isLoadingVerify.value = true;  // Start loading

    try {
      var url = Uri.parse("https://projects.funtashtechnologies.com/gomeetapi/forgotpassword.php");
      var response = await http.post(url, body: {"email": email});

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true) {
          isEmailVerified.value = true;
          Get.snackbar("Success", "Email matches, enter new password");
        } else {
          Get.snackbar("Error", jsonResponse['message']);
        }
      } else {
        Get.snackbar("Error", "Server Error: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoadingVerify.value = false;  // Stop loading
    }
  }

  Future<void> updatePassword() async {
    String email = emailController.text.trim();
    String newPassword = passwordController.text.trim();

    if (newPassword.isEmpty) {
      Get.snackbar("Error", "Please enter a new password");
      return;
    }

    isLoadingUpdate.value = true;  // Start loading

    try {
      var url = Uri.parse("https://projects.funtashtechnologies.com/gomeetapi/updatepassword.php");
      var response = await http.post(url, body: {
        "email": email,
        "new_password": newPassword,
      });

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true) {
          Get.snackbar("Success", "Password updated successfully");
          Get.offAll(LoginScreen());
        } else {
          Get.snackbar("Error", jsonResponse['message']);
        }
      } else {
        Get.snackbar("Error", "Server Error: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoadingUpdate.value = false;  // Stop loading
    }
  }
}
