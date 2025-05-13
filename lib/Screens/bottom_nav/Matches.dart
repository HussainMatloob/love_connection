import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:love_connection/ApiService/ApiService.dart';
import 'package:love_connection/Controllers/BasicInfoController.dart';
import 'package:love_connection/Controllers/PendingSendRequests.dart';
import 'package:love_connection/Widgets/FormWidgets.dart';
import '../../Controllers/GetConnections.dart';

class Matches extends StatefulWidget {
  const Matches({super.key});

  @override
  State<Matches> createState() => _MatchesState();
}

class _MatchesState extends State<Matches> {
  final PageController pageController = PageController();
  final BasicInfoController controller = Get.put(BasicInfoController());
  final GetPendingRequestsController getPendingRequestsController =
      Get.put(GetPendingRequestsController());
  final GetConnectionsController getConnectionsController =
      Get.put(GetConnectionsController(ApiService()));

  @override
  void initState() {
    super.initState();
    // Fetch API data only once
    getPendingRequestsController.fetchPendingRequests();
    getConnectionsController.getconnections();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Matches',
              style: GoogleFonts.outfit(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 22.sp, // Responsive text
              ),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: 20.w), // Responsive padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormWidgets.buildTabs(controller, 'Completed', 'Pending'),
                SizedBox(height: 10.h), // Responsive spacing
                Divider(),
                Expanded(
                  child: Obx(() {
                    // Render the screen based on the selected tab
                    return controller.Rcurrentpage.value == 0
                        ? FormWidgets().buildCompletedTab(context)
                        : FormWidgets().buildPendingTab(context);
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
