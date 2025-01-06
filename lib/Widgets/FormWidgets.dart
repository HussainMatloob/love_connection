import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:love_connection/ApiService/ApiService.dart';
import 'package:love_connection/Controllers/AuthController.dart';
import 'package:love_connection/Controllers/GetConnections.dart';
import 'package:love_connection/Controllers/PendingSendRequests.dart';
import 'package:love_connection/Screens/Profilepicture.dart';
import 'package:love_connection/Widgets/PinkButton.dart';
import '../Controllers/BasicInfoController.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart'; // Import GoogleFonts
import 'PlanOption.dart';
import 'ProfileCard.dart';
import 'ProfilePendingCard.dart'; // Ensure this import is added

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
      final isSelected = controller.currentPage.value == index;
      return Expanded(
        child: GestureDetector(
          onTap: () {
            controller.currentPage.value = index;
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

  static Widget buildForm(BasicInfoController controller) {
    final AuthController authController = Get.put(AuthController());

    return Padding(
      padding: EdgeInsets.all(Get.width * 0.05),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputField(
                authController, 'First Name', authController.firstName),
            SizedBox(height: Get.height * 0.02),
            _buildInputField(
                authController, 'Last Name', authController.lastName),
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
            Text(
              'Date of Birth',
              style: GoogleFonts.outfit(
                color: Colors.grey[600],
                fontSize: Get.width * 0.04,
              ),
            ),
            SizedBox(height: Get.height * 0.02),
            _buildDateOfBirth(authController),
          ],
        ),
      ),
    );
  }

  // Method to build input field
  static Widget _buildInputField(
      AuthController controller, String label, RxString value) {
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
            onChanged: (text) => value.value = text,
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

  // Method to build gender option
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

  // Method to build date of birth picker
  static Widget _buildDateOfBirth(AuthController controller) {
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
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
          border: Border.all(color: Colors.blue, width: 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Obx(() {
                final date = controller.dateOfBirth.value;
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
            Icon(Icons.calendar_today, color: Colors.blue),
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
              width: 8,
              height: 8,
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

  Widget _buildDropdownField({
    required String label,
    required Rxn<String> value,
    required List<String> items,
    double? width,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(height: Get.height * 0.01),
        Container(
          width: width,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(Get.width * 0.02),
          ),
          child: Obx(() => DropdownButtonFormField<String>(
                value: value.value,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: Get.width * 0.04,
                    vertical: Get.height * 0.015,
                  ),
                  border: InputBorder.none,
                ),
                hint: Text(
                  'Select ${label}',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                  ),
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

  Widget buildSecondForm() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(Get.width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDropdownField(
            label: 'Height',
            value: authController.height,
            items: authController.heightOptions,
          ),
          SizedBox(height: Get.height * 0.02),
          _buildDropdownField(
            label: 'Marital Status',
            value: authController.maritalStatus,
            items: authController.maritalStatusOptions,
          ),
          SizedBox(height: Get.height * 0.02),
          Row(
            children: [
              Expanded(
                child: _buildDropdownField(
                  label: 'Religion',
                  value: authController.religion,
                  items: authController.religionOptions,
                ),
              ),
              SizedBox(width: Get.width * 0.02),
              Expanded(
                child: _buildDropdownField(
                  label: 'Looking for',
                  value: authController.lookingForReligion,
                  items: authController.religionOptions,
                ),
              ),
            ],
          ),
          SizedBox(height: Get.height * 0.02),
          Row(
            children: [
              Expanded(
                child: _buildDropdownField(
                  label: 'Nationality',
                  value: authController.nationality,
                  items: authController.nationalityOptions,
                ),
              ),
              SizedBox(width: Get.width * 0.02),
              Expanded(
                child: _buildDropdownField(
                  label: 'Looking for',
                  value: authController.lookingForNationality,
                  items: authController.nationalityOptions,
                ),
              ),
            ],
          ),

          // add pink button
        ],
      ),
    );
  }

  static Widget buildPreferencesForm(BasicInfoController controller) {
    final AuthController authController = Get.put(AuthController());
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(Get.width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Education Level Dropdown Pair
            buildDropdownPair(
              label: 'Education Level',
              value: authController.educationLevel,
              lookingForValue: authController.lookingForEducation,
              items: authController.educationOptions,
              hinttext: 'Select Education',
            ),
            SizedBox(height: 24),

            // Employment Status Dropdown
            FormWidgets().buildSingleDropdown(
              label: 'Employment Status',
              value: authController.employmentStatus,
              items: authController.employmentOptions,
            ),
            SizedBox(height: 24),

            // Income Selection Widget
            FormWidgets().buildIncomeSelection(),
            SizedBox(height: 24),

            // Country of Current Residence Dropdown Pair
            buildDropdownPair(
              label: 'Country of Current Residence',
              value: authController.currentResidence,
              lookingForValue: authController.lookingForResidence,
              items: authController.countryOptions,
              hinttext: 'Select Country',
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  static Widget buildPreferencesForm2(BasicInfoController controller) {
    final AuthController authController = Get.put(AuthController());
    return Padding(
      padding: EdgeInsets.all(Get.width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // City of Current Residence
          buildDropdownPair(
            label: 'City of Current Residence',
            value: authController.cityOfResidence,
            lookingForValue: authController.lookingForCity,
            items: authController.cityOptions,
            hinttext: 'Select City',
          ),
          SizedBox(height: 16),

          // Caste
          buildDropdownPair(
            label: 'Caste',
            value: authController.caste,
            lookingForValue: authController.lookingForCaste,
            items: authController.casteOptions,
            hinttext: 'Select Caste',
          ),
          SizedBox(height: 16),

          // Sub-Caste (optional)
          buildDropdownPair(
            label: 'Sub-Caste (optional)',
            value: authController.subCaste,
            lookingForValue: authController.lookingForSubCaste,
            items: authController.subCasteOptions,
            hinttext: 'Select Sub-Caste',
          ),
          SizedBox(height: 16),

          // Sect
          buildDropdownPair(
            label: 'Sect',
            value: authController.sect,
            lookingForValue: authController.lookingForSect,
            items: authController.sectOptions,
            hinttext: 'Select Sect',
          ),
          SizedBox(height: 16),

          // Sub-Sect (optional)
          buildDropdownPair(
            label: 'Sub-Sect (optional)',
            value: authController.subSect,
            lookingForValue: authController.lookingForSubSect,
            items: authController.subSectOptions,
            hinttext: 'Select Sub-Sect',
          ),
          SizedBox(height: 16),

          // Ethnicity
          buildDropdownPair(
              label: 'Ethnicity',
              value: authController.ethnicity,
              lookingForValue: authController.lookingForEthnicity,
              items: authController.ethnicityOptions,
              hinttext: "Select Ethnicity"),

          SizedBox(height: 16),

          PinkButton(
              text: "Next",
              onTap: () {
                Get.to(Profilepicture());
              })
        ],
      ),
    );
  }

  static Widget buildDropdownPair({
    required String label,
    required Rxn<String> value,
    required Rxn<String> lookingForValue,
    required List<String> items,
    required String hinttext,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
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
                        hinttext,
                        style: GoogleFonts.outfit(
                            fontSize: 13, fontWeight: FontWeight.w400),
                      ),
                      items: items.map((String item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(
                            item,
                            style:
                                GoogleFonts.outfit(fontWeight: FontWeight.w400),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        value.value = newValue;
                      },
                    )),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Obx(() => DropdownButtonFormField<String>(
                      value: lookingForValue.value,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        border: InputBorder.none,
                      ),
                      hint: Text(
                        'Looking for',
                        style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: Colors.white),
                      ),
                      items: items.map((String item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(
                            item,
                            style:
                                GoogleFonts.outfit(fontWeight: FontWeight.w400),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        lookingForValue.value = newValue;
                      },
                    )),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildSingleDropdown({
    required String label,
    required Rxn<String> value,
    required List<String> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            color: Colors.grey[600],
            fontSize: Get.width * 0.04,
          ),
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
                  'Select ${label}',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Monthly Household Income',
          style: GoogleFonts.outfit(
              color: Colors.grey[600],
              fontSize: Get.width * 0.04,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(height: 8),
        ...authController.incomeOptions.map(
          (option) => Obx(
            () => Container(
              padding: EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: RadioListTile<String>(
                title: Text(
                  option,
                  style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w400, fontSize: 13),
                ),
                value: option,
                groupValue: authController.monthlyIncome.value,
                onChanged: (value) =>
                    authController.monthlyIncome.value = value,
                contentPadding: EdgeInsets.zero,
                activeColor: Colors.pink,
              ),
            ),
          ),
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

  Widget buildCompletedTab() {
    final GetConnectionsController connectionsController =
        Get.put(GetConnectionsController(ApiService()));
    RxString searchQuery = "".obs;
    return Obx(() {
      if (connectionsController.isLoading.value) {
        // Show a loading indicator while fetching data
        return Center(
            child: Lottie.asset("assets/animations/circularloader.json",
                height: 150, width: 150));
      } else if (connectionsController.connections.isEmpty) {
        // Show a message if there are no pending requests
        return Center(
          child: Text(
            connectionsController.responseMessage.value,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        );
      } else {
        // Display the list of pending profiles
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Get.height * 0.01),
              FormWidgets.buildSearchView(
                hintText: "Search",
                searchQuery: connectionsController.searchQuerytext,
              ),
              SizedBox(height: Get.height * 0.01),
              // Remove Expanded or use a constrained height
              SizedBox(
                height: Get.height * 0.7, // Adjust based on your desired layout
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Two columns
                    crossAxisSpacing: 16, // Horizontal space between cards
                    mainAxisSpacing: 16, // Vertical space between cards
                    childAspectRatio:
                        0.65, // Adjust the aspect ratio of the cards
                  ),
                  itemCount: connectionsController.connections.length,
                  // Adjust based on the number of items you have
                  itemBuilder: (context, index) {
                    final connections =
                        connectionsController.connections[index];
                    return ProfileCard(
                      imageUrl: connections['profileimage'] != null
                          ? 'https://projects.funtashtechnologies.com/gomeetapi/${connections['profileimage']}'
                          : 'assets/images/profile.jpg',
                      name:
                          '${connections['firstname']} ${connections['lastname']} - ${_formatDate(connections['dateofbirth'] ?? 'N/A')}',
                      profession:
                          connections['education'] ?? 'N/A',
                      ignoreButtonText: 'Call',
                      acceptButtonText: 'Chat',
                      onIgnore: () {
                        print('Call');
                      },
                      onAccept: () {
                        print('Chat');
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

  Widget buildPendingTab() {
    final GetPendingRequestsController pendingRequestsController =
        Get.put(GetPendingRequestsController());

    return Obx(() {
      if (pendingRequestsController.isLoading.value) {
        // Show a loading indicator while fetching data
        return Center(
            child: Lottie.asset("assets/animations/circularloader.json",
                height: 150, width: 150));
      } else if (pendingRequestsController.pendingRequests.isEmpty) {
        // Show a message if there are no pending requests
        return Center(
          child: Text(
            pendingRequestsController.errorMessage.value,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        );
      } else {
        // Display the list of pending profiles
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Get.height * 0.01),
              SizedBox(
                height: Get.height, // Adjust based on your desired layout
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Two columns
                    crossAxisSpacing: 16, // Horizontal space between cards
                    mainAxisSpacing: 16, // Vertical space between cards
                    childAspectRatio:
                        0.80, // Adjust the aspect ratio of the cards
                  ),
                  itemCount: pendingRequestsController.pendingRequests.length,
                  itemBuilder: (context, index) {
                    final pendingProfile =
                        pendingRequestsController.pendingRequests[index];

                    return ProfilePendingCard(
                      imageUrl: pendingProfile['profileimage'] != null
                          ? 'https://projects.funtashtechnologies.com/gomeetapi/${pendingProfile['profileimage']}'
                          : 'assets/images/profile.jpg',
                      name:
                          '${pendingProfile['firstname']} ${pendingProfile['lastname']} - ${_formatDate(pendingProfile['dateofbirth'] ?? 'N/A')}',
                      profession: pendingProfile['city'] ?? 'N/A',
                      onClose: () {
                        // Handle onClose action, e.g., remove from the list
                        pendingRequestsController.pendingRequests
                            .removeAt(index);
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
            fontSize: 14,
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
