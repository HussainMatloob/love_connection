import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ApiService/ApiService.dart';
import '../Screens/SelectService.dart';
import '../Screens/bottom_nav/BottomNavbar.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  var isLoggedIn = false.obs;
  var userId = ''.obs;

  final ApiService apiService = ApiService();

  Future<void> login(String email, String password, int key) async {
    isLoading.value = true;
    try {
      final response = await apiService.loginUser(email, password);
      if (response['ResponseCode'] == '200' && response['Result'] == 'true') {
        isLoggedIn.value = true;
        userId.value = response['userid'].toString();
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('userid', userId.toString());
        print("User Login Succecfully and user id is : $userId");
        Get.snackbar('Success', response['ResponseMsg'],snackPosition: SnackPosition.BOTTOM);

        prefs.setString('registeredkey',key.toString());

        if(key == 1){
          Get.offAll(Bottomnavbar());
        }
        else{
          Get.offAll(SelectService());
        }
      } else {
        Get.snackbar('Error', 'Login failed: ${response['ResponseMsg']}');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
