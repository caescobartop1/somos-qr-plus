import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:somos_qr_plus/controllers/auth_controller.dart';
import 'package:somos_qr_plus/controllers/practice_controller.dart';
import 'package:somos_qr_plus/helpers/route_helper.dart';
import 'package:somos_qr_plus/models/provider.dart';
import 'package:somos_qr_plus/models/quality_score.dart';
import 'package:somos_qr_plus/widgets/spinner.dart';
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
  Provider _selectedIncentiveProvider = new Provider(name: 'All', id: '-1');
  int _currentPage = 0;
  int _rowsPerPage = 20;
  bool _showLogoutDialog = false;
  bool _isLoading = false;
  String? _selectedMco = '';
  String? _selectedProduct = '';
  String? _selectedLob = '';
  String? _selectedMeasure = '';
  String _sortColumn = '';
  bool _sortAscending = true;

  List<QualityScore> _qualityMetrics = [];

  @override
  void initState() {
    super.initState();
    final c = Get.find<PracticeController>();
    _selectedIncentiveProvider = c.defaultProvider;
    // Lánzalo después del frame para asegurar que el árbol está listo
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        _isLoading = true;
      });
      await _loadData(_selectedIncentiveProvider);
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _loadData(provider) async {
    final c = Get.find<PracticeController>();

    bool resPractice = await c.getPractice('');
    if (!resPractice) return;
    await c.getQuality(provider.id,
        mco: _selectedMco,
        product: _selectedProduct,
        lob: _selectedLob,
        measure: _selectedMeasure);
    await c.getQualityMco(provider.id);
    await c.getQualityProduct(provider.id);
    await c.getQualityLob(provider.id);
    await c.getQualityMeasure(provider.id);
    if (provider.id == '-1') {
      _selectedMco = '';
      _selectedProduct = '';
      _selectedLob = '';
      _selectedMeasure = '';
    }
    if (!mounted) return;
    setState(() {
      _qualityMetrics = c.qualityScores;
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _searchQuality() async {
      setState(() {
        _isLoading = true;
      });
      final c = Get.find<PracticeController>();
      await c.getQuality(_selectedIncentiveProvider.id,
          mco: _selectedMco,
          product: _selectedProduct,
          lob: _selectedLob,
          measure: _selectedMeasure);
      setState(() {
        _isLoading = false;
      });
    }

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
                            selectedProvider: _selectedIncentiveProvider,
                            providers: practiceController.practices,
                            onProviderChanged: (provider) async {
                              setState(() {
                                _selectedIncentiveProvider = provider;
                              });
                              setState(() {
                                _isLoading = true;
                              });
                              await _loadData(_selectedIncentiveProvider);
                              setState(() {
                                _isLoading = false;
                              });
                              String name = provider.name;
                              _showSuccessMessage(
                                  'Quality scorecards updated for $name');
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
                              // 🔹 Filters Block
                              Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      Border.all(color: Colors.grey.shade200),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Filters",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF333333),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              _selectedMco = '';
                                              _selectedProduct = '';
                                              _selectedLob = '';
                                              _selectedMeasure = '';
                                            });
                                            _searchQuality();
                                          },
                                          style: TextButton.styleFrom(
                                            side: const BorderSide(
                                                color: Colors.black, width: 1),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 4),
                                            minimumSize: Size.zero,
                                          ),
                                          child: const Text(
                                            "Clear all",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text("MCO",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color(
                                                              0xFF333333))),
                                                  const SizedBox(height: 4),
                                                  _buildFilterDropdown(
                                                    value: _selectedMco,
                                                    items: practiceController
                                                        .mcoOptions,
                                                    hint: "Select MCO",
                                                    onChanged: (val) {
                                                      setState(() =>
                                                          _selectedMco =
                                                              val ?? '');
                                                      _searchQuality();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text("Line of Business",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color(
                                                              0xFF333333))),
                                                  const SizedBox(height: 4),
                                                  _buildFilterDropdown(
                                                    value: _selectedLob,
                                                    items: practiceController
                                                        .lobOptions,
                                                    hint:
                                                        "Select Line of Business",
                                                    onChanged: (val) {
                                                      setState(() =>
                                                          _selectedLob =
                                                              val ?? '');
                                                      _searchQuality();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text("Product",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color(
                                                              0xFF333333))),
                                                  const SizedBox(height: 4),
                                                  _buildFilterDropdown(
                                                    value: _selectedProduct,
                                                    items: practiceController
                                                        .productOptions,
                                                    hint: "Select Product",
                                                    onChanged: (val) {
                                                      setState(() =>
                                                          _selectedProduct =
                                                              val ?? '');
                                                      _searchQuality();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text("Measure",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color(
                                                              0xFF333333))),
                                                  const SizedBox(height: 4),
                                                  _buildFilterDropdown(
                                                    value: _selectedMeasure,
                                                    items: practiceController
                                                        .measureOptions
                                                        .map((m) => m
                                                            .measureCode) // Lista de códigos
                                                        .toList(),
                                                    hint: "Select Measure",
                                                    onChanged: (val) {
                                                      setState(() =>
                                                          _selectedMeasure =
                                                              val ?? '');
                                                      _searchQuality();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Page Title
                              Padding(
                                padding:
                                    EdgeInsets.only(bottom: isMobile ? 16 : 20),
                                child: const Text(
                                  'Quality Scorecard',
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF333333),
                                  ),
                                ),
                              ),

                              // Score Cards Table
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Column(
                                  children: [
                                    // 🔹 HEADER con 2 niveles
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        border: Border.all(
                                            color: Colors.grey.shade300),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              _headerCell("Code", "measureCode",
                                                  rowSpan: true, width: 80),
                                              _headerCell(
                                                  "Measure Name", "measureName",
                                                  rowSpan: true, width: 200),
                                              _headerCell("Open", "open",
                                                  rowSpan: true, width: 70),
                                              _headerCell(
                                                  "Numerator", "numerator",
                                                  rowSpan: true, width: 90),
                                              _headerCell(
                                                  "Denominator", "denominator",
                                                  rowSpan: true, width: 110),

                                              // Grupo Closed
                                              _groupHeader("Closed",
                                                  width: 530,
                                                  children: [
                                                    _headerCell("APP", "app",
                                                        width: 70),
                                                    _headerCell(
                                                        "CLAIM", "claim",
                                                        width: 80),
                                                    _headerCell("EHR", "ehr",
                                                        width: 70),
                                                    _headerCell(
                                                        "Compliance rate",
                                                        "complianceRate",
                                                        width: 250),
                                                  ]),

                                              // Grupo Benchmarks
                                              _groupHeader("Benchmarks",
                                                  width: 300,
                                                  children: [
                                                    _headerCell("50th / 3★",
                                                        "bm50th3star",
                                                        width: 100),
                                                    _headerCell("75th / 4★",
                                                        "bm75th4star",
                                                        width: 100),
                                                    _headerCell("90th / 5★",
                                                        "bm90th5star",
                                                        width: 100),
                                                  ]),

                                              _headerCell("Hit to next target",
                                                  "hitsToNextTarget",
                                                  rowSpan: true, width: 140),
                                              _headerCell("Weight", "weight",
                                                  rowSpan: true, width: 80),
                                              _headerCell(
                                                  "Achieved", "achieved",
                                                  rowSpan: true, width: 100),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    // 🔹 FILAS DE DATOS dinámicas
                                    ...practiceController.qualityScores
                                        .sublist(
                                      _currentPage * _rowsPerPage,
                                      ((_currentPage + 1) * _rowsPerPage).clamp(
                                          0,
                                          practiceController
                                              .qualityScores.length),
                                    )
                                        .map((q) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            left: BorderSide(
                                                color: Colors.grey.shade300),
                                            right: BorderSide(
                                                color: Colors.grey.shade300),
                                            bottom: BorderSide(
                                                color: Colors.grey.shade300),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            _dataCell(q.measureCode, width: 80),
                                            _dataCell(q.measureName,
                                                width: 200),
                                            _dataCell(q.open.toStringAsFixed(0),
                                                width: 70),
                                            _dataCell(
                                                q.numerator.toStringAsFixed(0),
                                                width: 90),
                                            _dataCell(
                                                q.denominator
                                                    .toStringAsFixed(0),
                                                width: 110),
                                            _dataCell(q.app.toString(),
                                                width: 132),
                                            _dataCell(q.claim.toString(),
                                                width: 132),
                                            _dataCell(q.ehr.toString(),
                                                width: 132),
                                            _dataCell(
                                              "${(q.complianceRate * 100).toStringAsFixed(0)}%",
                                              width:
                                                  132, // ✅ alineado con el header
                                            ),
                                            _dataCell(
                                                "${(q.bm50th3star * 100).toStringAsFixed(0)}%",
                                                width: 100),
                                            _dataCell(
                                                "${(q.bm75th4star * 100).toStringAsFixed(0)}%",
                                                width: 100),
                                            _dataCell(
                                                "${(q.bm90th5star * 100).toStringAsFixed(0)}%",
                                                width: 100),
                                            _dataCell(
                                                q.hitsToNextTarget
                                                    .toStringAsFixed(0),
                                                width: 140),
                                            _dataCell(
                                                q.weight.toStringAsFixed(2),
                                                width: 80),
                                            _dataCell(
                                              q.achieved != null
                                                  ? "${(q.achieved! * 100).toStringAsFixed(0)}%"
                                                  : "-",
                                              width: 100,
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  border: Border(
                                    left:
                                        BorderSide(color: Colors.grey.shade300),
                                    right:
                                        BorderSide(color: Colors.grey.shade300),
                                    bottom:
                                        BorderSide(color: Colors.grey.shade300),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // Rows per page
                                    const Text(
                                      "Rows per page:",
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF333333)),
                                    ),
                                    const SizedBox(width: 8),
                                    DropdownButton<int>(
                                      value: _rowsPerPage,
                                      items: [10, 20, 50, 100].map((e) {
                                        return DropdownMenuItem<int>(
                                          value: e,
                                          child: Text(e.toString(),
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Color(0xFF333333))),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        if (value != null) {
                                          setState(() {
                                            _rowsPerPage = value;
                                            _currentPage = 0; // reset
                                          });
                                        }
                                      },
                                    ),
                                    const SizedBox(width: 20),

                                    // Page info
                                    Text(
                                      _getPageInfo(practiceController
                                          .qualityScores.length),
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF333333)),
                                    ),
                                    const SizedBox(width: 20),

                                    // Pagination buttons
                                    // _buildPaginationButton(
                                    //     "⏮", _currentPage == 0, _goToFirstPage),
                                    // const SizedBox(width: 6),
                                    _buildPaginationButton("◀",
                                        _currentPage == 0, _goToPreviousPage),
                                    const SizedBox(width: 6),
                                    _buildPaginationButton(
                                        "▶",
                                        (_currentPage + 1) * _rowsPerPage >=
                                            practiceController
                                                .qualityScores.length,
                                        _goToNextPage),
                                    // const SizedBox(width: 6),
                                    // _buildPaginationButton(
                                    //     "⏭",
                                    //     (_currentPage + 1) * _rowsPerPage >=
                                    //         practiceController
                                    //             .qualityScores.length,
                                    //     _goToLastPage),
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
            if (_isLoading) LoadingSpinner()
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

  int _getTotalPages() {
    return (_qualityMetrics.length / _rowsPerPage).ceil();
  }

  String _getPageInfo(int totalItems) {
    if (totalItems == 0) return "0-0 of 0";
    final startIndex = _currentPage * _rowsPerPage + 1;
    final endIndex = ((_currentPage + 1) * _rowsPerPage).clamp(0, totalItems);
    return '$startIndex-$endIndex of $totalItems';
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

  // void _goToLastPage() {
  //   final totalPages = _getTotalPages();
  //   if (_currentPage < totalPages - 1) {
  //     setState(() {
  //       _currentPage = totalPages - 1;
  //     });
  //   }
  // }

  // DataColumn _buildDataColumn(String label, String column, double fontSize) {
  //   return DataColumn(
  //     label: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Text(label),
  //         SizedBox(width: 4),
  //         Icon(
  //           _sortColumn == column
  //               ? (_sortAscending ? Icons.arrow_upward : Icons.arrow_downward)
  //               : Icons.unfold_more,
  //           size: fontSize,
  //           color: Colors.grey.shade600,
  //         ),
  //       ],
  //     ),
  //     onSort: (columnIndex, ascending) => _sortTable(column),
  //   );
  // }

  void _sortTable(String column) {
    final c = Get.find<PracticeController>();
    setState(() {
      if (_sortColumn == column) {
        _sortAscending = !_sortAscending;
      } else {
        _sortColumn = column;
        _sortAscending = true;
      }

      c.qualityScores.sort((a, b) {
        var aValue = _getValueForColumn(a, column);
        var bValue = _getValueForColumn(b, column);

        int comparison = aValue.compareTo(bValue);
        return _sortAscending ? comparison : -comparison;
      });
    });
  }

  dynamic _getValueForColumn(QualityScore quality, String column) {
    switch (column) {
      case 'measureName':
        return quality.measureName;
      case 'open':
        return quality.open;
      case 'numerator':
        return quality.numerator;
      case 'denominator':
        return quality.denominator;
      case 'app':
        return quality.app;
      case 'claim':
        return quality.claim;
      case 'ehr':
        return quality.ehr;
      case 'complianceRate':
        return quality.complianceRate;
      case 'bm50th3star':
        return quality.bm50th3star;
      case 'bm75th4star':
        return quality.bm75th4star;
      case 'bm90th5star':
        return quality.bm90th5star;
      case 'hitsToNextTarget':
        return quality.hitsToNextTarget;
      case 'weight':
        return quality.weight;
      case 'achieved':
        return quality.achieved ?? -1.0;

      default:
        return quality.measureName;
    }
  }

  Widget _headerCell(String text, String param,
      {double width = 100, bool rowSpan = false}) {
    return Container(
      width: width,
      height: rowSpan ? 64 : 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.grey.shade50,
      ),
      child: GestureDetector(
        onTap: () {
          _sortTable(param);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Color(0xFF333333),
              ),
              textAlign: TextAlign.center,
            ),
            Icon(
              _sortColumn == param
                  ? (_sortAscending ? Icons.arrow_upward : Icons.arrow_downward)
                  : Icons.unfold_more,
              size: 13,
              color: Colors.grey.shade600,
            ),
          ],
        ),
      ),
    );
  }

  Widget _groupHeader(String title,
      {required double width, required List<Widget> children}) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        color: const Color(0xFFEFF7F1),
      ),
      child: Column(
        children: [
          Container(
            height: 32,
            alignment: Alignment.center,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Color(0xFF333333),
              ),
            ),
          ),
          Row(
            children: children
                .map((child) =>
                    Expanded(child: child)) // 🔑 cada celda ocupa proporcional
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _dataCell(String text, {double width = 100}) {
    return Container(
      width: width,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, color: Color(0xFF333333)),
        overflow: TextOverflow.ellipsis,
      ),
    );
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

  Widget _buildFilterDropdown({
    required String? value,
    required List<String> items,
    required String hint,
    required ValueChanged<String?> onChanged,
  }) {
    return ConstrainedBox(
      constraints:
          const BoxConstraints(minWidth: 80), // Minimum width constraint
      child: DropdownButtonFormField<String>(
        value: value!.isEmpty ? null : value,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: 11, color: Colors.grey.shade500),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          isDense: true,
        ),
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item.isEmpty ? null : item,
            child: Text(
              item.isEmpty ? hint : item,
              style: TextStyle(
                fontSize: 11,
                color: item.isEmpty ? Colors.grey.shade500 : Colors.black,
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
