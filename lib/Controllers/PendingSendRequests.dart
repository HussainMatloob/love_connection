import 'package:get/get.dart';
import '../ApiService/ApiService.dart';

class GetPendingRequestsController extends GetxController{
  var isLoading = true.obs;
  var pendingRequests = [].obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPendingRequests();
  }

  void fetchPendingRequests() async {
    try {
      isLoading(true);
      // Call the API
      final response = await ApiService().getPendingRequests();
      if (response['ResponseCode'] == '200' && response['Result'] == 'true') {
        pendingRequests.value = response['Data'];
      } else {
        return errorMessage.value= response['ResponseMsg'];
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

}