import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:somos_qr_plus/helpers/route_helper.dart';
import 'package:somos_qr_plus/models/bonus_detail.dart';
import 'package:somos_qr_plus/models/invitation.dart';
import 'package:somos_qr_plus/models/login_response.dart';
import 'package:somos_qr_plus/models/panel_detail.dart';
import 'package:somos_qr_plus/models/practice.dart';
import 'package:somos_qr_plus/models/practice_details.dart';
import 'package:somos_qr_plus/models/provider.dart';
import 'package:somos_qr_plus/models/schedule.dart';
import 'package:somos_qr_plus/models/user.dart';
import '../api/api_client.dart';
import '../constants/app_constants.dart';

class PracticeController extends GetxController {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  PracticeController(
      {required this.apiClient, required this.sharedPreferences});

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<Provider> _practices = [];
  List<Provider> get practices => _practices;
  List<PanelDetail> _panelDetails = [];
  List<PanelDetail> get panelDetails => _panelDetails;
  List<BonusDetail> _bonusDetails = [];
  List<BonusDetail> get bonusDetails => _bonusDetails;
  List<Schedule> _scheduleDetails = [];
  List<Schedule> get scheduleDetails => _scheduleDetails;
  PracticeDetails _practiceDetails = PracticeDetails.empty();
  PracticeDetails get practiceDetails => _practiceDetails;

  Future<void> getPractice(String search) async {
    _isLoading = true;
    update();

    final response = await apiClient.getData(
      AppConstants.practiceUrl,
      useApi: true,
      query: {
        "app_key": AppConstants.appKey,
        "search": search,
        "limit": "1000",
      },
    );

    if (response.statusCode == 200) {
      final data = response.body;

      // Parseamos results a List<Provider>
      final List results = data['results'] ?? [];
      List<Provider> practices = results
          .map((item) => Provider.fromJson(item))
          .toList()
          .cast<Provider>();

      // Verificamos si ya existe un "All" (case insensitive)
      final hasAll = practices.any(
        (p) => p.name.toLowerCase() == "all",
      );

      if (!hasAll) {
        practices.insert(
          0,
          Provider(id: "-1", name: "All"),
        );
      }
      _practices = practices;
      update();
    } else {
      final message = response.body['detail'];
      Get.snackbar(
        'Error',
        message ?? 'Failed to get practice',
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

  Future<void> getPracticeDetails(String? practice_id) async {
    _isLoading = true;
    update();

    final response = await apiClient.getData(
      AppConstants.practiceDetailsUrl,
      useApi: true,
      query: {
        "app_key": AppConstants.appKey,
        "practice_id": practice_id ?? '-1'
      },
    );

    if (response.statusCode == 200) {
      final data = response.body;
      final List results = (data['results'] as List?) ?? const [];

      if (results.isNotEmpty) {
        _practiceDetails =
            PracticeDetails.fromJson(results.first as Map<String, dynamic>);
      } else {
        _practiceDetails = PracticeDetails.empty();
      }
      update();

      // Opcional: logs
      // print("PracticeDetails: ${practiceDetails.toJson()}");
    } else {
      final message = response.body['detail'];
      Get.snackbar(
        'Error',
        message ?? 'Failed to get practice',
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

  Future<void> getPanelDetails(String? practice_id) async {
    _isLoading = true;
    update();

    final response = await apiClient.getData(
      AppConstants.panelDetailsUrl,
      useApi: true,
      query: {
        "app_key": AppConstants.appKey,
        "practice_id": practice_id ?? '-1'
      },
    );

    if (response.statusCode == 200) {
      final data = response.body;
      final List results = (data['results'] as List?) ?? const [];
      _panelDetails = results
          .map((e) => PanelDetail.fromJson(e as Map<String, dynamic>))
          .toList();
      update();
    } else {
      final message = response.body['detail'];
      Get.snackbar(
        'Error',
        message ?? 'Failed to get practice',
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

  Future<void> mocListDetails(String? practice_id) async {
    _isLoading = true;
    update();

    final response = await apiClient.getData(
      AppConstants.mocListDetailsUrl,
      useApi: true,
      query: {
        "app_key": AppConstants.appKey,
        "billing_tin": practice_id ?? '-1'
      },
    );

    if (response.statusCode == 200) {
      final data = response.body;
      print(data);
      // final List results = (data['results'] as List?) ?? const [];
      // _panelDetails = results
      //     .map((e) => PanelDetail.fromJson(e as Map<String, dynamic>))
      //     .toList();
      // update();
    } else {
      final message = response.body['detail'];
      Get.snackbar(
        'Error',
        message ?? 'Failed to get practice',
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

  Future<void> getBonusDetails(String? practice_id) async {
    _isLoading = true;
    update();

    final response = await apiClient.getData(
      AppConstants.bonusDetailsUrl,
      useApi: true,
      query: {
        "app_key": AppConstants.appKey,
        "billing_tin": practice_id ?? '-1',
        "mco_id": '4'
      },
    );

    if (response.statusCode == 200) {
      final data = response.body;
      final List rawList =
          data is List ? data : (data['results'] as List?) ?? const [];

      _bonusDetails = rawList
          .map((e) => BonusDetail.fromJson(e as Map<String, dynamic>))
          .toList();
      update();
    } else {
      final message = response.body['detail'];
      Get.snackbar(
        'Error',
        message ?? 'Failed to get practice',
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

  Future<void> getSchedule(String? practice_id) async {
    _isLoading = true;
    update();

    final now = DateTime.now();

    final formatter = DateFormat("yyyy-MM-dd");

    final startOfDay = "${formatter.format(now)}T00:00:00";

    final endOfDay = "${formatter.format(now)}T23:59:59";

    final oneMonthLater = DateTime(now.year, now.month + 1, now.day);
    final endOneMonthLater = "${formatter.format(oneMonthLater)}T23:59:59";

    final response = await apiClient.getData(
      AppConstants.scheduleUrl,
      useApi: true,
      query: {
        "app_key": AppConstants.appKey,
        "practice_id": practice_id ?? '-1',
        "day__gte": startOfDay,
        "day__lte": endOneMonthLater,
        "offset": '0',
        "limit": '20',
      },
    );

    if (response.statusCode == 200) {
      try {
        final data = response.body;
        final results = data['results'] as List<dynamic>;
        _scheduleDetails = results.map((e) => Schedule.fromJson(e)).toList();
        print(_scheduleDetails.length);
        update();
      } catch (e) {
        print('hola aca e!!!');
        print(e);
      }
    } else {
      final message = response.body['detail'];
      Get.snackbar(
        'Error',
        message ?? 'Failed to get practice',
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
}
