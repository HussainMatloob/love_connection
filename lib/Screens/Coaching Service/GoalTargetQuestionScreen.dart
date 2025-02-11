import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controllers/goal_taragtquestion_controller.dart';

class GoalTargetQuestionScreen extends StatelessWidget {
  final String categoryName;

  GoalTargetQuestionScreen({required this.categoryName});
  final GoalTargetQuestionController controller = Get.put(GoalTargetQuestionController());

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
            child: Text(
              'No questions available for this goal target.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          );
        } else {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.questions.length,
            itemBuilder: (context, index) {
              final question = controller.questions[index];

              // Restore saved answers
              if (controller.selectedOptions[question.id.toString()] == null && question.options.isNotEmpty) {
                controller.selectOption(categoryId, question.id.toString(), question.options[0]);
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: ExpansionTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          question.question,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        // Obx(() {
                        //   int rating = controller.questionRatings[question.id.toString()] ?? 0;
                        //   return Text(
                        //     'Rating: $rating',
                        //     style: TextStyle(fontSize: 14, color: Colors.grey),
                        //   );
                        // }),
                      ],
                    ),
                    children: [
                      ...question.options.map((option) {
                        return Obx(
                              () => RadioListTile<String>(
                            value: option,
                            groupValue: controller.selectedOptions[question.id.toString()] ?? '',
                            activeColor: Colors.pink.shade400,
                            title: Text(option),
                            onChanged: (value) {
                              if (value != null) {
                                controller.selectOption(categoryId, question.id.toString(), value);
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              );
            },
          );
        }
      }),
    );
  }

  int _getCategoryId(String categoryName) {
    switch (categoryName) {
      case 'Effective Family Planning': return 1;
      case 'Sexual Satisfaction': return 2;
      case 'Develop Positive Habits': return 3;
      case 'Financial Managements': return 4;
      case 'Unmet Expectations': return 5;
      case 'Trust & Respect': return 6;
      default: return 0;
    }
  }
}
