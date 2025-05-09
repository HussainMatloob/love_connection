import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:love_connection/ApiService/ApiService.dart';
import 'package:love_connection/Controllers/AcceptRequestController.dart';
import 'package:love_connection/Widgets/FormWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Controllers/GetConnectionRequest.dart';
import '../../Widgets/ProfileCard.dart';
import 'package:animate_do/animate_do.dart';

class Requests extends StatefulWidget {
  const Requests({super.key});

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  // Controller instance
  final GetReceivedConnectionRequestController _controller =
      Get.put(GetReceivedConnectionRequestController());
  final AcceptRequestController acceptRequestController =
      Get.put(AcceptRequestController(ApiService()));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.fetchReceivedConnectionRequests();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
// Adjust this factor based on your card layout
    final childAspectRatio = screenWidth / (screenHeight / 1.4);
    // Fetch the data when the screen is loaded
    _controller.fetchReceivedConnectionRequests();

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset:
            true, // Ensures keyboard doesn't cause overflow
        appBar: AppBar(
          title: Text(
            'Requests Received',
            style: GoogleFonts.outfit(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.w400,
            ),
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
              child: Column(
                children: [
                  FormWidgets.buildSearchView(
                    hintText: "Search",
                    searchQuery: _controller.searchQuerytext,
                  ),
                  SizedBox(height: Get.height * 0.015),
                  Expanded(
                    child: Obx(() {
                      if (_controller.isLoading.value ||
                          acceptRequestController.isLoading.value) {
                        return Center(
                          child: Lottie.asset(
                            "assets/animations/circularloader.json",
                            height: 150,
                            width: 150,
                          ),
                        );
                      }
                      if (_controller.errorMessage.isNotEmpty) {
                        return Center(
                          child: SingleChildScrollView(
                            child: FadeIn(
                              duration: Duration(milliseconds: 500),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Lottie.asset(
                                    'assets/animations/snackbarloading.json',
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                    repeat: false,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "No Love Requests Yet! 💔",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.pinkAccent,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    child: Text(
                                      "Your love connection requests will appear here. Send a request or wait for someone special to find you! 💕",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      _controller
                                          .fetchReceivedConnectionRequests();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.pinkAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 14),
                                      elevation: 5,
                                    ),
                                    icon: Icon(Icons.favorite,
                                        color: Colors.white),
                                    label: Text(
                                      "Find Your Match 💖",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              MediaQuery.of(context).size.width < 360 ? 1 : 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 16,
                          childAspectRatio: childAspectRatio,
                        ),
                        itemCount: _controller.Getrequests.length,
                        itemBuilder: (context, index) {
                          final request = _controller.Getrequests[index];

                          final imageUrl =
                              'https://projects.funtashtechnologies.com/gomeetapi/${request['selfieimage']}';

                          return ProfileCard(
                            isRequestScreen: true,
                            imageUrl: imageUrl,
                            name:
                                '${request['firstname']},${request['lastname']} - ${request['age'] ?? "N/A"}',
                            profession: request['city'] ?? 'N/A',
                            ignoreButtonText: 'Ignore',
                            acceptButtonText: 'Accept',
                            onIgnore: () {
                              _controller.Getrequests.removeAt(index);
                              _controller.update();
                            },
                            onAccept: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              String userId =
                                  prefs.getString("userid").toString();
                              acceptRequestController.acceptRequest(
                                  userId: userId,
                                  // connectionId: request['id'].toString(),
                                  connectionId: "12");
                            },
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
