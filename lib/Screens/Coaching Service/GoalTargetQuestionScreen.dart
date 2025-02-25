import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/goal_taragtquestion_controller.dart';

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
                      child: Obx(() => ExpansionTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  question.question,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Rating: ${controller.questionRatings[questionId] ?? 0}",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.pinkAccent),
                                ),
                              ],
                            ),
                            children: [
                              ...question.options.map((option) {
                                return Obx(() {
                                  // Ensure options are unchecked by default
                                  final List<String> selectedList =
                                      controller.selectedOptions[questionId] ??
                                          [];

                                  final bool isSelected =
                                      selectedList.contains(option.trim());

                                  return CheckboxListTile(
                                    value: isSelected,
                                    activeColor: Colors.pink.shade400,
                                    title: Text(option),
                                    onChanged: (bool? value) {
                                      if (value == true) {
                                        controller.addOption(categoryId,
                                            questionId, option.trim());
                                      } else {
                                        controller.removeOption(categoryId,
                                            questionId, option.trim());
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
            }
          }),
          // Full-screen overlay with pink blurred background for the badge popup.
          Obx(
            () {
              if (!controller.badgeChecked.value) return SizedBox.shrink();
              return Positioned.fill(
                child: Container(
                  color: Colors.pink.withOpacity(0.3),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 500),
                      child: controller.badgePoints.value == -1
                          ? Center(
                              key: ValueKey("incomplete"),
                              child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFAB47BC),
                                      Color(0xFFFF4081)
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black38,
                                      blurRadius: 10,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  "PLEASE COMPLETE ALL THE GOALS FIRST",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              key: ValueKey("badge"),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AnimatedContainer(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                    width: 150,
                                    height: 150,
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFFFF4081),
                                          Color(0xFFFF9100)
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black38,
                                          blurRadius: 10,
                                          offset: Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: ClipOval(
                                      child: Image.asset(
                                        controller
                                                .badgeImageUrl.value.isNotEmpty
                                            ? controller.badgeImageUrl.value
                                            : 'assets/images/VarifyBadge.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  AnimatedDefaultTextStyle(
                                    duration: Duration(milliseconds: 500),
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      letterSpacing: 1.5,
                                      shadows: [
                                        Shadow(
                                          color: Colors.pinkAccent
                                              .withOpacity(0.5),
                                          blurRadius: 4,
                                          offset: Offset(2, 2),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      controller.badgeTitle.value.isNotEmpty
                                          ? controller.badgeTitle.value
                                          : "Congratulations!",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  AnimatedDefaultTextStyle(
                                    duration: Duration(milliseconds: 500),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.pink[700],
                                      shadows: [
                                        Shadow(
                                          color: Colors.pinkAccent
                                              .withOpacity(0.4),
                                          blurRadius: 3,
                                          offset: Offset(1, 1),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      controller
                                              .badgeDescription.value.isNotEmpty
                                          ? controller.badgeDescription.value
                                          : "You have unlocked your badge.",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ),
              );
            },
          ),
          // Floating button to manually refresh badge info.
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: Colors.pinkAccent,
              child: Icon(Icons.stars_rounded),
              onPressed: () async {
                await controller.checkGoalRatingForGoals(categoryId);
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
