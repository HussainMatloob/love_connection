import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/assisment_question_controller.dart';

class AssessmentQuestionScreen extends StatelessWidget {
  final String categoryName;

  AssessmentQuestionScreen({required this.categoryName});

  final AssessmentQuestionController controller = Get.put(AssessmentQuestionController());

  @override
  Widget build(BuildContext context) {
    final Map<String, int> categoryMap = {
      'Love Language': 2,
      'Strength & Weakness': 3,
      'Communication': 4,
      'Emotional Needs': 5,
      'Attachment Style': 6,
      'Relationship Satisfaction': 7,
      'Conflict Resolution': 8,
      'Mindfulness': 9,
    };

    final int categoryId = categoryMap[categoryName] ?? 0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchQuestions(categoryId);
    });

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
              'No questions available for this category.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          );
        } else {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
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
                        child: ExpansionTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                question.question,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 8),
                              Obx(() {
                                final rating = controller.questionRatings[questionId] ?? 0;
                                return Text(
                                  "Rating: $rating",
                                  style: TextStyle(fontSize: 14, color: Colors.pinkAccent),
                                );
                              }),
                            ],
                          ),
                          children: [
                            ...question.options.map((option) {
                              return Obx(
                                    () => RadioListTile<String>(
                                  value: option,
                                  groupValue: controller.selectedOptions[questionId] ?? '',
                                  activeColor: Colors.pink.shade400,
                                  title: Text(option),
                                  onChanged: (value) {
                                    if (value != null) {
                                      controller.selectOption(categoryId, questionId, value);
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
                ),
              ),

            ],
          );
        }
      }),
    );
  }
}
