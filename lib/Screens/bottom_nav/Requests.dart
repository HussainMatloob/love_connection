import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:love_connection/Widgets/FormWidgets.dart';

import '../../Widgets/ProfileExplorWidget.dart';

class Requests extends StatefulWidget {
  const Requests({super.key});

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  // create a text controller
  final TextEditingController searchQuery = TextEditingController();

  // create RxString for search query
  final searchQuerytext = "".obs;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: Text(
              'Requests Received',
              style: GoogleFonts.outfit(
                // Use the Outfit font
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w400,
              ),
            ),
            centerTitle: true),
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.all(Get.width * 0.05),
          child: Column(
            children: [
              FormWidgets.buildSearchView(
                  hintText: "Search", searchQuery: searchQuerytext),
              SizedBox(height: Get.height * 0.02),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Two columns
                    crossAxisSpacing: 25, // Horizontal space between cards
                    mainAxisSpacing: 16, // Vertical space between cards
                    childAspectRatio:
                        0.65, // Adjust the aspect ratio of the cards
                  ),
                  itemCount: 10, // Adjust based on the number of items you have
                  itemBuilder: (context, index) {
                    return FormWidgets
                        .buildProfileCard(); // Replace with your card widget
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
