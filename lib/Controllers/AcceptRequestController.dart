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
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green);
      } else {
        responseMessage.value = response['ResponseMsg'];
      }
    } catch (e) {
      responseMessage.value = 'An error occurred: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /*--------------------------------------------------*/
  /*               ignore send request                */
  /*--------------------------------------------------*/
  Future<void> ignoreRequest(var connectionUserId) async {
    try {
      final response = await ApiService.ignoreSendrequest(connectionUserId);

      if (response != null) {
        if (response.statusCode == 200) {
          //fetchPendingRequests();
          Get.snackbar(
            'Success',
            "Request ignore successfully",
            snackPosition: SnackPosition.BOTTOM,
            colorText: Colors.white,
            backgroundColor: Colors.green,
          );
        } else {
          //customerloadingFunction(false);
          Get.snackbar(
              'Error', "Request failed with status: ${response.statusCode}",
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red);
        }
      } else {
        Get.snackbar('Error', "Please try again",
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red);
      }
    } catch (e) {
      Get.snackbar('Error', "$e",
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red);
    }
  }
}
