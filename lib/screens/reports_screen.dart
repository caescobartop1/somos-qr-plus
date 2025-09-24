import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:somos_qr_plus/controllers/practice_controller.dart';
import 'package:somos_qr_plus/helpers/route_helper.dart';
import 'package:somos_qr_plus/models/provider.dart';
import 'package:somos_qr_plus/models/report_kpi_gic.dart';
import '../widgets/gic_table_widget.dart';
import '../widgets/ra_table_widget.dart';
import '../widgets/appt_table_widget.dart';
import '../widgets/mwov_table_widget.dart';
import '../widgets/siip_table_widget.dart';
import '../widgets/staff_login_table_widget.dart';
import '../widgets/app_header_widget.dart';
import '../widgets/app_drawer_widget.dart';
import '../widgets/provider_dropdown_widget.dart';
import 'package:intl/intl.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  bool _isDrawerOpen = false;
  bool _showLogoutDialog = false;
  Provider _selectedProvider = new Provider(name: 'All', id: '-1');

  // KPI Card Data
  final Map<String, Map<String, dynamic>> _kpiData = {
    'GIC': {
      'timeframe': 'TODAY',
      'date': '07-29-2025',
      'missed': 0,
      'completed': 0,
      'rank': 'RANK 0/0',
      'networkRank': '9 of 2,118 providers',
      'hasNavigation': false,
    },
    'RA': {
      'timeframe': 'TODAY',
      'date': '07-29-2025',
      'missed': 2,
      'completed': 8,
      'rank': 'RANK 3/5',
      'networkRank': '9 of 2,118 providers',
      'hasNavigation': true,
      'timeframes': [
        {
          'name': 'TODAY',
          'date': '07-29-2025',
          'missed': 2,
          'completed': 8,
          'rank': 'RANK 3/5'
        },
        {
          'name': 'LAST 30 DAYS',
          'date': '06-29-2025 to 07-29-2025',
          'missed': 12,
          'completed': 45,
          'rank': 'RANK 1/5'
        },
        {
          'name': 'YTD',
          'date': '01-01-2025 to 07-29-2025',
          'missed': 67,
          'completed': 234,
          'rank': 'RANK 2/5'
        },
      ],
      'currentTimeframeIndex': 0,
    },
    'APPT': {
      'timeframe': 'TODAY',
      'date': '07-29-2025',
      'scheduled': 8,
      'completed': 6,
      'missed': 2,
      'hasNavigation': false,
    },
    'MWOV': {
      'timeframe': 'LAST 30 DAYS',
      'noVisits': 45,
      'withVisits': 23,
      'hasNavigation': true,
      'timeframes': [
        {'name': 'TODAY', 'noVisits': 12, 'withVisits': 8},
        {'name': 'LAST 30 DAYS', 'noVisits': 45, 'withVisits': 23},
      ],
      'currentTimeframeIndex': 1,
    },
    'SIIP': {
      'timeframe': 'TODAY',
      'date': '07-29-2025',
      'completed': 2,
      'open': 3,
      'total': 5,
      'earnings': 20.00,
      'hasNavigation': true,
      'timeframes': [
        {
          'name': 'TODAY',
          'completed': 2,
          'open': 3,
          'total': 5,
          'earnings': 20.00
        },
        {
          'name': 'LAST 30 DAYS',
          'completed': 15,
          'open': 8,
          'total': 23,
          'earnings': 150.00
        },
      ],
      'currentTimeframeIndex': 0,
    },
  };

  final List<Map<String, dynamic>> _staffLogins = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  Future<void> _loadData() async {
    final c = Get.find<PracticeController>();

    await c.getReportKpiGic(_selectedProvider.id);
    await c.getReportKpiRa(_selectedProvider.id);
    await c.getReportKpiAppt(_selectedProvider.id);

    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PracticeController>(builder: (practiceController) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          body: Stack(
            children: [
              // Main Content
              Column(
                children: [
                  AppHeaderWidget(
                    onMenuPressed: () {
                      setState(() {
                        _isDrawerOpen = true;
                      });
                    },
                    onProfileAction: (action) {
                      _handleProfileAction(action);
                    },
                  ),

                  // Provider Dropdown
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom: BorderSide(color: Colors.grey.shade200)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: ProviderDropdownWidget(
                            selectedProvider: _selectedProvider,
                            providers: practiceController.practices,
                            onProviderChanged: (provider) {
                              setState(() {
                                _selectedProvider = provider;
                              });
                              _loadData();
                              _showSuccessMessage(
                                  'Reports updated for $provider');
                            },
                            maxWidth: 300,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      physics:
                          const BouncingScrollPhysics(), // Smooth scrolling for mobile
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width < 600 ? 12 : 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildPageHeader(),
                          SizedBox(
                              height: MediaQuery.of(context).size.width < 600
                                  ? 20
                                  : 32),
                          _buildKPIGrid(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Navigation Drawer
              AppDrawerWidget(
                isOpen: _isDrawerOpen,
                onClose: () {
                  setState(() {
                    _isDrawerOpen = false;
                  });
                },
                onNavigation: (route) {
                  setState(() {
                    _isDrawerOpen = false;
                  });
                  _handleNavigation(route);
                },
                activeRoute: 'reports',
              ),

              // Logout Dialog
              if (_showLogoutDialog) _buildLogoutDialog(),
            ],
          ),
        ),
      );
    });
  }

  void _handleNavigation(String route) {
    switch (route) {
      case 'dashboard':
        Get.offAllNamed(RouteHelper.getDashboardRoute());
        break;
      case 'quality':
        Get.offAllNamed(RouteHelper.getQualityScoreCardsRoute());
        break;
      case 'schedule':
        Get.offAllNamed(RouteHelper.getScheduleRoute());
        break;
      case 'patients':
        Get.offAllNamed(RouteHelper.getPatientsRoute());
        break;
      case 'reports':
        // Already on reports page
        break;
      case 'resources':
        Get.offAllNamed(RouteHelper.getResourcesRoute());
        break;
      case 'settings':
        Get.offAllNamed(RouteHelper.getSettingsRoute());
        break;
      case 'logout':
        setState(() {
          _showLogoutDialog = true;
        });
        break;
    }
  }

  void _handleProfileAction(String action) {
    switch (action) {
      case 'language':
        // Handle language change
        break;
      case 'invitations':
        Get.offAllNamed(RouteHelper.getInvitationsRoute());
        break;
      case 'logout':
        setState(() {
          _showLogoutDialog = true;
        });
        break;
    }
  }

  Widget _buildPageHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive font sizing
        double fontSize = 26; // Default desktop
        if (constraints.maxWidth < 600) {
          fontSize = 18; // Mobile
        } else if (constraints.maxWidth < 900) {
          fontSize = 22; // Tablet
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reports',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF333333),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showGICTableDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding:
              const EdgeInsets.all(8), // Increased padding to prevent overflow
          child: LayoutBuilder(
            builder: (context, constraints) {
              double dialogWidth =
                  constraints.maxWidth * 0.95; // Reduced to prevent overflow
              double dialogHeight =
                  constraints.maxHeight * 0.95; // Use more screen height

              if (constraints.maxWidth > 1200) {
                dialogWidth = 1200; // Reduced max width to prevent overflow
              }

              return Container(
                width: dialogWidth,
                height: dialogHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFf8f9fa),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'GIC Detailed Report',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF333333),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close, size: 24),
                            tooltip: 'Close',
                          ),
                        ],
                      ),
                    ),
                    // Table Content
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16), // Reduced padding
                        child: const GICTableWidget(),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showRATableDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding:
              const EdgeInsets.all(6), // Further reduced padding for more width
          child: LayoutBuilder(
            builder: (context, constraints) {
              double dialogWidth =
                  constraints.maxWidth * 0.99; // Use even more screen width
              double dialogHeight =
                  constraints.maxHeight * 0.95; // Use more screen height

              if (constraints.maxWidth > 1200) {
                dialogWidth =
                    1250; // Slightly increased max width for very large screens
              }

              return Container(
                width: dialogWidth,
                height: dialogHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFf8f9fa),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'RA Detailed Report',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF333333),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close, size: 24),
                            tooltip: 'Close',
                          ),
                        ],
                      ),
                    ),
                    // Table Content
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16), // Reduced padding
                        child: const RATableWidget(),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showAPPTTableDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding:
              const EdgeInsets.all(6), // Further reduced padding for more width
          child: LayoutBuilder(
            builder: (context, constraints) {
              double dialogWidth =
                  constraints.maxWidth * 0.99; // Use even more screen width
              double dialogHeight =
                  constraints.maxHeight * 0.95; // Use more screen height

              if (constraints.maxWidth > 1200) {
                dialogWidth =
                    1250; // Slightly increased max width for very large screens
              }

              return Container(
                width: dialogWidth,
                height: dialogHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFf8f9fa),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'APPT Detailed Report',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF333333),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close, size: 24),
                            tooltip: 'Close',
                          ),
                        ],
                      ),
                    ),
                    // Table Content
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16), // Reduced padding
                        child: const APPTTableWidget(),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showMWOVTableDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding:
              const EdgeInsets.all(6), // Further reduced padding for more width
          child: LayoutBuilder(
            builder: (context, constraints) {
              double dialogWidth =
                  constraints.maxWidth * 0.99; // Use even more screen width
              double dialogHeight =
                  constraints.maxHeight * 0.95; // Use more screen height

              if (constraints.maxWidth > 1200) {
                dialogWidth =
                    1250; // Slightly increased max width for very large screens
              }

              return Container(
                width: dialogWidth,
                height: dialogHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFf8f9fa),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'MWOV\'s Detailed Report',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF333333),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close, size: 24),
                            tooltip: 'Close',
                          ),
                        ],
                      ),
                    ),
                    // Table Content
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16), // Reduced padding
                        child: const MWOVTableWidget(),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showSIIPTableDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding:
              const EdgeInsets.all(6), // Further reduced padding for more width
          child: LayoutBuilder(
            builder: (context, constraints) {
              double dialogWidth =
                  constraints.maxWidth * 0.99; // Use even more screen width
              double dialogHeight =
                  constraints.maxHeight * 0.95; // Use more screen height

              if (constraints.maxWidth > 1200) {
                dialogWidth =
                    1250; // Slightly increased max width for very large screens
              }

              return Container(
                width: dialogWidth,
                height: dialogHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFf8f9fa),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'SIIP Detailed Report',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF333333),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close, size: 24),
                            tooltip: 'Close',
                          ),
                        ],
                      ),
                    ),
                    // Table Content
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16), // Reduced padding
                        child: const SIIPTableWidget(),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showStaffLoginTableDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding:
              const EdgeInsets.all(6), // Further reduced padding for more width
          child: LayoutBuilder(
            builder: (context, constraints) {
              double dialogWidth =
                  constraints.maxWidth * 0.99; // Use even more screen width
              double dialogHeight =
                  constraints.maxHeight * 0.95; // Use more screen height

              if (constraints.maxWidth > 1200) {
                dialogWidth =
                    1250; // Slightly increased max width for very large screens
              }

              return Container(
                width: dialogWidth,
                height: dialogHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFf8f9fa),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Staff Login Detailed Report',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF333333),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close, size: 24),
                            tooltip: 'Close',
                          ),
                        ],
                      ),
                    ),
                    // Table Content
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16), // Reduced padding
                        child: const StaffLoginTableWidget(),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildKPIGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive grid based on screen width
        int crossAxisCount;
        double childAspectRatio;
        double spacing;

        if (constraints.maxWidth < 600) {
          // Mobile phones - 1 column
          crossAxisCount = 1;
          childAspectRatio = 1.2; // Taller cards for mobile to show button
          spacing = 12; // Reduced spacing for mobile
        } else if (constraints.maxWidth < 900) {
          // Tablets - 2 columns
          crossAxisCount = 2;
          childAspectRatio = 1.0; // Taller cards for tablets to show button
          spacing = 16;
        } else {
          // Desktop - 3 columns
          crossAxisCount = 3;
          childAspectRatio = 0.9; // Taller cards for desktop to show button
          spacing = 20;
        }

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          childAspectRatio: childAspectRatio,
          children: [
            _buildGICCard(),
            _buildRACard(),
            _buildAPPTCard(),
            _buildMWOVCard(),
            // _buildSIIPCard(),
            _buildStaffLoginCard(),
          ],
        );
      },
    );
  }

  Widget _buildGICCard() {
    final c = Get.find<PracticeController>();
    final data = c.reportKpiGic;
    if (data == null) return const SizedBox.shrink();

    final String formatted = DateFormat('MM-dd-yyyy').format(data.todayDate);

    return _buildKPICard(
      title: 'GIC',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildKPIHeader(
              'GIC', 'Today' as String?, formatted as String?, false, null),
          const SizedBox(height: 4),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildKPIMetrics([
                    {
                      'label': 'Missed',
                      'value': data.todayMessedWoa,
                      'type': 'missed'
                    },
                    {
                      'label': 'Completed',
                      'value': data.todayCompletedWa,
                      'type': 'completed'
                    },
                  ]),
                  const SizedBox(height: 2),
                  _buildKPIRank(
                      data.todayRank.toString() +
                              '/' +
                              data.todayRankOf.toString() as String? ??
                          'RANK 0/0',
                      '' as String? ?? ''),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _showGICTableDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1976D2),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Text(
                        'View Reports',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRACard() {
    final c = Get.find<PracticeController>();
    final data = c.reportKpiRa;
    final dataTime = _kpiData['RA'];
    if (data == null) return const SizedBox.shrink();

    final String formatted = DateFormat('MM-dd-yyyy').format(data.todayDate);
    // LAST 30 DAYS
    return _buildKPICard(
      title: 'RA',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildKPIHeader(
              'RA', dataTime?['timeframe'], formatted as String?, true, data),
          const SizedBox(height: 4),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildKPIMetrics([
                    {
                      'label': 'Missed',
                      'value': data.todayMessedWoa,
                      'type': 'missed'
                    },
                    {
                      'label': 'Completed',
                      'value': data.todayCompletedWa,
                      'type': 'completed'
                    },
                  ]),
                  const SizedBox(height: 2),
                  _buildKPIRank(
                      data.todayRank.toString() +
                              '/' +
                              data.todayRankOf.toString() as String? ??
                          'RANK 0/0',
                      '' as String? ?? ''),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _showRATableDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1976D2),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Text(
                        'View Reports',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAPPTCard() {
    final c = Get.find<PracticeController>();
    final ReportKpiGic? appt = c.reportKpiAPPT;

    if (appt == null) return const SizedBox.shrink();

    return _buildKPICard(
      title: 'APPT',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Header (usa las fechas de lastMonth como timeframe de ejemplo)
          _buildKPIHeader(
              'APPT',
              // timeframe: mes anterior
              '${DateFormat('MM/dd').format(appt.lmonthBegin)} - '
                  '${DateFormat('MM/dd').format(appt.lmonthEnd)}',
              // fecha de hoy
              DateFormat('MM/dd/yyyy').format(appt.todayDate),
              true,
              appt),
          const SizedBox(height: 4),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildKPIMetrics([
                    {
                      'label': 'Scheduled',
                      // aquí puedes mapear a la métrica que uses
                      'value': appt.todayStar,
                      'type': 'scheduled',
                    },
                    {
                      'label': 'Completed',
                      'value': appt.todayCompletedWa,
                      'type': 'completed',
                    },
                    {
                      'label': 'Missed',
                      'value': appt.todayMessedWoa,
                      'type': 'missed',
                    },
                  ]),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _showAPPTTableDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1976D2),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Text(
                        'View Reports',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMWOVCard() {
    final data = _kpiData['MWOV'];
    if (data == null) return const SizedBox.shrink();

    return _buildKPICard(
      title: 'MWOV\'s',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildKPIHeader(
              'MWOV\'s', data['timeframe'] as String?, null, true, null),
          const SizedBox(height: 4),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Center(
                    child: _buildPieChart(
                        data['noVisits'] ?? 0, data['withVisits'] ?? 0),
                  ),
                  const SizedBox(height: 16),
                  _buildMWOVLegend(
                      data['noVisits'] ?? 0, data['withVisits'] ?? 0),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _showMWOVTableDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1976D2),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Text(
                        'View Reports',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSIIPCard() {
    final data = _kpiData['SIIP'];
    if (data == null) return const SizedBox.shrink();

    return _buildKPICard(
      title: 'SIIP',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildKPIHeader('SIIP', data['timeframe'] as String?,
              data['date'] as String?, true, null),
          const SizedBox(height: 4),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildKPIMetrics([
                    {
                      'label': 'Completed',
                      'value': data['completed'] ?? 0,
                      'type': 'completed'
                    },
                    {
                      'label': 'Open',
                      'value': data['open'] ?? 0,
                      'type': 'missed'
                    },
                  ]),
                  const SizedBox(height: 2),
                  _buildKPISummary(data['total'] ?? 0, data['earnings'] ?? 0.0),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _showSIIPTableDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1976D2),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Text(
                        'View Reports',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaffLoginCard() {
    return _buildKPICard(
      title: 'STAFF LOGIN',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LAST 4 LOGINS',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLoginActivityList(),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _showStaffLoginTableDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1976D2),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Text(
                        'View Reports',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKPICard({
    required String title,
    required Widget child,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive padding based on card width
        double padding;
        if (constraints.maxWidth < 300) {
          padding = 12; // Mobile
        } else if (constraints.maxWidth < 500) {
          padding = 16; // Tablet
        } else {
          padding = 20; // Desktop
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.grey.shade300,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: child,
          ),
        );
      },
    );
  }

  Widget _buildKPIHeader(String title, String? timeframe, String? date,
      bool hasNavigation, ReportKpiGic? data) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive font sizes based on available width
        double titleSize, timeframeSize, dateSize;
        if (constraints.maxWidth < 300) {
          titleSize = 14;
          timeframeSize = 10;
          dateSize = 10;
        } else if (constraints.maxWidth < 500) {
          titleSize = 16;
          timeframeSize = 11;
          dateSize = 11;
        } else {
          titleSize = 18;
          timeframeSize = 12;
          dateSize = 12;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF333333),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (hasNavigation) _buildTimeframeNavigation(title, data),
              ],
            ),
            if (timeframe != null) ...[
              const SizedBox(height: 4),
              Text(
                timeframe,
                style: TextStyle(
                  fontSize: timeframeSize,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF666666),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (date != null) ...[
              const SizedBox(height: 2),
              Text(
                date,
                style: TextStyle(
                  fontSize: dateSize,
                  color: const Color(0xFF999999),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildTimeframeNavigation(String kpiType, ReportKpiGic? data) {
    print(data);
    if (data == null) return const SizedBox.shrink();

    final currentIndex = 0;
    final timeframes = [
          {
            'name': 'TODAY',
          },
          {
            'name': 'LAST 30 DAYS',
          },
        ] as List<Map<String, dynamic>>? ??
        [];
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive sizing based on available width
        double iconSize, fontSize;
        if (constraints.maxWidth < 300) {
          iconSize = 16;
          fontSize = 10;
        } else if (constraints.maxWidth < 500) {
          iconSize = 18;
          fontSize = 11;
        } else {
          iconSize = 20;
          fontSize = 12;
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: currentIndex > 0
                  ? () => _updateTimeframe(kpiType, currentIndex - 1)
                  : null,
              icon: Icon(
                Icons.chevron_left,
                color: currentIndex > 0
                    ? Colors.grey.shade600
                    : Colors.grey.shade300,
              ),
              iconSize: iconSize,
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(
                minWidth: iconSize + 8,
                minHeight: iconSize + 8,
              ),
            ),
            Flexible(
              child: Text(
                timeframes.isNotEmpty ? timeframes[currentIndex]['name'] : '',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF666666),
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            IconButton(
              onPressed: currentIndex < timeframes.length - 1
                  ? () => _updateTimeframe(kpiType, currentIndex + 1)
                  : null,
              icon: Icon(
                Icons.chevron_right,
                color: currentIndex < timeframes.length - 1
                    ? Colors.grey.shade600
                    : Colors.grey.shade300,
              ),
              iconSize: iconSize,
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(
                minWidth: iconSize + 8,
                minHeight: iconSize + 8,
              ),
            ),
          ],
        );
      },
    );
  }

  void _updateTimeframe(String kpiType, int newIndex) {
    setState(() {
      final kpiData = _kpiData[kpiType];
      if (kpiData == null) return;

      kpiData['currentTimeframeIndex'] = newIndex;
      final timeframes = kpiData['timeframes'] as List<Map<String, dynamic>>?;
      if (timeframes == null || newIndex >= timeframes.length) return;

      final timeframe = timeframes[newIndex];

      // Update the displayed data
      if (kpiType == 'RA') {
        kpiData['missed'] = timeframe['missed'] ?? 0;
        kpiData['completed'] = timeframe['completed'] ?? 0;
        kpiData['rank'] = timeframe['rank'] ?? 'RANK 0/0';
      } else if (kpiType == 'MWOV') {
        kpiData['noVisits'] = timeframe['noVisits'] ?? 0;
        kpiData['withVisits'] = timeframe['withVisits'] ?? 0;
      } else if (kpiType == 'SIIP') {
        kpiData['completed'] = timeframe['completed'] ?? 0;
        kpiData['open'] = timeframe['open'] ?? 0;
        kpiData['total'] = timeframe['total'] ?? 0;
        kpiData['earnings'] = timeframe['earnings'] ?? 0.0;
      }
    });
  }

  Widget _buildKPIMetrics(List<Map<String, dynamic>> metrics) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive sizing based on available width
        double horizontalPadding, verticalPadding, labelSize, valueSize, margin;
        if (constraints.maxWidth < 300) {
          horizontalPadding = 6;
          verticalPadding = 4;
          labelSize = 11;
          valueSize = 14;
          margin = 3;
        } else if (constraints.maxWidth < 500) {
          horizontalPadding = 8;
          verticalPadding = 5;
          labelSize = 12;
          valueSize = 15;
          margin = 4;
        } else {
          horizontalPadding = 10;
          verticalPadding = 6;
          labelSize = 13;
          valueSize = 16;
          margin = 5;
        }

        return Column(
          children: metrics.map((metric) {
            final type = metric['type'] as String;
            final label = metric['label'] as String;
            final value = metric['value'] as int;

            Color backgroundColor;
            Color borderColor;

            switch (type) {
              case 'missed':
                backgroundColor = const Color(0xFFE3F2FD);
                borderColor = const Color(0xFFBBDEFB);
                break;
              case 'completed':
                backgroundColor = const Color(0xFFE8F5E8);
                borderColor = const Color(0xFFC8E6C9);
                break;
              case 'scheduled':
                backgroundColor = const Color(0xFFF3E5F5);
                borderColor = const Color(0xFFE1BEE7);
                break;
              default:
                backgroundColor = const Color(0xFFF5F5F5);
                borderColor = const Color(0xFFE0E0E0);
            }

            return Container(
              margin: EdgeInsets.only(bottom: margin),
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              decoration: BoxDecoration(
                color: backgroundColor,
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: labelSize,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF333333),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    value.toString(),
                    style: TextStyle(
                      fontSize: valueSize,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF333333),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildKPIRank(String rank, String networkRank) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double rankSize, starSize, networkSize, spacing;
        if (constraints.maxWidth < 300) {
          rankSize = 9;
          starSize = 8;
          networkSize = 8;
          spacing = 1;
        } else if (constraints.maxWidth < 500) {
          rankSize = 10;
          starSize = 9;
          networkSize = 9;
          spacing = 2;
        } else {
          rankSize = 11;
          starSize = 10;
          networkSize = 10;
          spacing = 3;
        }

        return Column(
          children: [
            Text(
              rank,
              style: TextStyle(
                fontSize: rankSize,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF666666),
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  5,
                  (index) => Icon(
                        Icons.star,
                        color: const Color(0xFFFFD700),
                        size: starSize,
                      )),
            ),
            SizedBox(height: spacing),
            Text(
              networkRank,
              style: TextStyle(
                fontSize: networkSize,
                color: const Color(0xFF999999),
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      },
    );
  }

  Widget _buildKPISummary(int total, double earnings) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double fontSize, padding, spacing;
        if (constraints.maxWidth < 300) {
          fontSize = 12;
          padding = 12;
          spacing = 3;
        } else if (constraints.maxWidth < 500) {
          fontSize = 13;
          padding = 14;
          spacing = 4;
        } else {
          fontSize = 14;
          padding = 16;
          spacing = 4;
        }

        return Container(
          padding: EdgeInsets.only(top: padding),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          child: Column(
            children: [
              Text(
                'Total: $total appointments',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF666666),
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: spacing),
              Text(
                'Earnings: \$$earnings.toStringAsFixed(2)',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF666666),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPieChart(int noVisits, int withVisits) {
    final total = noVisits + withVisits;
    final noVisitsPercentage = total > 0 ? (noVisits / total * 100).round() : 0;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive sizing based on available width
        double chartSize, centerSpaceRadius, fontSize;
        if (constraints.maxWidth < 300) {
          chartSize = 65;
          centerSpaceRadius = 20;
          fontSize = 12;
        } else if (constraints.maxWidth < 500) {
          chartSize = 80;
          centerSpaceRadius = 25;
          fontSize = 14;
        } else {
          chartSize = 95;
          centerSpaceRadius = 30;
          fontSize = 16;
        }

        return Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: chartSize,
                height: chartSize,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: noVisits.toDouble(),
                        color: const Color(0xFF2196F3),
                        radius: chartSize / 2,
                        title: '$noVisits',
                        titleStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      PieChartSectionData(
                        value: withVisits.toDouble(),
                        color: const Color(0xFF4CAF50),
                        radius: chartSize / 2,
                        title: '$withVisits',
                        titleStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                    centerSpaceRadius: centerSpaceRadius,
                    sectionsSpace: 2,
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        if (event is FlTapDownEvent &&
                            pieTouchResponse != null) {
                          final section = pieTouchResponse.touchedSection;
                          if (section != null) {
                            final sectionIndex = section.touchedSectionIndex;
                            final sectionName =
                                sectionIndex == 0 ? 'No Visits' : 'With Visits';
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(sectionName),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$noVisitsPercentage%',
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF333333),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMWOVLegend(int noVisits, int withVisits) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive sizing based on available width
        double fontSize, spacing, colorSize;
        if (constraints.maxWidth < 300) {
          fontSize = 10;
          spacing = 8;
          colorSize = 10;
        } else if (constraints.maxWidth < 500) {
          fontSize = 11;
          spacing = 10;
          colorSize = 11;
        } else {
          fontSize = 12;
          spacing = 12;
          colorSize = 12;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Descriptive labels
            Text(
              'No Visits: $noVisits patients',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF333333),
              ),
            ),
            SizedBox(height: spacing / 2),
            Text(
              'With Visits: $withVisits patients',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF333333),
              ),
            ),
            SizedBox(height: spacing),
            // Color guide
            Row(
              children: [
                Container(
                  width: colorSize,
                  height: colorSize,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2196F3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(width: spacing / 2),
                Text(
                  'No Visits',
                  style: TextStyle(
                    fontSize: fontSize - 1,
                    color: const Color(0xFF666666),
                  ),
                ),
                SizedBox(width: spacing),
                Container(
                  width: colorSize,
                  height: colorSize,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(width: spacing / 2),
                Text(
                  'With Visits',
                  style: TextStyle(
                    fontSize: fontSize - 1,
                    color: const Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildLegendItem(String text, Color color) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive sizing based on available width
        double colorSize, fontSize, spacing;
        if (constraints.maxWidth < 300) {
          colorSize = 10;
          fontSize = 10;
          spacing = 6;
        } else if (constraints.maxWidth < 500) {
          colorSize = 11;
          fontSize = 11;
          spacing = 7;
        } else {
          colorSize = 12;
          fontSize = 12;
          spacing = 8;
        }

        return Row(
          children: [
            Container(
              width: colorSize,
              height: colorSize,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: fontSize,
                  color: const Color(0xFF666666),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoginActivityList() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive sizing based on available width
        double avatarSize, fontSize, nameSize, statusFontSize, margin, spacing;
        if (constraints.maxWidth < 300) {
          avatarSize = 28;
          fontSize = 10;
          nameSize = 12;
          statusFontSize = 9;
          margin = 8;
          spacing = 8;
        } else if (constraints.maxWidth < 500) {
          avatarSize = 30;
          fontSize = 11;
          nameSize = 13;
          statusFontSize = 10;
          margin = 10;
          spacing = 10;
        } else {
          avatarSize = 32;
          fontSize = 12;
          nameSize = 14;
          statusFontSize = 10;
          margin = 12;
          spacing = 12;
        }

        return Column(
          children: _staffLogins.map((login) {
            final status = login['status'] as String;
            Color statusColor;

            switch (status) {
              case 'Active':
                statusColor = const Color(0xFF4CAF50);
                break;
              case 'Online':
                statusColor = const Color(0xFF2196F3);
                break;
              case 'Offline':
                statusColor = const Color(0xFF9E9E9E);
                break;
              default:
                statusColor = const Color(0xFF9E9E9E);
            }

            return Container(
              margin: EdgeInsets.only(bottom: margin),
              child: Row(
                children: [
                  Container(
                    width: avatarSize,
                    height: avatarSize,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(avatarSize / 2),
                    ),
                    child: Center(
                      child: Text(
                        login['initials'],
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: fontSize,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: spacing),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          login['name'],
                          style: TextStyle(
                            fontSize: nameSize,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF333333),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          login['time'],
                          style: TextStyle(
                            fontSize: fontSize,
                            color: const Color(0xFF666666),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: spacing / 2,
                      vertical: spacing / 3,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: statusColor.withOpacity(0.3)),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: statusFontSize,
                        fontWeight: FontWeight.w500,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildLogoutDialog() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          width: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE74C3C).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.logout,
                        color: Color(0xFFE74C3C),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Log Out',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
              ),

              // Body
              Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Text(
                      'Are you sure you want to log out of your account?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF333333),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You\'ll need to sign in again to access your dashboard.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Footer
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () =>
                            setState(() => _showLogoutDialog = false),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle logout
                          setState(() => _showLogoutDialog = false);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE74C3C),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Log Out',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
