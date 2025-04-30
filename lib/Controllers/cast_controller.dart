import 'package:get/get.dart';
import 'package:love_connection/Controllers/AuthController.dart';
import 'package:love_connection/ApiService/ApiService.dart';

class CastController extends GetxController {
  final ApiService _apiService = ApiService();
  final RxList<Map<String, dynamic>> castList = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final AuthController authController = Get.put(AuthController());
  final RxString religion1 = ''.obs;

  @override
  void onInit() {
    ever(authController.religion, (String? religion) {
      if (religion != null && religion.isNotEmpty) {
        print('Religion Name from controller: $religion');
        fetchCastData(religion);
        religion1.value = religion;
      }
    });
    super.onInit();
    fetchCastData(religion1.value.toString());
  }

  Future<void> fetchCastData(String religion) async {
    try {
      isLoading(true);
      final data = await _apiService.fetchCastData(religion);
      castList.assignAll(data);
      isLoading(false);
      castList.refresh();

      errorMessage('');
    } catch (e) {
      isLoading(false);
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }
}
