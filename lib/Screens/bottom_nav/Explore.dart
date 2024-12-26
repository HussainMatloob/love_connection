import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:  PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight), // Standard AppBar height
          child:  AppBar(
              title: Text('Explore'),
              backgroundColor: Colors.transparent,
              centerTitle: true,// Makes the background transparent to show the gradient
              elevation: 0, // Removes shadow
            ),
          ),

        body: Stack(
          children: [
            Container(
              width: Get.width,
              height: Get.height,
              child: Image.asset(
                'assets/images/profile.jpg',
                fit: BoxFit.cover,
              ),
            ),

            Positioned(
              bottom: Get.height * 0.18, // 20% from the bottom
              left: Get.width * 0.05, // 10% from the left
              right: Get.width * 0.05, // 10% from the right
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Container for the Close Icon with white background
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white, // Background color is white
                        shape: BoxShape.circle, // Circular shape
                      ),
                      child: IconButton(
                        onPressed: () {
                          // Close button action
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.pink, // Icon color is pink
                        ),
                      ),
                    ),
                    // Container for the Check Icon with pink background
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.pink.shade200, // Background color is pink
                        shape: BoxShape.circle, // Circular shape
                      ),
                      child: IconButton(
                        onPressed: () {
                          // Check button action
                        },
                        icon: Icon(
                          Icons.check,
                          color: Colors.white, // Icon color is white
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.9),
                      Colors.black.withOpacity(0.8),
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.6),
                      Colors.black.withOpacity(0.5),
                      Colors.black.withOpacity(0.4),
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.1),
                      Colors.black.withOpacity(0.05),
                      Colors.black.withOpacity(0.025),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Samina -25',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Bachelors in Computer Science',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'United States',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 20),
                    // Circular button with rounded corners
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        child: Text(
                          'Basic Info',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
            // add one more container in center with corner radius and padding of 20 of top left and right with center text basic info with underline
          ],
        ),
      ),
    );
  }
}
