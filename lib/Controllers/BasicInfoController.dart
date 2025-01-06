import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class BasicInfoController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var userData = {}.obs;
  final currentFormPage = 0.obs;
  final currentPage = 0.obs;
  final MatchescurrentPage = 0.obs;

  void nextPage() => currentPage.value = 1;
  void previousPage() => currentPage.value = 0;

}
