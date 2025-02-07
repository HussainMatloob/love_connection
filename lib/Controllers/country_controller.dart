import 'package:get/get.dart';
import '../ApiService/ApiService.dart';

class CountryController extends GetxController {
  var countryList = <String>[].obs;
  var isLoading = true.obs;
  final ApiService apiService = ApiService(); // Instance of API service

  @override
  void onInit() {
    fetchCountryList();
    super.onInit();
  }

  // Fetch country list from API
  void fetchCountryList() async {
    isLoading.value = true;
    var countries = await apiService.fetchCountries(); // Call instance method
    if (countries.isNotEmpty) {
      countryList.assignAll(countries);
    }
    isLoading.value = false;
  }
}
