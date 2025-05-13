import 'package:get/get.dart';
import '../ApiService/ApiService.dart';

class GetReceivedConnectionRequestController extends GetxController {
  // List to store send connection requests data
  var Getrequests = [].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var searchQuerytext = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchReceivedConnectionRequests();
  }

  Future<void> fetchReceivedConnectionRequests() async {
    try {
      isLoading.value = true;
      final response = await ApiService().getSendConRequest();
      //print(
      // "================================== RESPONSE ===================================");
      //print(response);
      if (response['Result'] == 'true') {
        Getrequests.value = response['Data'] ?? [];
        update();
      } else {
        errorMessage.value =
            response['ResponseMsg'] ?? 'Failed to fetch requests';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
    } finally {
      isLoading(false);
    }
  }
}
