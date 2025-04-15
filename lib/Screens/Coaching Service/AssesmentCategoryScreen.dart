import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:love_connection/Controllers/rating_controller.dart';
import '../../Controllers/assisment_controller.dart';
import 'AssessmentQuestionScreen.dart';

class AssessmentCategoriesScreen extends StatelessWidget {
  final AssessmentController controller = Get.put(AssessmentController());
  final RatingController ratingController = Get.put(RatingController());

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive design
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    ratingController.startAutoRefresh(); // Start auto-refresh for rating

    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        title: Text("Assessment Categories",
            style: TextStyle(fontSize: screenWidth * 0.05)), // Responsive title
        centerTitle: true,
        backgroundColor: Colors.pink.shade50,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.assessmentCategories.isEmpty) {
          return Center(
            child: Text("No categories available",
                style: TextStyle(fontSize: screenWidth * 0.04)), // Responsive text
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.02), // Adaptive spacing
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: screenWidth < 600 ? 2 : 3, // Adjust for tablets
                  mainAxisSpacing: screenHeight * 0.03, // Adaptive spacing
                  crossAxisSpacing: screenWidth * 0.04,
                  childAspectRatio: screenWidth < 600 ? 0.85 : 0.9, // Responsive ratio
                ),
                itemCount: controller.assessmentCategories.length,
                itemBuilder: (context, index) {
                  final category = controller.assessmentCategories[index];

                  return GestureDetector(
                    onTap: () {
                      Get.to(() => AssessmentQuestionScreen(
                        categoryName: category.title.toString(),
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
                          )
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
                              category.image ?? '',
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.image_not_supported),
                              fit: BoxFit.cover,
                              height: screenWidth * 0.3, // Responsive height
                              width: screenWidth * 0.20, // Responsive width
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.02), // Adaptive padding
                            child: SizedBox(
                              width: double.infinity, // Ensures full width
                              child: Text(
                                category.title ?? "Unknown Category",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * 0.035, // Responsive font
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
              ),
            ),
          ],
        );
      }),
    );
  }
}
