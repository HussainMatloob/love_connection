import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoveLanguageController extends GetxController {
  var isLoading = true.obs;
  var questions = <String>[].obs;

  @override
  void onInit() {
    fetchQuestions();
    super.onInit();
  }

  Future<void> fetchQuestions() async {
    const apiUrl = "https://yourapi.com/love-language-questions";
    try {
      isLoading(true);
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        questions.value = data.cast<String>();
      } else {
        Get.snackbar("Error", "Failed to load questions");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}
