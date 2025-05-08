import 'package:get/get.dart';
import '../ApiService/ApiService.dart';

class GetPendingRequestsController extends GetxController {
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
        print("=======================+++++++++++${pendingRequests}");
      } else {
        return errorMessage.value = response['ResponseMsg'];
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  /*--------------------------------------------------*/
  /*               Cancel send tequest                */
  /*--------------------------------------------------*/
  Future<void> cancelRequest(var specificPersonSendRequest) async {
    try {
      // final response = await ApiService.cancelConnectionRequest();
      // if (forSendRequestResponse != null) {
      //   if (forSendRequestResponse!.statusCode == 201) {
      //     customerloadingFunction(false);
      //     checkCustomerPermission();
      //     Get.snackbar(
      //       'Success',
      //       "Request Submitted successfully",
      //       snackPosition: SnackPosition.BOTTOM,
      //       colorText: Colors.white,
      //       backgroundColor: Colors.green,
      //     );
      //   } else if (forSendRequestResponse!.statusCode == 403) {
      //     Get.snackbar('Error',
      //         "Your request has already been submitted,Please wait for approval",
      //         snackPosition: SnackPosition.BOTTOM,
      //         colorText: Colors.white,
      //         backgroundColor: Colors.red);
      //   } else {
      //     customerloadingFunction(false);
      //     Get.snackbar('Error',
      //         "Request failed with status: ${forSendRequestResponse!.statusCode}",
      //         colorText: Colors.white,
      //         snackPosition: SnackPosition.BOTTOM,
      //         backgroundColor: Colors.red);
      //   }
      // } else {
      //   //customerloadingFunction(false);
      // }
    } catch (e) {
    } finally {}
  }
}
