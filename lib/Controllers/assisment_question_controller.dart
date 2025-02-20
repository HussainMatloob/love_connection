import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ApiService/ApiService.dart';
import '../Models/Questions.dart';

class AssessmentQuestionController extends GetxController {
  var questions = <Question>[].obs;
  var isLoading = true.obs;
  var isSubmitting = false.obs;
  var selectedOptions = <String, String>{}.obs;
  var questionRatings = <String, int>{}.obs;

  void fetchQuestions(int categoryId) async {
    isLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final fetchedQuestions = await ApiService.fetchAssessmentQuestions();

      questions.assignAll(
        fetchedQuestions.where((q) => q.categoryId == categoryId).toList(),
      );

      for (var question in questions) {
        String? savedAnswer = prefs.getString("selected_answer_${question.id}");
        int? savedRating = prefs.getInt("rating_${question.id}");

        if (savedAnswer != null) {
          selectedOptions[question.id.toString()] = savedAnswer;
        }
        if (savedRating != null) {
          questionRatings[question.id.toString()] = savedRating;
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load questions", snackPosition: SnackPosition.BOTTOM);
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
        type: "assesment",
        answer: answer,
      );

      bool isSuccess = responseData["Result"] == true || responseData["Result"].toString() == "true";

      if (isSuccess) {
        dynamic rawRating = responseData["Data"]["rating"];
        int rating = 0;

        if (rawRating is int) {
          rating = rawRating;
        } else if (rawRating is String) {
          rating = int.tryParse(rawRating) ?? 0;
        }

        await prefs.setString("selected_answer_$questionId", answer);
        await prefs.setInt("rating_$questionId", rating);

        selectedOptions[questionId] = answer;
        questionRatings[questionId] = rating;

        Get.snackbar("Success", responseData["ResponseMsg"] ?? "Answer submitted successfully!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } else {
        Get.snackbar("Error", responseData["ResponseMsg"] ?? "Failed to submit answer",
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
} //this is the controller update it with new ui code only dont remove other code