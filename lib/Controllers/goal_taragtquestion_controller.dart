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
  // For multiple selections per question.
  var selectedOptions = <String, List<String>>{}.obs;
  var questionRatings = <String, int>{}.obs;

  // Reactive variables for badge information.
  // badgePoints: if -1, then incomplete.
  var badgePoints = 0.obs;
  var badgeTitle = "".obs;
  var badgeDescription = "".obs;
  var badgeImageUrl = "".obs;
  // Flag to determine whether to show the badge overlay.
  var badgeChecked = false.obs;

  final ApiService apiservice = ApiService();

  Future<void> fetchGoalTargetQuestions(int categoryId) async {
    isLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final fetchedQuestions = await apiservice.fetchGoalTargetQuestions();
      final filteredQuestions =
      fetchedQuestions.where((q) => q.categoryId == categoryId).toList();

      // If no questions exist, clear data and badge info.
      if (filteredQuestions.isEmpty) {
        questions.assignAll([]);
        badgePoints.value = 0;
        badgeTitle.value = "";
        badgeDescription.value = "";
        badgeImageUrl.value = "";
        badgeChecked.value = false;
        await prefs.remove("badgePoints_category_$categoryId");
        print("No questions found for category $categoryId; badge cleared.");
        isLoading(false);
        return;
      }

      questions.assignAll(filteredQuestions);
      print("Fetched ${questions.length} questions for category $categoryId.");

      // Load any saved answers/ratings.
      for (var question in questions) {
        String? savedAnswer = prefs.getString("goal_selected_answer_${question.id}");
        int? savedRating = prefs.getInt("goal_rating_${question.id}");
        if (savedAnswer != null) {
          selectedOptions[question.id.toString()] =
              savedAnswer.split('-').map((e) => e.trim()).toList();
        }
        if (savedRating != null) {
          questionRatings[question.id.toString()] = savedRating;
        }
      }
      // Do NOT automatically check the badge on screen load.
      // The badge info will be refreshed only when the user presses the refresh button.
    } catch (e) {
      print("Error fetching questions: $e");
      Get.snackbar("Error", "Failed to load goal target questions",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  /// Calls the API to check badge validity.
  /// If the backend ResponseMsg equals "Please complete the tasks",
  /// then badgePoints is set to -1 (indicating incomplete tasks).
  /// Otherwise, badge details are stored.
  Future<void> checkGoalRatingForGoals(int categoryId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString('userid');
      if (userId == null || userId.isEmpty) {
        print("checkGoalRatingForGoals: userId not found");
        return;
      }

      print("Calling getGoalRatingForGoals API with userId: $userId, categoryId: $categoryId");
      final responseData = await ApiService.getGoalRatingForGoals(
        userId: userId,
        categoryId: categoryId,
      );
      print("Response from getGoalRatingForGoals: $responseData");

      bool isSuccess = responseData["Result"] == true ||
          responseData["Result"].toString() == "true";

      // Check the response message.
      if (responseData["BadgeMessage"] == "Please complete the tasks") {
        badgePoints.value = -1;
        badgeTitle.value = "";
        badgeDescription.value = "";
        badgeImageUrl.value = "";
        print("API indicates incomplete tasks. Badge set to -1.");
      } else if (isSuccess) {
        // Parse counts from API response.
        final int total = int.tryParse(
            responseData["OneRatingsCountFromGoaltargetQuestions"]?.toString() ?? "0") ?? 0;
        final int answers = int.tryParse(
            responseData["OneRatingsCountFromAssesmentAnswers"]?.toString() ?? "0") ?? 0;
        print("Answers: $answers, Total: $total");

        if (total > 0 && (answers / total) >= 0.5) {
          // Use the backend's BadgePoints if available; here we use a default value (e.g., 10) if not.
          final int points = int.tryParse(responseData["BadgePoints"]?.toString() ?? "10") ?? 10;
          badgePoints.value = points;
          badgeTitle.value = responseData["BadgeTitle"] ?? "Congratulations!";
          badgeDescription.value = responseData["BadgeMessage"] ?? "You have unlocked your badge.";
          badgeImageUrl.value = responseData["BadgeImageUrl"] ?? 'assets/images/VarifyBadge.png';
          print("Badge awarded: ${badgePoints.value} points, Title: ${badgeTitle.value}");
        } else {
          badgePoints.value = -1;
          badgeTitle.value = "";
          badgeDescription.value = "";
          badgeImageUrl.value = "";
          print("Not enough answered questions. Badge set to -1.");
        }
      } else {
        badgePoints.value = -1;
        print("API returned unsuccessful result. Badge set to -1.");
      }
      // Mark that badge checking has been performed.
      badgeChecked.value = true;
      // Automatically hide the badge overlay after 5 seconds.
      Future.delayed(Duration(seconds: 5), () {
        badgeChecked.value = false;
      });
    } catch (e) {
      print("Error in checkGoalRatingForGoals: $e");
      Get.snackbar("Error", "Failed to get rating from server: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Add an option (for multiple selection)
  void addOption(int categoryId, String questionId, String option) async {
    List<String> options = selectedOptions[questionId] ?? [];
    if (!options.contains(option)) {
      options.add(option);
      selectedOptions[questionId] = options;
      String joinedAnswer = options.join(' - ');
      print("Submitting answer for question $questionId: $joinedAnswer");
      await submitAnswer(categoryId, questionId, joinedAnswer);
      // await checkGoalRatingForGoals(categoryId);
    }
  }

  // Remove an option (for multiple selection)
  void removeOption(int categoryId, String questionId, String option) async {
    List<String> options = selectedOptions[questionId] ?? [];
    if (options.contains(option)) {
      options.remove(option);
      selectedOptions[questionId] = options;
      String joinedAnswer = options.join(' - ');
      print("Submitting answer for question $questionId after removal: $joinedAnswer");
      await submitAnswer(categoryId, questionId, joinedAnswer);
      // await checkGoalRatingForGoals(categoryId);
    }
  }

  Future<void> submitAnswer(int categoryId, String questionId, String answer) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString('userid');
      if (userId == null || userId.isEmpty) {
        print("submitAnswer: userId not found");
        Get.snackbar("Error", "User ID not found. Please log in again.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return;
      }

      isSubmitting(true);
      update();
      print("Submitting answer to API for question $questionId: $answer");
      final responseData = await ApiService.submitAnswer(
        userId: userId,
        categoryId: categoryId,
        questionId: questionId,
        type: "goals",
        answer: answer.trim(),
      );
      print("Response from submitAnswer API for question $questionId: $responseData");

      bool isSuccess = responseData["Result"] == true ||
          responseData["Result"].toString() == "true";

      if (isSuccess) {
        int rating = responseData["Data"]["rating"] is int
            ? responseData["Data"]["rating"]
            : int.tryParse(responseData["Data"]["rating"].toString()) ?? 0;

        await prefs.setString("goal_selected_answer_$questionId", answer.trim());
        await prefs.setInt("goal_rating_$questionId", rating);

        selectedOptions[questionId] = answer.trim().isNotEmpty
            ? answer.trim().split('-').map((e) => e.trim()).toList()
            : <String>[];
        questionRatings[questionId] = rating;
        update();

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
      print("Error in submitAnswer: $e");
      Get.snackbar("Error", "An unexpected error occurred: ${e.toString()}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isSubmitting(false);
      update();
    }
  }

  int getTotalRating() {
    return questionRatings.values.fold(0, (sum, rating) => sum + rating);
  }

  double getAverageRating() {
    if (questionRatings.isEmpty) return 0;
    int total = getTotalRating();
    int count = questionRatings.length;
    return (total / (count * 5)) * 100;
  }
}
