import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class BasicInfoController extends GetxController {
  final firstName = ''.obs;
  final lastName = ''.obs;
  final gender = Rxn<String>();
  final dateOfBirth = Rxn<DateTime>();
  final currentPage = 0.obs;

  void setGender(String? value) => gender.value = value;
  void setDateOfBirth(DateTime? value) => dateOfBirth.value = value;
  void nextPage() => currentPage.value = 1;
  void previousPage() => currentPage.value = 0;

  // Second form fields
  final height = Rxn<String>();
  final maritalStatus = Rxn<String>();
  final religion = Rxn<String>();
  final lookingForReligion = Rxn<String>();
  final nationality = Rxn<String>();
  final lookingForNationality = Rxn<String>();

  // Page control
  final currentFormPage = 0.obs;

  // New fields for preferences
  final educationLevel = Rxn<String>();
  final lookingForEducation = Rxn<String>();
  final employmentStatus = Rxn<String>();
  final monthlyIncome = Rxn<String>();
  final currentResidence = Rxn<String>();
  final lookingForResidence = Rxn<String>();

  // Options lists
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
    'Less than 1000',
    'Greater than 1000, less than 3000',
    'Greater than 3000'
  ];

  final List<String> countryOptions = [
    'United States',
    'United Kingdom',
    'Canada',
    'Australia',
    'Other'
  ];


  // Dropdown options
  final List<String> heightOptions = ['4\'0"', '4\'1"', '4\'2"', '4\'3"', '4\'4"', '4\'5"', '4\'6"', '4\'7"', '4\'8"', '4\'9"', '4\'10"', '4\'11"', '5\'0"', '5\'1"', '5\'2"', '5\'3"', '5\'4"', '5\'5"', '5\'6"', '5\'7"', '5\'8"', '5\'9"', '5\'10"', '5\'11"', '6\'0"', '6\'1"', '6\'2"', '6\'3"', '6\'4"', '6\'5"', '6\'6"', '6\'7"', '6\'8"', '6\'9"', '6\'10"', '6\'11"', '7\'0"'];
  final List<String> maritalStatusOptions = ['Single', 'Divorced', 'Widowed', 'Separated'];
  final List<String> religionOptions = ['Islam', 'Christianity', 'Judaism', 'Hinduism', 'Buddhism', 'Other'];
  final List<String> nationalityOptions = ['American', 'British', 'Canadian', 'Australian', 'Indian', 'Pakistani', 'Other'];


  // Preferences fields
  final cityOfResidence = Rxn<String>();
  final lookingForCity = Rxn<String>();
  final caste = Rxn<String>();
  final lookingForCaste = Rxn<String>();
  final subCaste = Rxn<String>();
  final lookingForSubCaste = Rxn<String>();
  final sect = Rxn<String>();
  final lookingForSect = Rxn<String>();
  final subSect = Rxn<String>();
  final lookingForSubSect = Rxn<String>();
  final ethnicity = Rxn<String>();
  final lookingForEthnicity = Rxn<String>();

  // Dropdown options
  final cityOptions = ['New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix'];
  final casteOptions = ['Brahmin', 'Kshatriya', 'Vaishya', 'Shudra'];
  final subCasteOptions = ['Sub-Caste 1', 'Sub-Caste 2', 'Sub-Caste 3'];
  final sectOptions = ['Sunni', 'Shia', 'Ahmadiyya', 'Ibadi'];
  final subSectOptions = ['Sub-Sect 1', 'Sub-Sect 2', 'Sub-Sect 3'];
  final ethnicityOptions = ['Asian', 'African', 'European', 'Hispanic'];


  //
  // void setFormPage(int index) {
  //   currentFormPage.value = index;
  // }
}
