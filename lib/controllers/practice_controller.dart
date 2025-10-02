import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:somos_qr_plus/controllers/auth_controller.dart';
import 'package:somos_qr_plus/helpers/route_helper.dart';
import 'package:somos_qr_plus/models/appt_list.dart';
import 'package:somos_qr_plus/models/bonus_detail.dart';
import 'package:somos_qr_plus/models/gic_list.dart';
import 'package:somos_qr_plus/models/invitation.dart';
import 'package:somos_qr_plus/models/invitation_role.dart';
import 'package:somos_qr_plus/models/invite.dart';
import 'package:somos_qr_plus/models/login_response.dart';
import 'package:somos_qr_plus/models/mco.dart';
import 'package:somos_qr_plus/models/mfa_method.dart';
import 'package:somos_qr_plus/models/mwov_list.dart';
import 'package:somos_qr_plus/models/my_invites.dart';
import 'package:somos_qr_plus/models/notifications.dart';
import 'package:somos_qr_plus/models/npi_response.dart';
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
import 'package:somos_qr_plus/models/quality_measure.dart';
import 'package:somos_qr_plus/models/quality_score.dart';
import 'package:somos_qr_plus/models/ra_list.dart';
import 'package:somos_qr_plus/models/report_kpi_gic.dart';
import 'package:somos_qr_plus/models/schedule.dart';
import 'package:somos_qr_plus/models/staff_login.dart';
import 'package:somos_qr_plus/models/user.dart';
import 'package:somos_qr_plus/models/user_settings.dart';
import '../api/api_client.dart';
import '../constants/app_constants.dart';

class PracticeController extends GetxController {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  PracticeController(
      {required this.apiClient, required this.sharedPreferences});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Provider _defaultProvider = Provider(name: 'All', id: '-1');
  Provider get defaultProvider => _defaultProvider;
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
  ReportKpiGic? _reportKpiMWOV;
  ReportKpiGic? get reportKpiMWOV => _reportKpiMWOV;

  PatientResponse? _patient;
  PatientResponse? get patient => _patient;
  List<PatientGap> _patientGaps = [];
  List<PatientGap> get patientGaps => _patientGaps;
  List<PatientPatology> _patientPatologies = [];
  List<PatientPatology> get patientPatologies => _patientPatologies;
  List<StaffLogin> _staffLogins = [];
  List<StaffLogin> get staffLogins => _staffLogins;
  List<StaffLogin> _usersAccounts = [];
  List<StaffLogin> get usersAccounts => _usersAccounts;
  List<GicList> _gicList = [];
  List<GicList> get gicList => _gicList;
  List<RaList> _raList = [];
  List<RaList> get raList => _raList;
  List<ApptList> _apptList = [];
  List<ApptList> get apptList => _apptList;
  List<MWOVList> _mwovList = [];
  List<MWOVList> get mwovList => _mwovList;
  List<Invite> _invites = [];
  List<Invite> get invites => _invites;
  List<NpiResponse> _npiList = [];
  List<NpiResponse> get npiList => _npiList;
  List<InvitationRole> _invitationRoles = [];
  List<InvitationRole> get invitationRoles => _invitationRoles;
  List<MyInvite> _myInvites = [];
  List<MyInvite> get myInvites => _myInvites;
  List<MfaMethod> _mfaMethods = [];
  List<MfaMethod> get mfaMethods => _mfaMethods;
  UserSettings? _userSettings;
  UserSettings? get userSettings => _userSettings;
  List<QualityScore> _qualityScores = [];
  List<QualityScore> get qualityScores => _qualityScores;
  List<String> _mcoOptions = [];
  List<String> get mcoOptions => _mcoOptions;
  List<String> _productOptions = [];
  List<String> get productOptions => _productOptions;
  List<String> _lobOptions = [];
  List<String> get lobOptions => _lobOptions;
  List<QualityMeasure> _measureOptions = [];
  List<QualityMeasure> get measureOptions => _measureOptions;

  // Done
  Future<bool> getPractice(String search) async {
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
      return true;
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

      return false;
    }
  }

  // Done
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
      if (response.statusCode == 401) {
        return;
      }
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

// Done
  Future<bool> getPracticeDetails(String? practice_id) async {
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
      return true;

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
      return false;
    }
  }

