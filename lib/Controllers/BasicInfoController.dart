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

  // Dropdown options
  final List<String> heightOptions = ['4\'0"', '4\'1"', '4\'2"', '4\'3"', '4\'4"', '4\'5"', '4\'6"', '4\'7"', '4\'8"', '4\'9"', '4\'10"', '4\'11"', '5\'0"', '5\'1"', '5\'2"', '5\'3"', '5\'4"', '5\'5"', '5\'6"', '5\'7"', '5\'8"', '5\'9"', '5\'10"', '5\'11"', '6\'0"', '6\'1"', '6\'2"', '6\'3"', '6\'4"', '6\'5"', '6\'6"', '6\'7"', '6\'8"', '6\'9"', '6\'10"', '6\'11"', '7\'0"'];
  final List<String> maritalStatusOptions = ['Single', 'Divorced', 'Widowed', 'Separated'];
  final List<String> religionOptions = ['Islam', 'Christianity', 'Judaism', 'Hinduism', 'Buddhism', 'Other'];
  final List<String> nationalityOptions = ['American', 'British', 'Canadian', 'Australian', 'Indian', 'Pakistani', 'Other'];
}
