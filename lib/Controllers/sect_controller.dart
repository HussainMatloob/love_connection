import 'dart:async';

import 'package:get/get.dart';
import 'package:love_connection/ApiService/ApiService.dart';
import 'package:love_connection/Controllers/AuthController.dart';

class SectController extends GetxController {
  
  final ApiService _apiService = ApiService();
  final AuthController authController = Get.put(AuthController());
  final RxList<String> sectList = <String>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  Timer? _debounce;
  @override
  void onInit() {
    super.onInit();

    everAll([authController.religion, authController.caste], (_) {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 400), () async {
        final religion = authController.religion.value ?? '';
        final caste = authController.caste.value ?? '';

        print('Religion: $religion, Caste: $caste');

        if (religion.isNotEmpty && caste.isNotEmpty) {
          await fetchSectData(religion: religion, caste: caste);
        }
      });
    });
  }

  Future<void> fetchSectData(
      {required String religion, required String caste}) async {
    try {
      isLoading(true);
      final data =
          await _apiService.fetchSectData(religion: religion, caste: caste);
      sectList.clear();
      sectList.assignAll(data);
      isLoading(false);
    } catch (e) {
      isLoading(false);
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }
}
