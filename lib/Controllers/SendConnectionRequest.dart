import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ApiService/ApiService.dart';

class SendConectionController extends GetxController {

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var successMessage = ''.obs;

  final ApiService apiService = ApiService();

  // Method to send a connection request
  Future<void> sendConnectionRequest(String userId, String connectionId) async {
    try {
      isLoading.value = true;
      final response = await apiService.sendConnectionRequest(
        userId: userId,
        connectionId: connectionId,
      );

      // Handle API response
      if (response['ResponseCode'] == '200') {
        successMessage.value = response['ResponseMsg'];
        Get.snackbar('Success', response['ResponseMsg'],
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.pink.withOpacity(0.8),
            colorText: Colors.white);
      } else {
        errorMessage.value = response['ResponseMsg'];
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
