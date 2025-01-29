import 'package:get/get.dart';
import '../ApiService/ApiService.dart';
import '../Models/Questions.dart';

class AssessmentQuestionController extends GetxController {
  var questions = <Question>[].obs;
  var isLoading = true.obs;
  var selectedOptions = <String, String>{}.obs;

  final ApiService apiService = ApiService();

  void fetchQuestions(int categoryId) async {
    isLoading(true);
    try {
      final fetchedQuestions = await apiService.fetchAssessmentQuestions();
      questions.assignAll(
        fetchedQuestions.where((q) => q.categoryId == categoryId).toList(),
      );
    } catch (e) {
      Get.snackbar("Error", "Failed to load questions", snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  void selectOption(String questionId, String option) {
    selectedOptions[questionId] = option;
    update(); // Notify UI of state change
  }
}