// Done
  Future<bool> getPanelDetails(String? practice_id) async {
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
      return true;
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
      return false;
    }
  }

// Done
  Future<bool> mocListDetails(String? practice_id) async {
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
      return true;
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

    return false;
  }

// Done
  Future<bool> getBonusDetails(String? practice_id) async {
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
      return true;
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
      return false;
    }
  }

// Done
  Future<bool> getSchedule(String? practice_id) async {
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
        return true;
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
    return false;
  }

// Done
  Future<bool> getScheduleForScreen(
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
        return true;
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

    return false;
  }

// Done
  Future<bool> getMco(String? practiceId) async {
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
        return true;
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

    return false;
  }

// Done
  Future<bool> getProvider(String? practiceId) async {
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
        return true;
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

    return false;
  }

// Done
  Future<bool> getPatients(String? practiceId,
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
      print('hola aca!');
      print(mco);
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
        update();
        return true;
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

    return false;
  }

// Done
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

// Done
  Future<bool> getPocketQuality(
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
        return true;
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

    return false;
  }

// Done
  Future<bool> getPocketRa(String? search) async {
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
        return true;
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

    return false;
  }

// Done
  Future<bool> getReportKpiGic(String? practice_id) async {
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
        return true;
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

    return false;
  }

// Done
  Future<bool> getReportKpiGicList(String? practice_id,
      {String? member_name,
      String? mco_name,
      String? dob,
      String? date_time,
      String? measure_code,
      String? status,
      String? phone}) async {
    _isLoading = true;
    update();

    final query = <String, String>{
      "app_key": AppConstants.appKey,
      "offset": "0",
      "limit": "20",
      "practice_id": practice_id ?? '-1'
    };
    if (member_name != null && member_name.isNotEmpty) {
      query['member_name__icontains'] = member_name;
    }
    if (mco_name != null && mco_name.isNotEmpty && mco_name != 'all') {
      query['mco_name__icontains'] = mco_name;
    }
    if (dob != null && dob.isNotEmpty) {
      query['dob'] = dob;
    }
    if (date_time != null && date_time.isNotEmpty) {
      query['date_time'] = date_time;
    }
    if (measure_code != null && measure_code.isNotEmpty) {
      query['measure_code__icontains'] = measure_code;
    }
    if (status != null && status.isNotEmpty) {
      query['status__icontains'] = status;
    }
    if (phone != null && phone.isNotEmpty) {
      query['phone_number__icontains'] = phone;
    }
    print(query);

    final response = await apiClient.getData(
      AppConstants.reportGicList,
      useApi: true,
      query: query,
    );

    if (response.statusCode == 200) {
      try {
        final data = response.body;
        final List<GicList> results = GicList.listFromJson(data);
        _gicList = results;
        update();
        return true;
      } catch (e) {
        print('Error parseando datos: $e');
      }
    } else {
      final message = response.body['detail'];
      Get.snackbar(
        'Error',
        message ?? 'Failed to get gic list',
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

// Done
  Future<void> getReportKpiRaList(String? practiceId,
      {String? memberName,
      String? mcoName,
      String? dob,
      String? ic10,
      String? status,
      String? dateTime,
      String? phone}) async {
    _isLoading = true;
    update();

    final query = <String, String>{
      "app_key": AppConstants.appKey,
      "offset": "0",
      "limit": "20",
      "practice_id": practiceId ?? '-1'
    };

    if (memberName != null && memberName.isNotEmpty) {
      query['member_name__icontains'] = memberName;
    }
    if (mcoName != null && mcoName.isNotEmpty && mcoName != 'all') {
      query['mco_name__icontains'] = mcoName;
    }
    if (dob != null && dob.isNotEmpty) {
      query['dob'] = dob;
    }
    if (ic10 != null && ic10.isNotEmpty) {
      query['icd10_code__icontains'] = ic10;
    }
    if (dateTime != null && dateTime.isNotEmpty) {
      query['date_time'] = dateTime;
    }
    if (status != null && status.isNotEmpty) {
      query['hcc_status__icontains'] = status;
    }
    if (phone != null && phone.isNotEmpty) {
      query['phone_number__icontains'] = phone;
    }

    final response = await apiClient.getData(
      AppConstants.reportRaList, // ✅ Usa el endpoint correcto para RA
      useApi: true,
      query: query,
    );
    print(query);

    if (response.statusCode == 200) {
      try {
        final data = response.body;
        _raList = RaList.listFromJson(data);
        update();
      } catch (e) {
        print('Error parseando datos RA: $e');
      }
    } else {
      final message = response.body['detail'];
      Get.snackbar(
        'Error',
        message ?? 'Failed to get RA list',
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

// Done
  Future<bool> getReportKpiApptList(String? practiceId,
      {String? memberName,
      String? mcoName,
      String? dob,
      String? lastVisitDate,
      String? messedDate,
      String? address,
      String? phone}) async {
    _isLoading = true;
    update();

    final query = <String, String>{
      "app_key": AppConstants.appKey,
      "offset": "0",
      "limit": "20",
      "practice_id": practiceId ?? '-1'
    };

    if (memberName != null && memberName.isNotEmpty) {
      query['member_name__icontains'] = memberName;
    }
    if (mcoName != null && mcoName.isNotEmpty) {
      query['mco_name__icontains'] = mcoName;
    }
    if (dob != null && dob.isNotEmpty) {
      query['dob'] = dob;
    }
    if (lastVisitDate != null && lastVisitDate.isNotEmpty) {
      query['last_visit_date'] = lastVisitDate;
    }
    if (messedDate != null && messedDate.isNotEmpty) {
      query['messed_date'] = messedDate;
    }
    if (address != null && address.isNotEmpty) {
      query['address__icontains'] = address;
    }
    if (phone != null && phone.isNotEmpty) {
      query['phone_number__icontains'] = phone;
    }

    final response = await apiClient.getData(
      AppConstants.reportApptList, // ✅ Usa el endpoint correcto para RA
      useApi: true,
      query: query,
    );
    print(query);

    if (response.statusCode == 200) {
      try {
        final data = response.body;
        print(data);
        print('hola aca!!');
        final List<ApptList> apptList = ApptList.listFromJson(data);
        _apptList = apptList;
        print(_apptList.length);
        update();
        return true;
      } catch (e) {
        print('Error parseando datos RA: $e');
      }
    } else {
      final message = response.body['detail'];
      Get.snackbar(
        'Error',
        message ?? 'Failed to get RA list',
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

// Done
  Future<bool> getReportKpiMwovList(String? practiceId,
      {String? memberName,
      String? mcoName,
      String? dob,
      String? phone,
      String? lastVisitDate,
      String? address}) async {
    _isLoading = true;
    update();

    final query = <String, String>{
      "app_key": AppConstants.appKey,
      "offset": "0",
      "limit": "20",
      "practice_id": practiceId ?? '-1',
    };

    if (memberName != null && memberName.isNotEmpty) {
      query['member_name__icontains'] = memberName;
    }
    if (mcoName != null && mcoName.isNotEmpty) {
      query['mco_name__icontains'] = mcoName;
    }
    if (dob != null && dob.isNotEmpty) {
      query['dob'] = dob;
    }
    if (phone != null && phone.isNotEmpty) {
      query['phone_number__icontains'] = phone;
    }
    if (lastVisitDate != null && lastVisitDate.isNotEmpty) {
      query['last_visit_date'] = lastVisitDate;
    }
    if (address != null && address.isNotEmpty) {
      query['address__icontains'] = address;
    }

    final response = await apiClient.getData(
      AppConstants.reportMwovList,
      useApi: true,
      query: query,
    );

    if (response.statusCode == 200) {
      try {
        final data = response.body;
        _mwovList = MWOVList.listFromJson(data);
        update();
        return true;
      } catch (e) {
        print('Error parseando datos MWOV: $e');
      }
    } else {
      final message = response.body['detail'];
      Get.snackbar(
        'Error',
        message ?? 'Failed to get MWOV list',
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

// Done
  Future<bool> getReportKpiLastLogin(String? practice_id) async {
    _isLoading = true;
    update();

    final query = <String, String>{
      "app_key": AppConstants.appKey,
      "offset": "0",
      "limit": "100",
      "practice_id": practice_id ?? '-1',
      "fields":
          "is_verified,practice.name,role.name,id,full_name,user.last_login",
      "expand": "practice,role,user"
    };

    final response = await apiClient.getData(
      AppConstants.reportStaffLogin,
      useApi: true,
      query: query,
    );

    if (response.statusCode == 200) {
      try {
        final data = response.body;

        final List<dynamic> results =
            data is List ? data : (data['results'] ?? []);
        _staffLogins = results
            .map((e) => StaffLogin.fromJson(e as Map<String, dynamic>))
            .toList();
        update();
        return true;
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

    return false;
  }

// Done
  Future<bool> getReportKpiRa(String? practice_id) async {
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
        return true;
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

    return false;
  }

// Done
  Future<bool> getReportKpiAppt(String? practice_id) async {
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
        return true;
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

    return false;
  }

// Done
  Future<bool> getReportKpiMWOV(String? practice_id) async {
    _isLoading = true;
    update();

    final query = <String, String>{
      "app_key": AppConstants.appKey,
      "offset": "0",
      "limit": "5",
      "practice_id": practice_id ?? '-1',
      "kpi_type": 'MWOV',
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
          _reportKpiMWOV = ReportKpiGic.fromJson(results.first);
        } else {
          _reportKpiMWOV = null;
        }

        update();
        return true;
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

    return false;
  }

// Done
  Future<bool> getPatient(String patientId, String practice_id) async {
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
        return true;
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

    return false;
  }

// Done
  Future<bool> getPatientGap(String patientId) async {
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
        return true;
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

    return false;
  }

// Done
  Future<bool> getPatientPatology(String patientId) async {
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
        return true;
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

    return false;
  }

// Done
  Future<bool> getInvites(String practiceId, String? search) async {
    _isLoading = true;
    update();

    final query = <String, String>{
      "app_key": AppConstants.appKey,
      "practice_id": practiceId,
      "search": search ?? ''
    };

    final response = await apiClient.getData(
      '${AppConstants.userInvites}',
      useApi: true,
      query: query,
    );

    if (response.statusCode == 200) {
      try {
        final data = response.body;
        final List<dynamic> results = data['results'] ?? [];
        _invites = Invite.listFromJson(results);

        update();
        return true;
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
    return false;
  }

// Done
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

// Done
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

// Done
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

  void setProvider(Provider provider) {
    _defaultProvider = provider;
    print('hola aca hubo un update!');
    update();
  }

// Done
  Future<bool> sendUserInvitation({
    required String email,
    required String firstName,
    required String lastName,
    required String npi,
    required String phoneNumber,
    required String practiceId,
    required dynamic roleId,
  }) async {
    // ✅ Validación de practiceId
    if (practiceId == '-1') {
      print('⚠️ practiceId es -1, manejar caso especial aquí');
      return false;
    }

    final body = {
      "email": email,
      "first_name": firstName,
      "last_name": lastName,
      "phone_number": phoneNumber,
      "practice_id": practiceId,
      "role_id": roleId,
    };

    if (npi.isNotEmpty) {
      body["npi"] = npi;
    }
    final query = <String, String>{"app_key": AppConstants.appKey};

    final response = await apiClient.postData(
      AppConstants.generateRequestInvitationUrl,
      queryParams: query,
      body,
      useApi: true,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      final message = response.body['detail'] ?? response.body['error'];
      Get.snackbar(
        'Error',
        message ?? 'Failed to create invitation',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        icon: const Icon(Icons.error, color: Colors.white),
      );
      return false;
    }
  }

// Done
  Future<bool> updateUserInvitation(
      {required String email,
      required String firstName,
      required String lastName,
      required String npi,
      required String phoneNumber,
      required String practiceId,
      required dynamic roleId,
      required dynamic invitationId}) async {
    // ✅ Validación de practiceId
    if (practiceId == '-1') {
      print('⚠️ practiceId es -1, manejar caso especial aquí');
      return false;
    }

    final body = {
      "email": email,
      "first_name": firstName,
      "last_name": lastName,
      "npi": npi,
      "phone_number": phoneNumber,
      "practice_id": practiceId,
      "role_id": roleId,
    };
    final query = <String, String>{"app_key": AppConstants.appKey};

    final response = await apiClient.patchData(
      AppConstants.updateRequestInvitationUrl + '$invitationId/',
      queryParams: query,
      body,
      useApi: true,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      final message = response.body['detail'] ?? response.body['error'];
      Get.snackbar(
        'Error',
        message ?? 'Failed to edit invitation',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    }
    update();
    return false;
  }

// Done
  Future<bool> resendInvitation(int invitationId) async {
    _isLoading = true;
    update();

    final url = AppConstants.userInvites + '$invitationId/resend_invitation/';

    try {
      final query = <String, String>{"app_key": AppConstants.appKey};
      final response =
          await apiClient.postData(url, {}, useApi: true, queryParams: query);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        final message = response.body['detail'];
        Get.snackbar(
          'Error',
          message ?? 'Failed to resend invitation',
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Exception: $e',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    }
    return false;
  }

// Done
  Future<bool> getInvitationRoles() async {
    _isLoading = true;
    update();

    final response = await apiClient.getData(
      AppConstants.securityRolesUrl,
      useApi: false, // ❗️ no requiere token de práctica
      query: {
        "practice_required": "true",
        "is_invitation": "true",
        "app_key": AppConstants.appKey
      },
    );

    if (response.statusCode == 200) {
      try {
        final data = response.body;
        final List<dynamic> results = data['results'] ?? [];
        _invitationRoles = InvitationRole.listFromJson(results);
        print(_invitationRoles.length);
        update();
        return true;
      } catch (e) {
        print('Error parseando roles de invitación: $e');
      }
    } else {
      final message = response.body['detail'];
      Get.snackbar(
        'Error',
        message ?? 'Failed to get invitation roles',
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

// Done
  Future<bool> getProviderInvitations(String practiceId) async {
    final query = <String, String>{
      "practice_id": practiceId,
      "app_key": AppConstants.appKey
    };

    final response = await apiClient.getData(
      AppConstants.providerInvitationUrl,
      useApi: true,
      query: query,
    );
    print(query);

    if (response.statusCode == 200) {
      try {
        final data = response.body;
        final List<dynamic> results = data['results'] ?? [];
        print('hola aqui aja!');
        print(results.length);
        _npiList = NpiResponse.listFromJson(results);
        update();
        return true;
      } catch (e) {
        print('❌ Error parseando provider invitations: $e');
      }
    } else {
      final message = response.body['detail'];
      Get.snackbar(
        'Error',
        message ?? 'Failed to fetch provider invitations',
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

// Done
  Future<bool> getUserManagement(String practiceId) async {
    final query = <String, String>{
      "practice_id": practiceId,
      "app_key": AppConstants.appKey,
      "fields":
          "is_verified,practice.name,role.name,id,full_name,user.last_login",
      "expand": "practice,role,user"
    };

    final response = await apiClient.getData(
      AppConstants.reportStaffLogin,
      useApi: true,
      query: query,
    );
    print(query);

    if (response.statusCode == 200) {
      try {
        final data = response.body;

        final List<dynamic> results =
            data is List ? data : (data['results'] ?? []);
        _usersAccounts = results
            .map((e) => StaffLogin.fromJson(e as Map<String, dynamic>))
            .toList();
        update();
        return true;
      } catch (e) {
        print('Error parseando datos: $e');
      }
    } else {
      final message = response.body['detail'];
      Get.snackbar(
        'Error',
        message ?? 'Failed to fetch provider invitations',
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

  // Done
  Future<void> disableUserAccount({
    required int userId,
    required String practiceId,
  }) async {
    final url = '${AppConstants.reportStaffLogin}$userId/disable/';

    final response = await apiClient.postData(
      url,
      {}, // No body necesario
      useApi: true,
      queryParams: {
        'practice_id': practiceId,
        'app_key': AppConstants.appKey,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      Get.snackbar(
        'Success',
        'User account disabled successfully.',
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
      await getUserManagement(practiceId); // 🔄 Refresca la lista
    } else {
      final message = response.body['detail'];
      Get.snackbar(
        'Error',
        message ?? 'Failed to disable user account.',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    }
  }

// Done
  Future<void> enableUserAccount({
    required int userId,
    required String practiceId,
  }) async {
    final url = '${AppConstants.reportStaffLogin}$userId/enable/';

    final response = await apiClient.postData(
      url,
      {}, // No body necesario
      useApi: true,
      queryParams: {
        'practice_id': practiceId,
        'app_key': AppConstants.appKey,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      Get.snackbar(
        'Success',
        'User account enabled successfully.',
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
      await getUserManagement(practiceId); // 🔄 Refresca la lista
    } else {
      final message = response.body['detail'];
      Get.snackbar(
        'Error',
        message ?? 'Failed to enable user account.',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    }
  }

// Done
  Future<bool> changeUserRole({
    required int userId,
    required String practiceId,
    required int newRoleId,
    required String newRoleName,
  }) async {
    // Si no hay práctica válida, haz un print para debug
    if (practiceId == '-1') {
      print('⚠️ No practice selected, cannot change role');
      return false;
    }

    final url = '${AppConstants.reportStaffLogin}$userId/change_role/';

    final headers = {'practice_id': practiceId, 'app_key': AppConstants.appKey};

    final body = {
      'role_id': newRoleId,
    };

    final response = await apiClient.postData(
      url,
      body,
      queryParams: headers,
      useApi: true,
    );

    if (response.statusCode == 200) {
      print('✅ Role changed successfully for user $userId to role $newRoleId');
      _usersAccounts = _usersAccounts.map((u) {
        if (u.id == userId) {
          print('hola aca lo encontro!');
          return StaffLogin(
            id: u.id,
            fullName: u.fullName,
            practiceName: u.practiceName,
            userId: u.userId,
            userUsername: u.userUsername,
            userFirstName: u.userFirstName,
            userLastName: u.userLastName,
            userEmail: u.userEmail,
            userIsActive: u.userIsActive,
            userIsStaff: u.userIsStaff,
            userLastLogin: u.userLastLogin,
            userDateJoined: u.userDateJoined,
            userIsSuperuser: u.userIsSuperuser,
            userIsVerified: u.userIsVerified,
            // 👇 Actualizamos solo el nombre del rol
            roleName: newRoleName,
            isVerified: u.isVerified,
          );
        }
        return u;
      }).toList();

      update();
      return true;
    } else {
      final message = response.body['detail'];
      print('❌ Error changing role: $message');
      Get.snackbar(
        'Error',
        message ?? 'Failed to change role',
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

// Done
  Future<bool> getMyInvitations() async {
    final response = await apiClient.getData(
      AppConstants.myInvites,
      useApi: true,
      query: {
        "app_key": AppConstants.appKey,
      },
    );

    if (response.statusCode == 200) {
      try {
        final data = response.body;
        final List<dynamic> results =
            data is List ? data : (data['results'] ?? []);
        _myInvites = MyInvite.listFromJson(results);
        update();
        return true;
      } catch (e) {
        print('❌ Error parsing my invitations: $e');
      }
    } else {
      final message = response.body['detail'];
      Get.snackbar(
        'Error',
        message ?? 'Failed to fetch my invitations',
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

// Done
  Future<bool> acceptInvitation(int invitationId) async {
    final url = '/accounts/my_invitations/$invitationId/accept/';
    try {
      final response = await apiClient.postData(
        url,
        {}, // No requiere body
        queryParams: {'app_key': AppConstants.appKey},
        useApi: true,
      );

      if (response.statusCode == 200) {
        print('✅ Invitación $invitationId aceptada correctamente');
        // Si deseas refrescar las invitaciones:
        await getMyInvitations();
        update();
        return true;
      } else {
        final message = response.body['detail'];
        print('❌ Error aceptando invitación: $message');
        Get.snackbar(
          'Error',
          message ?? 'Failed to accept invitation',
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          icon: const Icon(Icons.error, color: Colors.white),
        );
      }
    } catch (e) {
      print('❌ Excepción al aceptar invitación: $e');
      Get.snackbar(
        'Error',
        'Unexpected error while accepting invitation',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    }
    return false;
  }

// Done
  Future<bool> denyInvitation(int invitationId) async {
    final url = '/accounts/my_invitations/$invitationId/deny/';
    try {
      final response = await apiClient.postData(
        url,
        {}, // No requiere body
        queryParams: {'app_key': AppConstants.appKey},
        useApi: true,
      );

      if (response.statusCode == 200) {
        print('✅ Invitación $invitationId rechazada correctamente');
        // Si deseas refrescar las invitaciones:
        await getMyInvitations();
        update();
        return true;
      } else {
        final message = response.body['detail'];
        print('❌ Error rechazando invitación: $message');
        Get.snackbar(
          'Error',
          message ?? 'Failed to deny invitation',
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          icon: const Icon(Icons.error, color: Colors.white),
        );
      }
    } catch (e) {
      print('❌ Excepción al rechazar invitación: $e');
      Get.snackbar(
        'Error',
        'Unexpected error while denying invitation',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    }
    return false;
  }

// Done
  Future<void> getMfaMethods() async {
    final response = await apiClient.getData(
      '/security/mfa_setup/', // Ajusta si tu endpoint exacto es distinto
      query: {'app_key': AppConstants.appKey},
      useApi: false,
    );

    if (response.statusCode == 200) {
      try {
        final data = response.body;
        final List<dynamic> results =
            data is List ? data : (data['results'] ?? []);

        _mfaMethods = MfaMethod.listFromJson(results);
        update();
      } catch (e) {
        print('Error parseando métodos MFA: $e');
      }
    } else {
      final message = response.body['detail'];
      Get.snackbar(
        'Error',
        message ?? 'Failed to fetch MFA methods',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    }
  }

// Done
  Future<void> getUserSettings() async {
    final response = await apiClient.getData(
      '/security/user_settings/',
      query: {'app_key': AppConstants.appKey},
      useApi: false,
    );

    if (response.statusCode == 200) {
      try {
        final body = response.body;
        final List<dynamic> results =
            body is List ? body : (body['results'] ?? []);
        if (results.isNotEmpty) {
          _userSettings = UserSettings.fromJson(results.first);
          update();
        }
      } catch (e) {
        print('Error parseando user settings: $e');
      }
    } else {
      final message = response.body['detail'];
      Get.snackbar(
        'Error',
        message ?? 'Failed to fetch user settings',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    }
  }

  String _getRefreshKeySuffix(int mfaId) {
    final m = mfaMethods.firstWhereOrNull((x) => x.id == mfaId);
    if (m == null) return 'unknown';

    switch (m.code.toUpperCase()) {
      case 'FACEID':
        return 'faceId';
      case 'AUTHENTICATOR':
        return 'authenticator';
      case 'OTP':
        return 'otp';
      case 'TOUCHID':
        return 'biometric';
      default:
        return m.code.toLowerCase();
    }
  }

// Done
  Future<bool> updateUserMfa(int userSettingsId, int newMfaId) async {
    final url = '/security/user_settings/$userSettingsId/';
    final body = {'mfa_id': newMfaId};

    final response = await apiClient.patchData(
      url,
      body,
      queryParams: {'app_key': AppConstants.appKey},
      useApi: false,
    );

    if (response.statusCode == 200) {
      // Actualizar el objeto userSettings local
      if (_userSettings != null) {
        _userSettings = _userSettings!.copyWith(mfaId: newMfaId);
      }
      final prefs = await SharedPreferences.getInstance();
      String refreshToken =
          sharedPreferences.getString(AppConstants.refreshToken) ?? '';

      String sufix = _getRefreshKeySuffix(newMfaId);
      print(sufix);
      await prefs.setString(
        'refresh_method',
        sufix,
      );
      if (sufix == 'faceId' || sufix == 'biometric') {
        await prefs.setString(
          'refresh_biometric',
          refreshToken,
        );
      }
      update();
      return true;
    } else {
      final message = response.body['detail'];
      Get.snackbar(
        'Error',
        message ?? 'Failed to update MFA method',
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

// Done
  Future<Map<String, dynamic>?> getAuthenticatorUrl(int userId) async {
    final response = await apiClient.postData(
      '/security/user_settings/$userId/authenticator/',
      {},
      queryParams: {'app_key': AppConstants.appKey},
      useApi: false,
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      final msg = response.body['detail'] ?? 'Failed to get authenticator data';
      Get.snackbar(
        'Error',
        msg,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
      return null;
    }
  }

  void reset() {
    _isLoading = false;

    _defaultProvider = Provider(name: 'All', id: '-1');
    _practices = [];
    _panelDetails = [];
    _bonusDetails = [];
    _scheduleDetails = [];
    _scheduleDetailsForPage = [];
    _practiceDetails = PracticeDetails.empty();

    _notifications = [];
    _mcoList = [];
    _providerList = [];
    _pocketGuides = [];
    _pocketRaList = [];
    _patients = [];
    _reportKpiGic = null;
    _reportKpiRA = null;
    _reportKpiAPPT = null;
    _reportKpiMWOV = null;

    _patient = null;
    _patientGaps = [];
    _patientPatologies = [];
    _staffLogins = [];
    _usersAccounts = [];
    _gicList = [];
    _raList = [];
    _apptList = [];
    _mwovList = [];
    _invites = [];
    _npiList = [];
    _invitationRoles = [];
    _myInvites = [];
    _mfaMethods = [];
    _userSettings = null;
    _qualityScores = [];
    _mcoOptions = [];
    _productOptions = [];
    _lobOptions = [];
    _measureOptions = [];

    update();
  }

  Future<void> getQuality(String? practiceId,
      {String? product, String? mco, String? lob, String? measure}) async {
    if (practiceId == null || practiceId == '-1' || practiceId == 'all') {
      Get.snackbar(
        'Error',
        'Must select a practice',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        icon: const Icon(Icons.error, color: Colors.white),
      );
      return;
    }
    final query = {
      'app_key': AppConstants.appKey,
      'practice_id': practiceId,
      'limit': '100',
      'offset': '0'
    };

    if (product != null && product.isNotEmpty) {
      query["product"] = product;
    }
    if (mco != null && mco.isNotEmpty) {
      query["mco"] = mco;
    }
    if (lob != null && lob.isNotEmpty) {
      query["line_of_business"] = lob;
    }
    if (measure != null && measure.isNotEmpty) {
      query["measure_code"] = measure;
    }
    final response = await apiClient.getData(
      '/catalog/app_quality_score/',
      query: query,
      useApi: true,
    );

    if (response.statusCode == 200) {
      final results = response.body['results'] as List<dynamic>;
      _qualityScores =
          results.map((json) => QualityScore.fromJson(json)).toList();
      update();
    } else {
      final message = response.body['detail'];
      Get.snackbar(
        'Error',
        message ?? 'Failed to fetch quality score',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    }
  }

  Future<void> getQualityMco(String? practiceId) async {
    if (practiceId == '-1') {
      _mcoOptions = [];
    } else {
      await _fetchQualityFilter(practiceId, 'mco', (results) {
        _mcoOptions = results;
      });
    }
    update();
  }

  Future<void> getQualityProduct(String? practiceId) async {
    if (practiceId == '-1') {
      _productOptions = [];
    } else {
      await _fetchQualityFilter(practiceId, 'product', (results) {
        _productOptions = results;
      });
    }
    update();
  }

  Future<void> getQualityLob(String? practiceId) async {
    if (practiceId == '-1') {
      _lobOptions = [];
    } else {
      await _fetchQualityFilter(practiceId, 'line_of_business', (results) {
        _lobOptions = results;
      });
    }
    update();
  }

  Future<void> getQualityMeasure(String? practiceId) async {
    if (practiceId == null || practiceId == '-1' || practiceId == 'all') {
      _measureOptions = [];
      return;
    }

    final response = await apiClient.getData(
      '/catalog/app_quality_filters/',
      query: {
        'app_key': AppConstants.appKey,
        'practice_id': practiceId,
        'limit': '100',
        'offset': '0',
        'type': 'measure',
      },
      useApi: true,
    );

    if (response.statusCode == 200) {
      final body = response.body;
      final List<dynamic> results =
          body is List ? body : (body['results'] ?? []);
      _measureOptions = results
          .map((item) => QualityMeasure.fromJson(item as Map<String, dynamic>))
          .toList();
      update();
    } else {
      final message = response.body['detail'];
      Get.snackbar(
        'Error',
        message ?? 'Failed to fetch measure filters',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    }
  }

  Future<void> _fetchQualityFilter(
    String? practiceId,
    String type,
    Function(List<String>) onSuccess,
  ) async {
    if (practiceId == null || practiceId == '-1' || practiceId == 'all') {
      Get.snackbar(
        'Error',
        'Must select a practice',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        icon: const Icon(Icons.error, color: Colors.white),
      );
      return;
    }

    final response = await apiClient.getData(
      '/catalog/app_quality_filters/',
      query: {
        'app_key': AppConstants.appKey,
        'practice_id': practiceId,
        'limit': '100',
        'offset': '0',
        'type': type,
      },
      useApi: true,
    );

    if (response.statusCode == 200) {
      final results = (response.body['results'] as List<dynamic>)
          .map((e) => e.toString())
          .toList();
      onSuccess(results);
    } else {
      final message = response.body['detail'];
      Get.snackbar(
        'Error',
        message ?? 'Failed to fetch $type filters',
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
