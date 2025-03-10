import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:love_connection/Widgets/FormWidgets.dart';

import '../Controllers/BasicInfoController.dart';

class Preferences extends StatefulWidget {
  const Preferences({super.key});

  @override
  State<Preferences> createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {

  final BasicInfoController controller = Get.put(BasicInfoController());
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: PageView(
            controller: pageController,
            onPageChanged: (index) {
              controller.currentFormPage.value = index;
            },
            children: [
              FormWidgets.buildPreferencesForm(controller),
              // FormWidgets.buildPreferencesForm2(controller),
            ],
          ),
        ),
        // FormWidgets().buildPageIndicator(),
      ],
    );
  }
}
