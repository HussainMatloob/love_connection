import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:love_connection/Controllers/SendConnectionRequest.dart';
import 'package:love_connection/Widgets/ProfileCard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Controllers/GetuserController.dart';
import '../../Widgets/NoprofileFound.dart';
import '../../Widgets/ProfileExplorWidget.dart';

class Explore extends StatelessWidget {
  Explore({super.key});

  // Reference to GetUsersController
  final GetUsersController usersController = Get.put(GetUsersController());
  final SendConectionController sendConectionController = Get.put(
      SendConectionController());

  @override
  Widget build(BuildContext context) {
    // Fetch user data on page load
    usersController.fetchUsers();

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Top header section
            Positioned(
              top: 0,
              child: Container(
                width: Get.width,
                height: 70,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.pink.shade100],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                    child: Image.asset(
                      'assets/images/LClogo2.png', fit: BoxFit.fitHeight,
                      color: Colors.pink.shade300,
                    )
                ),
              ),
            ),

            // PageView for swipeable profiles
            Positioned.fill(
              top: 70, // Offset to avoid overlapping with the AppBar
              child: Obx(() {
                // Inside your Widget Tree
                if (usersController.isLoading.value) {
                  return Center(
                    child: Lottie.asset(
                      "assets/animations/circularloader.json",
                      height: 150,
                      width: 150,
                    ),
                  );
                } else if (usersController.users.isEmpty) {
                  // 📌 Show NoProfilesScreen when no profiles are found
                  return NoProfilesScreen(onRefresh: () {
                    usersController.fetchUsers(); // Reload profiles when clicked
                  });
                }

                else {
                  return PageView.builder(
                    itemCount: usersController.users.length,
                    controller: PageController(),
                    scrollDirection: Axis.vertical, // Vertical swipe
                    itemBuilder: (context, index) {
                      final profile = usersController.users[index];
                      return ProfileInfoWidget(
                        name: '${profile['firstname']} ${profile['lastname']}',
                        age: _calculateAge(profile['dateofbirth'] ?? ''),
                        details: '${profile['education']} from ${profile['city']}',
                        location: profile['city'] ?? '',
                        image: _getImageUrl(profile["profileimage"] ?? ''),
                        onClose: () {},
                        onCheck: () async {
                          final prefs = await SharedPreferences.getInstance();
                          final userID = prefs.getString("userid").toString();
                          sendConectionController.sendConnectionRequest(
                              userID, profile['id']);
                          usersController.users.removeAt(index);
                        },
                        personalInfo: {
                          'name': '${profile['firstname']} ${profile['lastname']}',
                          'maritalStatus': profile['maritalstatus'] ??
                              'Unknown',
                          'sect': profile['sect'] ?? 'Unknown',
                          'caste': profile['cast'] ?? 'Unknown',
                          'height': profile['height'] ?? 'Unknown',
                          'dob': _formatDate(
                              profile['dateofbirth'] ?? 'Unknown'),
                          'religion': profile['religion'] ?? 'Unknown',
                          'nationality': profile['nationality'] ?? 'Unknown',
                        },
                        educationInfo: {
                          'education': profile['education'] ?? 'Unknown',
                          'monthlyIncome': profile['monthlyincome'] ??
                              'Unknown',
                          'employmentStatus': profile['employmentstatus'] ??
                              'Unknown',
                        },
                      );
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to calculate age from date of birth
  String _calculateAge(String dateOfBirth) {
    if (dateOfBirth.isEmpty) return 'Unknown';
    final dob = DateTime.tryParse(dateOfBirth);
    if (dob == null) return 'Unknown';
    final currentDate = DateTime.now();
    int age = currentDate.year - dob.year;
    if (currentDate.month < dob.month ||
        (currentDate.month == dob.month && currentDate.day < dob.day)) {
      age--;
    }
    return age.toString();
  }

  // Helper method to construct image URL
  String _getImageUrl(String relativePath) {
    const baseUrl = 'https://projects.funtashtechnologies.com/gomeetapi/'; // Replace with your base URL
    return baseUrl + relativePath;
  }

  String _formatDate(String date) {
    if (date == '00000000' || date.isEmpty || date == 'null') {
      return 'Unknown';
    }

    try {
      // Assuming the date is in 'yyyyMMdd' format
      final parsedDate = DateTime.parse(
        '${date.substring(0, 4)}-${date.substring(4, 6)}-${date.substring(
            6, 8)}',
      );
      return '${parsedDate.day}-${parsedDate.month}-${parsedDate.year}';
    } catch (e) {
      return 'Unknown';
    }
  }

}
