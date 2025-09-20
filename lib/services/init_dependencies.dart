import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:somos_qr_plus/controllers/practice_controller.dart';
import 'package:somos_qr_plus/controllers/theme_controller.dart';
import '../api/api_client.dart';
import '../constants/app_constants.dart';
import '../controllers/auth_controller.dart';
import 'package:http/http.dart' as http;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.put(sharedPreferences);

  Get.put(ApiClient(
    appBaseAuthUrl: AppConstants.baseAuthUrl,
    appBaseUrl: AppConstants.baseUrl,
    sharedPreferences: sharedPreferences,
    onTokenRefresh: () async {
      final rt = sharedPreferences.getString(AppConstants.refreshToken);
      print('hola aca refresh token!');
      print(rt);
      print(rt == null || rt.isEmpty);
      if (rt == null || rt.isEmpty) return null;
      print('logro pasar aqui!!!;');
      final url = Uri.parse((AppConstants.baseAuthUrl)).replace(
        path: '/auth/token/refresh/',
        queryParameters: {
          'app_key': AppConstants.appKey,
        },
      );
      print('hola url!!!;');
      print(url);
      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh': rt}),
      );
      print(res.statusCode);
      if (res.statusCode == 200) {
        print('hola entro aqui por supuesto aca!!!;');
        final json = jsonDecode(res.body);
        print(json);
        String accessToken = json['access'].toString();
        String refreshToken = json['refresh'].toString();
        await sharedPreferences.setString(AppConstants.token, accessToken);
        await sharedPreferences.setString(
            AppConstants.refreshToken, refreshToken);
        return accessToken;
      }
      print(res.statusCode);
      print('entro aca!!!');
      print(res.body);
      return null;
    },
  ));
  Get.put(ThemeController(
    sharedPreferences: Get.find(),
  ));
  Get.put(AuthController(
    apiClient: Get.find(),
    sharedPreferences: Get.find(),
  ));
  Get.put(PracticeController(
    apiClient: Get.find(),
    sharedPreferences: Get.find(),
  ));
}
