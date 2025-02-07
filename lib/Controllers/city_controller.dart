import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../ApiService/ApiService.dart';
import 'AuthController.dart';

class CityController extends GetxController {
  var cityOptions = <String>[].obs;
  var isLoading = true.obs;
  final ApiService apiService = ApiService();

  final AuthController authController = Get.put(AuthController());

  @override
  void onInit() {
    super.onInit();

    // Listen for changes in currentResidence and fetch cities accordingly
    ever(authController.currentResidence, (String? countryName) {
      if (countryName != null && countryName.isNotEmpty) {
        loadCities(countryName);
      }
    });
  }

  // Fetch cities based on the selected country
  Future<void> loadCities(String countryName) async {
    try {
      isLoading.value = true;
      print('Country Name: $countryName');
      List<String> cities = await apiService.fetchCities(countryName);
      cityOptions.assignAll(cities); // Update the cityOptions list
    } catch (e) {
      print('Error fetching cities: $e');
      cityOptions.assignAll([]); // In case of error, set cityOptions to an empty list
    } finally {
      isLoading.value = false;
    }
  }
}
