import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

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
  // final languages = await init(); // inicialización de dependencias + idiomas

  runApp(MyApp(
      // languages: languages
      ));
}

class MyApp extends StatelessWidget {
  // final Map<String, Map<String, String>> languages;
  const MyApp({super.key
      // , required this.languages
      });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        //     return GetBuilder<SplashController>(
        //       builder: (splashController) {
        return GetMaterialApp(
          title: AppConstants.appName,
          themeMode: ThemeMode.light,
          debugShowCheckedModeBanner: false,
          navigatorKey: Get.key,
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch},
          ),
          theme:
              (themeController.darkTheme ? ThemeData.dark() : ThemeData.light()),
          initialRoute: RouteHelper.getInitialRoute(),
          getPages: RouteHelper.routes,
        );
        //     },
        //   );
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
