import 'package:get/get.dart';
import '../ApiService/ApiService.dart';
import '../Models/GoalTarget.dart';

class GoalTargetController extends GetxController {
  var goalTargets = <GoalTarget>[].obs;
  var isLoading = true.obs;

  final ApiService apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    fetchGoalTargets();
  }

  void fetchGoalTargets() async {
    isLoading(true);
    try {
      final fetchedGoalTargets = await apiService.fetchGoalTargets();
      goalTargets.assignAll(fetchedGoalTargets);
    } catch (e) {
      Get.snackbar("Error", "Failed to load Goal Targets", snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }
}
