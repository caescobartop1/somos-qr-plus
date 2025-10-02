import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:somos_qr_plus/controllers/auth_controller.dart';
import 'package:somos_qr_plus/controllers/practice_controller.dart';
import 'package:somos_qr_plus/helpers/route_helper.dart';
import 'package:somos_qr_plus/models/provider.dart';
import 'package:somos_qr_plus/widgets/spinner.dart';
import '../widgets/patient_profile_modal.dart';
import '../widgets/patient_filter_modal.dart';
import '../widgets/app_header_widget.dart';
import '../widgets/app_drawer_widget.dart';
import '../widgets/provider_dropdown_widget.dart';

import '../models/patient.dart';
import 'dart:async';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  bool _isDrawerOpen = false;
  final TextEditingController _searchController = TextEditingController();
  Provider _selectedProvider = new Provider(name: 'All', id: '-1');

  String _mcoFilter = '';
  String _providerFilter = '';
  String _dobFilter = '';
  int _currentPage = 1;
  int _rowsPerPage = 20;
  bool _showLogoutDialog = false;
  bool _isLoading = false;
  Timer? _debounce;
  String _currentOrdering = ''; // ← lo que se envía a getPatients
  String _currentSortColumn =
      ''; // ← columna actual (full_name, birthdate, etc.)
  bool _isAscending = true; // ← dirección actual
  String _sortColumn = 'full_name';
  bool _sortAscending = true;
  List<Patient> _filteredPatients = [];

  @override
  void initState() {
    super.initState();
    final c = Get.find<PracticeController>();
    _selectedProvider = c.defaultProvider;
    _initializePatients();
    // Lánzalo después del frame para asegurar que el árbol está listo
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        _isLoading = true;
      });
      await _loadData(_selectedProvider);
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _initializePatients() {}

  void _applyFilters() async {
    setState(() {
      _isLoading = true;
    });
    final c = Get.find<PracticeController>();
    String dobParsed = '';
    try {
      final parsed = DateFormat('dd/MM/yyyy').parse(_dobFilter);
      dobParsed = DateFormat('yyyy-MM-dd').format(parsed);
    } catch (_) {}

    await c.getPatients(
      _selectedProvider.id,
      dob: dobParsed.isEmpty ? null : dobParsed,
      provider: _providerFilter.isEmpty || _providerFilter == 'All'
          ? null
          : _providerFilter,
      mco: (_mcoFilter.isEmpty || _mcoFilter == 'All' || _mcoFilter == 'all')
          ? null
          : _mcoFilter,
      search: _searchController.text.isEmpty ? null : _searchController.text,
    );

    if (!mounted) return;
    setState(() {
      _currentPage = 1;
      _filteredPatients = c.patients;
    });
    setState(() {
      _isLoading = false;
    });
  }

  Widget _sortableHeader(String title, String column) {
    final isActive = _currentSortColumn == column;
    IconData? icon;
    if (isActive) {
      icon = _isAscending ? Icons.arrow_drop_up : Icons.arrow_drop_down;
    }

    return GestureDetector(
      onTap: () => _onSortColumn(column),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          if (icon != null)
            Icon(
              icon,
              size: 16,
              color: Colors.grey.shade700,
            ),
        ],
      ),
    );
  }

  void _onSortColumn(String column) async {
    setState(() {
      if (_currentSortColumn == column) {
        // si es la misma columna, alternar asc/desc
        _isAscending = !_isAscending;
      } else {
        // nueva columna → asc por defecto
        _currentSortColumn = column;
        _isAscending = true;
      }
      // prefijo "-" si es descendente
      _currentOrdering = _isAscending ? column : '-$column';
    });

    final c = Get.find<PracticeController>();
    String dobParsed = '';
    try {
      final parsed = DateFormat('dd/MM/yyyy').parse(_dobFilter);
      dobParsed = DateFormat('yyyy-MM-dd').format(parsed);
    } catch (_) {}

    await c.getPatients(
      _selectedProvider.id,
      dob: dobParsed.isEmpty ? null : dobParsed,
      provider: _providerFilter.isEmpty || _providerFilter == 'All'
          ? null
          : _providerFilter,
      mco: (_mcoFilter.isEmpty || _mcoFilter == 'All' || _mcoFilter == 'all')
          ? null
          : _mcoFilter,
      search: _searchController.text.isEmpty ? null : _searchController.text,
      ordering: _currentOrdering,
    );

    if (!mounted) return;
    setState(() {
      _currentPage = 1;
      _filteredPatients = c.patients;
    });
  }

  void _showPatientProfile(Patient patient) {
    final c = Get.find<PracticeController>();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientProfileModal(
          patient: patient,
          providers: c.providerList,
          practice_id: _selectedProvider.id,
          member_plan_id: 0,
          schedule_id: 0,
          shouldUpdate: false,
        ),
      ),
    );
  }

  void _showFilterModal() {
    final c = Get.find<PracticeController>();
    showDialog(
      context: context,
      builder: (context) => PatientFilterModal(
        mcoFilter: _mcoFilter,
        mco: c.mcoList,
        provider: c.providerList,
        providerFilter: _providerFilter,
        dobFilter: _dobFilter,
        showProvider: true,
        onApply: (mco, provider, dob) {
          setState(() {
            _mcoFilter = mco;
            _providerFilter = provider;
            _dobFilter = dob;
          });
          _applyFilters(); // ✅ Llamada a la API con los nuevos filtros
        },
      ),
    );
  }

  List<Patient> get _paginatedPatients {
    final practiceController = Get.find<PracticeController>();
    final patients = practiceController.patients;
    final startIndex = (_currentPage - 1) * _rowsPerPage;
    final endIndex = startIndex + _rowsPerPage;
    return patients.sublist(
      startIndex,
      endIndex > patients.length ? patients.length : endIndex,
    );
  }

  int get _totalPages {
    final count = Get.find<PracticeController>().patients.length;
    return (count / _rowsPerPage).ceil();
  }

  Future<void> _loadData(Provider provider) async {
    final c = Get.find<PracticeController>();
    String dobParsed = '';
    try {
      final parsed = DateFormat('dd/MM/yyyy').parse(_dobFilter);
      dobParsed = DateFormat('yyyy-MM-dd').format(parsed);
    } catch (_) {}

    bool resPatients = await c.getPatients(
      _selectedProvider.id,
      dob: dobParsed.isEmpty ? null : dobParsed,
      provider: _providerFilter.isEmpty || _providerFilter == 'All'
          ? null
          : _providerFilter,
      mco: _mcoFilter.isEmpty || _mcoFilter == 'All' ? null : _mcoFilter,
      search: _searchController.text.isEmpty ? null : _searchController.text,
    );
    if (!resPatients) return;

    bool resMco = await c.getMco(_selectedProvider.id);
    if (!resMco) return;

    bool resProvider = await c.getProvider(_selectedProvider.id);
    if (!resProvider) return;

    if (!mounted) return;
    setState(() {
      _filteredPatients = c.patients;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PracticeController>(builder: (practiceController) {
      return SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              // Main Content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                            onProviderChanged: (provider) async {
                              setState(() => _selectedProvider = provider);
                              final c = Get.find<PracticeController>();
                              c.setProvider(provider);
                              setState(() {
                                _isLoading = true;
                              });
                              await _loadData(provider);
                              setState(() {
                                _isLoading = false;
                              });
                              _showSuccessMessage(
                                  'Showing data for ${provider.name}');
                            },
                            maxWidth: 300,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Page Title
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'My Patients',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Search and Filter Bar
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      border: Border(
                          bottom: BorderSide(color: Colors.grey.shade200)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.grey.shade200),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.03),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Search patients...',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 12,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey.shade500,
                                  size: 16,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                              ),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              onChanged: (value) {
                                // Cancelar timer anterior si existe
                                if (_debounce?.isActive ?? false)
                                  _debounce!.cancel();

                                // Iniciar nuevo timer (ej: 500ms)
                                _debounce = Timer(
                                    const Duration(milliseconds: 500), () {
                                  // Llamar al método real después del retraso
                                  _applyFilters();
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.grey.shade200),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: _showFilterModal,
                            icon: Icon(
                              Icons.filter_list,
                              color: Colors.grey.shade700,
                              size: 16,
                            ),
                            tooltip: 'Filter by MCO, Provider, or DOB',
                            style: IconButton.styleFrom(
                              padding: const EdgeInsets.all(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Patients Table
                  Expanded(
                    child: Column(
                      children: [
                        // Table con scroll horizontal + vertical
                        Expanded(
                          child: _paginatedPatients.isEmpty
                              ? Center(child: Text("No records found"))
                              : SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: DataTable(
                                      columnSpacing: 20,
                                      dataTextStyle:
                                          const TextStyle(fontSize: 14),
                                      headingTextStyle: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF333333),
                                      ),
                                      columns: [
                                        _buildDataColumn(
                                            'FULL NAME', 'full_name', 14),
                                        _buildDataColumn(
                                            'DOB', 'birthdate', 14),
                                        _buildDataColumn('MCO', 'mco_name', 14),
                                        _buildDataColumn('GIC', 'gic', 14),
                                        _buildDataColumn('RA', 'ra', 14),
                                      ],
                                      rows: _paginatedPatients.map((patient) {
                                        return DataRow(
                                          // onSelectChanged: (_) =>
                                          //     _showPatientProfile(patient),
                                          cells: [
                                            DataCell(onTap: () {
                                              _showPatientProfile(patient);
                                            },
                                                Text(patient.fullName,
                                                    overflow:
                                                        TextOverflow.ellipsis)),
                                            DataCell(onTap: () {
                                              _showPatientProfile(patient);
                                            },
                                                Text(_formatDate(patient.dob),
                                                    overflow:
                                                        TextOverflow.ellipsis)),
                                            DataCell(onTap: () {
                                              _showPatientProfile(patient);
                                            },
                                                Text(patient.mco,
                                                    overflow:
                                                        TextOverflow.ellipsis)),
                                            DataCell(onTap: () {
                                              _showPatientProfile(patient);
                                            },
                                                Text(patient.gic.toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis)),
                                            DataCell(onTap: () {
                                              _showPatientProfile(patient);
                                            },
                                                Text(patient.ra.toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis)),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                        ),

                        // Controles de paginación
                        const SizedBox(height: 16),
                        _buildPaginationControls(),
                      ],
                    ),
                  ),

                  // Pagination
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      border:
                          Border(top: BorderSide(color: Colors.grey.shade300)),
                    ),
                    child: Row(
                      children: [
                        // Left side
                        Row(
                          children: [
                            Text('Rows per page: ',
                                style: TextStyle(color: Colors.grey.shade600)),
                            DropdownButton<int>(
                              value: _rowsPerPage,
                              underline: const SizedBox(),
                              items: [20, 35, 50, 100]
                                  .map((size) => DropdownMenuItem(
                                        value: size,
                                        child: Text(size.toString()),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _rowsPerPage = value;
                                    _currentPage = 1;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                        const Spacer(),
                        // Right side
                        Row(
                          children: [
                            Text(
                              'Page $_currentPage of $_totalPages',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                            const SizedBox(width: 16),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: _currentPage > 1
                                      ? () => setState(() => _currentPage--)
                                      : null,
                                  icon: const Icon(Icons.chevron_left),
                                ),
                                IconButton(
                                  onPressed: _currentPage < _totalPages
                                      ? () => setState(() => _currentPage++)
                                      : null,
                                  icon: const Icon(Icons.chevron_right),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Drawer Overlay (transparent)
              if (_isDrawerOpen)
                GestureDetector(
                  onTap: () => setState(() => _isDrawerOpen = false),
                  child: Container(
                    color: Colors.transparent,
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
                activeRoute: 'patients',
              ),
              if (_showLogoutDialog) _buildLogoutDialog(),
              if (_isLoading) LoadingSpinner()
            ],
          ),
        ),
      );
    });
  }

  String _formatDate(String dob) {
    try {
      final date = DateTime.parse(dob); // viene en yyyy-MM-dd
      return DateFormat('MM/dd/yyyy').format(date);
    } catch (e) {
      return dob; // fallback si no se puede parsear
    }
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
        // Already on patients page
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
        // Handle language change
        break;
      case 'invitations':
        // Handle invitations
        break;
      case 'logout':
        setState(() {
          _showLogoutDialog = true;
        });
        break;
    }
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

  Widget _buildPaginationControls() {
    final startIndex = (_currentPage - 1) * _rowsPerPage + 1;
    final endIndex =
        (_currentPage * _rowsPerPage).clamp(0, _filteredPatients.length);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // If width is too small, stack vertically
          if (constraints.maxWidth < 600) {
            return Column(
              children: [
                // Rows per page selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Rows per page:',
                      style: TextStyle(fontSize: 11, color: Color(0xFF666666)),
                    ),
                    const SizedBox(width: 6),
                    DropdownButton<int>(
                      value: _rowsPerPage,
                      items: [10, 20, 50, 100].map((value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text('$value',
                              style: const TextStyle(
                                  fontSize: 11, color: Colors.black)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _rowsPerPage = value;
                            _currentPage = 1;
                          });
                        }
                      },
                      underline: Container(),
                      style: const TextStyle(fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Page info and navigation
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Showing $startIndex-$endIndex of ${_filteredPatients.length}',
                      style: const TextStyle(
                          fontSize: 11, color: Color(0xFF666666)),
                    ),
                    const SizedBox(width: 12),
                    _buildCompactNavigation(),
                  ],
                ),
              ],
            );
          } else {
            // Horizontal layout for wider screens
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Rows per page selector
                Row(
                  children: [
                    const Text(
                      'Rows per page:',
                      style: TextStyle(fontSize: 11, color: Color(0xFF666666)),
                    ),
                    const SizedBox(width: 6),
                    DropdownButton<int>(
                      value: _rowsPerPage,
                      items: [10, 20, 50, 100].map((value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text('$value',
                              style: const TextStyle(fontSize: 11)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _rowsPerPage = value;
                            _currentPage = 1;
                          });
                        }
                      },
                      underline: Container(),
                      style: const TextStyle(fontSize: 11),
                    ),
                  ],
                ),

                // Page info and navigation
                Row(
                  children: [
                    Text(
                      'Showing $startIndex-$endIndex of ${_filteredPatients.length}',
                      style: const TextStyle(
                          fontSize: 11, color: Color(0xFF666666)),
                    ),
                    const SizedBox(width: 12),
                    _buildCompactNavigation(),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }

  void _goToPage(int page) {
    if (page >= 1 && page <= _totalPages) {
      setState(() {
        _currentPage = page;
      });
    }
  }

  Widget _buildCompactNavigation() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Previous button
        IconButton(
          onPressed:
              _currentPage > 1 ? () => _goToPage(_currentPage - 1) : null,
          icon: const Icon(Icons.chevron_left),
          iconSize: 18,
          padding: const EdgeInsets.all(2),
          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
        ),

        // Current page number only (to save space)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF1976D2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '$_currentPage',
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Next button
        IconButton(
          onPressed: _currentPage < _totalPages
              ? () => _goToPage(_currentPage + 1)
              : null,
          icon: const Icon(Icons.chevron_right),
          iconSize: 18,
          padding: const EdgeInsets.all(2),
          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
        ),
      ],
    );
  }

  DataColumn _buildDataColumn(String label, String column, double fontSize) {
    return DataColumn(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          SizedBox(width: 4),
          Icon(
            _sortColumn == column
                ? (_sortAscending ? Icons.arrow_upward : Icons.arrow_downward)
                : Icons.unfold_more,
            size: fontSize,
            color: Colors.grey.shade600,
          ),
        ],
      ),
      onSort: (columnIndex, ascending) => _sortTable(column),
    );
  }

  void _sortTable(String column) {
    final c = Get.find<PracticeController>();
    setState(() {
      if (_sortColumn == column) {
        _sortAscending = !_sortAscending;
      } else {
        _sortColumn = column;
        _sortAscending = true;
      }

      c.patients.sort((a, b) {
        var aValue = _getValueForColumn(a, column);
        var bValue = _getValueForColumn(b, column);

        int comparison = aValue.compareTo(bValue);
        return _sortAscending ? comparison : -comparison;
      });
    });
  }

  dynamic _getValueForColumn(Patient patient, String column) {
    switch (column) {
      case 'full_name':
        return patient.fullName;
      case 'birthdate':
        return patient.dob;
      case 'mco_name':
        return patient.mco;
      case 'gic':
        return patient.gic.toString();
      case 'ra':
        return patient.ra.toString();

      default:
        return patient.fullName;
    }
  }
}
