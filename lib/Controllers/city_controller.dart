import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/rx_workers.dart';

import '../ApiService/ApiService.dart';
import 'AuthController.dart';

class CityController extends GetxController {
  var cityOptions = <String>[].obs; // Cities for current residence
  var lookingForCityOptions = <String>[].obs; // Cities for looking for residence
  var isLoading = false.obs;
  final ApiService apiService = ApiService();
  final AuthController authController = Get.put(AuthController());

  @override
  void onInit() {
    super.onInit();

    // Listen for currentResidence country change
    ever(authController.currentResidence, (String? countryName) {
      if (countryName != null && countryName.isNotEmpty) {
        loadCities(countryName, isLookingFor: false);
      }
    });

    // Listen for lookingForResidence country change
    ever(authController.lookingForResidence, (String? countryName) {
      if (countryName != null && countryName.isNotEmpty) {
        loadCities(countryName, isLookingFor: true);
      }
    });
  }

  // Fetch cities based on the selected country
  Future<void> loadCities(String countryName, {required bool isLookingFor}) async {
    try {
      isLoading.value = true;
      List<String> cities = await apiService.fetchCities(countryName);

      if (isLookingFor) {
        // Ensure the selected value is valid
        if (!cities.contains(authController.lookingForCity.value)) {
          authController.lookingForCity.value = null; // Reset if not found
        }
        lookingForCityOptions.assignAll(cities);
      } else {
        // Ensure the selected value is valid
        if (!cities.contains(authController.cityOfResidence.value)) {
          authController.cityOfResidence.value = null; // Reset if not found
        }
        cityOptions.assignAll(cities);
      }
    } catch (e) {
      print('Error fetching cities: $e');
      if (isLookingFor) {
        lookingForCityOptions.assignAll([]);
      } else {
        cityOptions.assignAll([]);
      }
    } finally {
      isLoading.value = false;
    }
  }

}
