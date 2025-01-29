import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:love_connection/Screens/Coaching%20Service/AssesmentCategoryScreen.dart';
import '../Controllers/AuthController.dart';

class SelectService extends StatefulWidget {
  @override
  _SelectServiceState createState() => _SelectServiceState();
}

class _SelectServiceState extends State<SelectService> {
  bool isMatchmakingSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Black Opacity Overlay
          Container(
            color: Colors.black.withOpacity(0.3),
          ),
          // Content
          SafeArea(
            child: Column(
              children: [
                // Back Button
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.pinkAccent),
                      onPressed: () => Get.back(),
                    ),
                  ),
                ),
                Spacer(),
                // Main Content Container
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Title Text
                        Text(
                          "Coaching Services",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 24),
                        // Selection Buttons
                        Column(
                          children: [
                          GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          isMatchmakingSelected = true;
                                        });

                                        Get.to(AssessmentCategoriesScreen());
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 14),
                                        decoration: BoxDecoration(
                                          color: isMatchmakingSelected
                                              ? Colors.pinkAccent
                                              : Colors.white,
                                          borderRadius: BorderRadius.circular(18),
                                          border: Border.all(
                                              color: Colors.pinkAccent),
                                        ),
                                        child: Text(
                                          "Assessments",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: isMatchmakingSelected
                                                ? Colors.white
                                                : Colors.pinkAccent,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),

                            SizedBox(height: 16),
                            GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        isMatchmakingSelected = false;
                                      });
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(vertical: 14),
                                      decoration: BoxDecoration(
                                        color: !isMatchmakingSelected
                                            ? Colors.pinkAccent
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(18),
                                        border:
                                            Border.all(color: Colors.pinkAccent),
                                      ),
                                      child: Text(
                                        "Goal Targets",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: !isMatchmakingSelected
                                              ? Colors.white
                                              : Colors.pinkAccent,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),
                      ],
                    ),
                  ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
