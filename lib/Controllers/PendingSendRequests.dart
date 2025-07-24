import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../ApiService/ApiService.dart';

class GetPendingRequestsController extends GetxController {
  var isLoading = true.obs;
  var pendingRequests = [].obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPendingRequests();
  }

  Future<void> fetchPendingRequests() async {
    try {
      isLoading(true);
      // Call the API
      final response = await ApiService().getPendingRequests();
      if (response['ResponseCode'] == '200' && response['Result'] == 'true') {
        pendingRequests.value = response['Data'];
        // print("=======================+++++++++++${pendingRequests}");
      } else {
        return errorMessage.value = response['ResponseMsg'];
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  /*--------------------------------------------------*/
  /*               Cancel send request                */
  /*--------------------------------------------------*/
  Future<void> cancelRequest(var specificPersonSendRequest) async {
    try {
      final response =
          await ApiService.cancelSendrequest(specificPersonSendRequest);

      if (response != null) {
        if (response.statusCode == 200) {
          //fetchPendingRequests();
          Get.snackbar(
            'Success',
            "Request cancelled successfully",
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
