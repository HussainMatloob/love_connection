import 'package:get/get.dart';

import '../ApiService/ApiService.dart';

class GetConnectionsController extends GetxController{
  final ApiService _apiService;
  // Observables to manage state
  var isLoading = false.obs;
  var responseMessage = ''.obs;
  var connections =[].obs;
  var searchQuerytext = ''.obs;


  GetConnectionsController(this._apiService);
  Future<void> getconnections() async {
    isLoading.value = true; // Start loading
    try {
      final response = await _apiService.getConnections();

      if (response['Result'] == 'true') {
        responseMessage.value = response['ResponseMsg'];
        connections.value = response['ConnectionsData'];
        print("================================== CONNECTIONS DATA ===================================");
        print(connections);
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
}