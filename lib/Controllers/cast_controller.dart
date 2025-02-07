import 'package:get/get.dart';
import 'package:love_connection/Controllers/AuthController.dart';
import 'package:love_connection/ApiService/ApiService.dart';

class CastController extends GetxController {
  // Observable list to store cast names.
  var castNames = <String>[].obs;

  // Observable flag to indicate loading state.
  var isLoading = false.obs;

  // Instance of the ApiService.
  final ApiService apiService = ApiService();

  // Obtain the AuthController instance (adjust if needed).
  final AuthController authController = Get.put(AuthController());

  @override
  void onInit() {
    super.onInit();
    // Automatically call fetchCasts when the religion changes.
    ever(authController.religion, (String? religion) {
      if (religion != null && religion.isNotEmpty) {
        print('Religion Name from controller: $religion');
        fetchCasts(religion);
      }
    });
  }



  /// Fetches cast names for the given [religion] and updates [castNames].
  void fetchCasts(String religion) async {

    print('Religion Name ////// : $religion');
    try {
      isLoading.value = true;
      // Ensure the [religion] parameter is passed as required.
      final List<String> fetchedCasts = await apiService.fetchCasts1(religion);
      // Update the observable list with the fetched cast names.
      castNames.assignAll(fetchedCasts);
    } catch (error) {
      print("Error fetching cast data: $error");
    } finally {
      isLoading.value = false;
    }
  }
}
