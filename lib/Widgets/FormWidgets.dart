import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:love_connection/Screens/Profilepicture.dart';
import 'package:love_connection/Widgets/PinkButton.dart';
import '../Controllers/BasicInfoController.dart';
import 'package:intl/intl.dart'; // Ensure this import is added

class FormWidgets {
  final BasicInfoController controller = Get.put(BasicInfoController());

  // Method to build tabs
  static Widget buildTabs(BasicInfoController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(Get.width * 0.02),
      ),
      child: Row(
        children: [
          _buildTabButton(controller, 'Basic', 0),
          _buildTabButton(controller, 'Preferences', 1),
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
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.grey,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  // Method to build the form
  static Widget buildForm(BasicInfoController controller) {
    return Padding(
      padding: EdgeInsets.all(Get.width * 0.05),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputField(controller, 'First Name', controller.firstName),
            SizedBox(height: Get.height * 0.02),
            _buildInputField(controller, 'Last Name', controller.lastName),
            SizedBox(height: Get.height * 0.03),
            Text(
              'Gender',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: Get.width * 0.04,
              ),
            ),
            SizedBox(height: Get.height * 0.02),
            _buildGenderSelection(controller),
            SizedBox(height: Get.height * 0.03),
            Text(
              'Date of Birth',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: Get.width * 0.04,
              ),
            ),
            SizedBox(height: Get.height * 0.02),
            _buildDateOfBirth(controller),
          ],
        ),
      ),
    );
  }

  // Method to build input field
  static Widget _buildInputField(
      BasicInfoController controller, String label, RxString value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: Get.width * 0.04,
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
  static Widget _buildGenderSelection(BasicInfoController controller) {
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
  static Widget _buildGenderOption(BasicInfoController controller, String label,
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
                style: TextStyle(
                  color: isSelected ? color : Colors.grey[600],
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // Method to build date of birth picker
  static Widget _buildDateOfBirth(BasicInfoController controller) {
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
                  style: TextStyle(
                    color: date != null ? Colors.black : Colors.grey,
                  ),
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
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: Get.width * 0.04,
          ),
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
                hint: Text('Select ${label}'),
                items: items.map((String item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item),
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
            value: controller.height,
            items: controller.heightOptions,
          ),
          SizedBox(height: Get.height * 0.02),
          _buildDropdownField(
            label: 'Marital Status',
            value: controller.maritalStatus,
            items: controller.maritalStatusOptions,
          ),
          SizedBox(height: Get.height * 0.02),
          Row(
            children: [
              Expanded(
                child: _buildDropdownField(
                  label: 'Religion',
                  value: controller.religion,
                  items: controller.religionOptions,
                ),
              ),
              SizedBox(width: Get.width * 0.02),
              Expanded(
                child: _buildDropdownField(
                  label: 'Looking for',
                  value: controller.lookingForReligion,
                  items: controller.religionOptions,
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
                  value: controller.nationality,
                  items: controller.nationalityOptions,
                ),
              ),
              SizedBox(width: Get.width * 0.02),
              Expanded(
                child: _buildDropdownField(
                  label: 'Looking for',
                  value: controller.lookingForNationality,
                  items: controller.nationalityOptions,
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
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(Get.width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Education Level Dropdown Pair
            buildDropdownPair(
              label: 'Education Level',
              value: controller.educationLevel,
              lookingForValue: controller.lookingForEducation,
              items: controller.educationOptions,
              hinttext: 'Select Education',
            ),
            SizedBox(height: 24),

            // Employment Status Dropdown
            FormWidgets().buildSingleDropdown(
              label: 'Employment Status',
              value: controller.employmentStatus,
              items: controller.employmentOptions,
            ),
            SizedBox(height: 24),

            // Income Selection Widget
            FormWidgets().buildIncomeSelection(),
            SizedBox(height: 24),

            // Country of Current Residence Dropdown Pair
           buildDropdownPair(
              label: 'Country of Current Residence',
              value: controller.currentResidence,
              lookingForValue: controller.lookingForResidence,
              items: controller.countryOptions,
              hinttext: 'Select Country',
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }


  static Widget buildPreferencesForm2(BasicInfoController controller) {
    return Padding(
      padding: EdgeInsets.all(Get.width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // City of Current Residence
          buildDropdownPair(
            label: 'City of Current Residence',
            value: controller.cityOfResidence,
            lookingForValue: controller.lookingForCity,
            items: controller.cityOptions,
            hinttext: 'Select City',
          ),
          SizedBox(height: 16),

          // Caste
          buildDropdownPair(
            label: 'Caste',
            value: controller.caste,
            lookingForValue: controller.lookingForCaste,
            items: controller.casteOptions,
            hinttext: 'Select Caste',
          ),
          SizedBox(height: 16),

          // Sub-Caste (optional)
          buildDropdownPair(
            label: 'Sub-Caste (optional)',
            value: controller.subCaste,
            lookingForValue: controller.lookingForSubCaste,
            items: controller.subCasteOptions,
            hinttext: 'Select Sub-Caste',
          ),
          SizedBox(height: 16),

          // Sect
          buildDropdownPair(
            label: 'Sect',
            value: controller.sect,
            lookingForValue: controller.lookingForSect,
            items: controller.sectOptions,
            hinttext: 'Select Sect',
          ),
          SizedBox(height: 16),

          // Sub-Sect (optional)
          buildDropdownPair(
            label: 'Sub-Sect (optional)',
            value: controller.subSect,
            lookingForValue: controller.lookingForSubSect,
            items: controller.subSectOptions,
            hinttext: 'Select Sub-Sect',
          ),
          SizedBox(height: 16),

          // Ethnicity
          buildDropdownPair(
            label: 'Ethnicity',
            value: controller.ethnicity,
            lookingForValue: controller.lookingForEthnicity,
            items: controller.ethnicityOptions,
            hinttext: "Select Ethnicity"
          ),

          SizedBox(height: 16),

          PinkButton(text: "Next", onTap: (){
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
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: Get.width * 0.04,
          ),
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
                      hint: Text(hinttext),
                      items: items.map((String item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item),
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
                      hint: Text('Looking for'),
                      items: items.map((String item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item),
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
          style: TextStyle(
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
                hint: Text('Select ${label}'),
                items: items.map((String item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item),
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
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: Get.width * 0.04,
          ),
        ),
        SizedBox(height: 8),
        ...controller.incomeOptions.map(
          (option) => Obx(
            () => Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: controller.monthlyIncome.value,
                onChanged: (value) => controller.monthlyIncome.value = value,
                contentPadding: EdgeInsets.zero,
                activeColor: Colors.pink,
              ),
            ),
          ),
        ),
      ],
    );
  }

}
