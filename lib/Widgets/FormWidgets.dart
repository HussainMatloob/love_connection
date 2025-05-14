import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:love_connection/ApiService/ApiService.dart';
import 'package:love_connection/Controllers/AuthController.dart';
import 'package:love_connection/Controllers/GetConnections.dart';
import 'package:love_connection/Controllers/PendingSendRequests.dart';
import 'package:love_connection/Controllers/cast_controller.dart';
import 'package:love_connection/Controllers/city_controller.dart';
import 'package:love_connection/Controllers/country_controller.dart';
import 'package:love_connection/Screens/Profilepicture.dart';
import 'package:love_connection/Screens/call_screen.dart';
import 'package:love_connection/Screens/chat_screen.dart';
import 'package:love_connection/Screens/requested_connection_detail_screen.dart';
import 'package:love_connection/Widgets/PinkButton.dart';

import '../Controllers/BasicInfoController.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart'; // Import GoogleFonts
import '../Controllers/religion_controller.dart';
import '../Controllers/sect_controller.dart';
import 'PlanOption.dart';
import 'ProfileCard.dart';
import 'ProfilePendingCard.dart'; // Ensure this import is added
import 'package:animate_do/animate_do.dart';

class FormWidgets {
  final BasicInfoController controller = Get.put(BasicInfoController());
  int? selectedIndex; // Track selected index

  final AuthController authController = Get.put(AuthController());

