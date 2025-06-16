import 'package:get/get.dart';
import 'package:love_connection/ApiService/ApiService.dart';

class EthnicityController extends GetxController {
  final RxList<String> ethnicityList = <String>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  void onInit() {
    fetchEthnicityData();
    super.onInit();
  }

  Future<void> fetchEthnicityData() async {
    try {
      isLoading(true);
      final ApiService _apiService = ApiService();
      final data = await _apiService.fetchEthenicityList();
      ethnicityList.clear();
      ethnicityList.assignAll(data);
      isLoading(false);
    } catch (e) {
      isLoading(false);
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }
}
