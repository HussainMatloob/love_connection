import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/goal_taragtquestion_controller.dart';

class GoalTargetQuestionScreen extends StatelessWidget {
  final String categoryName;
  final GoalTargetQuestionController controller = Get.put(GoalTargetQuestionController());

  // Track which questions have already shown a snackbar
  final Set<String> shownSnackbars = {};

  GoalTargetQuestionScreen({required this.categoryName});

  @override
  Widget build(BuildContext context) {
    int categoryId = _getCategoryId(categoryName);
    controller.fetchGoalTargetQuestions(categoryId);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(categoryName),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (controller.questions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.sentiment_dissatisfied,
                  color: Colors.pinkAccent,
                  size: 60,
                ),
                SizedBox(height: 16),
                Text(
                  'Oops! No questions available.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Please check back later or try a different category.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // You can add a refresh function or navigation here
                    controller.fetchGoalTargetQuestions(categoryId);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    "Refresh",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          );
        }
        else {
          return Column(
            children: [
              // Total Rating & Average Rating Row
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() => Text(
                      "Total Rating: ${controller.getTotalRating()}",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                    )),
                    Obx(() => Text(
                      "Avg Rating: ${controller.getAverageRating().toStringAsFixed(2)} / 100",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                    )),
                  ],
                ),
              ),
              // List of Questions
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.questions.length,
                    itemBuilder: (context, index) {
                      final question = controller.questions[index];
                      final questionId = question.id.toString();

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          child: Obx(() => ExpansionTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  question.question,
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Rating: ${controller.questionRatings[questionId] ?? 0}",
                                  style: TextStyle(fontSize: 14, color: Colors.pinkAccent),
                                ),
                              ],
                            ),
                            children: [
                              ...question.options.map((option) {
                                return Obx(() {
                                  return RadioListTile<String>(
                                    value: option.trim(), // Trim before assigning
                                    groupValue: controller.selectedOptions[questionId]?.trim() ?? '',
                                    activeColor: Colors.pink.shade400,
                                    title: Text(option),
                                    onChanged: (value) {
                                      if (value != null) {
                                        controller.selectOption(categoryId, questionId, value.trim());
                                      }
                                    },
                                  );
                                });
                              }).toList(),
                            ],
                          )),
                        ),
                      );
                    },
                  );
                }),
              ),


            ],
          );
        }
      }),
    );
  }

  int _getCategoryId(String categoryName) {
    switch (categoryName) {
      case 'Effective Family Planning':
        return 1;
      case 'Sexual Satisfaction':
        return 2;
      case 'Develop Positive Habits':
        return 3;
      case 'Financial Managements':
        return 4;
      case 'Unmet Expectations':
        return 5;
      case 'Trust & Respect':
        return 6;
      default:
        return 0;
    }
  }
}
