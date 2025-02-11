import 'dart:async';
import 'package:get/get.dart';
import '../ApiService/ApiService.dart';

class RatingController extends GetxController {
  var ratingPercentage = 0.0.obs;
  final ApiService apiService = ApiService();
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    fetchRating();
    // Automatically refresh rating every 5 seconds
    ever(ratingPercentage, (_) => fetchRating());
    startAutoRefresh();

  }

  void fetchRating() async {

    double? rating = await ApiService.fetchRatingPercentage();
    if (rating != null) {
      ratingPercentage.value = rating;
    }
  }

  void startAutoRefresh() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      fetchRating();
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
