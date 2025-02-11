import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ApiService/ApiService.dart';
import '../Models/GoaltargetQuestions.dart';

class GoalTargetQuestionController extends GetxController {
  var questions = <GoaltargetQuestions>[].obs;
  var isLoading = true.obs;
  var isSubmitting = false.obs;
  var selectedOptions = <String, String>{}.obs;

  final ApiService apiService = ApiService();

  void fetchGoalTargetQuestions(int categoryId) async {
    isLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final fetchedQuestions = await apiService.fetchGoalTargetQuestions();
      final filteredQuestions = fetchedQuestions.where((q) => q.categoryId == categoryId).toList();
      questions.assignAll(filteredQuestions);

      // Restore saved answers from SharedPreferences
      for (var question in questions) {
        String? savedAnswer = prefs.getString("goal_selected_answer_${question.id}");
        if (savedAnswer != null) {
          selectedOptions[question.id.toString()] = savedAnswer;
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load goal target questions", snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  void selectOption(int categoryId, String questionId, String option) async {
    selectedOptions[questionId] = option;
    await submitAnswer(categoryId, questionId, option);
  }

  Future<void> submitAnswer(int categoryId, String questionId, String answer) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString('userid');

      if (userId == null || userId.isEmpty) {
        Get.snackbar("Error", "User ID not found. Please log in again.",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      isSubmitting(true);

      final responseData = await ApiService.submitAnswer(
        userId: userId,
        categoryId: categoryId,
        questionId: questionId,
        answer: answer,
      );

      bool isSuccess = responseData["Result"] == true || responseData["Result"].toString() == "true";

      if (isSuccess) {
        await prefs.setString("goal_selected_answer_$questionId", answer);
        selectedOptions[questionId] = answer;

        Get.snackbar("Success", responseData["ResponseMsg"] ?? "Answer submitted successfully!",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar("Error", responseData["ResponseMsg"] ?? "Failed to submit answer",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: ${e.toString()}",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isSubmitting(false);
    }
  }
}
