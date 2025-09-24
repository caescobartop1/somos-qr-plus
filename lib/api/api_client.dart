import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get_connect/http/src/request/request.dart';

import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:somos_qr_plus/constants/app_constants.dart';
import 'package:somos_qr_plus/helpers/route_helper.dart';
import 'package:somos_qr_plus/controllers/auth_controller.dart';

class ApiClient extends GetxService {
  final String appBaseUrl;
  final String appBaseAuthUrl;
  final SharedPreferences sharedPreferences;
  static final String noInternetMessage = 'connection_to_api_server_failed'.tr;
  final int timeoutInSeconds = 40;
  final Future<String?> Function()? onTokenRefresh;
  bool _didRetry401 = false;

  String? token;
  String? refreshToken;
  late Map<String, String> _mainHeaders;

  ApiClient(
      {required this.appBaseUrl,
      required this.appBaseAuthUrl,
      required this.sharedPreferences,
      this.onTokenRefresh}) {
    token = sharedPreferences.getString(AppConstants.token);
    refreshToken = sharedPreferences.getString(AppConstants.refreshToken);
    if (kDebugMode) {
      print('Token: $token');
      print('refreshToken: $refreshToken');
    }
    updateHeader(token);
    if (token != null) {
      // Get.offAllNamed(RouteHelper.getQualityScoreCardsRoute());
    }
  }
  Future<Response> _sendWith401Retry({
    required Future<http.Response> Function() send,
    required String uri,
    required bool handleError,
  }) async {
    http.Response res = await send();
    if (res.statusCode == 401 && !_didRetry401 && onTokenRefresh != null) {
      _didRetry401 = true;
      try {
        final authController = Get.find<AuthController>();
        authController.logout();
        // final newToken = await onTokenRefresh!();
        // print(newToken);
        // if (newToken != null && newToken.isNotEmpty) {
        //   token = newToken;
        //   sharedPreferences.setString(AppConstants.token, newToken);
        //   updateHeader(newToken);
        //   res = await send();
        // }
      } catch (_) {
        // si falla el refresh, seguimos con el 401 original
      } finally {
        _didRetry401 = false;
      }
    }

    return handleResponse(res, uri, handleError);
  }

  Map<String, String> updateHeader(String? token, {bool setHeader = true}) {
    Map<String, String> header = {};

    header.addAll({
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    });

    if (token != null && token.isNotEmpty) {
      header['Authorization'] = 'Bearer $token';
    }
    if (setHeader) {
      _mainHeaders = header;
    }
    return header;
  }

  Map<String, String> getHeader() => _mainHeaders;

