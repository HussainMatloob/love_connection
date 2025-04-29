import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:love_connection/Screens/Service_selection_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ApiService/ApiService.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  var isLoggedIn = false.obs;
  var userId = ''.obs;
  var isPasswordHidden = true.obs;
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  final ApiService apiService = ApiService();
  Future<void> login(
    String email,
    String password,
  ) async {
    isLoading.value = true;
    try {
      final response = await apiService.loginUser(email, password);
      if (response['ResponseCode'] == '200' && response['Result'] == 'true') {
        isLoggedIn.value = true;
        userId.value = response['userid'];
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('userid', userId.toString());
        print("User Login Successfully and user id is : $userId");

        // Elegant, Simple Success Dialog
        Get.dialog(
          Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor:
                const Color(0xFFFFF1F3), // Light romantic pink background
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.favorite,
                    color: Color(0xFFFC3C5B),
                    size: 50,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Welcome to Love Connection 💕',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFC3C5B), // Deep romantic pink
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    response['ResponseMsg'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Get.back(); // Close the dialog
                      Get.offAll(ServiceSelectionScreen());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFC3C5B), // Romantic pink
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 36),
                    ),
                    child: const Text(
                      "Let's Begin",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        Get.snackbar('Error', 'Login failed: ${response['ResponseMsg']}');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