  // Method to build tabs
  static Widget buildTabs(
      BasicInfoController controller, String tab1, String tab2) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(Get.width * 0.02),
      ),
      child: Row(
        children: [
          _buildTabButton(controller, tab1, 0),
          _buildTabButton(controller, tab2, 1),
        ],
      ),
    );
  }

  // Method to build tab button
  static Widget _buildTabButton(
      BasicInfoController controller, String text, int index) {
    return Obx(() {
      final isSelected = controller.Rcurrentpage.value == index;
      return Expanded(
        child: GestureDetector(
          onTap: () {
            controller.Rcurrentpage.value = index;
            // Update the selected tab
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: Get.height * 0.015),
            decoration: BoxDecoration(
              color: isSelected ? Colors.pink[100] : Colors.transparent,
              borderRadius: BorderRadius.circular(Get.width * 0.02),
            ),
            child: Center(
              child: Text(
                text,
                style: GoogleFonts.outfit(
                  // Use the Outfit font
                  color: isSelected ? Colors.black : Colors.grey,
                  // Change color based on selection
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  // Change weight based on selection
                  fontSize: 16, // Optionally set the font size
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  static Widget buildHomeTabs(BasicInfoController controller,
      PageController pageController, String tab1, String tab2) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(Get.width * 0.02),
      ),
      child: Row(
        children: [
          _buildTabButton1(controller, pageController, tab1, 0),
          // Maps to index 0
          _buildTabButton1(controller, pageController, tab2, 2),
          // Maps to index 2
        ],
      ),
    );
  }

  static Widget _buildTabButton1(BasicInfoController controller,
      PageController pageController, String text, int mappedIndex) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          // pageController.animateToPage(
          //   mappedIndex,
          //   duration: Duration(milliseconds: 300),
          //   curve: Curves.easeInOut,
          // );
          // controller.currentPage.value = mappedIndex;
          //
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: Get.height * 0.015),
          decoration: BoxDecoration(
            color: mappedIndex == 0 ? Colors.pink[100] : Colors.transparent,
            borderRadius: BorderRadius.circular(Get.width * 0.02),
          ),
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.outfit(
                color: mappedIndex == 0 ? Colors.black : Colors.grey,
                fontWeight:
                    mappedIndex == 0 ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget buildForm(BasicInfoController controller) {
    final AuthController authController = Get.put(AuthController());
    return Padding(
      padding: EdgeInsets.all(Get.width * 0.05),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputField('Email', authController.emailController),
            SizedBox(height: Get.height * 0.02),
            _buildInputField('Password', authController.passwordController),
            SizedBox(height: Get.height * 0.02),
            _buildInputField('First Name', authController.firstNameController),
            SizedBox(height: Get.height * 0.02),
            _buildInputField('Last Name', authController.lastNameController),
            SizedBox(height: Get.height * 0.03),
            Text(
              'Gender',
              style: GoogleFonts.outfit(
                color: Colors.grey[600],
                fontSize: Get.width * 0.04,
              ),
            ),
            SizedBox(height: Get.height * 0.02),
            _buildGenderSelection(authController),
            SizedBox(height: Get.height * 0.03),
          ],
        ),
      ),
    );
  }

  // Method to build input field
  static Widget _buildInputField(
      String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            color: Colors.grey[600],
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: Get.height * 0.01),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(Get.width * 0.02),
          ),
          child: TextField(
            controller: controller, // Assign controller
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: Get.width * 0.04,
                vertical: Get.height * 0.015,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Method to build gender selection
  static Widget _buildGenderSelection(AuthController controller) {
    return Row(
      children: [
        Expanded(
          child: _buildGenderOption(
              controller, 'Male', 'male', Icons.male, Colors.blue),
        ),
        SizedBox(width: Get.width * 0.04),
        Expanded(
          child: _buildGenderOption(
              controller, 'Female', 'female', Icons.female, Colors.pink),
        ),
      ],
    );
  }

  static Widget _buildGenderOption(AuthController controller, String label,
      String value, IconData icon, Color color) {
    return Obx(() {
      final isSelected = controller.gender.value == value;
      return GestureDetector(
        onTap: () => controller.setGender(value),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: Get.height * 0.02,
            horizontal: Get.width * 0.04,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(Get.width * 0.02),
            border: isSelected ? Border.all(color: color, width: 2) : null,
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: Get.width * 0.16),
              SizedBox(height: Get.height * 0.01),
              Text(
                label,
                style: GoogleFonts.outfit(
                  color: isSelected ? color : Colors.grey[600],
                  fontWeight: isSelected ? FontWeight.w400 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  static Widget buildDateOfBirth(
      AuthController controller, DateTime dateOfBirth, bool isProfileupdate) {
    return GestureDetector(
      onTap: () async {
        var date = await showDatePicker(
          context: Get.context!,
          initialDate: DateTime.now().subtract(Duration(days: 6570)),
          // 18 years ago
          firstDate: DateTime.now().subtract(Duration(days: 36500)),
          // 100 years ago
          lastDate:
              DateTime.now().subtract(Duration(days: 6570)), // 18 years ago
        );
        if (date != null) controller.setDateOfBirth(date);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Get.width * 0.04,
          vertical: Get.height * 0.015,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(Get.width * 0.02),
          border: Border.all(color: Colors.transparent, width: 0),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: Colors.pink),
            SizedBox(width: Get.width * 0.02),
            Expanded(
              child: Obx(() {
                if (isProfileupdate && controller.dateOfBirth.value == null) {
                  controller.setDateOfBirth(dateOfBirth);
                }

                var date = controller.dateOfBirth.value;

                return Text(
                  date != null
                      ? DateFormat('dd/MM/yyyy').format(date)
                      : 'DD/MM/YYYY',
                  style: GoogleFonts.outfit(
                      color: date != null ? Colors.black : Colors.grey,
                      fontWeight: FontWeight.w400),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPageIndicator() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          2,
          (index) => Obx(() {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              width: 8.w,
              height: 8.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: controller.currentFormPage.value == index
                    ? Colors.pink
                    : Colors.grey[300],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget buildDropdownField({
    required String label,
    required Rxn<String> value,
    required List<String> items,
    double? width,
  }) {
    List<String> uniqueItems = items.toSet().toList();

    if (!uniqueItems.contains(value.value)) {
      value.value = null;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // Prevents unbounded height issues
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            color: Colors.grey[600],
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          // Removed Expanded
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Obx(
            () => DropdownButtonFormField<String>(
              isDense: true,
              isExpanded: true,
              value: value.value,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 12.h,
                ),
                border: InputBorder.none,
              ),
              hint: Text(
                label,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              items: uniqueItems.map((String item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                value.value = newValue;
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSecondForm() {
    final ReligionController religionController = Get.put(ReligionController());

    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: Get.height * 0.75, // Ensures a valid height
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Avoid infinite height issues
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Obx(() {
                    final religions = religionController.religions;
                    if (religions.isEmpty)
                      return const CircularProgressIndicator();
                    return buildDropdownField(
                      label: 'Religion',
                      value: authController.religion,
                      items: religions,
                    );
                  }),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Obx(() {
                    final religions = religionController.religions;
                    if (religions.isEmpty)
                      return const CircularProgressIndicator();
                    return buildDropdownField(
                      label: 'Looking for',
                      value: authController.lookingForReligion,
                      items: religions,
                    );
                  }),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            buildDropdownField(
              label: 'Height',
              value: authController.height,
              items: authController.heightOptions,
            ),
            SizedBox(height: 20.h),
            buildDropdownField(
              label: 'Marital Status',
              value: authController.maritalStatus,
              items: authController.maritalStatusOptions,
            ),
            SizedBox(height: 20.h),
            Text(
              'Date of Birth',
              style: GoogleFonts.outfit(
                color: Colors.grey[600],
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 10.h),
            buildDateOfBirth(authController,
                DateTime.parse('2007-06-04 00:00:00.000'), false),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  static Widget buildPreferencesForm(BasicInfoController controller) {
    final AuthController authController = Get.put(AuthController());
    final CountryController countryController = Get.put(CountryController());
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20.w), // Using ScreenUtil for padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Education Level Dropdown Pair
            buildDropdownPair(
              label1: 'Your Education',
              label2: 'Looking For',
              value: authController.educationLevel,
              lookingForValue: authController.lookingForEducation,
              items: authController.educationOptions,
              hinttext: 'Select Education',
            ),
            SizedBox(height: 24.h),

            Obx(() {
              final countries = [
                "Any",
                ...countryController.countryList
                    .where((country) => country != "Any")
              ];
              final _ = countries.length;

              if (countryController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }
              return buildDropdownPair(
                label1: 'Your Country',
                label2: 'Looking For',
                value: authController.currentResidence,
                lookingForValue: authController.lookingForResidence,
                items: countries,
                hinttext: 'Select Country',
              );
            }),

            SizedBox(height: 24.h),
            // Employment Status Dropdown
            FormWidgets().buildSingleDropdown(
              label1: 'Your Employment Status',
              label2: 'Looking For',
              value: authController.employmentStatus,
              items: authController.employmentOptions,
            ),
            SizedBox(height: 24.h),

            // Income Selection Widget
            FormWidgets().buildIncomeSelection(),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget buildPreferencesForm2(BasicInfoController controller) {
    final AuthController authController = Get.put(AuthController());
    final CityController cityController = Get.put(CityController());
    final CastController castController = Get.put(CastController());
    final SectController sectController = Get.put(SectController());

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // City Dropdown
              Obx(() {
                if (cityController.isLoading.value)
                  return Center(child: CircularProgressIndicator());
                return buildDropdownPair1(
                  label1: 'Your City',
                  label2: 'Looking For',
                  value: authController.cityOfResidence,
                  lookingForValue: authController.lookingForCity,
                  selfItems: [
                    "Any",
                    ...cityController.cityOptions.where((city) => city != "Any")
                  ],

                  lookingForItems: [
                    "Any",
                    ...cityController.lookingForCityOptions
                        .where((city) => city != "Any")
                  ], // Cities for Looking For Residence with "Any"
                  hinttext: 'Select City',
                );
              }),
              SizedBox(height: 8.h),

              // Caste Dropdown with "Any" Option
              Obx(() {
                if (castController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                final List<String> casteNames = castController.castList
                    .map<String>((cast) => cast["cast"].toString())
                    .toList();
                return buildDropdownPair(
                  label1: 'Your Caste',
                  label2: 'Looking For',

                  value: authController.caste,
                  lookingForValue: authController.lookingForCaste,
                  items: [
                    "Any",
                    ...casteNames.where((cast) => cast != "Any")
                  ], // Add "Any" option
                  hinttext:
                      casteNames.isEmpty ? 'No Cast found' : 'Select Cast',
                );
              }),
              SizedBox(height: 8.h),

              // Sect Dropdown with "Any" Option
              Obx(() {
                if (sectController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                return buildDropdownPair(
                  label1: 'Your Sect',
                  label2: 'Looking For',

                  value: authController.sect,
                  lookingForValue: authController.lookingForSect,
                  items: [
                    "Any",
                    ...sectController.sectList.where((sect) => sect != "Any")
                  ], // Add "Any" option
                  hinttext: sectController.sectList.isEmpty
                      ? 'No Sect found'
                      : 'Select Sect',
                );
              }),
              SizedBox(height: 8.h),

              // Ethnicity Dropdown with "Any" Option
              buildDropdownPair(
                  label1: 'Your Ethnicity',
                  label2: 'Looking For',
                  value: authController.ethnicity,
                  lookingForValue: authController.lookingForEthnicity,
                  items: [
                    "Any",
                    ...authController.ethnicityOptions
                        .where((ethnicity) => ethnicity != "Any")
                  ], // Add "Any" option
                  hinttext: "Select Ethnicity"),
              SizedBox(height: 20.h),
            ],
          ),
        ),
        Positioned(
          bottom: 20.h,
          left: 0,
          right: 0,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: PinkButton(
                text: "Next",
                onTap: () {
                  if (authController.cityOfResidence.value == null ||
                      authController.lookingForCity.value == null ||
                      authController.caste.value == null ||
                      authController.lookingForCaste.value == null ||
                      authController.sect.value == null ||
                      authController.lookingForSect.value == null ||
                      authController.ethnicity.value == null ||
                      authController.lookingForEthnicity.value == null) {
                    Get.snackbar(
                      'Error',
                      'Please fill in all required education and residence details.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red.withOpacity(0.8),
                      colorText: Colors.white,
                    );
                    return;
                  } else {
                    Get.to(ProfilePicture());
                  }
                }),
          ),
        ),
      ],
    );
  }

  static Widget buildDropdownPair({
    required String label1,
    required String label2,
    required Rxn<String> value,
    required Rxn<String> lookingForValue,
    required List<String> items,
    required String hinttext,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// First Dropdown
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label1,
                    style: GoogleFonts.outfit(
                      color: Colors.grey[600],
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Obx(
                      () => DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: items.contains(value.value) ? value.value : null,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          border: InputBorder.none,
                        ),
                        hint: Text(
                          hinttext,
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        items: items.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          value.value = newValue;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 16),

            /// Second Dropdown
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label2,
                    style: GoogleFonts.outfit(
                      color: Colors.grey[600],
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Obx(
                      () => DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: items.contains(lookingForValue.value)
                            ? lookingForValue.value
                            : null,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          border: InputBorder.none,
                        ),
                        hint: Text(
                          'Looking for',
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        items: items.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          lookingForValue.value = newValue;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  static Widget buildDropdownPair1({
    required String label1,
    required String label2,
    required Rxn<String> value,
    required Rxn<String> lookingForValue,
    required List<String> selfItems,
    required List<String> lookingForItems,
    required String hinttext,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        Row(
          children: [
            // First Dropdown and Label
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label1,
                    style: GoogleFonts.outfit(
                      color: Colors.grey[600],
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Obx(() {
                      String? selectedValue =
                          selfItems.contains(value.value) ? value.value : null;

                      return DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: selectedValue,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          border: InputBorder.none,
                        ),
                        hint: Text(
                          hinttext,
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        items: selfItems.toSet().map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          value.value = newValue;
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Second Dropdown and Label
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label2,
                    style: GoogleFonts.outfit(
                      color: Colors.grey[600],
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Obx(() {
                      String? selectedLookingForValue =
                          lookingForItems.contains(lookingForValue.value)
                              ? lookingForValue.value
                              : null;

                      return DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: selectedLookingForValue,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          border: InputBorder.none,
                        ),
                        hint: Text(
                          'Looking for',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: Colors.black,
                          ),
                        ),
                        items: lookingForItems.toSet().map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          lookingForValue.value = newValue;
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildSingleDropdown({
    required String label1,
    required String label2,
    required Rxn<String> value,
    required List<String> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label1,
              style: GoogleFonts.outfit(
                color: Colors.grey[600],
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),

            // Text(
            //   label2,
            //   style: GoogleFonts.outfit(
            //     color: Colors.grey[600],
            //     fontSize: 16,
            //     fontWeight: FontWeight.w400,
            //   ),
            // ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Obx(() => DropdownButtonFormField<String>(
                value: value.value,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  border: InputBorder.none,
                ),
                hint: Text(
                  'Select ${label1}',
                  style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w400, fontSize: 13),
                ),
                items: items.map((String item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: GoogleFonts.outfit(fontWeight: FontWeight.w400),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  value.value = newValue;
                },
              )),
        ),
      ],
    );
  }

  Widget buildIncomeSelection() {
    final currencyOptions = [
      {'code': 'USD', 'label': '🇺🇸 USD'},
      {'code': 'INR', 'label': '🇮🇳 INR'},
      {'code': 'EUR', 'label': '🇪🇺 EUR'},
      {'code': 'GBP', 'label': '🇬🇧 GBP'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Monthly Household Income',
          style: GoogleFonts.outfit(
            color: Colors.grey[600],
            fontSize: Get.width * 0.04,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 10),

        // 🏷️ Row for Currency and Income Dropdowns
        Row(
          children: [
            // 🌍 Currency Dropdown (1% width)
            Expanded(
              flex: 30,
              child: Obx(() => Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: authController.selectedCurrency.value,
                      underline: SizedBox(),
                      icon: Icon(Icons.keyboard_arrow_down),
                      style: GoogleFonts.outfit(
                          color: Colors.black87, fontSize: 14),
                      onChanged: (value) =>
                          authController.selectedCurrency.value = value!,
                      items: currencyOptions
                          .map((currency) => DropdownMenuItem<String>(
                                value: currency['code']!,
                                child: Text(currency['label']!,
                                    style: GoogleFonts.outfit(fontSize: 14)),
                              ))
                          .toList(),
                    ),
                  )),
            ),

            SizedBox(width: 8), // Space between dropdowns

            // 💰 Income Dropdown (Remaining width)
            Expanded(
              flex: 70,
              child: Obx(() => Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: authController.monthlyIncome.value,
                      underline: SizedBox(),
                      icon: Icon(Icons.keyboard_arrow_down),
                      style: GoogleFonts.outfit(
                          color: Colors.black87, fontSize: 14),
                      onChanged: (value) =>
                          authController.monthlyIncome.value = value!,
                      items: authController.incomeOptions
                          .map((option) => DropdownMenuItem<String>(
                                value: option,
                                child: Text(option,
                                    style: GoogleFonts.outfit(fontSize: 14)),
                              ))
                          .toList(),
                    ),
                  )),
            ),
          ],
        ),
      ],
    );
  }

  // create a search view widget with search text hint and icon to search text
  static Widget buildSearchView({
    required String hintText,
    required RxString searchQuery,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
              ),
              style: GoogleFonts.outfit(
                  fontSize: 22,
                  color: Colors.grey,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Icon(Icons.search, color: Colors.grey),
        ],
      ),
    );
  }

  // know add card widget with image full full and height and at the bottom of the image add a  name with age , below it job status, and his with country flag
  static Widget buildProfileCard() {
    return Column(children: [
      Container(
        width: Get.width,
        height: Get.height * 0.22,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          // add grey color border
          border: Border.all(color: Colors.pinkAccent),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[200]!,
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Profile Image as the background
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/profile.jpg',
                width: Get.width,
                height: Get.height,
                fit: BoxFit.cover,
              ),
            ),
            // Profile Details Section
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(left: 10, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John Doe, 25',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Software Engineer',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 12),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: Get.width * 0.18,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Center(
              child: Text(
                'Ignore',
                style: GoogleFonts.outfit(
                  color: Colors.pink,
                ),
              ),
            ),
          ),
          Container(
            width: Get.width * 0.18,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.pinkAccent,
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            child: Center(
              child: Text('Accept',
                  style: GoogleFonts.outfit(color: Colors.white)),
            ),
          ),
        ],
      ),
    ]);
  }

  Widget buildCompletedTab(BuildContext context) {
    final GetConnectionsController connectionsController =
        Get.put(GetConnectionsController(ApiService()));

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
// Adjust this factor based on your card layout
    final childAspectRatio = screenWidth / (screenHeight / 1.0);

    return Obx(() {
      if (connectionsController.isLoading.value) {
        return Center(
          child: Lottie.asset(
            "assets/animations/circularloader.json",
            height: 100.h,
            width: 100.w,
          ),
        );
      } else if (connectionsController.connections.isEmpty) {
        return Center(
          child: FadeIn(
            duration: Duration(milliseconds: 500),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/animations/snackbarloading.json',
                  width: 200.w,
                  height: 200.h,
                  fit: BoxFit.cover,
                  repeat: false,
                ),
                SizedBox(height: 8.h),
                Text(
                  "No Love Connections Yet! 💕",
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.pinkAccent,
                  ),
                ),
                SizedBox(height: 8.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Text(
                    "Looks like no one has completed a connection yet. Start connecting with people and accept requests to build your love story! ❤️",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: Colors.black54,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                ElevatedButton.icon(
                  onPressed: () {
                    connectionsController.getconnections();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
                    elevation: 5,
                    shadowColor: Colors.pinkAccent.withOpacity(0.3),
                  ),
                  icon: Icon(Icons.favorite, color: Colors.white, size: 20.sp),
                  label: Text(
                    "Find Your Soulmate 💖",
                    style: TextStyle(color: Colors.white, fontSize: 16.sp),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(height: 10.h),
            // FormWidgets.buildSearchView(
            //   hintText: "Search",
            //   searchQuery: connectionsController.searchQuerytext,
            // ),
            SizedBox(height: 10.h),
            Expanded(
              child: SizedBox(
                height: 0.7.sh, // Enough space for grid view
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.w,
                      mainAxisSpacing: 16.h,
                      childAspectRatio:
                          childAspectRatio // Make card taller to avoid overflow
                      ),
                  itemCount: connectionsController.connections.length,
                  itemBuilder: (context, index) {
                    final connections =
                        connectionsController.connections[index];
                    return ProfileCard(
                        completeRequestData: connections,
                        onTap: () {
                          Get.to(() => RequestedConnectionDetailScreen(
                                imageUrl: connections['selfieimage'] != null
                                    ? '${connections['selfieimage']}'
                                    : '',
                                pendingRequestData: connections,
                              ));
                        },
                        imageUrl: connections['selfieimage'] != null
                            ? 'https://projects.funtashtechnologies.com/gomeetapi/${connections['selfieimage']}'
                            : 'assets/images/profile.jpg',
                        name:
                            '${connections['firstname']} ${connections['lastname']}',
                        profession: connections['education'] ?? 'N/A',
                        ignoreButtonText: 'Call',
                        acceptButtonText: 'Chat',
                        unfollowTab: () {
                          connectionsController.cancelRequest(connections);
                          connectionsController.connections.removeAt(index);
                        },
                        onIgnore: () {
                          Get.to(() => CallScreen());
                        },
                        onAccept: () {
                          Get.to(() => ChatScreen());
                        });
                  },
                ),
              ),
            ),
          ],
        );
      }
    });
  }

  String _formatDate(String date) {
    if (date == '00000000' || date.isEmpty || date == 'null') {
      return 'Unknown';
    }

    try {
      // Assuming the date is in 'yyyyMMdd' format
      final parsedDate = DateTime.parse(
        '${date.substring(0, 4)}-${date.substring(4, 6)}-${date.substring(6, 8)}',
      );
      return '${parsedDate.day}-${parsedDate.month}-${parsedDate.year}';
    } catch (e) {
      return 'Unknown';
    }
  }

  Widget buildPendingTab(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
// Adjust this factor based on your card layout
    final childAspectRatio = screenWidth / (screenHeight / 1.5);
    final GetPendingRequestsController pendingRequestsController =
        Get.put(GetPendingRequestsController());

    return Obx(() {
      if (pendingRequestsController.isLoading.value) {
        return Center(
          child: Lottie.asset(
            "assets/animations/circularloader.json",
            height: 100.h,
            width: 100.w,
          ),
        );
      } else if (pendingRequestsController.pendingRequests.isEmpty) {
        return Center(
          child: FadeIn(
            duration: Duration(milliseconds: 500),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/animations/snackbarloading.json',
                  width: 100.w,
                  height: 100.h,
                  fit: BoxFit.cover,
                  repeat: false,
                ),
                SizedBox(height: 16.h),
                Text(
                  "No Pending Requests Sent! 💌",
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.pinkAccent,
                  ),
                ),
                SizedBox(height: 8.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Text(
                    "You haven’t sent any connection requests yet. Start reaching out and make new love connections today! 💖",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: Colors.black54,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                ElevatedButton.icon(
                  onPressed: () {
                    pendingRequestsController.fetchPendingRequests();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
                    elevation: 5,
                    shadowColor: Colors.pinkAccent.withOpacity(0.3),
                  ),
                  icon: Icon(Icons.favorite_border,
                      color: Colors.white, size: 20.sp),
                  label: Text(
                    "Send a Love Request 💕",
                    style: TextStyle(color: Colors.white, fontSize: 16.sp),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              SizedBox(
                height: 0.8.sh, // Adjusted height for responsiveness
                child: GridView.builder(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.w,
                      mainAxisSpacing: 16.h,
                      childAspectRatio: childAspectRatio),
                  itemCount: pendingRequestsController.pendingRequests.length,
                  itemBuilder: (context, index) {
                    final pendingProfile =
                        pendingRequestsController.pendingRequests[index];

                    return ProfilePendingCard(
                      onTap: () {
                        Get.to(() => RequestedConnectionDetailScreen(
                              imageUrl: pendingProfile['selfieimage'] != null
                                  ? '${pendingProfile['selfieimage']}'
                                  : '',
                              pendingRequestData: pendingProfile,
                            ));
                      },
                      imageUrl: pendingProfile['selfieimage'] != null
                          ? '${pendingProfile['selfieimage']}'
                          : '',
                      name:
                          '${pendingProfile['firstname']} ${pendingProfile['lastname']} ',
                      profession: pendingProfile['city'] ?? 'N/A',
                      onClose: () {
                        // pendingRequestsController.pendingRequests
                        //     .removeAt(index);
                        // pendingRequestsController.cancelRequest(pendingProfile);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }
    });
  }

  Widget buildInfoRow(BuildContext context, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: Colors.pink,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.outfit(
              fontSize: 13,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildBasicInfoRow(String heading, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          heading,
          style: GoogleFonts.outfit(
              color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w400),
        ),
        Text(
          value,
          style: GoogleFonts.outfit(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  void showUpgradeDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.transparent,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            // Blur effect
            child: Container(
              // add blur inside the container
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black
                    .withOpacity(0.4), // Semi-transparent black background
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Close button
                    Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context); // Close dialog
                        },
                        child: const Icon(Icons.close, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Title
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Unlock\n",
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: "Unlimited\n",
                            style: GoogleFonts.roboto(
                              color: Colors.yellow.shade600,
                              // Set yellow color here
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: "Profiles",
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Subtitle
                    Text(
                      "All the following options\n include unlimited access",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PlanOption(
                          badge: "Save 35%",
                          plan: "Monthly",
                          price: "\$4.99",
                          perWeek: "\$1.25/Wk",
                          index: 0, // Provide index for the first plan
                        ),
                        const SizedBox(width: 10),
                        PlanOption(
                          badge: "Save 60%",
                          plan: "Yearly",
                          price: "\$21.99",
                          perWeek: "\$1.25/Wk",
                          isPopular: true,
                          index: 1, // Provide index for the second plan
                        ),
                        const SizedBox(width: 10),
                        PlanOption(
                          badge: "",
                          plan: "Weekly",
                          price: "\$1.99",
                          perWeek: "\$1.25/Wk",
                          index: 2, // Provide index for the third plan
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Continue Button
                    SizedBox(
                      width: Get.width * 0.7,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Close dialog and proceed
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow.shade600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 30),
                        ),
                        child: Text(
                          "Continue",
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Cancel Text
                    Text(
                      "Cancel anytime",
                      style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
