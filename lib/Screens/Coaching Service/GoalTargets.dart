import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/goal_target_controller.dart';

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
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.goalTargets.isEmpty) {
          return Center(child: Text("No categories available"));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 22,
            crossAxisSpacing: 16,
          ),
          itemCount: controller.goalTargets.length,
          itemBuilder: (context, index) {
            final category = controller.goalTargets[index];
            return GestureDetector(
              onTap: () {
                // Get.to(() => AssessmentQuestionScreen(
                //   categoryName: category.title,
                // ));
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
                            Icon(Icons.image_not_supported),
                        fit: BoxFit.cover,
                        height: 120,
                        width: 100,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      category.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
