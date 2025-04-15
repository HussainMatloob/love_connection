import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Controllers/assisment_question_controller.dart';
import '../../Controllers/rating_controller.dart';

class AssessmentQuestionScreen extends StatelessWidget {
  final String categoryName;

  AssessmentQuestionScreen({required this.categoryName});

  final AssessmentQuestionController controller =
      Get.put(AssessmentQuestionController());
  final RatingController ratingController = Get.put(RatingController());

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
      'Mindfulness': 9, // Category ID 9 for Mindfulness
    };

    final int categoryId = categoryMap[categoryName] ?? 0;

// Save categoryId in local memory
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt('selectedCategoryId', categoryId);
    });

    print("Category id is :$categoryId");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchQuestions(categoryId);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ratingController.fetchRating(categoryId.toString());
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(categoryName),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Obx(
        () {
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
                      controller.fetchQuestions(categoryId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                // add a text widget to display the 'Questions' text with full style in left side
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18, top: 16),
                    child: Text(
                      "Questions*",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
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
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            children: [
                              ...question.options.map((option) {
                                return Obx(
                                  () => RadioListTile<String>(
                                    value: option,
                                    groupValue: controller
                                            .selectedOptions[questionId] ??
                                        '',
                                    activeColor: Colors.pink.shade400,
                                    title: Text(option),
                                    onChanged: (value) {
                                      if (value != null) {
                                        controller.selectOption(
                                            categoryId, questionId, value);
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

                SizedBox(
                  width: double.infinity, // Full-width button
                  child: ElevatedButton(
                    onPressed: () {
                      Get.dialog(
                        Dialog(
                          backgroundColor: Colors.transparent,
                          // Remove default background
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                // Strong blur effect
                                child: Container(
                                    color: Colors
                                        .transparent // Semi-transparent overlay
                                    ),
                              ),
                              TweenAnimationBuilder(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeOutBack,
                                builder: (context, double scale, child) {
                                  return Transform.scale(
                                      scale: scale, child: child);
                                },
                                tween: Tween<double>(begin: 0, end: 1),
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    // Glassmorphism effect
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                        color: Colors.white.withOpacity(0.3)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                        offset: Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Total Rating",
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "Your $categoryName rating is:",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white70),
                                        ),
                                        SizedBox(height: 8),
                                        ShaderMask(
                                          shaderCallback: (bounds) =>
                                              LinearGradient(
                                            colors: [
                                              Colors.pinkAccent,
                                              Colors.deepPurpleAccent
                                            ],
                                          ).createShader(bounds),
                                          child: Text(
                                            "${ratingController.ratingPercentage.value.toStringAsFixed(2)}%",
                                            style: TextStyle(
                                              fontSize: 40,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 16),
                                        SizedBox(
                                          width: double.infinity,
                                          // Full-width button in dialog
                                          child: ElevatedButton(
                                            onPressed: () => Get.back(),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.pinkAccent,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 14),
                                            ),
                                            child: Text("OK",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      // Bigger button
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      backgroundColor: Colors.transparent,
                      // Use gradient instead
                      shadowColor: Colors.pinkAccent.withOpacity(0.4),
                      elevation: 8,
                    ).copyWith(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      overlayColor: MaterialStateProperty.all(
                          Colors.white.withOpacity(0.1)), // Ripple effect
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.pinkAccent, Colors.deepPurpleAccent],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        child: Text(
                          "Show Total Rating",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
