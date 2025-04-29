import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../ApiService/ApiService.dart';

class SendConectionController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var successMessage = ''.obs;

  final ApiService apiService = ApiService();

  // Method to send a connection request
  Future<void> sendConnectionRequest(int userId, String connectionId) async {
    try {
      isLoading.value = true;

      final response = await apiService.sendConnectionRequest(
        userId: userId,
        connectionId: connectionId,
      );

      if (response['ResponseCode'] == '200') {
        successMessage.value = response['ResponseMsg'];

        // Romantic success dialog
        Get.dialog(
          Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: const Color(0xFFFFF1F3),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.favorite_border,
                    color: Color(0xFFFC3C5B),
                    size: 50,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Connection Sent 💌',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFC3C5B),
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
                    onPressed: () => Get.back(), // Close the dialog
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFC3C5B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 36),
                    ),
                    child: const Text(
                      "Sweet ❤️",
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
        errorMessage.value = response['ResponseMsg'];
        Get.snackbar(
          'Error',
          response['ResponseMsg'],
          backgroundColor: Colors.redAccent.withOpacity(0.8),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again later.',
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
