import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/assisment_question_controller.dart';

class AssessmentQuestionScreen extends StatelessWidget {
  final String categoryName;

  AssessmentQuestionScreen({required this.categoryName});

  final AssessmentQuestionController controller = Get.put(AssessmentQuestionController());

  @override
  Widget build(BuildContext context) {
    // Determine the categoryId based on categoryName
    int categoryId;
    switch (categoryName) {
      case 'Love Language':
        categoryId = 2;
        break;
      case 'Strength & Weakness':
        categoryId = 3;
        break;
      case 'Communication':
        categoryId = 4;
        break;
      case 'Emotional Needs':
        categoryId = 5;
        break;
      case 'Attachment Style':
        categoryId = 6;
        break;
      case 'Relationship Satisfaction':
        categoryId = 7;
        break;
      case 'Conflict Resolution':
        categoryId = 8;
        break;
      case 'Mindfulness':
        categoryId = 9;
        break;
      default:
        categoryId = 0; // Default case if no match found
    }

    // Fetch questions for the selected category
    controller.fetchQuestions(categoryId);

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
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.questions.length,
            itemBuilder: (context, index) {
              final question = controller.questions[index];

              // Select the first option by default if not already selected
              if (controller.selectedOptions[question.id.toString()] == null &&
                  question.options.isNotEmpty) {
                controller.selectOption(question.id.toString(), question.options[0]);
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
                    title: Text(
                      question.question,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    children: [
                      ...question.options.map((option) {
                        return Obx(
                              () => RadioListTile<String>(
                            value: option,
                            groupValue:
                            controller.selectedOptions[question.id.toString()] ?? '',
                            activeColor: Colors.pink.shade400,
                            title: Text(option),
                            onChanged: (value) {
                              if (value != null) {
                                controller.selectOption(question.id.toString(), value);
                                print(
                                    "Selected Option for Question ${question.id}: $value");
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
}
