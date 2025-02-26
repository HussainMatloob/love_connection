import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ApiService/ApiService.dart';

class GetUsersController extends GetxController {
  var isLoading = true.obs;
  var users = [].obs;

  // Instance of API Service
  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  void fetchUsers() async {
    try {
      isLoading(true);
      // get it here from shared preferences
      final userID; 
      
      final prefs = await SharedPreferences.getInstance();
      userID = prefs.getString("userid").toString();
      
      print("============================== USERS DATA =============================");
      print("================================ User id is :${userID}========================================");
      // Call the API
      final response = await _apiService.getUsers(userId: userID);

      // Check response and update the users list
      if (response['ResponseCode'] == '200' && response['Result'] == 'true') {
        print("============================ FETCH USERS ===============================");
        print("==============================${response['ResponseMsg']}=============================");
        print(response['Data']);
        print("===========================================================");
        users.value = response['Data'];
      } else {
        // Get.snackbar('Error', response['ResponseMsg']);
      }
    } catch (e) {
      // Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
