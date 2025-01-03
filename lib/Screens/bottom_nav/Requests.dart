import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:love_connection/ApiService/ApiService.dart';
import 'package:love_connection/Controllers/AcceptRequestController.dart';
import 'package:love_connection/Widgets/FormWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Controllers/GetConnectionRequest.dart';
import '../../Widgets/ProfileCard.dart';

class Requests extends StatefulWidget {
  const Requests({super.key});

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  // Controller instance
  final GetReceivedConnectionRequestController controller = Get.put(GetReceivedConnectionRequestController());
  final AcceptRequestController acceptRequestController = Get.put(AcceptRequestController(ApiService()));

  @override
  Widget build(BuildContext context) {
    // Fetch the data when the screen is loaded
    controller.fetchReceivedConnectionRequests();
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
                searchQuery: controller.searchQuerytext, // Use the controller's searchQuerytext
              ),
              SizedBox(height: Get.height * 0.02),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    // Show loading spinner while data is being fetched
                    return Center(child: CircularProgressIndicator());
                  }

                  if (controller.errorMessage.isNotEmpty) {
                    // Show error message if there is any
                    return Center(child: Text(controller.errorMessage.value));
                  }

                  // Data is fetched successfully, display it in GridView
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Two columns
                      crossAxisSpacing: 25, // Horizontal space between cards
                      mainAxisSpacing: 16, // Vertical space between cards
                      childAspectRatio: 0.65, // Adjust the aspect ratio of the cards
                    ),
                    itemCount: controller.Getrequests.length, // Use the length of sendRequests
                    itemBuilder: (context, index) {
                      final request = controller.Getrequests[index];
                      final imageUrl = 'https://projects.funtashtechnologies.com/gomeetapi/${request['profileimage']}'; // API URL for image

                      return ProfileCard(
                        imageUrl: imageUrl,
                        name: '${request['firstname']}, ${request['age'] ?? "N/A"}', // Name and age
                        profession: request['profession'] ?? 'N/A', // Placeholder if profession is not available
                        ignoreButtonText: 'Ignore',
                        acceptButtonText: 'Accept',
                        onIgnore: () {
                          // remove the request from the list
                          controller.Getrequests.removeAt(index);
                          controller.update();
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
