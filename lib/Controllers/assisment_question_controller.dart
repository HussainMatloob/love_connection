import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../ApiService/ApiService.dart';
import '../Models/Questions.dart';

class AssessmentQuestionController extends GetxController {
  var questions = <Question>[].obs;
  var isLoading = true.obs;
  var isSubmitting = false.obs;
  var selectedOptions = <String, String>{}.obs;

  final ApiService apiService = ApiService();
  final int userId = 1; // Replace with actual user ID
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

      print('User ID     :  =>  $userId');
      print('Category ID :  =>  $categoryId');
      print('Question ID :  =>  $questionId');
      print('Answer      :  =>  $answer');

      isSubmitting(true);

      Map<String, dynamic> payload = {
        "userid": userId,
        "type": "assessment",
        "categoryid": categoryId.toString(),
        "questionid": questionId.toString(),
        "answer": answer,
      };

      print("Submitting Answer: $payload");

      final response = await http.post(
        Uri.parse("https://projects.funtashtechnologies.com/gomeetapi/answerassesmentquestions.php"),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: payload.map((key, value) => MapEntry(key, value.toString())),
      );

      final responseData = jsonDecode(response.body);
      print("API Response: $responseData");

      // Ensure Result is correctly interpreted
      bool isSuccess = response.statusCode == 200 &&
          (responseData["Result"] == true || responseData["Result"].toString() == "true");

      print("Final isSuccess Check: $isSuccess");

      if (isSuccess) {
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

}
