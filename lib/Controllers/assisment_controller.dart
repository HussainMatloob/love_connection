import 'package:get/get.dart';
import 'package:love_connection/ApiService/ApiService.dart';
import '../Models/Assisment.dart';


class AssessmentController extends GetxController {
  var assessmentCategories = <AssessmentCategory>[].obs;
  var isLoading = true.obs;

  final ApiService _assessmentService = ApiService();

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  void fetchCategories() async {
    isLoading(true);
    try {
      var categories = await _assessmentService.fetchAssessmentCategories();
      assessmentCategories.assignAll(categories);
    } catch (e) {
      Get.snackbar("Error", "Failed to load assessment categories");
    } finally {
      isLoading(false);
    }
  }
}
