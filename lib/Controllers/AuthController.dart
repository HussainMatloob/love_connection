import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:love_connection/Controllers/image_controller.dart';
import 'package:love_connection/Controllers/selfie_upload_controller.dart';
import 'package:love_connection/Screens/auth/Login.dart';
import '../ApiService/ApiService.dart';
import 'ProfilePictureController.dart';
import 'document_upload_controller.dart';

class AuthController extends GetxController {
  final ProfilepictureController profilepictureController =
      Get.put(ProfilepictureController());

  final DocumentUploadController documentUploadController =
      Get.put(DocumentUploadController());

  final SelfieImageController _selfieImageController =
      Get.put(SelfieImageController());
  final ImageController imageController = Get.put(ImageController());

  // Instead of RxString, use TextEditingController
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Observables
  var isLoading = false.obs; // To manage loading state
  var isLoading1 = false.obs; // To manage loading state
  var errorMessage = ''.obs; // To manage error messages
  var userData = {}.obs; // Store user data if needed (e.g., user profile)
  Rx<File?> profileImage = Rx<File?>(null);
  Rx<File?> galleryimages = Rx<File?>(null);
  Rx<File?> selfieimage = Rx<File?>(null);
  Rx<File?> cninfront = Rx<File?>(null);
  Rx<File?> cninback = Rx<File?>(null);
  Rx<File?> passportfront = Rx<File?>(null);
  Rx<File?> passportback = Rx<File?>(null);

  // final firstName = 'Enter first name'.obs;
  // final lastName = 'Enter last name'.obs;
  // final email = 'Enter email'.obs;
  // final password = 'Enter password'.obs;
  final gender = Rxn<String>();
  final dateOfBirth = Rxn<DateTime>();
  var createdAt = DateTime.now().obs; // Reactive variable to store created_at

  // Second form fields
  final height = Rxn<String>();
  final maritalStatus = Rxn<String>();
  final religion = Rxn<String>();
  final lookingForReligion = Rxn<String>();
  final nationality = Rxn<String>();
  final lookingForNationality = Rxn<String>();

  // Page control
  void setGender(String? value) => gender.value = value;

  void setDateOfBirth(DateTime? value) => dateOfBirth.value = value;

  final educationLevel = Rxn<String>();
  final lookingForEducation = Rxn<String>();
  final employmentStatus = Rxn<String>();
  final monthlyIncome = Rxn<String>();
  final currentResidence = Rxn<String>();
  final lookingForResidence = Rxn<String>();

  void updateProfileImage(File image) {
    profileImage.value = image;
  }

  Rx<File?> getprofileimage() {
    return profilepictureController.profileImage;
  }

  final List<String> educationOptions = [
    'High School',
    'Bachelor\'s Degree',
    'Master\'s Degree',
    'Doctorate',
    'Other'
  ];

  final List<String> employmentOptions = [
    'Employed',
    'Self-Employed',
    'Business Owner',
    'Student',
    'Unemployed'
  ];

  final List<String> incomeOptions = [
    'Below 1000',
    '1000 - 3000',
    '3000 - 5000',
    '5000 - 10,000',
    'Above 10,000',
  ];

  final List<String> countryOptions = [
    'United States',
    'United Kingdom',
    'Canada',
    'Australia',
    'Other'
  ];

  // Dropdown options
  final List<String> heightOptions = [
    '4\'8"',
    '4\'9"',
    '4\'10"',
    '4\'11"',
    '5\'0"',
    '5\'1"',
    '5\'2"',
    '5\'3"',
    '5\'4"',
    '5\'5"',
    '5\'6"',
    '5\'7"',
    '5\'8"',
    '5\'9"',
    '5\'10"',
    '5\'11"',
    '6\'0"',
    '6\'1"',
    '6\'2"',
    '6\'3"',
    '6\'4"',
    '6\'5"',
    '6\'6"',
    '6\'7"',
    '6\'8"',
    '6\'9"',
    '6\'10"',
    '6\'11"',
    '7\'0"'
  ];
  final List<String> maritalStatusOptions = [
    'Single',
    'Divorced',
    'Widowed',
    'Separated'
  ];
  final List<String> religionOptions = [
    'Islam',
    'Christianity',
    'Judaism',
    'Hinduism',
    'Buddhism',
    'Other'
  ];
  final List<String> nationalityOptions = [
    'American',
    'British',
    'Canadian',
    'Australian',
    'Indian',
    'Pakistani',
    'Other'
  ];

  // Preferences fields
  final cityOfResidence = Rxn<String>('');
  final lookingForCity = Rxn<String>('');
  final caste = Rxn<String>('');
  final lookingForCaste = Rxn<String>('');
  final subCaste = Rxn<String>('');
  final lookingForSubCaste = Rxn<String>('');
  final sect = Rxn<String>('');
  final lookingForSect = Rxn<String>('');
  final subSect = Rxn<String>('');
  final lookingForSubSect = Rxn<String>('');
  final ethnicity = Rxn<String>('');
  final lookingForEthnicity = Rxn<String>('');
  var selectedCurrency = 'USD'.obs; // Default currency

