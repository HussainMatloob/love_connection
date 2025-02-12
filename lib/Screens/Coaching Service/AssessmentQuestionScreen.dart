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
                    controller.fetchQuestions(categoryId);
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
