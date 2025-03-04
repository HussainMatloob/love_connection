import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:love_connection/Screens/UpdateProfile.dart';
import 'package:love_connection/Screens/auth/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Profile',
                style: GoogleFonts.outfit(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 18.sp,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
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
                  child: Lottie.asset(
                    "assets/animations/circularloader.json",
                    height: 100.h,
                    width: 100.h,
                  ),
                );
              }

              if (userController.userData.value != null) {
                final user = userController.userData.value!;
                return Stack(
                  children: [
                    SizedBox(
                      width: 1.sw,
                      height: 1.sh - 60.h, // Dynamically adjusting height
                      child: CachedNetworkImage(
                        imageUrl: _getImageUrl(user['profileimage']),
                        fadeInCurve: Curves.easeIn,
                        placeholder: (context, url) => Image.asset(
                          "assets/images/PROFILE.png",
                          fit: BoxFit.cover,
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          "assets/images/PROFILE.png",
                          fit: BoxFit.cover,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 15.h,
                      left: 12.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${user['firstname'] ?? ""} ${user['lastname'] ?? ""} - ${_getAge(user['dateofbirth'] ?? "")}',
                                style: GoogleFonts.outfit(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(width: 5.w),
                              Image.asset(
                                user['status'] == "verified"
                                    ? "assets/images/VarifyBadge.png"
                                    : "assets/images/Unverified.png",
                                width: 30.w,
                                height: 30.h,
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          // Ensure spacing
                          Text(
                            '${user['maritalstatus'] ?? ""}, ${user['education'] ?? ""}',
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 3.h),
                          // Ensure spacing
                          Text(
                            '${user['country'] ?? "No country available"}',
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 10.h),

                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: Get.width * 0.1,
                      right: Get.width * 0.1,
                      child: GestureDetector(
                        onVerticalDragUpdate: (details) {
                          if (details.primaryDelta! < -10) {
                            showBasicInfoBottomSheet(context);
                          }
                        },
                        child: _buildSwipeUpIndicator(),
                      ),
                    ),
                  ],
                );
              }

              return const Center(child: Text('No user data available.'));
            }),
          ),
        );
      },
    );
  }

  String _getImageUrl(String relativePath) {
    const baseUrl = 'https://projects.funtashtechnologies.com/gomeetapi/';
    return baseUrl + relativePath;
  }

  int _getAge(String date) {
    if (date == '00000000' || date.isEmpty || date == 'null') {
      return 0;
    }
    try {
      final birthDate = DateTime.parse(date);
      final currentDate = DateTime.now();
      int age = currentDate.year - birthDate.year;
      if (currentDate.month < birthDate.month ||
          (currentDate.month == birthDate.month &&
              currentDate.day < birthDate.day)) {
        age--;
      }
      return age;
    } catch (e) {
      return 0;
    }
  }

  Widget _buildSwipeUpIndicator() {
    return Container(
      width: 120.w,
      height: 30.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(width: 50.w, height: 3.h, color: Colors.black),
          SizedBox(height: 5.h),
          Text(
            "Basic Info",
            style: GoogleFonts.outfit(
                fontSize: 16.sp, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          insetPadding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.07),
          alignment: Alignment.topRight,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.6,
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
                buildMenuItem(
                    icon: Icons.person_outline,
                    title: 'Saved Profiles',
                    onTap: () {}),
                buildMenuItem(
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    onTap: () {}),
                buildMenuItem(
                    icon: Icons.share_outlined,
                    title: 'Share App',
                    onTap: () {}),
                const Divider(),
                buildMenuItem(
                    icon: Icons.logout,
                    title: 'Logout',
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setString("userid", "");
                      Get.offAll(LoginScreen(
                        keyParam: 1,
                      ));
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
      onTap: onTap,
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
          heightFactor: 0.75,
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
                  const SizedBox(height: 10),
                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        FormWidgets().showUpgradeDialog(context);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
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
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                            GestureDetector(
                                onTap: () {
                                  Get.to(() => UpdateProfileScreen());
                                },
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.pink,
                                )),
                          ],
                        ),
                        const SizedBox(height: 10),
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
                        FormWidgets()
                            .buildBasicInfoRow('Nationality', user['country']),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
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
                        FormWidgets().buildBasicInfoRow(
                            'Monthly Income', user['monthlyincome']),
                        const SizedBox(height: 10),
                        FormWidgets().buildBasicInfoRow(
                            'Employment Status', user['employmentstatus']),
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
} //MAKE IT FULL RESPONSIVE FOR ALL TYPE OF DEVICES SCREENC
