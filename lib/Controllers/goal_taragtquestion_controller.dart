import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ApiService/ApiService.dart';
import '../Models/GoaltargetQuestions.dart';

class GoalTargetQuestionController extends GetxController {
  var questions = <GoaltargetQuestions>[].obs;
  var isLoading = true.obs;
  var isSubmitting = false.obs;
  // Store multiple selections per question.
  var selectedOptions = <String, List<String>>{}.obs;
  var questionRatings = <String, int>{}.obs;

  // Reactive variable to hold badge points.
  var badgePoints = 0.obs;

  final ApiService apiservice = ApiService();

  void fetchGoalTargetQuestions(int categoryId) async {
    isLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final fetchedQuestions = await apiservice.fetchGoalTargetQuestions();
      final filteredQuestions =
      fetchedQuestions.where((q) => q.categoryId == categoryId).toList();

      // If no questions are found for this category, clear everything.
      if (filteredQuestions.isEmpty) {
        questions.assignAll([]);
        badgePoints.value = 0;
        await prefs.remove("badgePoints_category_$categoryId");
        isLoading(false);
        return;
      }

      questions.assignAll(filteredQuestions);

      for (var question in questions) {
        String? savedAnswer = prefs.getString("goal_selected_answer_${question.id}");
        int? savedRating = prefs.getInt("goal_rating_${question.id}");

        if (savedAnswer != null) {
          // Split the stored answer by '-' to create a list.
          selectedOptions[question.id.toString()] =
              savedAnswer.split('-').map((e) => e.trim()).toList();
        }
        if (savedRating != null) {
          questionRatings[question.id.toString()] = savedRating;
        }
      }

      // Load stored badge points for this category, if available.
      String key = "badgePoints_category_$categoryId";
      int? storedBadgePoints = prefs.getInt(key);
      if (storedBadgePoints != null) {
        badgePoints.value = storedBadgePoints;
      } else {
        await checkAndAwardBadgePoints(categoryId);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load goal target questions",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  Future<void> checkAndAwardBadgePoints(int categoryId) async {
    // If no questions, then reset badge points.
    if (questions.isEmpty) {
      badgePoints.value = 0;
      final prefs = await SharedPreferences.getInstance();
      String key = "badgePoints_category_$categoryId";
      await prefs.remove(key);
      return;
    }
    bool allAnswered = questions.every((question) {
      String qId = question.id.toString();
      return selectedOptions[qId] != null && selectedOptions[qId]!.isNotEmpty;
    });
    final prefs = await SharedPreferences.getInstance();
    String key = "badgePoints_category_$categoryId";
    if (allAnswered) {
      int points = Random().nextInt(16) + 5; // Random between 5 and 20
      badgePoints.value = points;
      await prefs.setInt(key, points);
    } else {
      badgePoints.value = 0;
      await prefs.remove(key);
    }
  }

  // Add an option (for multiple selection)
  void addOption(int categoryId, String questionId, String option) async {
    List<String> options = selectedOptions[questionId] ?? [];
    if (!options.contains(option)) {
      options.add(option);
      selectedOptions[questionId] = options;
      // Join options with ' - ' before submitting.
      String joinedAnswer = options.join(' - ');
      await submitAnswer(categoryId, questionId, joinedAnswer);
      await checkAndAwardBadgePoints(categoryId);
    }
  }

  // Remove an option (for multiple selection)
  void removeOption(int categoryId, String questionId, String option) async {
    List<String> options = selectedOptions[questionId] ?? [];
    if (options.contains(option)) {
      options.remove(option);
      selectedOptions[questionId] = options;
      String joinedAnswer = options.join(' - ');
      await submitAnswer(categoryId, questionId, joinedAnswer);
      await checkAndAwardBadgePoints(categoryId);
    }
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
      update(); // Update UI before API call

      final responseData = await ApiService.submitAnswer(
        userId: userId,
        categoryId: categoryId,
        questionId: questionId,
        type: "goals",
        answer: answer.trim(),
      );

      bool isSuccess = responseData["Result"] == true ||
          responseData["Result"].toString() == "true";

      if (isSuccess) {
        int rating = responseData["Data"]["rating"] is int
            ? responseData["Data"]["rating"]
            : int.tryParse(responseData["Data"]["rating"].toString()) ?? 0;

        await prefs.setString("goal_selected_answer_$questionId", answer.trim());
        await prefs.setInt("goal_rating_$questionId", rating);

        // Update stored answer by splitting the joined answer back into a list.
        selectedOptions[questionId] = answer.trim().isNotEmpty
            ? answer.trim().split('-').map((e) => e.trim()).toList()
            : <String>[];
        questionRatings[questionId] = rating;
        update(); // Refresh UI after API response

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
      update(); // Refresh UI after submission
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
