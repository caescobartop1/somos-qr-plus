import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:somos_qr_plus/controllers/theme_controller.dart';
import '../api/api_client.dart';
import '../constants/app_constants.dart';
import '../controllers/auth_controller.dart';

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.put(sharedPreferences);

  Get.put(ApiClient(
      appBaseAuthUrl: AppConstants.baseAuthUrl, appBaseUrl: AppConstants.baseUrl, sharedPreferences: sharedPreferences));
  Get.put(ThemeController(
    sharedPreferences: Get.find(),
  ));
  Get.put(AuthController(
    apiClient: Get.find(),
    sharedPreferences: Get.find(),
  ));
}
