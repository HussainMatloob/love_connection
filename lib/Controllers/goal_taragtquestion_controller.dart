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
  var questionRatings = <String, int>{}.obs;

  final ApiService apiService = ApiService();

  void fetchGoalTargetQuestions(int categoryId) async {
    isLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final fetchedQuestions = await apiService.fetchGoalTargetQuestions();
      final filteredQuestions = fetchedQuestions.where((q) =>
      q.categoryId == categoryId).toList();
      questions.assignAll(filteredQuestions);

      for (var question in questions) {
        String? savedAnswer = prefs.getString(
            "goal_selected_answer_${question.id}");
        int? savedRating = prefs.getInt("goal_rating_${question.id}");

        if (savedAnswer != null) {
          selectedOptions[question.id.toString()] = savedAnswer;
        }
        if (savedRating != null) {
          questionRatings[question.id.toString()] = savedRating;
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load goal target questions",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  void selectOption(int categoryId, String questionId,
      String selectedOption) async {
    selectedOptions[questionId] = selectedOption;
    selectedOptions.refresh(); // 🔥 Ensures UI updates properly
    await submitAnswer(categoryId, questionId, selectedOption.trim());
  }

  Future<void> submitAnswer(int categoryId, String questionId,
      String answer) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString('userid');

      if (userId == null || userId.isEmpty) {
        Get.snackbar("Error", "User ID not found. Please log in again.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return;
      }

      isSubmitting(true);

      final responseData = await ApiService.submitAnswer(
        userId: userId,
        categoryId: categoryId,
        questionId: questionId,
        type: "goals",
        answer: answer,
      );

      bool isSuccess = responseData["Result"] == true ||
          responseData["Result"].toString() == "true";

      if (isSuccess) {
        dynamic rawRating = responseData["Data"]["rating"];
        int rating = 0;

        if (rawRating is int) {
          rating = rawRating;
        } else if (rawRating is String) {
          rating = int.tryParse(rawRating) ?? 0;
        }

        await prefs.setString("goal_selected_answer_$questionId", answer);
        await prefs.setInt("goal_rating_$questionId", rating);

        selectedOptions[questionId] = answer;
        questionRatings[questionId] = rating;
        selectedOptions.refresh(); // 🔥 Ensures UI updates correctly

        Get.snackbar("Success",
            responseData["ResponseMsg"] ?? "Answer submitted successfully!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } else {
        Get.snackbar(
            "Error", responseData["ResponseMsg"] ?? "Failed to submit answer",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: ${e.toString()}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isSubmitting(false);
    }
  }

  /// Calculate Total Rating
  int getTotalRating() {
    return questionRatings.values.fold(0, (sum, rating) => sum + rating);
  }

  /// Calculate Average Rating (Percentage)
  double getAverageRating() {
    if (questionRatings.isEmpty) return 0;
    int total = getTotalRating();
    int count = questionRatings.length;
    return (total / (count * 5)) * 100;
  }

}