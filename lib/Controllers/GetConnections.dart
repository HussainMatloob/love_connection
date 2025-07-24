import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../ApiService/ApiService.dart';

class GetConnectionsController extends GetxController {
  final ApiService _apiService;
  // Observables to manage state
  var isLoading = false.obs;
  var responseMessage = ''.obs;
  var connections = [].obs;
  var searchQuerytext = ''.obs;

  GetConnectionsController(this._apiService);
  Future<void> getconnections() async {
    isLoading.value = true; // Start loading
    try {
      final response = await _apiService.getConnections();

      if (response['Result'] == 'true') {
        responseMessage.value = response['ResponseMsg'];
        connections.value = response['ConnectionsData'];
        // print(
        //     "================================== CONNECTIONS DATA ===================================");
        // print(connections);
      } else {
        responseMessage.value = response['ResponseMsg'];
      }
    } catch (e) {
      // Handle any unexpected exceptions
      responseMessage.value = 'An error occurred: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /*--------------------------------------------------*/
  /*                   Unfollow user                  */
  /*--------------------------------------------------*/
  Future<void> unfollowUser(var specificPersonSendRequest) async {
    try {
      final response = await ApiService.unfollow(specificPersonSendRequest);

      if (response != null) {
        if (response.statusCode == 200) {
          //connections.clear();
          // getconnections();
          Get.snackbar(
            'Success',
            "User Unfollow successfully",
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
