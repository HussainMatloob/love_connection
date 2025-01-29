import 'package:get/get.dart';
import '../ApiService/ApiService.dart';
import '../Models/GoaltargetQuestions.dart';

class GoalTargetQuestionController extends GetxController {
  var questions = <GoaltargetQuestions>[].obs;
  var isLoading = true.obs;
  var selectedOptions = <String, String>{}.obs;

  final ApiService apiService = ApiService();
  void fetchGoalTargetQuestions(int categoryId) async {
    isLoading(true);
    try {
      final fetchedQuestions = await apiService.fetchGoalTargetQuestions();
      // Filter questions by categoryId
      final filteredQuestions = fetchedQuestions.where((q) => q.categoryId == categoryId).toList();
      questions.assignAll(filteredQuestions); // Assign the filtered questions
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to load goal target questions",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  // Handle selection of options for questions
  void selectOption(String questionId, String option) {
    selectedOptions[questionId] = option;
  }
}
