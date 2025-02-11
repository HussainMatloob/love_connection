import 'package:get/get.dart';
import 'package:love_connection/ApiService/ApiService.dart';
import 'package:love_connection/Controllers/AuthController.dart';

class SectController extends GetxController {
  final ApiService _apiService = ApiService();
  final AuthController authController = Get.put(AuthController());
  final RxList<String> sectList = <String>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;



  @override
  void onInit() {
    super.onInit();

    // Listen for changes in religion or caste and fetch sect data
    everAll([authController.religion, authController.caste], (_) {
      print('Religion: ${authController.religion.value}, Caste: ${authController.caste.value}');

      if (authController.religion.value!.isNotEmpty || authController.caste.value!.isNotEmpty) {
        fetchSectData(
            religion: authController.religion.value.toString(),
            caste: authController.caste.toString()
        );
      }
    });
  }



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
