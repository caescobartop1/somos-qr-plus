import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:somos_qr_plus/core/theme/app_theme.dart';

import 'constants/app_constants.dart';
import 'controllers/theme_controller.dart';
import 'helpers/route_helper.dart';
import 'services/init_dependencies.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    // DeviceOrientation.portraitDown,
  ]);

  // if (ResponsiveHelper.isMobilePhone()) {
  //   HttpOverrides.global = MyHttpOverrides();
  // }
  await init();
  final sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString(AppConstants.token) ?? '';
  // final languages = await init(); // inicialización de dependencias + idiomas

  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  // final Map<String, Map<String, String>> languages;
  final String token;
  const MyApp(
      {super.key,
      // , required this.languages
      required this.token});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        return GetMaterialApp(
          title: AppConstants.appName,
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          navigatorKey: Get.key,
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch},
          ),
          initialRoute: token.isNotEmpty
              ? RouteHelper.getDashboardRoute()
              : RouteHelper.getInitialRoute(),
          getPages: RouteHelper.routes,
        );
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
