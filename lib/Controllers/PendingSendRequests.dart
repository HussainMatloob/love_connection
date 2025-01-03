import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ApiService/ApiService.dart';

class GetPendingRequestsController extends GetxController{
  var isLoading = true.obs;
  var pendingRequests = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPendingRequests();
  }

  void fetchPendingRequests() async {
    try {
      isLoading(true);
      final prefs = await SharedPreferences.getInstance();
      String  userID = prefs.getString("userid").toString();
      print("================================ User id is :$userID========================================");

      // Call the API
      final response = await ApiService().getPendingRequests(userid: userID);
      // Check response and update the pendingRequests list
      if (response['ResponseCode'] == '200' && response['Result'] == 'true') {
        pendingRequests.value = response['Data'];
      } else {
        // Get.snackbar('Error', response['ResponseMsg']);
        print(response['ResponseMsg']);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

}