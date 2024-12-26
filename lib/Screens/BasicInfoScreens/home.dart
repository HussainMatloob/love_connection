import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:love_connection/Screens/BasicInfo.dart';
import 'package:love_connection/Widgets/FormWidgets.dart';

import '../../Controllers/BasicInfoController.dart';
import '../Preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final BasicInfoController controller = Get.put(BasicInfoController());
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Basic Information'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(Get.width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FormWidgets.buildTabs(controller, 'Basic', 'Preferences'),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                // Render the screen based on the selected tab
                return controller.currentPage.value == 0
                    ? Basicinfo()
                    : Preferences();
              }),
            ),
          ],
        ),
      ),
    );
  }
}
