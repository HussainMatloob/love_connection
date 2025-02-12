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
import '../../Widgets/ProfileCard.dart';import 'package:animate_do/animate_do.dart';
import 'package:lottie/lottie.dart';

class Requests extends StatefulWidget {
  const Requests({super.key});

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  // Controller instance
  final GetReceivedConnectionRequestController _controller = Get.put(GetReceivedConnectionRequestController());
  final AcceptRequestController acceptRequestController = Get.put(AcceptRequestController(ApiService()));


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.fetchReceivedConnectionRequests();
  }

  @override
  Widget build(BuildContext context) {
    // Fetch the data when the screen is loaded
    _controller.fetchReceivedConnectionRequests();

    return SafeArea(
      child: Scaffold(
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
        body: Padding(
          padding: EdgeInsets.all(Get.width * 0.05),
          child: Column(
            children: [
              FormWidgets.buildSearchView(
                hintText: "Search",
                searchQuery: _controller.searchQuerytext, // Controller's search query
              ),
              SizedBox(height: Get.height * 0.02),
              Expanded(
                child: Obx(() {
                  if (_controller.isLoading.value) {
                    // Show loading spinner while data is being fetched
                    return  Center(child: Lottie.asset("assets/animations/circularloader.json",height: 150, width: 150));
                  }
                  else if(acceptRequestController.isLoading.value) {
                    return   Center(child: Lottie.asset("assets/animations/circularloader.json",height: 150, width: 150));
                  }
                  else if (_controller.errorMessage.isNotEmpty) {
                    return Center(
                      child: FadeIn(
                        duration: Duration(milliseconds: 500),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              'assets/animations/snackbarloading.json', // Add a nice love-themed animation
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                              repeat: false
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
                              padding: EdgeInsets.symmetric(horizontal: 24),
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
                                 // Reload love requests
                                _controller.fetchReceivedConnectionRequests();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pinkAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                elevation: 5,
                                shadowColor: Colors.pinkAccent.withOpacity(0.3),
                              ),
                              icon: Icon(Icons.favorite, color: Colors.white),
                              label: Text(
                                "Find Your Match 💖",
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Two columns
                      crossAxisSpacing: 25, // Horizontal space between cards
                      mainAxisSpacing: 16, // Vertical space between cards
                      childAspectRatio: 0.65, // Adjust the aspect ratio of the cards
                    ),
                    itemCount: _controller.Getrequests.length, // Use the length of sendRequests
                    itemBuilder: (context, index) {
                      print('Getrequests length: ${_controller.Getrequests.length}');

                      final request = _controller.Getrequests[index];
                      final imageUrl = 'https://projects.funtashtechnologies.com/gomeetapi/${request['profileimage']}'; // API URL for image

                      return ProfileCard(
                        imageUrl: imageUrl,
                        name: '${request['firstname']},${request['lastname']} - ${request['age'] ?? "N/A"}', // Name and age
                        profession: request['city'] ?? 'N/A', // Placeholder if profession is not available
                        ignoreButtonText: 'Ignore',
                        acceptButtonText: 'Accept',
                        onIgnore: () {
                          // remove the request from the list
                          _controller.Getrequests.removeAt(index);
                          _controller.update();
                        },
                        onAccept: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          String userId = prefs.getString("userid").toString();
                          acceptRequestController.acceptRequest(
                            userId: userId,
                            connectionId: request['id'].toString(),
                          );
                        },
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
