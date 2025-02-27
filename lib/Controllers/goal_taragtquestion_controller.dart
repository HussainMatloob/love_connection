import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ApiService/ApiService.dart';
import '../Models/GoaltargetQuestions.dart';

class GoalTargetQuestionController extends GetxController {
  var questions = <GoaltargetQuestions>[].obs;
  var isLoading = true.obs;
  var isSubmitting = false.obs;

  // Reactive selections
  var selectedOptions = <String, List<String>>{}.obs;
  var questionRatings = <String, int>{}.obs;

  // Badge Information
  var badgePoints = 0.obs;
  var badgeTitle = "".obs;
  var badgeDescription = "".obs;
  var badgeImageUrl = "".obs;
  var badgeChecked = false.obs;

  final ApiService apiservice = ApiService();

  Future<void> fetchGoalTargetQuestions(int categoryId) async {
    isLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final fetchedQuestions = await apiservice.fetchGoalTargetQuestions();
      final filteredQuestions =
          fetchedQuestions.where((q) => q.categoryId == categoryId).toList();

      if (filteredQuestions.isEmpty) {
        questions.clear();
        badgePoints.value = 0;
        badgeTitle.value = "";
        badgeDescription.value = "";
        badgeImageUrl.value = "";
        badgeChecked.value = false;
        await prefs.remove("badgePoints_category_$categoryId");
        print("No questions found for category $categoryId; badge cleared.");
        return;
      }

      questions.assignAll(filteredQuestions);
      print("Fetched ${questions.length} questions for category $categoryId.");

      // **Reset selections & ratings (unchecked by default)**
      selectedOptions.clear();
      questionRatings.clear();

      for (var question in questions) {
        String? savedAnswer =
            prefs.getString("goal_selected_answer_${question.id}");
        int? savedRating = prefs.getInt("goal_rating_${question.id}");

        if (savedAnswer != null) {
          selectedOptions[question.id.toString()] =
              savedAnswer.split('-').map((e) => e.trim()).toList();
        } else {
          selectedOptions[question.id.toString()] =
              []; // **Unchecked by default**
        }

        if (savedRating != null) {
          questionRatings[question.id.toString()] = savedRating;
        }
      }
      update();
    } catch (e) {
      print("Error fetching questions: $e");
      Get.snackbar("Error", "Failed to load goal target questions",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

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

      bool isSuccess = responseData["Result"] == true || responseData["Result"].toString() == "true";

      if (responseData["BadgeMessage"] == "Please complete the tasks") {
        // 🚀 Set values for an incomplete badge
        badgePoints.value = -1;
        badgeTitle.value = "";
        badgeDescription.value = "";
        badgeImageUrl.value = "";
        print("API indicates incomplete tasks. Badge set to -1.");

        badgeChecked.value = true; // Show the incomplete badge
      } else if (isSuccess) {
        final int total = int.tryParse(responseData["OneRatingsCountFromGoaltargetQuestions"]?.toString() ?? "0") ?? 0;
        final int answers = int.tryParse(responseData["OneRatingsCountFromAssesmentAnswers"]?.toString() ?? "0") ?? 0;

        print("Answers: $answers, Total: $total");

        if (total > 0 && (answers / total) >= 0.5) {
          // 🎉 Awarding a badge
          final int points = int.tryParse(responseData["BadgePoints"]?.toString() ?? "10") ?? 10;
          badgePoints.value = points;
          badgeTitle.value = responseData["BadgeTitle"] ?? "Congratulations!";
          badgeDescription.value = responseData["BadgeMessage"] ?? "You have unlocked your badge.";
          badgeImageUrl.value = responseData["BadgeImageUrl"] ?? 'assets/images/VarifyBadge.png';

          print("Badge awarded: ${badgePoints.value} points, Title: ${badgeTitle.value}");

          badgeChecked.value = true; // ✅ Show the badge
        } else {
          badgePoints.value = -1;
          badgeTitle.value = "";
          badgeDescription.value = "";
          badgeImageUrl.value = "";
          print("Not enough answered questions. Badge set to -1.");

          badgeChecked.value = true; // Show incomplete badge
        }
      } else {
        // ❌ API returned an unsuccessful result
        badgePoints.value = -1;
        print("API returned unsuccessful result. Badge set to -1.");

        badgeChecked.value = true; // Show incomplete badge
      }

      // 🔥 Manually trigger UI update (only needed in some cases)
      update();

      // ⏳ Auto-hide badge after 5 seconds
      Future.delayed(Duration(seconds: 5), () {
        badgeChecked.value = false;
        update();
      });

    } catch (e) {
      print("Error in checkGoalRatingForGoals: $e");
    }
  }


  void addOption(int categoryId, String questionId, String option) async {
    List<String> options = selectedOptions[questionId] ?? [];
    if (!options.contains(option)) {
      options.add(option);
      selectedOptions[questionId] = options;
      await submitAnswer(categoryId, questionId, options.join(' - '));
    }
  }

  void removeOption(int categoryId, String questionId, String option) async {
    List<String> options = selectedOptions[questionId] ?? [];
    if (options.contains(option)) {
      options.remove(option);
      selectedOptions[questionId] = options;
      await submitAnswer(categoryId, questionId, options.join(' - '));
    }
  }

  Future<void> submitAnswer(
      int categoryId, String questionId, String answer) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString('userid');
      if (userId == null || userId.isEmpty) {
        print("submitAnswer: userId not found");
        return;
      }

      isSubmitting(true);
      update();

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
        int rating =
            int.tryParse(responseData["Data"]["rating"].toString()) ?? 0;
        await prefs.setString(
            "goal_selected_answer_$questionId", answer.trim());
        await prefs.setInt("goal_rating_$questionId", rating);

        selectedOptions[questionId] = answer.isNotEmpty
            ? answer.split('-').map((e) => e.trim()).toList()
            : [];
        questionRatings[questionId] = rating;

        update();
      }
    } catch (e) {
      print("Error in submitAnswer: $e");
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
