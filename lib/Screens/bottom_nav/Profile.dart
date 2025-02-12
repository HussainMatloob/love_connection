import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:love_connection/Screens/auth/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ApiService/ApiService.dart';
import '../../Controllers/UserInfoController.dart';
import '../../Widgets/FormWidgets.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final UserController userController = Get.put(UserController(ApiService()));

  @override
  void initState() {
    super.initState();
    userController.fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    print(userController.userData);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Profile',
            style: GoogleFonts.outfit(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: 22,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                showCustomDialog(context);
              },
              icon: const Icon(Icons.menu),
            ),
          ],
        ),
        body: Obx(() {
          if (userController.isLoading.value) {
            return Center(
                child: Lottie.asset("assets/animations/circularloader.json",
                    height: 150, width: 150));
          }

          if (userController.userData.value != null) {
            final user = userController.userData.value!;
            return Column(
              children: [
                // Header Section
                Stack(
                  children: [
                    // Background Image
                    Container(
                      width: Get.width,
                      height: Get.height * 0.83,
                      child: CachedNetworkImage(
                        imageUrl: _getImageUrl(user['profileimage'] ??
                            "assets/images/PROFILE.png"),
                        placeholder: (context, url) => Center(
                          child: Lottie.asset(
                            'assets/animations/registerloading.json',
                            // Path to your Lottie file
                            width: Get.width * 0.4,
                            height: Get.height * 0.4,
                            fit: BoxFit.contain,
                          ),
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Profile Details
                    Positioned(
                      bottom: Get.height * 0.05,
                      left: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${user['firstname'] ?? ""}  ${user['lastname'] ?? ""} - ${_getAge(user['dateofbirth'] ?? "")}',
                            style: GoogleFonts.outfit(
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${user['maritalstatus'] ?? ""} , ${user['education'] ?? ""}',
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                          '${user['employmentstatus'] ?? ""}',  style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),),   Text(
                          '${user['nationality'] ?? ""}',  style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: Get.width * 0.1,
                      left: Get.width * 0.1,
                      child: GestureDetector(
                        onVerticalDragUpdate: (details) {
                          if (details.primaryDelta! < -10) {
                            showBasicInfoBottomSheet(context);
                          }
                        },
                        child: Container(
                          width: Get.width * 0.6,
                          height: Get.height * 0.04,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 50,
                                height: 2,
                                color: Colors.black,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Basic Info',
                                style: GoogleFonts.outfit(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }

          return const Center(child: Text('No user data available.'));
        }),
      ),
    );
  }

  String _getImageUrl(String relativePath) {
    const baseUrl =
        'https://projects.funtashtechnologies.com/gomeetapi/'; // Replace with your base URL
    return baseUrl + relativePath;
  }
  int _getAge(String date) {
    if (date == '00000000' || date.isEmpty || date == 'null') {
      return 0; // Unknown age
    }

    try {
      // Parse the birthdate from the given string format
      final birthDate = DateTime.parse(date);

      // Get the current date
      final currentDate = DateTime.now();

      // Calculate the difference in years
      int age = currentDate.year - birthDate.year;

      // Check if the current date has already passed the birthdate for this year
      if (currentDate.month < birthDate.month || (currentDate.month == birthDate.month && currentDate.day < birthDate.day)) {
        age--; // Subtract one if the birthday hasn't occurred yet this year
      }

      return age;
    } catch (e) {
      return 0; // In case of an error or invalid date format
    }
  }


  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          insetPadding: EdgeInsets.only(top: Get.height * 0.07),
          alignment: Alignment.topRight,
          child: Container(
            width: Get.width * 0.6,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildMenuItem( icon:  Icons.person_outline,title:  'Saved Profiles',onTap: (){}),
                buildMenuItem( icon:  Icons.settings_outlined, title: 'Settings',onTap: (){}),
                buildMenuItem(icon:  Icons.share_outlined, title: 'Share App',onTap: (){}),
                const Divider(),
                buildMenuItem(icon: Icons.logout,title:  'Logout', onTap: () async {
                  final prefs= await SharedPreferences.getInstance();
                  prefs.setString("userid", "");
                  Get.offAll(LoginScreen(keyParam: 1,));
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  ListTile buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.pinkAccent.shade100,
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(
        title,
        style: GoogleFonts.outfit(fontWeight: FontWeight.w500, fontSize: 14),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap, // ✅ Executes the provided function when tapped
    );
  }

  void showBasicInfoBottomSheet(BuildContext context) {
    final user = userController.userData.value!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.75, // Adjust height as needed
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Upgrade Button
                  const SizedBox(height: 10),
                  Center(
                    child: InkWell(
                      onTap: () {
                        // Your action here
                        Navigator.pop(context); // Close the bottom sheet
                        FormWidgets().showUpgradeDialog(context);
                      },
                      child: Container(
                        width: Get.width * 0.6,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.yellow.shade600,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Upgrade',
                              style: GoogleFonts.outfit(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 10),
                            SvgPicture.asset(
                              'assets/svg/premium.svg',
                              color: Colors.black,
                              width: 24,
                              height: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Informational Text
                  FormWidgets().buildInfoRow(
                    context,
                    "Boost your profile to the top of search results and get faster,\n handpicked matches tailored to your preferences.",
                  ),
                  const SizedBox(height: 10),
                  FormWidgets().buildInfoRow(
                    context,
                    "Enjoy unlimited messages and see who liked your profile\n to connect with more potential matches.",
                  ),
                  const SizedBox(height: 20),

                  // Basic Information Section
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Basic Information',
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const Icon(Icons.edit, color: Colors.pink),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Basic Information Data Rows
                        FormWidgets().buildBasicInfoRow(
                            'Name', user['firstname'] + " " + user['lastname']),
                        const SizedBox(height: 10),
                        FormWidgets().buildBasicInfoRow(
                            'Marital Status', user['maritalstatus']),
                        const SizedBox(height: 10),
                        FormWidgets().buildBasicInfoRow('Sect', user['sect']),
                        const SizedBox(height: 10),
                        FormWidgets().buildBasicInfoRow('Caste', user['cast']),
                        const SizedBox(height: 10),
                        FormWidgets()
                            .buildBasicInfoRow('Height', user['height']),
                        const SizedBox(height: 10),
                        FormWidgets().buildBasicInfoRow(
                            'Date of Birth', user['dateofbirth']),
                        const SizedBox(height: 10),
                        FormWidgets()
                            .buildBasicInfoRow('Religion', user['religion']),
                        const SizedBox(height: 10),
                        FormWidgets().buildBasicInfoRow(
                            'Nationality', user['nationality']),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Education Information Section
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Education Information',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        FormWidgets().buildBasicInfoRow(
                            'Education', 'Bachelors in Computer Science'),
                        const SizedBox(height: 10),
                        FormWidgets()
                            .buildBasicInfoRow('Monthly Income', user['monthlyincome']),
                        const SizedBox(height: 10),
                        FormWidgets()
                            .buildBasicInfoRow('Employment Status', user['employmentstatus']),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
