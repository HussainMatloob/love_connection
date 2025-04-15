import 'dart:async';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ApiService/ApiService.dart';

class RatingController extends GetxController {
  var ratingPercentage = 0.0.obs; // Reactive variable
  final ApiService apiService = ApiService();
  Timer? _timer;
  int selectedCategoryId = 0; // Default value

  @override
  void onInit() {
    super.onInit();
    // fetchRating(); // Fetch when initialized
    startAutoRefresh(); // Auto-refresh every 5 seconds
    // now get it here from this int selectedCategoryId from shared preference
  }

  Future<void> fetchRating(String categoryID) async {
    print("Fetching Rating...");
    double? rating = await ApiService.fetchRatingPercentage(categoryID);

    if (rating != null) {
      print("API Returned Rating: $rating");
      ratingPercentage.value = rating; // Update reactive value
      update(); // Force UI update (Optional if using Obx)
    } else {
      print("Failed to fetch rating");
    }
  }

  void startAutoRefresh() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      final SharedPreferences prefs =await SharedPreferences.getInstance();
      selectedCategoryId= prefs.getInt('selectedCategoryId') ?? 0;
      fetchRating(selectedCategoryId.toString());
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
