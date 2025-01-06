import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../ApiService/ApiService.dart';

class AcceptRequestController extends GetxController {
  final ApiService _apiService;
  var isLoading = false.obs;
  var responseMessage = ''.obs;

  AcceptRequestController(this._apiService);

  Future<void> acceptRequest({
    required String userId,
    required String connectionId,
  }) async {
    isLoading.value = true;
    try {
      final response = await _apiService.acceptRequest(
        userId: userId,
        connectionId: connectionId,
      );
      if (response['Result'] == 'true') {
        responseMessage.value = response['ResponseMsg'];
        Get.snackbar('Success', responseMessage.value,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.pinkAccent[800]);
      } else {
        responseMessage.value = response['ResponseMsg'];
      }
    } catch (e) {
      responseMessage.value = 'An error occurred: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
