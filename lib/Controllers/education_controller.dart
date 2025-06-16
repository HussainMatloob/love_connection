import 'package:get/get.dart';
import 'package:love_connection/ApiService/ApiService.dart';

class EducationController extends GetxController {
  var educationList = <String>[].obs;
  var isLoading = true.obs;
  final ApiService apiService = ApiService(); // Instance of API service

  @override
  void onInit() {
    fetchEducationList();
    super.onInit();
  }

  //Fetch education list from API
  void fetchEducationList() async {
    isLoading.value = true;
    var education = await apiService.fetchEducation(); // Call instance method\
    // print all the countries with Good response message
    print("================== Education  ==================");
    print(education);

    if (education.isNotEmpty) {
      educationList.clear();
      educationList.assignAll(education);
    }
    isLoading.value = false;
  }
}
