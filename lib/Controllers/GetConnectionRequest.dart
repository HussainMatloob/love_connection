import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ApiService/ApiService.dart';

class GetReceivedConnectionRequestController extends GetxController {
  // List to store send connection requests data
  var Getrequests = <Map<String, String>>[].obs;
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

      if (response['ResponseCode'] == '200') {
        Getrequests.value =
            List<Map<String, String>>.from(response['Data'].map((request) {
          return {
            'firstname': request['firstname'],
            'lastname': request['lastname'],
            'profileimage': request['profileimage'],
            'city': request['city'],
            'id': request['id'],
          };
        }));
      } else {
        errorMessage.value = response['ResponseMsg'];
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
    } finally {
      isLoading(false); // Set loading to false after completion
    }
  }
}
