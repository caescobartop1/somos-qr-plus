// import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:somos_qr_plus/screens/auth/create_account_screen.dart';
import 'package:somos_qr_plus/screens/auth/forgot_password_screen.dart';
import 'package:somos_qr_plus/screens/auth/login_screen.dart';
import 'package:somos_qr_plus/screens/auth/reset_password_screen.dart';
import 'package:somos_qr_plus/screens/auth/two_factor_screen.dart';
import 'package:somos_qr_plus/screens/dashboard_screen.dart';
import 'package:somos_qr_plus/screens/patients_screen.dart';
import 'package:somos_qr_plus/screens/quality_scorecards_screen.dart';
import 'package:somos_qr_plus/screens/reports_screen.dart';
import 'package:somos_qr_plus/screens/resources_screen.dart';
import 'package:somos_qr_plus/screens/schedule_screen.dart';
import 'package:somos_qr_plus/screens/settings_screen.dart';

class RouteHelper {
  static const String initial = '/';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String createAccount = '/create-account';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String twoFactorAuth = '/2fa';
  static const String settings = '/settings';
  static const String qualityScoreCards = '/quality-scorecards';
  static const String patients = '/patients';
  static const String reports = '/reports';
  static const String schedule = '/schedule';
  static const String resources = '/resources';

  static String getLoginRoute() => login;
  static String getDashboardRoute() => dashboard;
  static String getCreateAccountRoute() => createAccount;
  static String getForgotPasswordRoute() => forgotPassword;
  static String getResetPasswordRoute() => resetPassword;
  static String getTwoFactorAuthRoute() => twoFactorAuth;
  static String getSettingsRoute() => settings;
  static String getQualityScoreCardsRoute() => qualityScoreCards;
  static String getPatientsRoute() => patients;
  static String getReportsRoute() => reports;
  static String getResourcesRoute() => resources;
  static String getScheduleRoute() => schedule;
  static String getInitialRoute() => login;

  static List<GetPage> routes = [
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: createAccount, page: () => CreateAccountScreen()),
    GetPage(name: forgotPassword, page: () => ForgotPasswordScreen()),
    GetPage(name: resetPassword, page: () => ResetPasswordScreen()),
    GetPage(name: twoFactorAuth, page: () => TwoFactorScreen()),
    GetPage(name: settings, page: () => SettingsScreen()),
    GetPage(name: qualityScoreCards, page: () => QualityScorecardsScreen()),
    GetPage(name: patients, page: () => PatientsScreen()),
    GetPage(name: reports, page: () => ReportsScreen()),
    GetPage(name: schedule, page: () => ScheduleScreen()),
    GetPage(name: resources, page: () => ResourcesScreen()),
    GetPage(name: dashboard, page: () => DashboardScreen()),
  ];

  static void goTo(String routeName, {dynamic arguments}) {
    Get.toNamed(routeName, arguments: arguments);
  }
}
