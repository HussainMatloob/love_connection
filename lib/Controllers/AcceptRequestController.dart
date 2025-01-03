import 'package:get/get.dart';

import '../ApiService/ApiService.dart';

class AcceptRequestController extends GetxController{
  final ApiService _apiService;

  // Observables to manage state
  var isLoading = false.obs;
  var responseMessage = ''.obs;

  AcceptRequestController(this._apiService);

  Future<void> acceptRequest({
    required String userId,
    required String connectionId,
  }) async {
    isLoading.value = true; // Start loading
    try {
      final response = await _apiService.acceptRequest(
        userId: userId,
        connectionId: connectionId,
      );

      // Update response message based on API result
      if (response['Result'] == 'true') {
        responseMessage.value = response['ResponseMsg']; // Success message
      } else {
        responseMessage.value = response['ResponseMsg']; // Failure message
      }
    } catch (e) {
      // Handle any unexpected exceptions
      responseMessage.value = 'An error occurred: $e';
    } finally {
      isLoading.value = false; // Stop loading
    }
  }
}