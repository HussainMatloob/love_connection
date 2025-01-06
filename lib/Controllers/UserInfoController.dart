import 'package:get/get.dart';

import '../ApiService/ApiService.dart';

class UserController extends GetxController {
  final ApiService apiService;

  UserController(this.apiService);

  // Observables
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var userData = Rxn<Map<String, dynamic>>(); // Stores the user data

  // Method to fetch user data
  Future<void> fetchUserData() async {
    try {
      isLoading.value = true; // Start loading
      errorMessage.value = ''; // Clear error message

      final response = await apiService.GetUserInfo();

      if (response['ResponseCode'] == '200' && response['Result'] == 'true') {
        userData.value = response['UserData']; // Set user data
      } else {
        errorMessage.value = response['ResponseMsg']; // Set error message
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
    } finally {
      isLoading.value = false; // Stop loading
    }
  }




}
