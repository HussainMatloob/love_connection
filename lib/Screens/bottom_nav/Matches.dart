import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:love_connection/Controllers/BasicInfoController.dart';
import 'package:love_connection/Controllers/PendingSendRequests.dart';
import 'package:love_connection/Widgets/FormWidgets.dart';
import '../BasicInfo.dart';
import '../Preferences.dart';

class Matches extends StatefulWidget {
  const Matches({super.key});

  @override
  State<Matches> createState() => _MatchesState();
}

class _MatchesState extends State<Matches> {

  final PageController pageController = PageController();
  final BasicInfoController controller = Get.put(BasicInfoController());
  final GetPendingRequestsController getPendingRequestsController = Get.put(GetPendingRequestsController());


  @override
  Widget build(BuildContext context) {
    getPendingRequestsController.fetchPendingRequests();
    return SafeArea(child: Scaffold(
      appBar: AppBar(title:  Text('Matches',style: GoogleFonts.outfit(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 22 ),), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.only(left: Get.width * 0.05, right: Get.width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormWidgets.buildTabs(controller, 'Completed', 'Pending'),
            SizedBox(height: 10),
            Divider(),
            Expanded(
              child: Obx(() {
                // Render the screen based on the selected tab
                return controller.currentPage.value == 0
                    ? FormWidgets.buildCompletedTab()
                    : FormWidgets().buildPendingTab();
              }),
            ),

          ],
        ),
      ),
    ));
  }
}
