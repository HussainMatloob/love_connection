import 'package:get/get.dart';

import '../ApiService/ApiService.dart';

class GetConnectionsController extends GetxController{
  final ApiService _apiService;

  // Observables to manage state
  var isLoading = false.obs;
  var responseMessage = ''.obs;
  // creata a variable for list of connections
  var connections = [].obs;

  GetConnectionsController(this._apiService);

  Future<void> getconnections({
    required String userId,
    required String connectionId,
  }) async {
    isLoading.value = true; // Start loading
    try {
      final response = await _apiService.getConnections(
      );

      // Update response message based on API result
      if (response['Result'] == 'true') {
        responseMessage.value = response['ResponseMsg']; // Success message
        connections.value = response['ConnectionsData']; // Set connections
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