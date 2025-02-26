import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/goal_target_controller.dart';
import 'GoalTargetQuestionScreen.dart';

class GoalTargetScreen extends StatelessWidget {
  final GoalTargetController controller = Get.put(GoalTargetController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Goal Targets"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;
          int crossAxisCount = 2;

          // Adjust grid layout for tablets & desktops
          if (screenWidth >= 1200) {
            crossAxisCount = 4;
          } else if (screenWidth >= 800) {
            crossAxisCount = 3;
          }

          return Obx(() {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }

            if (controller.goalTargets.isEmpty) {
              return Center(child: Text("No categories available"));
            }

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 22,
                crossAxisSpacing: 16,
                childAspectRatio: screenWidth < 600 ? 0.85 : 1, // Keeps items proportional
              ),
              itemCount: controller.goalTargets.length,
              itemBuilder: (context, index) {
                final category = controller.goalTargets[index];

                return GestureDetector(
                  onTap: () {
                    Get.to(() => GoalTargetQuestionScreen(
                      categoryName: category.title,
                    ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: Offset(0, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Image.network(
                            category.imageUrl,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.image_not_supported, size: 50),
                            fit: BoxFit.cover,
                            height: screenWidth < 600 ? 120 : 140, // Adaptive image size
                            width: screenWidth < 600 ? 90 : 100,
                          ),
                        ),
                        SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              category.title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth < 600 ? 14 : 18, // Adaptive font size
                              ),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          });
        },
      ),
    );
  }
}
