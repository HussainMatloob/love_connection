import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:love_connection/Screens/UpdateProfile.dart';
import 'package:love_connection/Screens/auth/Login.dart';
import 'package:love_connection/Screens/verification_document.dart';
import 'package:love_connection/Widgets/custom_dialogs.dart';
import 'package:love_connection/utils/date_time_util.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../ApiService/ApiService.dart';
import '../../Controllers/UserInfoController.dart';
import '../../Widgets/FormWidgets.dart';
import 'package:country_flags/country_flags.dart';

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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
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
                      height: 1.sh,
                      child: CachedNetworkImage(
                        imageUrl: _getImageUrl(user['profileimage']),
                        fadeInCurve: Curves.easeIn,
                        fit: BoxFit.cover,

                        // Show red CircularProgressIndicator while loading
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.pink),
                          ),
                        ),

                        // If failed to load, show fallback professional icon (you can customize this)
                        errorWidget: (context, url, error) => Container(
                          width: Get.width,
                          height: Get.height,
                          color: Colors.grey.shade200,
                          alignment: Alignment.center,
                          child: Image.asset(
                            "assets/images/PROFILE.png", // Professional icon here
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),

                    //add linear gradient color to the image at bottom
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 10.h * 0.2,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Column(childreen[

                    // ]),

                    Positioned(
                      bottom: 70.h,
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
                              SizedBox(width: 3.w),
                              Image.asset(
                                user['status'] == "verified"
                                    ? "assets/images/VarifyBadge.png"
                                    : "assets/images/Unverified.png",
                                width: 30.w,
                                height: 30.h,
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          // Ensure spacing
                          Text(
                            '${user['maritalstatus'] ?? ""}, ${user['education'] ?? ""}',
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          // Ensure spacing
                          Row(
                            children: [
                              // ✅ Display country name
                              Text(
                                '${user['country'] ?? "No country available"}',
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 8.w),

                              // ✅ Display country flag
                              if (user['country'] != null)
                                CountryFlag.fromCountryCode(
                                  getCountryCode(user['country']!),
                                  height: 16.h,
                                  width: 24.w,
                                ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                        ],
                      ),
                    ),

                    Positioned(
                      bottom: 0,
                      left: Get.width * 0.1,
                      right: Get.width * 0.1,
                      child: GestureDetector(
                        onTap: () {
                          showBasicInfoBottomSheet(context);
                        },
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

              return Center(
                child: FadeIn(
                  duration: Duration(milliseconds: 500),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Something went wrong ",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Text(
                          "Please check your connection and try again.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      SizedBox(height: 20.h),
                      ElevatedButton.icon(
                        onPressed: () {
                          userController.fetchUserData();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 24.w, vertical: 14.h),
                          elevation: 5,
                          shadowColor: Colors.pinkAccent.withOpacity(0.3),
                        ),
                        icon: Icon(Icons.refresh,
                            color: Colors.white, size: 20.sp),
                        label: Text(
                          "Retry",
                          style:
                              TextStyle(color: Colors.white, fontSize: 16.sp),
                        ),
                      ),
                    ],
                  ),
                ),
              );
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
      padding: EdgeInsets.all(10.r),
      // width: 120.w,
      // height: 40.h,
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
                    icon: Icons.verified,
                    title: 'Verification Document',
                    onTap: () {
                      Get.to(() => VerificationDocument());
                    }),
                buildMenuItem(
                    icon: Icons.share_outlined,
                    title: 'Share App',
                    onTap: () {
                      Share.share(
                        'Check out my app on the Play Store:\nhttps://play.google.com/store/apps/details?id=com.loveconnection.app',
                        subject: 'Install this app',
                      );
                    }),
                buildMenuItem(
                    icon: Icons.edit,
                    title: 'Edit Preferences',
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.to(() => Updateprofile());
                    }),
                const Divider(),
                buildMenuItem(
                    icon: Icons.logout,
                    title: 'Logout',
                    onTap: () async {
                      CustomDialogs.showQuitDialog(
                        context,
                        height: 210.h,
                        width: 200.w,
                        radius: 10.r,
                        headText: "Logout Confirmation",
                        messageText:
                            "Are you sure you want to log out? You will need to sign in again to access your account.",
                        quitText: "Logout",
                        cancelText: "Cancel",
                        onTap: () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.remove(
                              "userid"); // More appropriate than setting empty string
                          Get.offAll(LoginScreen());
                        },
                      );
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
                              'Comming Soon',
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
                    "Boost your profile to the top of search results and get faster, handpicked matches tailored to your preferences.",
                  ),
                  const SizedBox(height: 10),
                  FormWidgets().buildInfoRow(
                    context,
                    "Enjoy unlimited messages and see who liked your profile to connect with more potential matches.",
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
                            IconButton(
                                onPressed: () {
                                  Get.to(() => Updateprofile());
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.pink,
                                ))
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
                            'Date of Birth',
                            DateTimeUtil.getDate(
                                user['dateofbirth'].split('T').first)),
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

  final Map<String, String> countryNameToCode = {
    "Albania": "AL",
    "Angola": "AO",
    "Argentina": "AR",
    "Austria": "AT",
    "Australia": "AU",
    "Bosnia": "BA",
    "Belgium": "BE",
    "Burkina Faso": "BF",
    "Bulgaria": "BG",
    "Burundi": "BI",
    "Bolivia": "BO",
    "Brazil": "BR",
    "Botswana": "BW",
    "Belarus": "BY",
    "Canada": "CA",
    "Congo (Kinshasa)": "CD",
    "Switzerland": "CH",
    "Chile": "CL",
    "Cameroon": "CM",
    "China": "CN",
    "Colombia": "CO",
    "Cuba": "CU",
    "Germany": "DE",
    "Denmark": "DK",
    "Dominican Republic": "DO",
    "Algeria": "DZ",
    "Ecuador": "EC",
    "Egypt": "EG",
    "Spain": "ES",
    "Ethiopia": "ET",
    "Finland": "FI",
    "France": "FR",
    "United Kingdom": "GB",
    "Guinea": "GN",
    "Greece": "GR",
    "Guatemala": "GT",
    "Croatia": "HR",
    "Hungary": "HU",
    "Indonesia": "ID",
    "Ireland": "IE",
    "India": "IN",
    "Iraq": "IQ",
    "Iran": "IR",
    "Italy": "IT",
    "Jordan": "JO",
    "Japan": "JP",
    "Kenya": "KE",
    "Kyrgyzstan": "KG",
    "Laos": "LA",
    "Lebanon": "LB",
    "Lithuania": "LT",
    "Luxembourg": "LU",
    "Latvia": "LV",
    "Libya": "LY",
    "Moldova": "MD",
    "Montenegro": "ME",
    "Madagascar": "MG",
    "Macedonia": "MK",
    "Mali": "ML",
    "Burma": "MM",
    "Mongolia": "MN",
    "Malta": "MT",
    "Malawi": "MW",
    "Mexico": "MX",
    "Malaysia": "MY",
    "Mozambique": "MZ",
    "Namibia": "NA",
    "Niger": "NE",
    "Netherlands": "NL",
    "Norway": "NO",
    "New Zealand": "NZ",
    "Panama": "PA",
    "Peru": "PE",
    "Philippines": "PH",
    "Pakistan": "PK",
    "Poland": "PL",
    "Puerto Rico": "PR",
    "Portugal": "PT",
    "Paraguay": "PY",
    "Romania": "RO",
    "Serbia": "RS",
    "Russia": "RU",
    "Saudi Arabia": "SA",
    "Sudan": "SD",
    "Sweden": "SE",
    "Slovenia": "SI",
    "Slovakia": "SK",
    "Somalia": "SO",
    "Syria": "SY",
    "Chad": "TD",
    "Thailand": "TH",
    "Tajikistan": "TJ",
    "Tunisia": "TN",
    "Turkey": "TR",
    "Taiwan": "TW",
    "Tanzania": "TZ",
    "Ukraine": "UA",
    "Uganda": "UG",
    "United States of America": "US",
    "Uruguay": "UY",
    "Uzbekistan": "UZ",
    "Venezuela": "VE",
    "Vietnam": "VN",
    "Kosovo": "XK",
    "Yemen": "YE",
    "South Africa": "ZA",
    "Zambia": "ZM",
    "Nepal": "NP",
  };

  String getCountryCode(String countryName) {
    return countryNameToCode[countryName] ??
        "US"; // Default to "US" if not found
  }
} //MAKE IT FULL RESPONSIVE FOR ALL TYPE OF DEVICES SCREENC
