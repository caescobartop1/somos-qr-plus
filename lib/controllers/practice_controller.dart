import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:somos_qr_plus/helpers/route_helper.dart';
import 'package:somos_qr_plus/models/bonus_detail.dart';
import 'package:somos_qr_plus/models/invitation.dart';
import 'package:somos_qr_plus/models/login_response.dart';
import 'package:somos_qr_plus/models/mco.dart';
import 'package:somos_qr_plus/models/notifications.dart';
import 'package:somos_qr_plus/models/panel_detail.dart';
import 'package:somos_qr_plus/models/patient.dart';
import 'package:somos_qr_plus/models/patient_gap.dart';
import 'package:somos_qr_plus/models/patient_patology.dart';
import 'package:somos_qr_plus/models/patient_response.dart';
import 'package:somos_qr_plus/models/pocket_guide.dart';
import 'package:somos_qr_plus/models/practice.dart';
import 'package:somos_qr_plus/models/practice_details.dart';
import 'package:somos_qr_plus/models/provider.dart';
import 'package:somos_qr_plus/models/provider_schedule.dart';
import 'package:somos_qr_plus/models/report_kpi_gic.dart';
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
  List<Schedule> _scheduleDetailsForPage = [];
  List<Schedule> get scheduleDetailsForPage => _scheduleDetailsForPage;
  PracticeDetails _practiceDetails = PracticeDetails.empty();
  PracticeDetails get practiceDetails => _practiceDetails;

  List<NotificationModel> _notifications = [];
  List<NotificationModel> get notifications => _notifications;
  List<Mco> _mcoList = [];
  List<Mco> get mcoList => _mcoList;
  List<ProviderSchedule> _providerList = [];
  List<ProviderSchedule> get providerList => _providerList;
  List<PocketGuide> _pocketGuides = [];
  List<PocketGuide> get pocketGuides => _pocketGuides;
  List<PocketRaParent> _pocketRaList = [];
  List<PocketRaParent> get pocketRaList => _pocketRaList;
  List<Patient> _patients = [];
  List<Patient> get patients => _patients;
  ReportKpiGic? _reportKpiGic;
  ReportKpiGic? get reportKpiGic => _reportKpiGic;
  ReportKpiGic? _reportKpiRA;
  ReportKpiGic? get reportKpiRa => _reportKpiRA;
  ReportKpiGic? _reportKpiAPPT;
  ReportKpiGic? get reportKpiAPPT => _reportKpiAPPT;

  PatientResponse? _patient;
  PatientResponse? get patient => _patient;
  List<PatientGap> _patientGaps = [];
  List<PatientGap> get patientGaps => _patientGaps;
  List<PatientPatology> _patientPatologies = [];
  List<PatientPatology> get patientPatologies => _patientPatologies;

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

  Future<void> getNotifications() async {
    // _isLoading = true;
    // update();

    final response = await apiClient.getData(
      AppConstants.notificationsUrl,
      useApi: true,
      query: {
        "app_key": AppConstants.appKey,
        "unread": "true",
        "offset": "0",
        "limit": "10",
      },
    );

    if (response.statusCode == 200) {
      final data = response.body;
      final List<dynamic> results = data['results'] ?? [];

      _notifications =
          results.map((item) => NotificationModel.fromJson(item)).toList();

      update();
    } else {
      final message = response.body['detail'];
      Get.snackbar(
        'Error',
        message ?? 'Failed to get notifications',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    }

    // _isLoading = false;
    // update();
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
        "mco_id": '-1'
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
        "day__lte": endOfDay,
        "offset": '0',
        "limit": '20',
        'status': 'Pending'
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

  Future<void> getScheduleForScreen(
    String? practiceId, {
    DateTime? startDate,
    DateTime? endDate,
    String? dob,
    String? provider,
    String? status,
    String? mco,
  }) async {
    _isLoading = true;
    update();

    final now = DateTime.now();
    final formatter = DateFormat("yyyy-MM-dd");
    final start = startDate ?? now;
    final end = endDate ?? now;

    final startOfDay = "${formatter.format(start)}T00:00:00";
    final endOfDay = "${formatter.format(end)}T23:59:59";

    // Construimos el query dinámico
    final query = <String, String>{
      "app_key": AppConstants.appKey,
      "practice_id": practiceId ?? '-1',
      "day__gte": startOfDay,
      "day__lte": endOfDay,
      "offset": '0',
      "limit": '1000',
    };

    if (provider != null && provider.isNotEmpty) {
      query["provider_id"] = provider;
    }
    if (mco != null && mco.isNotEmpty) {
      query["mco_id"] = mco;
    }
    if (dob != null && dob.isNotEmpty) {
      query["birthdate"] = dob;
    }
    if (status != null && status.isNotEmpty) {
      query["status"] = status;
    }

    final response = await apiClient.getData(
      AppConstants.scheduleUrl,
      useApi: true,
      query: query,
    );

    if (response.statusCode == 200) {
      try {
        final data = response.body;
        final results = data['results'] as List<dynamic>;
        _scheduleDetailsForPage =
            results.map((e) => Schedule.fromJson(e)).toList();
        update();
      } catch (e) {
        print('Error parseando datos: $e');
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

  Future<void> getMco(String? practiceId) async {
    _isLoading = true;
    update();

    // Construimos el query dinámico
    final query = <String, String>{
      "app_key": AppConstants.appKey,
      "practice_id": practiceId ?? '-1'
    };

    final response = await apiClient.getData(
      AppConstants.mcoUrl,
      useApi: true,
      query: query,
    );

    if (response.statusCode == 200) {
      try {
        final data = response.body;
        final results = data['results'] as List<dynamic>;
        _mcoList = results.map((e) => Mco.fromJson(e)).toList();
        update();
      } catch (e) {
        print('Error parseando datos: $e');
      }
    } else {
      final message = response.body['detail'];
      Get.snackbar(
        'Error',
        message ?? 'Failed to get Mco',
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

  Future<void> getProvider(String? practiceId) async {
    _isLoading = true;
    update();

    final query = <String, String>{
      "app_key": AppConstants.appKey,
      "practice_id": practiceId ?? '-1',
    };

    final response = await apiClient.getData(
      AppConstants.providerUrl,
      useApi: true,
      query: query,
    );

    if (response.statusCode == 200) {
      try {
        final data = response.body;
        final results = data['results'] as List<dynamic>;

        _providerList =
            results.map((e) => ProviderSchedule.fromJson(e)).toList();

        update();
      } catch (e) {
        print('Error parseando datos: $e');
      }
    } else {
      final message = response.body['detail'];
      Get.snackbar(
        'Error',
        message ?? 'Failed to get providers',
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

  Future<void> getPatients(String? practiceId,
      {String? dob,
      String? provider,
      String? status,
      String? mco,
      String? search,
      String? ordering}) async {
    _isLoading = true;
    update();

    final query = <String, String>{
      "app_key": AppConstants.appKey,
      "practice_id": practiceId ?? '-1',
      "fields": 'id,full_name,birthdate,gic,ra,mco_name'
    };

    if (provider != null && provider.isNotEmpty) {
      query["provider_id"] = provider;
    }
    if (mco != null && mco.isNotEmpty) {
      query["mco_id"] = mco;
    }
    if (dob != null && dob.isNotEmpty) {
      query["birthdate"] = dob;
    }
    if (search != null && search.isNotEmpty) {
      query["search"] = search;
    }
    if (ordering != null && ordering.isNotEmpty) {
      query["ordering"] = ordering;
    }

    final response = await apiClient.getData(
      AppConstants.userUrl,
      useApi: true,
      query: query,
    );

    if (response.statusCode == 200) {
      try {
        final body = response.body;
        final List<dynamic> results = body['results'] ?? [];

        _patients = results.map((e) => Patient.fromJson(e)).toList();
      } catch (e) {
        print('Error parseando datos: $e');
      }
    } else {
      final message = response.body['detail'];
      Get.snackbar(
        'Error',
        message ?? 'Failed to get patients',
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

  Future<void> walkIn(String? practiceId,
      {String? patientId, String? provider}) async {
    _isLoading = true;
    update();

    final query = <String, String>{
      "app_key": AppConstants.appKey,
      "practice_id": practiceId ?? '-1',
      "provider_id": provider ?? '-1',
    };
    final response = await apiClient.postData(
        '${AppConstants.userUrl}${patientId ?? ''}/add_walk_in/', {},
        queryParams: query, useApi: true);

    if (response.statusCode == 200) {
      try {
        final body = response.body;
        print(body);
      } catch (e) {
        print('Error parseando datos: $e');
      }
    } else {
      final message = response.body['detail'];
      Get.snackbar(
        'Error',
        message ?? 'Failed to create walk in',
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

  Future<void> getPocketQuality(
      String? categoryParentId, String? search) async {
    _isLoading = true;
    update();

    final query = <String, String>{
      "app_key": AppConstants.appKey,
      "offset": "0",
      "limit": "100",
    };

    if (categoryParentId != null && categoryParentId.isNotEmpty) {
      query["category_parent_id"] = categoryParentId;
    } else {
      query["category_parent__isnull"] = "true";
    }

    if (search != null && search.isNotEmpty) {
      query["search"] = search;
    }

    final response = await apiClient.getData(
      AppConstants.pocketGapUrl,
      useApi: true,
      query: query,
    );

    if (response.statusCode == 200) {
      try {
        final data = response.body;
        final results = data['results'] as List<dynamic>;

        if (categoryParentId == null || categoryParentId.isEmpty) {
          // 🔹 Primera carga → solo guías
          _pocketGuides = results.map((e) {
            final guide = PocketGuide.fromJson(e);

            // ✅ Verificamos si vienen códigos en el JSON del padre
            final List<dynamic> rawCodes = e['codes'] as List<dynamic>? ?? [];
            if (rawCodes.isNotEmpty) {
              final codes =
                  rawCodes.map((c) => PocketQualityCode.fromJson(c)).toList();

              final PocketQualityCategory autoCategory = PocketQualityCategory(
                id: guide.id, // puedes reutilizar el id del guide
                name: guide.name,
                isEnabled: guide.isEnabled,
                created: guide.created,
                modified: guide.modified,
                codes: codes,
              );

              // devolvemos una copia del guide con la categoría creada
              return guide.copyWith(categories: [autoCategory]);
            }

            return guide;
          }).toList();
        } else {
          // 🔹 Carga de categorías para una guía específica
          final List<PocketQualityCategory> categories =
              results.map((e) => PocketQualityCategory.fromJson(e)).toList();

          final int guideId = int.tryParse(categoryParentId) ?? 0;

          // Reemplazamos las categorías SOLO en el guide correspondiente
          _pocketGuides = _pocketGuides.map((g) {
            if (g.id == guideId) {
              return g.copyWith(categories: categories);
            }
            return g;
          }).toList();
        }

        update();
      } catch (e) {
        print('Error parseando datos: $e');
      }
    } else {
      final message = response.body['detail'];
      Get.snackbar(
        'Error',
        message ?? 'Failed to get Pocket Quality',
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

  Future<void> getPocketRa(String? search) async {
    _isLoading = true;
    update();

    final query = <String, String>{
      "app_key": AppConstants.appKey,
      "offset": "0",
      "limit": "100",
    };

    if (search != null && search.isNotEmpty) {
      query["search"] = search;
    }

    final response = await apiClient.getData(
      AppConstants.pocketRaUrl,
      useApi: true,
      query: query,
    );

    if (response.statusCode == 200) {
      try {
        final data = response.body;
        final results = data['results'] as List? ?? [];

        _pocketRaList = results
            .map(
                (item) => PocketRaParent.fromJson(item as Map<String, dynamic>))
            .toList();

        update();
      } catch (e) {
        print('Error parseando datos: $e');
      }
    } else {
      final message = response.body['detail'];
      Get.snackbar(
        'Error',
        message ?? 'Failed to get pocket Ra',
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

  Future<void> getReportKpiGic(String? practice_id) async {
    _isLoading = true;
    update();

    final query = <String, String>{
      "app_key": AppConstants.appKey,
      "offset": "0",
      "limit": "5",
      "practice_id": practice_id ?? '-1',
      "kpi_type": 'GIC',
      "ordering": "-today_date"
    };

    final response = await apiClient.getData(
      AppConstants.reportKpiUrl,
      useApi: true,
      query: query,
    );

    if (response.statusCode == 200) {
      try {
        final data = response.body;

        final List<dynamic> results =
            data is List ? data : (data['results'] ?? []);

        if (results.isNotEmpty) {
          _reportKpiGic = ReportKpiGic.fromJson(results.first);
        } else {
          _reportKpiGic = null;
        }

        update();
      } catch (e) {
        print('Error parseando datos: $e');
      }
    } else {
      final message = response.body['detail'];
      Get.snackbar(
        'Error',
        message ?? 'Failed to get Kpi report',
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

  Future<void> getReportKpiRa(String? practice_id) async {
    _isLoading = true;
    update();

    final query = <String, String>{
      "app_key": AppConstants.appKey,
      "offset": "0",
      "limit": "5",
      "practice_id": practice_id ?? '-1',
      "kpi_type": 'RA',
      "ordering": "-today_date"
    };

    final response = await apiClient.getData(
      AppConstants.reportKpiUrl,
      useApi: true,
      query: query,
    );

    if (response.statusCode == 200) {
      try {
        final data = response.body;

        final List<dynamic> results =
            data is List ? data : (data['results'] ?? []);

        if (results.isNotEmpty) {
          _reportKpiRA = ReportKpiGic.fromJson(results.first);
        } else {
          _reportKpiRA = null;
        }

        update();
      } catch (e) {
        print('Error parseando datos: $e');
      }
    } else {
      final message = response.body['detail'];
      Get.snackbar(
        'Error',
        message ?? 'Failed to get Kpi report',
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

  Future<void> getReportKpiAppt(String? practice_id) async {
    _isLoading = true;
    update();

    final query = <String, String>{
      "app_key": AppConstants.appKey,
      "offset": "0",
      "limit": "5",
      "practice_id": practice_id ?? '-1',
      "kpi_type": 'APPT',
      "ordering": "-today_date"
    };

    final response = await apiClient.getData(
      AppConstants.reportKpiUrl,
      useApi: true,
      query: query,
    );

    if (response.statusCode == 200) {
      try {
        final data = response.body;

        final List<dynamic> results =
            data is List ? data : (data['results'] ?? []);

        if (results.isNotEmpty) {
          _reportKpiAPPT = ReportKpiGic.fromJson(results.first);
        } else {
          _reportKpiAPPT = null;
        }

        update();
      } catch (e) {
        print('Error parseando datos: $e');
      }
    } else {
      final message = response.body['detail'];
      Get.snackbar(
        'Error',
        message ?? 'Failed to get Kpi report',
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

  Future<void> getPatient(String patientId, String practice_id) async {
    _isLoading = true;
    update();

    final query = <String, String>{
      "app_key": AppConstants.appKey,
      "practice_id": practice_id == 'all' ? '-1' : practice_id
    };

    final response = await apiClient.getData(
      '${AppConstants.userUrl}${patientId}/',
      useApi: true,
      query: query,
    );

    if (response.statusCode == 200) {
      try {
        final data = response.body;
        _patient = PatientResponse.fromJson(data);
        update();
      } catch (e) {
        print('Error parseando datos: $e');
      }
    } else {
      final message = response.body['detail'];
      Get.snackbar(
        'Error',
        message ?? 'Failed to get patient',
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

  Future<void> getPatientGap(String patientId) async {
    _isLoading = true;
    update();

    final query = <String, String>{
      "app_key": AppConstants.appKey,
      "patient_id": patientId
    };

    final response = await apiClient.getData(
      '${AppConstants.userGapUrl}',
      useApi: true,
      query: query,
    );

    if (response.statusCode == 200) {
      try {
        final data = response.body;
        final List<dynamic> results = data['results'] ?? [];

        _patientGaps = results
            .map((e) => PatientGap.fromJson(e as Map<String, dynamic>))
            .toList();
        update();
      } catch (e) {
        print('Error parseando datos: $e');
      }
    } else {
      final message = response.body['detail'];
      Get.snackbar(
        'Error',
        message ?? 'Failed to get patient gap',
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

  Future<void> getPatientPatology(String patientId) async {
    _isLoading = true;
    update();

    final query = <String, String>{
      "app_key": AppConstants.appKey,
      "patient_id": patientId
    };

    final response = await apiClient.getData(
      '${AppConstants.userPatologyUrl}',
      useApi: true,
      query: query,
    );

    if (response.statusCode == 200) {
      try {
        final data = response.body;
        final List<dynamic> results = data['results'] ?? [];

        // ✅ Parsear usando PatientPatology
        _patientPatologies = results
            .map((e) => PatientPatology.fromJson(e as Map<String, dynamic>))
            .toList();
        update();
      } catch (e) {
        print('Error parseando datos: $e');
      }
    } else {
      final message = response.body['detail'];
      Get.snackbar(
        'Error',
        message ?? 'Failed to get patient gap',
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

  Future<void> updatePatientGaps(bool value, int index, int gap_id,
      String practice_id, String selected_provider) async {
    if (index < 0 || index >= _patientGaps.length) return;
    final query = <String, String>{
      "app_key": AppConstants.appKey,
      "practice_id": practice_id == 'all' ? '-1' : practice_id
    };
    if (selected_provider != 'all') {
      query["provider_id"] = selected_provider;
    }
    final response = await apiClient.postData(
        '${AppConstants.userGapUrl}${gap_id.toString()}/update_app/', {},
        queryParams: query, useApi: true);

    if (response.statusCode == 200) {
      try {
        final updatedList = List<PatientGap>.from(_patientGaps);

        updatedList[index] = updatedList[index].copyWith(app: value);

        _patientGaps = updatedList;

        update();
      } catch (e) {
        print('Error parseando datos: $e');
      }
    } else {
      final message = response.body['detail'] ?? response.body['error'];
      Get.snackbar(
        'Error',
        message ?? 'Failed to create update patient gap',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    }
  }

  Future<void> updatePatientPatologyField({
    required bool value,
    required int index,
    required int patologyId,
    required String practiceId,
    required String selectedProvider,
    required String field,
  }) async {
    if (index < 0 || index >= _patientPatologies.length) return;

    // Query base
    final query = <String, String>{
      "app_key": AppConstants.appKey,
      "practice_id": practiceId == 'all' ? '-1' : practiceId,
    };

    if (selectedProvider != 'all') {
      query["provider_id"] = selectedProvider;
    }

    // Elegir endpoint según el campo a actualizar
    // Asegúrate de tener las rutas correctas en AppConstants
    String endpoint;
    if (field == 'Inactive') {
      endpoint = '${AppConstants.userPatologyUrl}$patologyId/update_inactive/';
    } else if (field == 'App') {
      endpoint = '${AppConstants.userPatologyUrl}$patologyId/update_app/';
    } else {
      throw Exception('Campo no soportado para actualización: $field');
    }

    // Petición a la API
    final response = await apiClient.postData(
      endpoint,
      {}, // body vacío
      queryParams: query,
      useApi: true,
    );

    if (response.statusCode == 200) {
      try {
        // Crear una copia de la lista y reemplazar el elemento modificado
        final updatedList = List<PatientPatology>.from(_patientPatologies);
        final current = updatedList[index];

        updatedList[index] = current.copyWith(
          inactive: field == 'Inactive' ? value : current.inactive,
          app: field == 'App' ? value : current.app,
        );

        _patientPatologies = updatedList;

        // Notificar a GetX para refrescar la UI
        update();
      } catch (e) {
        print('Error parseando datos: $e');
      }
    } else {
      final message = response.body['detail'] ?? response.body['error'];
      Get.snackbar(
        'Error',
        message ?? 'Failed to update patient patology',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    }
  }

  Future<void> updateStatusVisit(
      {required int patientId,
      required String? practiceId,
      required String selectedProvider,
      required String field,
      required dynamic schedule_id}) async {
    // Query base
    final query = <String, String>{
      "app_key": AppConstants.appKey,
      "schedule_id": schedule_id.toString()
    };
    if (practiceId != null) {
      query["practice_id"] = practiceId == 'all' ? '-1' : practiceId;
    }

    if (selectedProvider != 'all') {
      query["provider_id"] = selectedProvider;
    }

    // Elegir endpoint según el campo a actualizar
    // Asegúrate de tener las rutas correctas en AppConstants
    String endpoint;
    if (field == 'No Shows') {
      endpoint = '${AppConstants.userUrl}$patientId/update_no_show/';
    } else if (field == 'Completed Visits') {
      endpoint = '${AppConstants.userUrl}$patientId/update_visit/';
    } else {
      throw Exception('Campo no soportado para actualización: $field');
    }

    // Petición a la API
    final response = await apiClient.postData(
      endpoint,
      {}, // body vacío
      queryParams: query,
      useApi: true,
    );

    if (response.statusCode == 200) {
      try {} catch (e) {
        print('Error parseando datos: $e');
      }
    } else {
      final message = response.body['detail'] ?? response.body['error'];
      Get.snackbar(
        'Error',
        message ?? 'Failed to update patient patology',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    }
  }
}
