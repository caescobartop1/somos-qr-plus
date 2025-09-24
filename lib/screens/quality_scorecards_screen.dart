import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:somos_qr_plus/controllers/auth_controller.dart';
import 'package:somos_qr_plus/controllers/practice_controller.dart';
import 'package:somos_qr_plus/helpers/route_helper.dart';
import 'package:somos_qr_plus/models/provider.dart';
import '../widgets/app_header_widget.dart';
import '../widgets/app_drawer_widget.dart';
import '../widgets/provider_dropdown_widget.dart';

class QualityScorecardsScreen extends StatefulWidget {
  const QualityScorecardsScreen({super.key});

  @override
  State<QualityScorecardsScreen> createState() =>
      _QualityScorecardsScreenState();
}

class _QualityScorecardsScreenState extends State<QualityScorecardsScreen> {
  bool _isDrawerOpen = false;
  Provider _selectedProvider = new Provider(name: 'All', id: '-1');
  int _currentPage = 0;
  int _rowsPerPage = 20;
  bool _showLogoutDialog = false;

  final List<Map<String, dynamic>> _qualityMetrics = [
    {
      'measure': 'COA-PA',
      'closed': ['123', '456', '789'],
      'benchmarks': ['50%', '75%', '90%'],
      'hitsNeeded': ['10', '20', '30'],
    },
    {
      'measure': 'CCS',
      'closed': ['234', '567', '890'],
      'benchmarks': ['55%', '80%', '95%'],
      'hitsNeeded': ['15', '25', '35'],
    },
    {
      'measure': 'CAW',
      'closed': ['345', '678', '901'],
      'benchmarks': ['60%', '85%', '92%'],
      'hitsNeeded': ['12', '22', '32'],
    },
    {
      'measure': 'CIS-3',
      'closed': ['456', '789', '012'],
      'benchmarks': ['65%', '88%', '94%'],
      'hitsNeeded': ['18', '28', '38'],
    },
    {
      'measure': 'CRC',
      'closed': ['567', '890', '123'],
      'benchmarks': ['70%', '90%', '96%'],
      'hitsNeeded': ['14', '24', '34'],
    },
    {
      'measure': 'CDC-EE',
      'closed': ['678', '901', '234'],
      'benchmarks': ['75%', '92%', '98%'],
      'hitsNeeded': ['16', '26', '36'],
    },
    {
      'measure': 'CDC-HbA1c',
      'closed': ['789', '012', '345'],
      'benchmarks': ['80%', '94%', '99%'],
      'hitsNeeded': ['13', '23', '33'],
    },
    {
      'measure': 'CHBP',
      'closed': ['890', '123', '456'],
      'benchmarks': ['85%', '96%', '100%'],
      'hitsNeeded': ['17', '27', '37'],
    },
    {
      'measure': 'FUA-7',
      'closed': ['901', '234', '567'],
      'benchmarks': ['90%', '98%', '100%'],
      'hitsNeeded': ['11', '21', '31'],
    },
    {
      'measure': 'MAC',
      'closed': ['012', '345', '678'],
      'benchmarks': ['95%', '99%', '100%'],
      'hitsNeeded': ['19', '29', '39'],
    },
    {
      'measure': 'MAH',
      'closed': ['123', '456', '789'],
      'benchmarks': ['100%', '100%', '100%'],
      'hitsNeeded': ['0', '0', '0'],
    },
    {
      'measure': 'MAD',
      'closed': ['234', '567', '890'],
      'benchmarks': ['45%', '70%', '85%'],
      'hitsNeeded': ['25', '40', '55'],
    },
    {
      'measure': 'OMF',
      'closed': ['345', '678', '901'],
      'benchmarks': ['40%', '65%', '80%'],
      'hitsNeeded': ['30', '45', '60'],
    },
    {
      'measure': 'PPC-PP',
      'closed': ['456', '789', '012'],
      'benchmarks': ['35%', '60%', '75%'],
      'hitsNeeded': ['35', '50', '65'],
    },
    {
      'measure': 'ST-DM',
      'closed': ['567', '890', '123'],
      'benchmarks': ['30%', '55%', '70%'],
      'hitsNeeded': ['40', '55', '70'],
    },
    {
      'measure': 'TOC-MR',
      'closed': ['678', '901', '234'],
      'benchmarks': ['25%', '50%', '65%'],
      'hitsNeeded': ['45', '60', '75'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PracticeController>(builder: (practiceController) {
      return SafeArea(
        child: Stack(
          children: [
            Scaffold(
              backgroundColor: const Color(0xFFF5F5F5),
              body: Column(
                children: [
                  // Header
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
                              _showSuccessMessage(
                                  'Quality scorecards updated for $provider');
                            },
                            maxWidth: 300,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Main Content
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isMobile = constraints.maxWidth < 600;
                        return SingleChildScrollView(
                          padding: EdgeInsets.all(isMobile ? 16 : 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Page Title
                              Padding(
                                padding:
                                    EdgeInsets.only(bottom: isMobile ? 16 : 20),
                                child: const Text(
                                  'Quality Score Cards',
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF333333),
                                  ),
                                ),
                              ),

                              // Score Cards Table
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey[300]!),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 3,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    // Table
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: DataTable(
                                        headingRowHeight: isMobile ? 80 : 100,
                                        dataRowHeight: isMobile ? 45 : 50,
                                        columnSpacing: 0,
                                        border: TableBorder.all(
                                          color: Colors.grey[300]!,
                                          width: 1,
                                        ),
                                        columns: [
                                          // Measures Column
                                          DataColumn(
                                            label: Container(
                                              width: isMobile ? 100 : 120,
                                              padding: EdgeInsets.all(
                                                  isMobile ? 12 : 16),
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFF8F9FA),
                                              ),
                                              child: Text(
                                                'Measures',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      const Color(0xFF333333),
                                                  fontSize: isMobile ? 12 : 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Closed Section
                                          ...List.generate(
                                              3,
                                              (index) => DataColumn(
                                                    label: Container(
                                                      width: isMobile ? 70 : 80,
                                                      padding: EdgeInsets.all(
                                                          isMobile ? 6 : 8),
                                                      decoration:
                                                          const BoxDecoration(
                                                        color:
                                                            Color(0xFFE8F5E8),
                                                      ),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            'Closed',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: const Color(
                                                                  0xFF333333),
                                                              fontSize: isMobile
                                                                  ? 12
                                                                  : 14,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          const SizedBox(
                                                              height: 4),
                                                          Text(
                                                            index == 0
                                                                ? 'MCO'
                                                                : index == 1
                                                                    ? 'CLAIM'
                                                                    : 'EHR*',
                                                            style: TextStyle(
                                                              fontSize: isMobile
                                                                  ? 10
                                                                  : 12,
                                                              color: Colors
                                                                  .grey[600],
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                          // Benchmarks Section
                                          ...List.generate(
                                              3,
                                              (index) => DataColumn(
                                                    label: Container(
                                                      width:
                                                          isMobile ? 90 : 100,
                                                      padding: EdgeInsets.all(
                                                          isMobile ? 6 : 8),
                                                      decoration:
                                                          const BoxDecoration(
                                                        color:
                                                            Color(0xFFF0F8F0),
                                                      ),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            'Benchmarks',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: const Color(
                                                                  0xFF333333),
                                                              fontSize: isMobile
                                                                  ? 12
                                                                  : 14,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          const SizedBox(
                                                              height: 4),
                                                          Text(
                                                            index == 0
                                                                ? '50TH/3 START'
                                                                : index == 1
                                                                    ? '75TH/4 START'
                                                                    : '90TH/5STAR',
                                                            style: TextStyle(
                                                              fontSize: isMobile
                                                                  ? 9
                                                                  : 11,
                                                              color: Colors
                                                                  .grey[600],
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .visible,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                          // Hits Needed Section
                                          ...List.generate(
                                              3,
                                              (index) => DataColumn(
                                                    label: Container(
                                                      width:
                                                          isMobile ? 90 : 100,
                                                      padding: EdgeInsets.all(
                                                          isMobile ? 6 : 8),
                                                      decoration:
                                                          const BoxDecoration(
                                                        color:
                                                            Color(0xFFF8F9FA),
                                                      ),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            'Hits Needed',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: const Color(
                                                                  0xFF333333),
                                                              fontSize: isMobile
                                                                  ? 12
                                                                  : 14,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          const SizedBox(
                                                              height: 4),
                                                          Text(
                                                            index == 0
                                                                ? '50TH/3 START'
                                                                : index == 1
                                                                    ? '75TH/4 START'
                                                                    : '90TH/5STAR',
                                                            style: TextStyle(
                                                              fontSize: isMobile
                                                                  ? 9
                                                                  : 11,
                                                              color: Colors
                                                                  .grey[600],
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .visible,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                        ],
                                        rows: _getCurrentPageRows(),
                                      ),
                                    ),

                                    // Pagination
                                    Container(
                                      padding:
                                          EdgeInsets.all(isMobile ? 12 : 16),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF8F9FA),
                                        border: Border(
                                          top: BorderSide(
                                              color: Colors.grey[300]!),
                                        ),
                                      ),
                                      child: isMobile
                                          ? Column(
                                              children: [
                                                // Mobile: Stack rows per page and info
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Rows per page:',
                                                          style: TextStyle(
                                                            fontSize: isMobile
                                                                ? 12
                                                                : 14,
                                                            color: const Color(
                                                                0xFF666666),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 8),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 4),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                            border: Border.all(
                                                                color:
                                                                    Colors.grey[
                                                                        300]!),
                                                          ),
                                                          child:
                                                              DropdownButtonHideUnderline(
                                                            child:
                                                                DropdownButton<
                                                                    int>(
                                                              value:
                                                                  _rowsPerPage,
                                                              style: TextStyle(
                                                                fontSize:
                                                                    isMobile
                                                                        ? 12
                                                                        : 14,
                                                                color: const Color(
                                                                    0xFF333333),
                                                              ),
                                                              items: const [
                                                                DropdownMenuItem(
                                                                    value: 20,
                                                                    child: Text(
                                                                        '20')),
                                                                DropdownMenuItem(
                                                                    value: 40,
                                                                    child: Text(
                                                                        '40')),
                                                                DropdownMenuItem(
                                                                    value: 60,
                                                                    child: Text(
                                                                        '60')),
                                                                DropdownMenuItem(
                                                                    value: 80,
                                                                    child: Text(
                                                                        '80')),
                                                                DropdownMenuItem(
                                                                    value: 100,
                                                                    child: Text(
                                                                        '100')),
                                                              ],
                                                              onChanged: (int?
                                                                  newValue) {
                                                                if (newValue !=
                                                                    null) {
                                                                  setState(() {
                                                                    _rowsPerPage =
                                                                        newValue;
                                                                    _currentPage =
                                                                        0;
                                                                  });
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      _getPageInfo(),
                                                      style: TextStyle(
                                                        fontSize:
                                                            isMobile ? 12 : 14,
                                                        color: const Color(
                                                            0xFF666666),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 12),
                                                // Mobile: Center pagination buttons
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    _buildPaginationButton(
                                                        '⏮️',
                                                        _currentPage == 0,
                                                        () => _goToFirstPage()),
                                                    const SizedBox(width: 4),
                                                    _buildPaginationButton(
                                                        '◀',
                                                        _currentPage == 0,
                                                        () =>
                                                            _goToPreviousPage()),
                                                    const SizedBox(width: 4),
                                                    _buildPaginationButton(
                                                        '▶',
                                                        _currentPage >=
                                                            _getTotalPages() -
                                                                1,
                                                        () => _goToNextPage()),
                                                    const SizedBox(width: 4),
                                                    _buildPaginationButton(
                                                        '⏭️',
                                                        _currentPage >=
                                                            _getTotalPages() -
                                                                1,
                                                        () => _goToLastPage()),
                                                  ],
                                                ),
                                              ],
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                // Desktop: Left side - Rows per page and info
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Rows per page:',
                                                      style: TextStyle(
                                                        fontSize:
                                                            isMobile ? 12 : 14,
                                                        color: const Color(
                                                            0xFF666666),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8,
                                                          vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                        border: Border.all(
                                                            color: Colors
                                                                .grey[300]!),
                                                      ),
                                                      child:
                                                          DropdownButtonHideUnderline(
                                                        child:
                                                            DropdownButton<int>(
                                                          value: _rowsPerPage,
                                                          style: TextStyle(
                                                            fontSize: isMobile
                                                                ? 12
                                                                : 14,
                                                            color: const Color(
                                                                0xFF333333),
                                                          ),
                                                          items: const [
                                                            DropdownMenuItem(
                                                                value: 20,
                                                                child:
                                                                    Text('20')),
                                                            DropdownMenuItem(
                                                                value: 40,
                                                                child:
                                                                    Text('40')),
                                                            DropdownMenuItem(
                                                                value: 60,
                                                                child:
                                                                    Text('60')),
                                                            DropdownMenuItem(
                                                                value: 80,
                                                                child:
                                                                    Text('80')),
                                                            DropdownMenuItem(
                                                                value: 100,
                                                                child: Text(
                                                                    '100')),
                                                          ],
                                                          onChanged:
                                                              (int? newValue) {
                                                            if (newValue !=
                                                                null) {
                                                              setState(() {
                                                                _rowsPerPage =
                                                                    newValue;
                                                                _currentPage =
                                                                    0;
                                                              });
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 32),
                                                    Text(
                                                      _getPageInfo(),
                                                      style: TextStyle(
                                                        fontSize:
                                                            isMobile ? 12 : 14,
                                                        color: const Color(
                                                            0xFF666666),
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                // Desktop: Right side - Pagination buttons
                                                Row(
                                                  children: [
                                                    _buildPaginationButton(
                                                        '⏮️',
                                                        _currentPage == 0,
                                                        () => _goToFirstPage()),
                                                    const SizedBox(width: 4),
                                                    _buildPaginationButton(
                                                        '◀',
                                                        _currentPage == 0,
                                                        () =>
                                                            _goToPreviousPage()),
                                                    const SizedBox(width: 4),
                                                    _buildPaginationButton(
                                                        '▶',
                                                        _currentPage >=
                                                            _getTotalPages() -
                                                                1,
                                                        () => _goToNextPage()),
                                                    const SizedBox(width: 4),
                                                    _buildPaginationButton(
                                                        '⏭️',
                                                        _currentPage >=
                                                            _getTotalPages() -
                                                                1,
                                                        () => _goToLastPage()),
                                                  ],
                                                ),
                                              ],
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
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
              activeRoute: 'quality',
            ),
            if (_showLogoutDialog) _buildLogoutDialog(),
          ],
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
        // Already on quality page
        break;
      case 'schedule':
        Get.offAllNamed(RouteHelper.getScheduleRoute());
        break;
      case 'patients':
        Get.offAllNamed(RouteHelper.getPatientsRoute());
        break;
      case 'reports':
        Get.offAllNamed(RouteHelper.getReportsRoute());
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Language clicked')),
        );
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

  List<DataRow> _getCurrentPageRows() {
    final startIndex = _currentPage * _rowsPerPage;
    final endIndex =
        (startIndex + _rowsPerPage).clamp(0, _qualityMetrics.length);

    return _qualityMetrics
        .sublist(startIndex, endIndex)
        .map((metric) => _buildDataRow(
              metric['measure'],
              metric['closed'],
              metric['benchmarks'],
              metric['hitsNeeded'],
            ))
        .toList();
  }

  int _getTotalPages() {
    return (_qualityMetrics.length / _rowsPerPage).ceil();
  }

  String _getPageInfo() {
    final startIndex = _currentPage * _rowsPerPage + 1;
    final endIndex =
        ((_currentPage + 1) * _rowsPerPage).clamp(0, _qualityMetrics.length);
    return '$startIndex-$endIndex of ${_qualityMetrics.length}';
  }

  void _goToFirstPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage = 0;
      });
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
    }
  }

  void _goToNextPage() {
    if (_currentPage < _getTotalPages() - 1) {
      setState(() {
        _currentPage++;
      });
    }
  }

  void _goToLastPage() {
    final totalPages = _getTotalPages();
    if (_currentPage < totalPages - 1) {
      setState(() {
        _currentPage = totalPages - 1;
      });
    }
  }

  Widget _buildPaginationButton(
      String icon, bool isDisabled, VoidCallback onPressed) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : onPressed,
          borderRadius: BorderRadius.circular(4),
          child: Center(
            child: Text(
              icon,
              style: TextStyle(
                fontSize: 14,
                color: isDisabled ? Colors.grey[400] : const Color(0xFF333333),
              ),
            ),
          ),
        ),
      ),
    );
  }

  DataRow _buildDataRow(String measure, List<String> closed,
      List<String> benchmarks, List<String> hitsNeeded) {
    return DataRow(
      cells: [
        DataCell(
          Container(
            width: 120,
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFFF8F9FA),
            ),
            child: Text(
              measure,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(0xFF1976D2),
                fontSize: 14,
              ),
            ),
          ),
        ),
        ...closed.map((value) => DataCell(
              Container(
                width: 80,
                padding: const EdgeInsets.all(12),
                child: Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )),
        ...benchmarks.map((value) => DataCell(
              Container(
                width: 100,
                padding: const EdgeInsets.all(12),
                child: Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )),
        ...hitsNeeded.map((value) => DataCell(
              Container(
                width: 100,
                padding: const EdgeInsets.all(12),
                child: Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )),
      ],
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

  Widget _buildLogoutDialog() {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 60,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF8F9FA), Color(0xFFE9ECEF)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Color(0xFFDC3545),
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                      ),
                      child: const Icon(
                        Icons.logout,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 12),
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
              const Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      'Are you sure you want to log out of your account?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF333333),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "You'll need to sign in again to access your dashboard.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Footer
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() => _showLogoutDialog = false);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Color(0xFF666666),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() => _showLogoutDialog = false);
                          final authController = Get.find<AuthController>();
                          authController.logout();
                          // Handle logout
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDC3545),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Log Out',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
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
}