  Future<Response> getData(String uri,
      {Map<String, dynamic>? query,
      Map<String, String>? headers,
      bool handleError = true,
      bool useApi = false}) async {
    try {
      final fullUri = Uri.parse((useApi ? appBaseUrl : appBaseAuthUrl) + uri)
          .replace(queryParameters: query);
      if (kDebugMode) {
        print('====> API Call: $uri\nHeader: ${headers ?? _mainHeaders}');
        print(fullUri);
      }
      return _sendWith401Retry(
        send: () => http
            .get(fullUri, headers: headers ?? _mainHeaders)
            .timeout(Duration(seconds: timeoutInSeconds)),
        uri: uri,
        handleError: handleError,
      );
    } catch (e) {
      if (kDebugMode) {
        print('------------${e.toString()}');
      }
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> postData(String uri, dynamic body,
      {Map<String, String>? headers,
      int? timeout,
      bool handleError = true,
      Map<String, String>? queryParams,
      bool useApi = false}) async {
    try {
      final url = Uri.parse((useApi ? appBaseUrl : appBaseAuthUrl)).replace(
        path: uri,
        queryParameters: queryParams,
      );

      if (kDebugMode) {
        print('====> API Call: $url\nHeader: ${headers ?? _mainHeaders}');
        print('====> API Body: $body');
      }

      return _sendWith401Retry(
        send: () => http
            .post(
              url,
              body: jsonEncode(body),
              headers: headers ?? _mainHeaders,
            )
            .timeout(Duration(seconds: timeout ?? timeoutInSeconds)),
        uri: uri,
        handleError: handleError,
      );
    } catch (e) {
      print(e);
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> postMultipartData(
      String uri, Map<String, String> body, List<MultipartBody> multipartBody,
      {Map<String, String>? headers,
      bool handleError = true,
      bool useApi = false}) async {
    try {
      if (kDebugMode) {
        print('====> API Call: $uri\nHeader: ${headers ?? _mainHeaders}');
        print('====> API Body: $body with ${multipartBody.length} picture');
      }
      http.MultipartRequest request = http.MultipartRequest(
          'POST', Uri.parse((useApi ? appBaseUrl : appBaseAuthUrl) + uri));
      request.headers.addAll(headers ?? _mainHeaders);
      for (MultipartBody multipart in multipartBody) {
        if (multipart.file != null) {
          Uint8List list = await multipart.file!.readAsBytes();
          request.files.add(http.MultipartFile(
            multipart.key,
            multipart.file!.readAsBytes().asStream(),
            list.length,
            filename: '${DateTime.now().toString()}.png',
          ));
        }
      }
      request.fields.addAll(body);
      http.Response response =
          await http.Response.fromStream(await request.send());
      return handleResponse(response, uri, handleError);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Uint8List?> downloadFile(String uri,
      {Map<String, String>? headers, bool useApi = false}) async {
    try {
      final fullUri = Uri.parse((useApi ? appBaseUrl : appBaseAuthUrl) + uri);

      if (kDebugMode) {
        print('====> Downloading File: $uri');
      }

      final response = await http
          .get(
            fullUri,
            headers: headers ?? _mainHeaders,
          )
          .timeout(Duration(seconds: timeoutInSeconds));

      if (response.statusCode == 200) {
        return response.bodyBytes; // PDF as bytes
      } else {
        if (kDebugMode) {
          print('Failed to download file: ${response.statusCode}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Download error: $e');
      }
      return null;
    }
  }

  Future<Response> putData(String uri, dynamic body,
      {Map<String, String>? headers,
      bool handleError = true,
      bool useApi = false}) async {
    try {
      if (kDebugMode) {
        print('====> API Call: $uri\nHeader: ${headers ?? _mainHeaders}');
        print('====> API Body: $body');
      }
      final url = Uri.parse((useApi ? appBaseUrl : appBaseAuthUrl) + uri);
      return _sendWith401Retry(
        send: () => http
            .put(url, body: jsonEncode(body), headers: headers ?? _mainHeaders)
            .timeout(Duration(seconds: timeoutInSeconds)),
        uri: uri,
        handleError: handleError,
      );
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> deleteData(String uri,
      {Map<String, String>? headers,
      bool handleError = true,
      bool useApi = false}) async {
    try {
      if (kDebugMode) {
        print('====> API Call: $uri\nHeader: ${headers ?? _mainHeaders}');
      }
      final url = Uri.parse((useApi ? appBaseUrl : appBaseAuthUrl) + uri);

      return _sendWith401Retry(
        send: () => http
            .delete(url, headers: headers ?? _mainHeaders)
            .timeout(Duration(seconds: timeoutInSeconds)),
        uri: uri,
        handleError: handleError,
      );
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Response handleResponse(
      http.Response response, String uri, bool handleError) {
    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (_) {}
    Response response0 = Response(
      body: body ?? response.body,
      bodyString: response.body.toString(),
      request: Request(
          headers: response.request!.headers,
          method: response.request!.method,
          url: response.request!.url),
      headers: response.headers,
      statusCode: response.statusCode,
      statusText: response.reasonPhrase,
    );
    if (response0.statusCode != 200 &&
        response0.body != null &&
        response0.body is! String) {
      if (response0.body.toString().startsWith('{errors: [{code:')) {
        // ErrorResponse errorResponse = ErrorResponse.fromJson(response0.body);
        // response0 = Response(
        //     statusCode: response0.statusCode,
        //     body: response0.body,
        //     statusText: errorResponse.errors![0].message);
      } else if (response0.body.toString().startsWith('{message')) {
        response0 = Response(
            statusCode: response0.statusCode,
            body: response0.body,
            statusText: response0.body['message']);
      }
    } else if (response0.statusCode != 200 && response0.body == null) {
      response0 = Response(statusCode: 0, statusText: noInternetMessage);
    }
    if (kDebugMode) {
      print('====> API Response: [${response0.statusCode}] $uri');
      if (response.statusCode != 500) {
        print('${response0.body}');
      }
    }
    return response0;
  }
}

class MultipartBody {
  String key;
  File? file;

  MultipartBody(this.key, this.file);
}
