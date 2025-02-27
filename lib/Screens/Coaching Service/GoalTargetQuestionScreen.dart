import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/goal_taragtquestion_controller.dart';
import '../../Widgets/Badge_dialog.dart';

class GoalTargetQuestionScreen extends StatelessWidget {
  final String categoryName;
  final GoalTargetQuestionController controller =
  Get.put(GoalTargetQuestionController());

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
      body: Stack(
        children: [
          Obx(() {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            } else if (controller.questions.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.sentiment_dissatisfied,
                        color: Colors.pinkAccent, size: 60),
                    SizedBox(height: 16),
                    Text(
                      'Oops! No questions available.',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Please check back later or try a different category.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        controller.fetchGoalTargetQuestions(categoryId);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        padding:
                        EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: Text("Refresh",
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ],
                ),
              );
            } else {
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
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      child: ExpansionTile(
                        title: Text(
                          question.question,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        children: question.options.map((option) {
                          return Obx(() {
                            final List<String> selectedList =
                                controller.selectedOptions[questionId] ?? [];
                            final bool isSelected =
                            selectedList.contains(option.trim());

                            return CheckboxListTile(
                              value: isSelected,
                              activeColor: Colors.pink.shade400,
                              title: Text(option),
                              onChanged: (bool? value) {
                                if (value == true) {
                                  controller.addOption(
                                      categoryId, questionId, option.trim());
                                } else {
                                  controller.removeOption(
                                      categoryId, questionId, option.trim());
                                }
                              },
                            );
                          });
                        }).toList(),
                      ),
                    ),
                  );
                },
              );
            }
          }),

          // Floating action button to check goal rating and show badge
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: Colors.pinkAccent,
              child: Icon(Icons.stars_rounded),
              onPressed: () async {
                await controller.checkGoalRatingForGoals(categoryId);

                if (controller.badgePoints.value > 0) {
                  Get.dialog(
                    buildBadgeDialog(context, controller), // ✅ Show Badge Dialog
                    barrierDismissible: false, // ❌ User can't close manually
                  );

                  // ⏳ **Auto-close after 5 seconds**
                  Future.delayed(Duration(seconds: 5), () {
                    if (Get.isDialogOpen ?? false) {
                      Get.back(); // ✅ Close Dialog after 5 sec
                    }
                  });
                }
              },

            ),
          ),
        ],
      ),
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
