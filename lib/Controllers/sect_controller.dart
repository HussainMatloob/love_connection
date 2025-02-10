import 'package:get/get.dart';
import 'package:love_connection/ApiService/ApiService.dart';
import 'package:love_connection/Controllers/AuthController.dart';

class SectController extends GetxController {
  final ApiService _apiService = ApiService();
  final AuthController authController = Get.put(AuthController());
  final RxList<String> sectList = <String>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;




  Future<void> fetchSectData({required String religion, required String caste}) async {
    try {
      isLoading(true);
      final data = await _apiService.fetchSectData(religion: religion, caste: caste);
      sectList.assignAll(data);
      isLoading(false);
      errorMessage('');
    } catch (e) {
      isLoading(false);
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }
}
