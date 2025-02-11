import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../ApiService/ApiService.dart';
import '../Models/Questions.dart';

class AssessmentQuestionController extends GetxController {
  var questions = <Question>[].obs;
  var isLoading = true.obs;
  var isSubmitting = false.obs;
  var selectedOptions = <String, String>{}.obs;

  final ApiService apiService = ApiService();
  final int userId = 1; // Replace with actual user ID (can be from AuthController)
  final String type = "assessment"; // Define appropriate type

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
  }

  Future<void> submitAnswers(int categoryId) async {
    if (selectedOptions.isEmpty) {
      Get.snackbar("Error", "Please answer at least one question before submitting",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isSubmitting(true);

      List<Map<String, dynamic>> answers = selectedOptions.entries
          .map((entry) => {
        "userid": userId,
        "type": type,
        "categoryid": categoryId,
        "questionid": entry.key,
        "answer": entry.value,
      })
          .toList();

      for (var answer in answers) {
        final response = await http.post(
          Uri.parse("https://projects.funtashtechnologies.com/gomeetapi/answerassesmentquestions.php"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(answer),
        );

        final responseData = jsonDecode(response.body);
        if (response.statusCode != 200 || responseData["status"] != "success") {
          throw Exception(responseData["message"] ?? "Failed to submit some answers");
        }
      }

      Get.snackbar("Success", "All answers submitted successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);

      selectedOptions.clear(); // Reset selected answers after submission
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isSubmitting(false);
    }
  }
}
