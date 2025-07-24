import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:love_connection/Controllers/image_controller.dart';
import 'package:love_connection/Controllers/selfie_upload_controller.dart';
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
  RxBool obsecureText = true.obs;

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

  void changeObsecureText() {
    obsecureText.value = !obsecureText.value;
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
  final selectedGender = Rxn<String>();
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
  final monthlyIncome = Rxn<String?>();
  final currentResidence = Rxn<String>();
  final lookingForResidence = Rxn<String>();

  void updateProfileImage(File image) {
    profileImage.value = image;
  }

  Rx<File?> getprofileimage() {
    return profilepictureController.profileImage;
  }

  // final List<String> educationOptions = [
  //   'High School',
  //   'Bachelor\'s Degree',
  //   'Master\'s Degree',
  //   'Doctorate',
  //   'Other'
  // ];

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

  final List<String> genderOptions = ["male", "female"];
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
  //final ethnicityOptions = ['Asian', 'African', 'European', 'Hispanic'];

  bool isPasswordValid(String password) {
    final passwordRegex =
        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$');
    return passwordRegex.hasMatch(password);
  }

  bool isEmailValid(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%-]+@gmail\.com$');
    return emailRegex.hasMatch(email);
  }

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
    if (selfieimage.value == null) return 'Selfie Image is required.';
    // if (passportfront.value == null) {
    //   return ' Passport Front Image is required.';
    // }
    // if (passportback.value == null) return ' Passport Back Image is required.';
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
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        gender: gender.value.toString(),
        dateofbirth: dateOfBirth.value.toString(),
        height: height.value.toString(),
        maritalstatus: maritalStatus.value.toString(),
        religion: religion.value.toString(),
        religionlookingfor: lookingForReligion.value.toString(),
        education: educationLevel.value.toString(),
        educationlookingfor: lookingForEducation.value.toString(),
        employmentstatus: employmentStatus.value.toString(),
        monthlyincome: monthlyIncome.value.toString(),
        city: cityOfResidence.value.toString(),
        citylookingfor: lookingForCity.value.toString(),
        cast: caste.value.toString(),
        castlookingfor: lookingForCaste.value.toString(),
        country: currentResidence.value.toString(),
        countryLookingfor: lookingForResidence.value.toString(),
        // subcast: subCaste.value.toString(),
        sect: sect.value.toString(),
        sectlookingfor: lookingForSect.value.toString(),
        // subsect: subSect.value.toString(),
        ethnicity: ethnicity.value.toString(),
        ethnicitylookingfor: lookingForEthnicity.value.toString(),
        created_at: createdAt.value.toString(),
        profileimage: File(profileImage.value!.path),
        // Send the profile image
        cnic_front: File(cninfront.value!.path),
        cnic_back: File(cninback.value!.path),
        passport_front: passportfront.value != null
            ? File(passportfront.value!.path)
            : null,
        passport_back:
            passportback.value != null ? File(passportback.value!.path) : null,
        selfieimage: File(selfieimage.value!.path),
        gallery: File(profileImage.value!.path),
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

  bool? emailResult;
  String? emailResponseMessage = "Something went wrong please try again";
  /*--------------------------------------------------*/
  /*                  check is Email Exist            */
  /*--------------------------------------------------*/
  Future<void> checkIsEmailExist(String email) async {
    try {
      final response = await ApiService.emailExisOrNot(email);

      if (response != null) {
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          if (data['Result'] == "true") {
            emailResponseMessage = data['ResponseMsg'];
            emailResult = false;
            update();
          } else {
            emailResult = true;
            update();
          }
        } else {
          emailResponseMessage = "Something went wrong please try again";
          emailResult = false;
          update();
        }
      } else {
        emailResponseMessage = "Something went wrong please try again";
        emailResult = false;
        update();
      }
    } catch (e) {
      emailResult = false;
      emailResponseMessage = "$e";
      update();
    }
  }

  final PageController pageController = PageController();

  int currentPageIndex = 0;

  bool validateCurrentPage(int pageIndex) {
    if (pageIndex == 1) {
      if (firstNameController.text.isEmpty ||
          lastNameController.text.isEmpty ||
          emailController.text.isEmpty ||
          passwordController.text.isEmpty ||
          gender.value == null) {
        showErrorSnackbar(
            'Please fill in all required fields before proceeding.');
        return false;
      } else if (!isEmailValid(emailController.text)) {
        showErrorSnackbar('Please enter a valid email address');
        return false;
      } else if (emailResult == false || emailResult == null) {
        showErrorSnackbar("${emailResponseMessage}");
        return false;
      } else if (!isPasswordValid(passwordController.text)) {
        showErrorSnackbar(
            'Password must be at least 8 characters long and include at least one uppercase letter, one lowercase letter, one number, and one special character');
        return false;
      }
    }
    if (pageIndex == 2) {
      if (religion.value == null ||
          lookingForReligion.value == null ||
          height.value == null ||
          maritalStatus.value == null ||
          dateOfBirth.value == null) {
        showErrorSnackbar(
            'Please complete the required details before proceeding.');
        return false;
      }
    }
    if (pageIndex == 3) {
      if (educationLevel.value == null ||
          lookingForEducation.value == null ||
          currentResidence.value == null ||
          lookingForResidence.value == null ||
          employmentStatus.value == null) {
        showErrorSnackbar(
            'Please fill in all required education and residence details.');
        return false;
      }
    }
    return true;
  }

  void showErrorSnackbar(String message) {
    Get.snackbar('Error', message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white);
  }

  void onPageChanged(int index) {
    if (!validateCurrentPage(index)) {
      pageController.jumpToPage(currentPageIndex);
      return;
    }

    currentPageIndex = index;
    update();
  }

  void onDotClicked(int index) {
    if (validateCurrentPage(index)) {
      pageController.animateToPage(index,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }
}
