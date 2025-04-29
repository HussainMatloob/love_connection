import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:love_connection/Controllers/SendConnectionRequest.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Controllers/GetuserController.dart';
import '../../Widgets/NoprofileFound.dart';
import '../../Widgets/ProfileExplorWidget.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  final GetUsersController usersController = Get.put(GetUsersController());
  final SendConectionController sendConectionController =
      Get.put(SendConectionController());
  late final PageController _pageController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController();
    usersController.fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            /// ✅ Responsive Header with Logo
            Container(
              width: double.infinity,
              height: 50.h, // Scales height
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.pink.shade100],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/LClogo2.png',
                  width: 150.w, // Scales with screen width
                  fit: BoxFit.contain,
                  color: Colors.pink.shade300,
                ),
              ),
            ),

            /// ✅ Expandable PageView to Prevent Overflow
            Expanded(
              child: Obx(() {
                if (usersController.isLoading.value) {
                  return Center(
                    child: Lottie.asset(
                      "assets/animations/circularloader.json",
                      height: 100.h, // Responsive animation size
                      width: 100.w,
                    ),
                  );
                } else if (usersController.users.isEmpty) {
                  return NoProfilesScreen(
                    onRefresh: () => usersController.fetchUsers(),
                  );
                } else {
                  return PageView.builder(
                    itemCount: usersController.users.length,
                    controller: _pageController,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      final profile = usersController.users[index];

                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0.w),
                        child: ProfileInfoWidget(
                          name:
                              '${profile['firstname']} ${profile['lastname']}',
                          age: _calculateAge(profile['dateofbirth'] ?? ''),
                          details:
                              '${profile['education']} from ${profile['city']}',
                          location: profile['city'] ?? '',
                          image: _getImageUrl(profile["profileimage"] ?? ''),
                          onClose: () {},

                          /// ✅ Button with Better UI
                          onCheck: () async {
                            final prefs = await SharedPreferences.getInstance();
                            final userID = prefs.getString("userid");
                            sendConectionController.sendConnectionRequest(
                                userID ?? '', profile['id']);
                            usersController.users.removeAt(index);
                          },
                          personalInfo: {
                            'name':
                                '${profile['firstname']} ${profile['lastname']}',
                            'maritalStatus':
                                profile['maritalstatus'] ?? 'Unknown',
                            'sect': profile['sect'] ?? 'Unknown',
                            'caste': profile['cast'] ?? 'Unknown',
                            'height': profile['height'] ?? 'Unknown',
                            'dob': _formatDate(
                                profile['dateofbirth'] ?? 'Unknown'),
                            'religion': profile['religion'] ?? 'Unknown',
                            'nationality': profile['country'] ?? 'Unknown',
                          },
                          educationInfo: {
                            'education': profile['education'] ?? 'Unknown',
                            'monthlyIncome':
                                profile['monthlyincome'] ?? 'Unknown',
                            'employmentStatus':
                                profile['employmentstatus'] ?? 'Unknown',
                          },
                        ),
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

  /// ✅ Responsive Age Calculation
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

  /// ✅ Image URL Helper
  String _getImageUrl(String relativePath) {
    const baseUrl = 'https://projects.funtashtechnologies.com/gomeetapi/';
    return baseUrl + relativePath;
  }

  /// ✅ Date Formatting
  String _formatDate(String date) {
    if (date == '00000000' || date.isEmpty || date == 'null') {
      return 'Unknown';
    }
    try {
      final parsedDate = DateTime.parse(
          '${date.substring(0, 4)}-${date.substring(4, 6)}-${date.substring(6, 8)}');
      return '${parsedDate.day}-${parsedDate.month}-${parsedDate.year}';
    } catch (e) {
      return 'Unknown';
    }
  }
}
