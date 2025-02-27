import 'package:get/get.dart';
import 'package:love_connection/Screens/Service_selection_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ApiService/ApiService.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  var isLoggedIn = false.obs;
  var userId = ''.obs;

  var isPasswordHidden = true.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  final ApiService apiService = ApiService();
  Future<void> login(
    String email,
    String password,
  ) async {
    isLoading.value = true;
    try {
      final response = await apiService.loginUser(email, password);
      if (response['ResponseCode'] == '200' && response['Result'] == 'true') {
        isLoggedIn.value = true;
        userId.value = response['userid'].toString();
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('userid', userId.toString());
        print("User Login Succecfully and user id is : $userId");
        Get.snackbar('Success', response['ResponseMsg'],
            snackPosition: SnackPosition.BOTTOM);
        Get.offAll(ServiceSelectionScreen());
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
