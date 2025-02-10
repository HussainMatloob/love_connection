import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../Controllers/BasicInfoController.dart';
import '../Widgets/FormWidgets.dart';

class Basicinfo extends StatefulWidget {
  const Basicinfo({super.key});

  @override
  State<Basicinfo> createState() => _BasicinfoState();
}

class _BasicinfoState extends State<Basicinfo> {

  final BasicInfoController controller = Get.put(BasicInfoController());
  final PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: pageController,
            onPageChanged: (index) {
              controller.currentFormPage.value = index;
            },
            children: [
              FormWidgets.buildForm(controller),
              FormWidgets().buildSecondForm(),
            ],
          ),
        ),
        // FormWidgets().buildPageIndicator(),
      ],
    );
  }
}
