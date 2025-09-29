import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:somos_qr_plus/controllers/auth_controller.dart';
import 'package:somos_qr_plus/controllers/practice_controller.dart';
import 'package:somos_qr_plus/helpers/route_helper.dart';
import 'package:somos_qr_plus/models/provider.dart';
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
  Timer? _debounce;
  String _currentOrdering = ''; // ← lo que se envía a getPatients
  String _currentSortColumn =
      ''; // ← columna actual (full_name, birthdate, etc.)
  bool _isAscending = true; // ← dirección actual

  @override
  void initState() {
    super.initState();
    final c = Get.find<PracticeController>();
    _selectedProvider = c.defaultProvider;
    _initializePatients();
    // Lánzalo después del frame para asegurar que el árbol está listo
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _loadData(_selectedProvider));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _initializePatients() {}

  void _applyFilters() async {
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
      mco: _mcoFilter.isEmpty || _mcoFilter == 'All' ? null : _mcoFilter,
      search: _searchController.text.isEmpty ? null : _searchController.text,
    );

    if (!mounted) return;
    setState(() {
      _currentPage = 1;
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
      mco: _mcoFilter.isEmpty || _mcoFilter == 'All' ? null : _mcoFilter,
      search: _searchController.text.isEmpty ? null : _searchController.text,
      ordering: _currentOrdering,
    );

    if (!mounted) return;
    setState(() {
      _currentPage = 1;
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

    await c.getPatients(
      _selectedProvider.id,
      dob: dobParsed.isEmpty ? null : dobParsed,
      provider: _providerFilter.isEmpty || _providerFilter == 'All'
          ? null
          : _providerFilter,
      mco: _mcoFilter.isEmpty || _mcoFilter == 'All' ? null : _mcoFilter,
      search: _searchController.text.isEmpty ? null : _searchController.text,
    );

    await c.getMco(_selectedProvider.id);
    await c.getProvider(_selectedProvider.id);

    if (!mounted) return;
    setState(() {});
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
                            onProviderChanged: (provider) {
                              setState(() => _selectedProvider = provider);
                              final c = Get.find<PracticeController>();
                              c.setProvider(provider);
                              _loadData(provider);
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
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              // Table Header
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade300)),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 3,
                                        child: _sortableHeader(
                                            'Full Name', 'full_name')),
                                    Expanded(
                                        flex: 2,
                                        child: _sortableHeader(
                                            'DOB', 'birthdate')),
                                    Expanded(
                                        flex: 3,
                                        child:
                                            _sortableHeader('MCO', 'mco_name')),
                                    Expanded(
                                        flex: 1,
                                        child: _sortableHeader('GIC', 'gic')),
                                    Expanded(
                                        flex: 1,
                                        child: _sortableHeader('RA', 'ra')),
                                  ],
                                ),
                              ),
                              // Table Rows
                              ..._paginatedPatients
                                  .map((patient) => GestureDetector(
                                        onTap: () =>
                                            _showPatientProfile(patient),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 12),
                                          decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color:
                                                        Colors.grey.shade200)),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  flex: 3,
                                                  child: Text(patient.fullName,
                                                      overflow: TextOverflow
                                                          .ellipsis)),
                                              Expanded(
                                                  flex: 2,
                                                  child: Text(patient.dob,
                                                      overflow: TextOverflow
                                                          .ellipsis)),
                                              Expanded(
                                                  flex: 3,
                                                  child: Text(patient.mco,
                                                      overflow: TextOverflow
                                                          .ellipsis)),
                                              Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                      patient.gic.toString(),
                                                      overflow: TextOverflow
                                                          .ellipsis)),
                                              Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                      patient.ra.toString(),
                                                      overflow: TextOverflow
                                                          .ellipsis)),
                                            ],
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ],
                          ),
                        ),
                      ),
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
}
