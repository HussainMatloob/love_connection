import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ApiService/ApiService.dart';

class GetReceivedConnectionRequestController extends GetxController {
  // List to store send connection requests data
  var Getrequests = [].obs;
  var isLoading = true.obs; // To track loading state
  var errorMessage = ''.obs;
  var searchQuerytext = ''.obs; // To store search query text
  // Fetch send connection requests data from API

  @override
  void onInit() {
    super.onInit();
    fetchReceivedConnectionRequests();
  }

  Future<void> fetchReceivedConnectionRequests() async {
    try {

      final prefs = await SharedPreferences.getInstance();
      String  userID = prefs.getString("userid").toString();

      print("============================== USERS DATA SENDS REQUEST =============================");
      print("================================ User id is :${userID}========================================");
      // Call the API // Set loading to true
      final response = await ApiService().getSendConRequest(userId: userID);
      print("================================== RESPONSE ===================================");
      print(response);
      // Check if the response is successful
      if (response['Result'] == 'true') {
        // Update the list with the received data
        Getrequests.value = response['Data'];
      } else {
        // Set error message if the response is not successful
        errorMessage.value = response['ResponseMsg'];
      }


    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
    } finally {
      isLoading(false); // Set loading to false after completion
    }
  }
}