  // Dropdown options
  final cityOptions = [
    'New York',
    'Los Angeles',
    'Chicago',
    'Houston',
    'Phoenix'
  ];
  final casteOptions = ['Brahmin', 'Kshatriya', 'Vaishya', 'Shudra'];

  // final subCasteOptions = ['Sub-Caste 1', 'Sub-Caste 2', 'Sub-Caste 3'];
  final sectOptions = ['Sunni', 'Shia', 'Ahmadiyya', 'Ibadi'];

  // final subSectOptions = ['Sub-Sect 1', 'Sub-Sect 2', 'Sub-Sect 3'];
  final ethnicityOptions = ['Asian', 'African', 'European', 'Hispanic'];

  String validateFields() {
    profileImage = profilepictureController.profileImage;
    cninfront = documentUploadController.idCardFrontImage;
    cninback = documentUploadController.idCardBackImage;
    passportfront = documentUploadController.passportFrontImage;
    passportback = documentUploadController.passportBackImage;
    selfieimage = _selfieImageController.selfieImage;
    // galleryimages= imageController.images as Rx<File?> ;
    if (emailController.text.isEmpty) return 'Email is required.';
    if (passwordController.text.isEmpty) return 'Password is required.';
    if (firstNameController.text.isEmpty) return 'First Name is required.';
    if (lastNameController.text.isEmpty) return 'Last Name is required.';
    if (height.value == null) return 'Height is required.';
    if (caste.value == null) return 'Caste is required.';
    if (currentResidence.value == null) return 'Current Residence is required.';
    if (lookingForResidence.value == null)
      return 'Looking For Residence is required.';
    if (cityOfResidence.value == null) return 'City of Residence is required.';
    if (dateOfBirth.value == null) return 'Date of Birth is required.';
    if (educationLevel.value == null) return 'Education Level is required.';
    if (employmentStatus.value == null) return 'Employment status is required.';
    if (monthlyIncome.value == null) return 'Monthly income is required.';
    if (gender.value == null) return 'Gender is required.';
    if (maritalStatus.value == null) return 'Marital Status is required.';
    if (religion.value == null) return 'Religion is required.';
    if (lookingForReligion.value == null)
      return 'Looking for Religion is required.';
    if (profileImage.value == null) return 'Profile Image is required.';
    if (cninfront.value == null) return ' CNIC Front Image is required.';
    if (cninback.value == null) return ' CNIC Back Image is required.';
    if (passportfront.value == null) {
      return ' Passport Front Image is required.';
    }
    if (passportback.value == null) return ' Passport Back Image is required.';
    return ''; // No errors
  }

  final ApiService _apiService = ApiService();

  Future<void> registerUser() async {
    isLoading(true);
    errorMessage('');
    // Validate the required fields before submitting
    final validationError = validateFields();
    if (validationError.isNotEmpty) {
      Get.snackbar(
        'Error',
        validationError,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      isLoading(false);
      return;
    }

    try {
      // Send the registration request to the API service
      final response = await _apiService.registerUser(
        firstname: firstNameController.text.trim(),
        lastname: lastNameController.text.trim(),
        height: height.value.toString(),
        cast: caste.value.toString(),
        // subcast: subCaste.value.toString(),
        sect: sect.value.toString(),
        // subsect: subSect.value.toString(),
        castlookingfor: lookingForCaste.value.toString(),
        city: cityOfResidence.value.toString(),
        citylookingfor: lookingForCity.value.toString(),
        dateofbirth: dateOfBirth.value.toString(),
        education: educationLevel.value.toString(),
        educationlookingfor: lookingForEducation.value.toString(),
        ethnicity: ethnicity.value.toString(),
        ethnicitylookingfor: lookingForEthnicity.value.toString(),
        gender: gender.value.toString(),
        maritalstatus: maritalStatus.value.toString(),
        religion: religion.value.toString(),
        religionlookingfor: lookingForReligion.value.toString(),
        sectlookingfor: lookingForSect.value.toString(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        employmentstatus: employmentStatus.value.toString(),
        monthlyincome: monthlyIncome.value.toString(),
        created_at: createdAt.value.toString(),
        profileimage: File(profileImage.value!.path),
        // Send the profile image
        cnic_front: File(cninfront.value!.path),
        cnic_back: File(cninback.value!.path),
        passport_front: File(passportfront.value!.path),
        passport_back: File(passportback.value!.path),
        selfieimage: File(selfieimage.value!.path),
        gallery: File(profileImage.value!.path),
        country: currentResidence.value.toString(),
        countryLookingfor: lookingForResidence.value.toString(),
      );

      // Handle the response from the API service
      if (response['ResponseCode'] == '200' && response['Result'] == 'true') {
        print(response['Data']);
      } else {
        Get.snackbar(
          'Error',
          response['ResponseMsg'] ?? 'An unknown error occurred',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Handle any errors that occur during the API call
      errorMessage(e.toString());
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      // Always stop loading state
      isLoading(false);
    }
  }

  // Example of logout method
  void logout() {
    userData({}); // Clear user data
    Get.snackbar('Logged out', 'You have been logged out.');
  }
}
