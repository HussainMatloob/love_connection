import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:love_connection/Widgets/PinkButton.dart';

import 'bottom_nav/BottomNavbar.dart';

class Profilepicture extends StatefulWidget {
  const Profilepicture({super.key});

  @override
  State<Profilepicture> createState() => _ProfilepictureState();
}

class _ProfilepictureState extends State<Profilepicture> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Profile Picture'),
          centerTitle: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: Get.width * 0.06,
                  top: Get.width * 0.05,
                  bottom: Get.width * 0.05),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Mandatory*',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            // Dotted border container
            GestureDetector(
              onTap: () {
                // Add image upload logic here

              },
              child: DottedBorder(
                color: Colors.pink.shade300,
                borderType: BorderType.RRect,
                radius: Radius.circular(8),
                dashPattern: [6, 4],
                strokeWidth: 2,
                child: Container(
                  width:  Get.width * 0.8,
                  height: Get.height * 0.2,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt_outlined,
                        size: 40,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Upload Image',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.all(Get.width * 0.10),
                child: PinkButton(text: "Continue", onTap: () {
                  Get.offAll(Bottomnavbar());
                }))
          ],
        ),
      ),
    );
  }
}
