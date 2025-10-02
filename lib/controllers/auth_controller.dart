import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:somos_qr_plus/controllers/practice_controller.dart';
import 'package:somos_qr_plus/helpers/route_helper.dart';
import 'package:somos_qr_plus/models/invitation.dart';
import 'package:somos_qr_plus/models/login_response.dart';
import 'package:somos_qr_plus/models/user.dart';
import '../api/api_client.dart';
import '../constants/app_constants.dart';
import 'package:local_auth/local_auth.dart';
import 'package:http/http.dart' as http;

class AuthController extends GetxController {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  final LocalAuthentication _localAuth = LocalAuthentication();

  AuthController({required this.apiClient, required this.sharedPreferences});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  User? _user;
  User? get user => _user;
  Invitation? _invitation;
  Invitation? get invitation => _invitation;
  LoginResponse? _loginResponse;
  LoginResponse? get loginResponse => _loginResponse;

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.token);
  }

  Future<void> login(String email, String password) async {
    final body = {'email': email, 'password': password};
    _isLoading = true;
    update();

    final response =
        await apiClient.postData(AppConstants.loginUrl, body, queryParams: {
      "app_key": AppConstants.appKey,
    });

    if (response.statusCode == 200) {
      _loginResponse = LoginResponse.fromJson(response.body);

      await sharedPreferences.setString(
          AppConstants.loginMethod, _loginResponse?.loginMethod ?? '');
      await sharedPreferences.setString(
          AppConstants.tokenOtp, _loginResponse?.token ?? '');
      Get.offAllNamed(RouteHelper.getTwoFactorAuthRoute());
      // apiClient.updateHeader(token);
    } else {
      final message = response.body['detail'];
      Get.snackbar(
        'Error',
        message ?? 'Failed to authenticate',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    }
    _isLoading = false;
    update();
  }

  Future<void> changePassword(
      String password1, String password2, String oldPassword) async {
    final body = {
      'new_password1': password1,
      'new_password2': password2,
      'old_password': oldPassword
    };
    _isLoading = true;
    update();

    final response = await apiClient
        .postData(AppConstants.changePasswordUrl, body, queryParams: {
      "app_key": AppConstants.appKey,
    });

    if (response.statusCode == 200) {
      Get.snackbar(
        'Success',
        response.body['detail'] ?? 'Password updated',
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    } else {
      final message = response.body['detail'];
      Get.snackbar(
        'Error',
        message ?? 'Failed to update password',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    }
    _isLoading = false;
    update();
  }

  Future<void> reSendCode() async {
    String tokenOtp = sharedPreferences.getString(AppConstants.tokenOtp) ?? '';
    final body = {'otp_delivery_email': true, 'token': tokenOtp};
    _isLoading = true;
    update();

    final response = await apiClient
        .postData(AppConstants.resendCodeUrl, body, queryParams: {
      "app_key": AppConstants.appKey,
    });

    if (response.statusCode == 200) {
      Get.snackbar(
        'Success',
        response.body['detail'] ?? 'Verification code sent',
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    } else {
      final message = response.body['detail'];
      Get.snackbar(
        'Error',
        message ?? 'Failed to resend code',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    }
    _isLoading = false;
    update();
  }

  Future<void> validateCode(String code) async {
    String loginMethod =
        sharedPreferences.getString(AppConstants.loginMethod) ?? '';

    /// 🔒 Forzar solo dos valores válidos
    if (loginMethod.toUpperCase() != 'OTP' &&
        loginMethod.toUpperCase() != 'AUTHENTICATOR') {
      loginMethod = 'OTP';
    }
    String tokenOtp = sharedPreferences.getString(AppConstants.tokenOtp) ?? '';
    final body = {'otp': code, 'login_method': loginMethod, 'token': tokenOtp};
    _isLoading = true;
    update();

    final response = await apiClient
        .postData(AppConstants.validateCodeUrl, body, queryParams: {
      "app_key": AppConstants.appKey,
    });

    if (response.statusCode == 200) {
      Get.offAllNamed(RouteHelper.getDashboardRoute());
      apiClient.updateHeader(response.body['access']);
      _user = User.fromJson(response.body['user']);
      await sharedPreferences.setString(
          AppConstants.token, response.body['access']);
      await sharedPreferences.setInt(AppConstants.userId, _user?.id ?? 0);
      await sharedPreferences.setString(
          AppConstants.refreshToken, response.body['refresh']);
      apiClient.refreshToken = response.body['refresh'];
      update();
    } else {
      final message = response.body['message'];
      Get.snackbar(
        'Error',
        message ?? 'Failed to validate code',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    }
    _isLoading = false;
    update();
  }

  Future<void> validateEmail(String email) async {
    final body = {'email': email};
    _isLoading = true;
    update();

    final response = await apiClient.postData(
        AppConstants.getEmailInvitationUrl, body,
        useApi: true,
        queryParams: {
          "app_key": AppConstants.appKey,
        });

    if (response.statusCode == 200) {
      _invitation = Invitation.fromJson(response.body['invitation']);
      Get.offAllNamed(RouteHelper.getCreateAccountRoute());
    } else {
      final message = response.body['detail'];
      Get.snackbar(
        'Error',
        message ?? 'Invalid email',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    }
    _isLoading = false;
    update();
  }

  Future<void> createAccount(String firstName, String lastName, String email,
      String password, String passwordConfirm) async {
    final body = {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password1': password,
      'password2': passwordConfirm,
    };
    _isLoading = true;
    update();

    final response = await apiClient
        .postData(AppConstants.createAccountUrl, body, queryParams: {
      "app_key": AppConstants.appKey,
    });

    if (response.isOk) {
      Get.snackbar(
        'Success',
        response.body['message'] ?? 'Account Created',
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
      Get.offAllNamed(RouteHelper.getLoginRoute());
    } else {
      final Map<String, dynamic> body = response.body;

      final List<String> messages = body.values
          .where((value) => value is List) // solo listas
          .expand((value) =>
              (value as List).cast<String>()) // 👈 cast a List<String>
          .toList();

      for (final msg in messages) {
        Get.snackbar(
          'Error',
          msg, // 👈 aquí va el mensaje individual
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          icon: const Icon(Icons.error, color: Colors.white),
        );
      }
    }
    _isLoading = false;
    update();
  }

  Future<void> sendEmailForgotPassword(String email) async {
    final body = {'email': email};
    _isLoading = true;
    update();

    final response = await apiClient
        .postData(AppConstants.forgotPasswordUrl, body, queryParams: {
      "app_key": AppConstants.appKey,
    });

    if (response.statusCode == 200) {
      final token = response.body['token'];
      await sharedPreferences.setString(AppConstants.tokenResetPassword, token);
      Get.snackbar(
        'Success',
        response.body['message'] ?? 'OTP code has been sent to your email',
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );

      Get.offAllNamed(RouteHelper.getResetPasswordRoute());
    } else {
      final message = response.body['message'];
      Get.snackbar(
        'Error',
        message ?? 'Failed to send reset email',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    }
    _isLoading = false;
    update();
  }

  Future<void> confirmForgotPassword(
      String password, String passwordConfirm, String otp) async {
    String token =
        sharedPreferences.getString(AppConstants.tokenResetPassword) ?? '';
    final body = {
      'new_password1': password,
      'new_password2': passwordConfirm,
      'token': token,
      'otp': otp
    };
    _isLoading = true;
    update();

    final response = await apiClient
        .postData(AppConstants.forgotPasswordConfirmUrl, body, queryParams: {
      "app_key": AppConstants.appKey,
    });

    if (response.statusCode == 200) {
      Get.snackbar(
        'Success',
        response.body['message'] ?? 'Password updated successfully',
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );

      Get.offAllNamed(RouteHelper.getLoginRoute());
    } else {
      final message = response.body['message'];
      Get.snackbar(
        'Error',
        message ?? 'Failed to update password',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    }
    _isLoading = false;
    update();
  }

  Future<void> logout() async {
    _isLoading = true;
    update();
    // final response = await apiClient.postData(AppConstants.logoutUrl, {});
    await sharedPreferences.setString(AppConstants.token, '');
    await sharedPreferences.setString(AppConstants.refreshToken, '');
    Get.find<PracticeController>().reset();
    apiClient.updateHeader('');
    Get.offAllNamed(RouteHelper.getLoginRoute());

    // if (response.statusCode == 200) {
    // } else {
    //   Get.snackbar('Error', response.statusText ?? 'Error desconocido');
    // }
    _isLoading = false;
    update();
  }

  Future<bool> biometricLogin() async {
    try {
      // Paso 1: Validar biometría
      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to continue',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (!didAuthenticate) {
        debugPrint('❌ Biometric authentication failed');
        return true;
      }

      // Paso 2: Obtener refresh_biometric
      final rt = sharedPreferences.getString('refresh_biometric');
      if (rt == null || rt.isEmpty) {
        debugPrint('❌ No biometric refresh token stored');
        return false;
      }

      // Paso 3: Request refresh al backend
      final url = Uri.parse(AppConstants.baseAuthUrl).replace(
        path: '/auth/token/refresh/',
        queryParameters: {"app_key": AppConstants.appKey},
      );

      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh': rt}),
      );

      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);
        final accessToken = json['access'].toString();
        final refreshToken = json['refresh'].toString();

        // Guardar tokens
        await sharedPreferences.setString(AppConstants.token, accessToken);
        await sharedPreferences.setString(
            AppConstants.refreshToken, refreshToken);
        await sharedPreferences.setString('refresh_biometric', refreshToken);

        // Update headers en ApiClient
        apiClient.updateHeader(accessToken);
        apiClient.refreshToken = refreshToken;

        debugPrint('✅ Biometric login successful!');
        debugPrint('Access: $accessToken');

        Get.offAllNamed(RouteHelper.getDashboardRoute());
        return true;
      } else {
        // ❌ Si falla, eliminamos la posibilidad biométrica
        debugPrint('❌ Failed refreshing token: ${res.statusCode}');
        debugPrint(res.body);

        await sharedPreferences.remove('refresh_biometric');
        await sharedPreferences.remove('refresh_method');

        Get.snackbar(
          'Error',
          'Biometric login failed. Please sign in manually.',
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
        );
        return false;
      }
    } on PlatformException catch (e) {
      debugPrint('❌ Biometric error: $e');
      return true;
    } catch (e) {
      debugPrint('❌ Unexpected biometric login error: $e');
      return true;
    }
  }

  void setUser(User user) {
    _user = user;
    update();
  }

  Future<bool> refreshUser() async {
    // Construimos el query dinámico
    final query = <String, String>{"app_key": AppConstants.appKey};

    final response = await apiClient.getData(
      '/auth/user/',
      useApi: false,
      query: query,
    );

    if (response.statusCode == 200) {
      try {
        final user = User.fromJson(response.body);
        Get.find<AuthController>().setUser(user);
        return true;
      } catch (e) {
        print('Error parseando datos: $e');
      }
    } else {
      final message = response.body['detail'];
      Get.snackbar(
        'Error',
        message ?? 'Failed to update get info',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    }

    return false;
  }
}
