import 'package:get/get.dart';
import '../ApiService/ApiService.dart';

class ReligionController extends GetxController {
  var religions = <String>[].obs;
  var isLoading = false.obs; // Start as false to prevent unnecessary loading
  final ApiService apiService = ApiService();

  @override
  void onInit() {
    fetchReligions();
    super.onInit();
  }

  // Fetch religions and update list
  Future<void> fetchReligions() async {
    try {
      isLoading.value = true;
      var fetchedReligions = await apiService.fetchReligions();

      if (fetchedReligions.isNotEmpty) {
        religions.assignAll(fetchedReligions);
        print('Religions: $religions');
      } else {
        print('No religions found.');
      }
    } catch (e) {
      print('Error fetching religions: $e');
    } finally {
      isLoading.value = false; // Ensure loading stops even if an error occurs
    }
  }
}
