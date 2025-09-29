import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:somos_qr_plus/controllers/auth_controller.dart';
import 'package:somos_qr_plus/controllers/practice_controller.dart';
import 'package:somos_qr_plus/helpers/route_helper.dart';
import 'package:somos_qr_plus/models/schedule.dart';
import '../widgets/app_header_widget.dart';
import '../widgets/app_drawer_widget.dart';
import '../widgets/provider_dropdown_widget.dart';
import '../widgets/patient_filter_modal.dart';
import '../widgets/patient_profile_modal.dart';
import '../models/patient.dart';
import 'package:somos_qr_plus/models/provider.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  bool _isDrawerOpen = false;
  Provider _selectedProvider = new Provider(name: 'All', id: '-1');
  String _selectedView = 'Week'; // Day, Week, Month
  DateTime _selectedDate = DateTime.now();
  bool _showNewAppointmentModal = false;

  // Filter functionality
  String _mcoFilter = '';
  String _providerFilter = 'all';
  String _dobFilter = '';

  // Schedule filters
  String _selectedStatusFilter = 'all';
  String _selectedScheduleProviderFilter = 'all';
  String _selectedMCOFilter = 'all';
  DateTime? _selectedDOBFilter;
  bool _showScheduleFilters = false;

  // Patient search functionality
  final TextEditingController _patientSearchController =
      TextEditingController();
  List<Patient> _allPatients = [];
  List<Patient> _filteredPatients = [];
  Patient? _selectedPatient;
  List<int> _workWeekDays = [1, 2, 3, 4, 5];

  @override
  void initState() {
    super.initState();
    final c = Get.find<PracticeController>();
    _selectedProvider = c.defaultProvider;
    _initializePatients();
    _patientSearchController.addListener(_onPatientSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  Future<void> _loadData() async {
    final c = Get.find<PracticeController>();

    await c.getPractice('');
    dynamic start =
        _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
    dynamic end = start.add(const Duration(days: 6));
    await c.getScheduleForScreen(
      _selectedProvider.id,
      startDate: start,
      endDate: end,
    );
    await c.getMco(_selectedProvider.id);
    await c.getProvider(_selectedProvider.id);

    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    _patientSearchController.dispose();
    super.dispose();
  }

  void _initializePatients() {
    _allPatients = [];
    _filteredPatients = _allPatients;
  }

  void _onPatientSearchChanged() {
    final query = _patientSearchController.text.toLowerCase();
    final c = Get.find<PracticeController>();
    List<Patient> filtered = c.patients;
    if (query.isNotEmpty) {
      filtered = filtered.where((patient) {
        return patient.fullName.toLowerCase().contains(query) ||
            patient.mco.toLowerCase().contains(query) ||
            patient.dob.contains(query);
      }).toList();
      setState(() {
        _filteredPatients = filtered;
      });
    }
  }

  void _selectPatient(Patient patient) {
    setState(() {
      _selectedPatient = patient;
      _patientSearchController.text = patient.fullName;
      _filteredPatients = [];
    });
  }

  void _showPatientProfile(String patientName) {
    // Find the patient in the list
    final c = Get.find<PracticeController>();
    final schedules = c.scheduleDetailsForPage;
    final Schedule? patient =
        schedules.firstWhereOrNull((p) => p.memberName == patientName);
    final patientToShow = Patient(patient?.patientId ?? 0,
        patient?.memberName ?? '', patient?.dob.toString() ?? '', '', 0, 0);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientProfileModal(
            patient: patientToShow,
            onCloseDialog: () {
              getSchedule();
            },
            providers: c.providerList,
            shouldUpdate: patient?.status == 'Pending',
            practice_id: _selectedProvider.id,
            member_plan_id: patient?.memberPlanId ?? 0,
            schedule_id: patient?.id),
      ),
    );
  }

  void _showFilterModal() {
    final c = Get.find<PracticeController>();
    final mcos = c.mcoList;

    showDialog(
      context: context,
      builder: (context) => PatientFilterModal(
        mcoFilter: _mcoFilter,
        mco: mcos,
        provider: c.providerList,
        providerFilter: _providerFilter,
        dobFilter: _dobFilter,
        onApply: (mco, provider, dob) {
          setState(() {
            _mcoFilter = mco;
            _providerFilter = provider;
            _dobFilter = dob;
          });
          // Apply filters to patient search
          _applyPatientFilters();
        },
      ),
    );
  }

  void _applyPatientFilters() async {
    final query = _patientSearchController.text.toLowerCase();
    String dobParsed = '';
    try {
      final parsed = DateFormat('dd/MM/yyyy').parse(_dobFilter);
      final formatted = DateFormat('yyyy-MM-dd').format(parsed);
      dobParsed = formatted;
    } catch (e) {}
    final c = Get.find<PracticeController>();
    await c.getPatients(_selectedProvider.id,
        dob: dobParsed,
        provider: _providerFilter == 'all' ? null : _providerFilter,
        mco: _mcoFilter == 'all' ? null : _mcoFilter);
    List<Patient> filtered = c.patients;
    if (query.isNotEmpty) {
      filtered = filtered.where((patient) {
        return patient.fullName.toLowerCase().contains(query) ||
            patient.mco.toLowerCase().contains(query) ||
            patient.dob.contains(query);
      }).toList();
      setState(() {
        _filteredPatients = filtered;
      });
    }
    setState(() {
      _filteredPatients = filtered;
    });
  }

  // Sample appointments data with specific days
  void getSchedule() {
    final c = Get.find<PracticeController>();
    DateTime start;
    DateTime end;
    print('hola aca entramos aja!');
    print(_selectedView);

    if (_selectedView == 'Day') {
      // Un solo día
      start = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
      );
      end = start;
    } else if (_selectedView == 'Work Week') {
      // rango base de la semana
      start = _selectedDate.subtract(Duration(days: _selectedDate.weekday % 7));
      end = start.add(const Duration(days: 6));
    } else if (_selectedView == 'Week') {
      // Semana completa (lunes a domingo)
      start = _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
      end = start.add(const Duration(days: 6));
      print(start);
      print(end);
      print('hola aca por supuesto aqui aja!');
    } else {
      // Mes completo
      start = DateTime(_selectedDate.year, _selectedDate.month, 1);
      end = DateTime(_selectedDate.year, _selectedDate.month + 1, 0);
    }
    final String dobParam = _selectedDOBFilter != null
        ? DateFormat('yyyy-MM-dd').format(_selectedDOBFilter!)
        : '';
    c.getScheduleForScreen(_selectedProvider.id,
        startDate: start,
        endDate: end,
        status: _selectedStatusFilter == 'all' ? null : _selectedStatusFilter,
        mco: _selectedMCOFilter == 'all' ? null : _selectedMCOFilter,
        dob: dobParam,
        provider: _selectedScheduleProviderFilter == 'all'
            ? null
            : _selectedScheduleProviderFilter);
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
                              setState(() {
                                _selectedProvider = provider;
                              });
                              final c = Get.find<PracticeController>();
                              c.setProvider(provider);
                              await c.getMco(_selectedProvider.id);
                              await c.getProvider(_selectedProvider.id);
                              getSchedule();
                              _showSuccessMessage(
                                  'Showing schedule for ${provider.name == 'All' ? 'All providers' : provider.name}');
                            },
                            maxWidth: 300,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Schedule Controls
                  _buildScheduleControls(),

                  // Schedule Filters
                  if (_showScheduleFilters) _buildScheduleFilters(),

                  // Schedule Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildScheduleHeader(),
                          const SizedBox(height: 16),
                          _buildScheduleGrid(),
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
                activeRoute: 'schedule',
              ),

              // New Appointment Modal
              if (_showNewAppointmentModal)
                _buildNewAppointmentModal(practiceController),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildScheduleControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        children: [
          // Page Title
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'My Schedule',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // View Toggle and Date Navigation
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 600;
              return Row(
                children: [
                  // View Toggle
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children:
                          ['Day', 'Week', 'Work Week', 'Month'].map((view) {
                        final isSelected = _selectedView == view;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedView = view;
                            });
                            getSchedule();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 10 : 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF1976D2)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              view,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                                fontSize: isMobile ? 10 : 12,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  // const Spacer(),

                  // Date Navigation
                  Expanded(
                    flex: 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (_selectedView == 'Day') {
                                _selectedDate = _selectedDate
                                    .subtract(const Duration(days: 1));
                              } else if (_selectedView == 'Week') {
                                _selectedDate = _selectedDate
                                    .subtract(const Duration(days: 7));
                              } else {
                                _selectedDate = DateTime(_selectedDate.year,
                                    _selectedDate.month - 1, _selectedDate.day);
                              }
                            });
                            getSchedule();
                          },
                          icon: const Icon(Icons.chevron_left),
                          iconSize: isMobile ? 20 : 24,
                        ),
                        Expanded(
                          flex: 5,
                          child: GestureDetector(
                            onTap: _showDatePicker,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: isMobile ? 18 : 30, vertical: 12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _getDateDisplayText(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF333333),
                                  fontSize: isMobile ? 12 : 14,
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.visible,
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (_selectedView == 'Day') {
                                _selectedDate =
                                    _selectedDate.add(const Duration(days: 1));
                              } else if (_selectedView == 'Week') {
                                _selectedDate =
                                    _selectedDate.add(const Duration(days: 7));
                              } else {
                                _selectedDate = DateTime(_selectedDate.year,
                                    _selectedDate.month + 1, _selectedDate.day);
                              }
                            });
                            getSchedule();
                          },
                          icon: const Icon(Icons.chevron_right),
                          iconSize: isMobile ? 20 : 24,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 16),
          if (_selectedView == 'Work Week')
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: List.generate(7, (index) {
                final labels = [
                  'Sun',
                  'Mon',
                  'Tue',
                  'Wed',
                  'Thu',
                  'Fri',
                  'Sat'
                ];
                final isSelected = _workWeekDays.contains(index);
                return FilterChip(
                  label: Text(labels[index]),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _workWeekDays.add(index);
                      } else {
                        _workWeekDays.remove(index);
                      }
                      getSchedule(); // recargar
                    });
                  },
                );
              }),
            ),

          // Action Buttons
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 600;
              return Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _showNewAppointmentModal = true;
                        });
                        final c = Get.find<PracticeController>();
                        c.getPatients(_selectedProvider.id);
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: Text(isMobile ? 'New' : 'New Appointment'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1976D2),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 12 : 16, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _showFilters,
                      icon: const Icon(Icons.filter_list, size: 18),
                      label: const Text('Filters'),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 12 : 16, vertical: 12),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleFilters() {
    final c = Get.find<PracticeController>();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Filter
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter by Status:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 400),
                child: DropdownButtonFormField<String>(
                  value: _selectedStatusFilter,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                  ),
                  items: [
                    'all',
                    'Pending',
                    'Confirmed',
                    'completed',
                    'No Show',
                    'Cancelled',
                  ].map((status) {
                    String displayName = status == 'all'
                        ? 'All Statuses'
                        : status == 'Pending'
                            ? 'Pending'
                            : status == 'Confirmed'
                                ? 'Confirmed'
                                : status == 'completed'
                                    ? 'Completed'
                                    : status == 'No Show'
                                        ? 'No Show'
                                        : status == 'Cancelled'
                                            ? 'Cancelled'
                                            : status;

                    return DropdownMenuItem(
                      value: status,
                      child: Text(displayName),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedStatusFilter = value!;
                    });
                    getSchedule();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Provider Filter
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter by Provider:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: DropdownButtonFormField<String>(
                    value: _selectedScheduleProviderFilter,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: 'all',
                        child: Text('Select a Provider'),
                      ),
                      ...c.providerList.map((p) => DropdownMenuItem(
                            value: p.id.toString(),
                            child: Text(p.fullName),
                          )),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedScheduleProviderFilter = value ?? 'all';
                      });
                      getSchedule();
                    },
                  )),
            ],
          ),
          const SizedBox(height: 20),

          // MCO Filter
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter by MCO:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 400),
                child: GetBuilder<PracticeController>(
                  builder: (c) {
                    // Obtenemos la lista de MCOs desde el controller
                    final mcos = c.mcoList;

                    return DropdownButtonFormField<String>(
                      value: _selectedMCOFilter,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                      ),
                      // Construimos las opciones dinámicamente
                      items: [
                        const DropdownMenuItem(
                          value: 'all',
                          child: Text('All MCOs'),
                        ),
                        ...mcos.map((mco) => DropdownMenuItem(
                              value: mco.mcoId.toString(),
                              child: Text(mco.mcoName),
                            )),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedMCOFilter = value ?? 'all';
                        });
                        getSchedule();
                      },
                    );
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // DOB Filter
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter by DOB:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 400),
                child: GestureDetector(
                  onTap: _showDOBPicker,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedDOBFilter != null
                                ? '${_selectedDOBFilter!.month}/${_selectedDOBFilter!.day}/${_selectedDOBFilter!.year}'
                                : 'Select Date of Birth',
                            style: TextStyle(
                              fontSize: 14,
                              color: _selectedDOBFilter != null
                                  ? Colors.black87
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleHeader() {
    final c = Get.find<PracticeController>();
    final schedules = c.scheduleDetailsForPage;

    return Row(
      children: [
        const Spacer(),
        Text(
          '${schedules.length} appointments',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleGrid() {
    if (_selectedView == 'Day') {
      return _buildDayView();
    } else if (_selectedView == 'Week') {
      return _buildWeekView();
    } else if (_selectedView == 'Work Week') {
      return _buildWorkWeekView();
    } else {
      return _buildMonthView();
    }
  }

  Widget _buildWorkWeekView() {
    final c = Get.find<PracticeController>();
    final schedules = c.scheduleDetailsForPage;

    // Días de la semana (domingo a sábado)
    final weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final startOfWeek =
        _selectedDate.subtract(Duration(days: _selectedDate.weekday % 7));

    // Filtramos solo los días seleccionados
    final selectedIndexes = _workWeekDays..sort();

    return Container(
      decoration: _boxDecoration(),
      child: Column(
        children: [
          // Encabezado
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 60),
                ...selectedIndexes.map((i) => Expanded(
                      child: Text(
                        weekDays[i],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                          fontSize: 12,
                        ),
                      ),
                    )),
              ],
            ),
          ),

          // Filas de horas
          ...List.generate(12, (index) {
            final hour = 8 + index;
            final timeSlot = '${hour.toString().padLeft(2, '0')}:00';
            return Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 60,
                    child: Text(timeSlot,
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 12)),
                  ),
                  ...selectedIndexes.map((dayIndex) {
                    final dayDate = startOfWeek.add(Duration(days: dayIndex));
                    final appointmentsInSlot = schedules.where((s) {
                      return s.day.year == dayDate.year &&
                          s.day.month == dayDate.month &&
                          s.day.day == dayDate.day &&
                          s.day.hour == hour;
                    }).toList();

                    return Expanded(
                      child: Container(
                        height: 80,
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: appointmentsInSlot.isEmpty
                            ? const SizedBox.shrink()
                            : _buildAppointmentCard(
                                appointmentsInSlot.first,
                                isCompact: true,
                              ),
                      ),
                    );
                  }),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDayView() {
    final c = Get.find<PracticeController>();
    final schedules = c.scheduleDetailsForPage;
    final selectedDay = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );

    return Container(
      decoration: _boxDecoration(),
      child: Column(
        children: [
          _buildTimeHeader(),
          ...List.generate(12, (index) {
            final hour = 8 + index;
            final appointmentsInSlot = schedules.where((s) {
              final sameDay = s.day.year == selectedDay.year &&
                  s.day.month == selectedDay.month &&
                  s.day.day == selectedDay.day;
              return sameDay && s.day.hour == hour;
            }).toList();

            return _buildTimeRow(hour, appointmentsInSlot);
          }),
        ],
      ),
    );
  }

  Widget _buildTimeRow(int hour, List<Schedule> schedules) {
    final timeSlot = '${hour.toString().padLeft(2, '0')}:00';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(timeSlot,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
          ),
          Expanded(
            child: schedules.isEmpty
                ? const SizedBox.shrink()
                : Column(
                    children: schedules
                        .map((schedule) => _buildAppointmentCard(schedule))
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _boxDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      );

  Widget _buildTimeHeader() => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 80,
              child: Text(
                'Time',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            const Expanded(
              child: Text(
                'Appointments',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildWeekView() {
    final c = Get.find<PracticeController>();
    final schedules = c.scheduleDetailsForPage;

    final weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final startOfWeek =
        _selectedDate.subtract(Duration(days: _selectedDate.weekday % 7));

    return Container(
      decoration: _boxDecoration(),
      child: Column(
        children: [
          // Encabezado de días
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 60), // Columna de hora
                ...weekDays.map((day) => Expanded(
                      child: Text(
                        day,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                          fontSize: 12,
                        ),
                      ),
                    )),
              ],
            ),
          ),

          // Filas de horas
          ...List.generate(12, (index) {
            final hour = 8 + index;
            final timeSlot = '${hour.toString().padLeft(2, '0')}:00';

            return Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 60,
                    child: Text(
                      timeSlot,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  ...List.generate(7, (dayIndex) {
                    final dayDate = startOfWeek.add(Duration(days: dayIndex));

                    // Citas que coinciden con el día y la hora
                    final appointmentsInSlot = schedules.where((s) {
                      return s.day.year == dayDate.year &&
                          s.day.month == dayDate.month &&
                          s.day.day == dayDate.day &&
                          s.day.hour == hour;
                    }).toList();

                    return Expanded(
                      child: Container(
                        height: 80,
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: appointmentsInSlot.isEmpty
                            ? const SizedBox.shrink()
                            : _buildAppointmentCard(
                                appointmentsInSlot.first,
                                isCompact: true,
                              ),
                      ),
                    );
                  }),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMonthView() {
    final c = Get.find<PracticeController>();
    final schedules = c.scheduleDetailsForPage;

    final firstDayOfMonth =
        DateTime(_selectedDate.year, _selectedDate.month, 1);
    final lastDayOfMonth =
        DateTime(_selectedDate.year, _selectedDate.month + 1, 0);
    final firstDayOfWeek = firstDayOfMonth.weekday; // 1 = Monday
    final daysInMonth = lastDayOfMonth.day;

    return Container(
      decoration: _boxDecoration(),
      child: Column(
        children: [
          // Encabezado del mes
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Text(
                  '${_getMonthName(_selectedDate.month)} ${_selectedDate.year}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
              ],
            ),
          ),

          // Encabezado de días de la semana
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: Colors.grey.shade100,
            child: Row(
              children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                  .map(
                    (day) => Expanded(
                      child: Text(
                        day,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),

          // Celdas del calendario
          ...List.generate(6, (weekIndex) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: Row(
                children: List.generate(7, (dayIndex) {
                  final dayNumber =
                      weekIndex * 7 + dayIndex - (firstDayOfWeek % 7) + 1;
                  final isCurrentMonth =
                      dayNumber > 0 && dayNumber <= daysInMonth;

                  final currentDate = isCurrentMonth
                      ? DateTime(
                          _selectedDate.year, _selectedDate.month, dayNumber)
                      : null;

                  final isToday = currentDate != null &&
                      currentDate.year == DateTime.now().year &&
                      currentDate.month == DateTime.now().month &&
                      currentDate.day == DateTime.now().day;

                  // Citas de ese día
                  final appointmentsForDay = currentDate == null
                      ? const <Schedule>[]
                      : schedules.where((s) {
                          return s.day.year == currentDate.year &&
                              s.day.month == currentDate.month &&
                              s.day.day == currentDate.day;
                        }).toList();

                  return Expanded(
                    child: Container(
                      height: 80,
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: isToday
                            ? const Color(0xFF1976D2).withOpacity(0.1)
                            : Colors.transparent,
                        border: Border.all(
                          color: isToday
                              ? const Color(0xFF1976D2)
                              : Colors.grey.shade200,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Column(
                        children: [
                          Text(
                            isCurrentMonth ? dayNumber.toString() : '',
                            style: TextStyle(
                              fontWeight:
                                  isToday ? FontWeight.w600 : FontWeight.normal,
                              color: isToday
                                  ? const Color(0xFF1976D2)
                                  : Colors.grey.shade700,
                            ),
                          ),
                          if (appointmentsForDay.isNotEmpty)
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(2),
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF4CAF50).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: Text(
                                  '${appointmentsForDay.length} apts',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF2E7D32),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(Schedule s, {bool isCompact = false}) {
    Color statusColor;
    switch (s.status.toLowerCase()) {
      case 'completed':
        statusColor = const Color(0xFF4CAF50);
        break;
      case 'pending':
        statusColor = const Color(0xFFFF9800);
        break;
      case 'no show':
        statusColor = const Color(0xFFF44336);
        break;
      default:
        statusColor = Colors.grey.shade600;
    }

    final timeStr = TimeOfDay.fromDateTime(s.day).format(context);

    final child = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          s.memberName,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: statusColor,
            fontSize: isCompact ? 10 : 14,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          timeStr,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: isCompact ? 8 : 12,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          s.providerName,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: isCompact ? 8 : 12,
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );

    return GestureDetector(
      onTap: () => _showPatientProfile(s.memberName),
      child: Container(
        margin: EdgeInsets.only(bottom: isCompact ? 2 : 8),
        padding: EdgeInsets.all(isCompact ? 4 : 12),
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.1),
          border: Border.all(color: statusColor.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: child,
      ),
    );
  }

  Widget _buildNewAppointmentModal(PracticeController practiceController) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.black54,
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 500),
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
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: Color(0xFF1976D2),
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                        ),
                        child: const Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'New Appointment',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF333333),
                              ),
                            ),
                            Text(
                              'Schedule a new patient visit',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF666666),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _showNewAppointmentModal = false;
                          });
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),

                // Body
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Filter Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _showFilterModal,
                          icon: const Icon(Icons.filter_list, size: 18),
                          label: const Text('Filter'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade50,
                            foregroundColor: Colors.blue.shade700,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(color: Colors.blue.shade200),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Provider Selection
                      // ProviderDropdownWidget(
                      //   selectedProvider: _selectedProvider,
                      //   providers: practiceController.providerList,
                      //   hintText: 'Select Provider',
                      //   onProviderChanged: (provider) {
                      //     setState(() {
                      //       _selectedProvider = provider;
                      //     });
                      //   },
                      // ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Provider',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            value: _providerFilter,
                            decoration: InputDecoration(
                              hintText: 'Select Provider',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                            ),
                            items: [
                              const DropdownMenuItem(
                                value: 'all',
                                child: Text('Select a Provider'),
                              ),
                              ...practiceController.providerList
                                  .map((p) => DropdownMenuItem(
                                        value: p.id.toString(),
                                        child: Text(p.fullName),
                                      )),
                            ],
                            onChanged: (value) {
                              setState(() => _providerFilter = value ?? '');
                              _applyPatientFilters();
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Patient Selection - Only show after provider is selected
                      if (_selectedProvider != 'All') ...[
                        TextField(
                          controller: _patientSearchController,
                          decoration: const InputDecoration(
                            labelText: 'Search Patient',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                            suffixIcon: Icon(Icons.search),
                          ),
                          onTap: () {
                            if (_selectedPatient != null) {
                              _patientSearchController.clear();
                              setState(() {
                                _selectedPatient = null;
                                _filteredPatients = _allPatients;
                              });
                            }
                          },
                        ),
                        if (_filteredPatients.isNotEmpty &&
                            _selectedPatient == null &&
                            _patientSearchController.text.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            constraints: const BoxConstraints(maxHeight: 200),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _filteredPatients.length > 5
                                  ? 5
                                  : _filteredPatients.length,
                              itemBuilder: (context, index) {
                                final patient = _filteredPatients[index];
                                return ListTile(
                                  dense: true,
                                  title: Text(
                                    patient.fullName,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  subtitle: Text(
                                    '${patient.mco} • DOB: ${patient.dob}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  onTap: () => _selectPatient(patient),
                                );
                              },
                            ),
                          ),
                        if (_selectedPatient != null)
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              border: Border.all(color: Colors.blue.shade200),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.check_circle,
                                    color: Colors.blue.shade600, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _selectedPatient!.fullName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        '${_selectedPatient!.mco} • DOB: ${_selectedPatient!.dob}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close, size: 18),
                                  onPressed: () {
                                    setState(() {
                                      _selectedPatient = null;
                                      _patientSearchController.clear();
                                      _filteredPatients = _allPatients;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                      ],
                      const SizedBox(height: 16),

                      // Available Slots - Only show after provider is selected
                      // if (_selectedProvider != 'All') ...[
                      //   Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       const Text(
                      //         'Available Slots',
                      //         style: TextStyle(
                      //           fontSize: 14,
                      //           fontWeight: FontWeight.w600,
                      //           color: Color(0xFF333333),
                      //         ),
                      //       ),
                      //       const SizedBox(height: 8),
                      //       Container(
                      //         width: double.infinity,
                      //         constraints: const BoxConstraints(maxWidth: 400),
                      //         child: DropdownButtonFormField<String>(
                      //           value: null, // No default selection
                      //           decoration: InputDecoration(
                      //             border: OutlineInputBorder(
                      //               borderRadius: BorderRadius.circular(6),
                      //               borderSide:
                      //                   BorderSide(color: Colors.grey.shade300),
                      //             ),
                      //             enabledBorder: OutlineInputBorder(
                      //               borderRadius: BorderRadius.circular(6),
                      //               borderSide:
                      //                   BorderSide(color: Colors.grey.shade300),
                      //             ),
                      //             contentPadding: const EdgeInsets.symmetric(
                      //                 horizontal: 12, vertical: 10),
                      //             hintText: 'Select Time Slot',
                      //             hintStyle:
                      //                 TextStyle(color: Colors.grey.shade600),
                      //           ),
                      //           items: _getAvailableSlots().map((slot) {
                      //             return DropdownMenuItem(
                      //               value: slot,
                      //               child: Text(slot),
                      //             );
                      //           }).toList(),
                      //           onChanged: (value) {
                      //             // Handle slot selection
                      //             setState(() {
                      //               // Store selected slot if needed
                      //             });
                      //           },
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      //   const SizedBox(height: 16),
                      // ],

                      // Appointment Type (Fixed to Walk-In)
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Appointment Type',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.medical_services),
                        ),
                        readOnly: true,
                        controller: TextEditingController(text: 'Walk-In'),
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
                            setState(() => _showNewAppointmentModal = false);
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
                          onPressed: () async {
                            setState(() => _showNewAppointmentModal = false);
                            final c = Get.find<PracticeController>();
                            await c.walkIn(_selectedProvider.id,
                                patientId: _selectedPatient?.id.toString(),
                                provider: _providerFilter);
                            getSchedule();
                            _showSuccessMessage(
                                'Appointment scheduled successfully!');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1976D2),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'Schedule',
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
      ),
    );
  }

  String _getDateDisplayText() {
    final isMobile = MediaQuery.of(context).size.width < 600;

    if (_selectedView == 'Day') {
      if (isMobile) {
        return '${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year.toString().substring(2)}';
      }
      return '${_getMonthName(_selectedDate.month)} ${_selectedDate.day}, ${_selectedDate.year}';
    } else if (_selectedView == 'Week') {
      final startOfWeek =
          _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
      final endOfWeek = startOfWeek.add(const Duration(days: 6));
      if (isMobile) {
        return '${startOfWeek.month}/${startOfWeek.day}-${endOfWeek.month}/${endOfWeek.day}';
      }
      return '${startOfWeek.month}/${startOfWeek.day} - ${endOfWeek.month}/${endOfWeek.day}';
    } else {
      if (isMobile) {
        return '${_selectedDate.month}/${_selectedDate.year}';
      }
      return '${_getMonthName(_selectedDate.month)} ${_selectedDate.year}';
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }

  void _showDatePicker() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  void _showFilters() {
    setState(() {
      _showScheduleFilters = !_showScheduleFilters;
    });
  }

  void _showDOBPicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDOBFilter ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1976D2),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDOBFilter) {
      setState(() {
        _selectedDOBFilter = picked;
      });
      getSchedule();
    }
  }

  List<String> _getAvailableSlots() {
    // Generate available time slots based on selected provider
    // This is a simplified version - in a real app, this would come from the backend
    final List<String> slots = [];

    // Generate slots from 9 AM to 5 PM with 30-minute intervals
    for (int hour = 9; hour <= 17; hour++) {
      for (int minute = 0; minute < 60; minute += 30) {
        if (hour == 17 && minute > 0) break; // Stop at 5:00 PM

        final time =
            '${hour > 12 ? hour - 12 : hour}:${minute.toString().padLeft(2, '0')} ${hour >= 12 ? 'PM' : 'AM'}';
        slots.add(time);
      }
    }

    // Filter out some slots to simulate availability
    // In a real app, this would be based on actual provider schedule
    final availableSlots = slots.where((slot) {
      // Simulate some slots being unavailable
      return !slot.contains('12:30 PM') &&
          !slot.contains('1:00 PM') &&
          !slot.contains('3:30 PM');
    }).toList();

    return availableSlots;
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
        // Already on schedule page
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
        final authController = Get.find<AuthController>();
        authController.logout();
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
        final authController = Get.find<AuthController>();
        authController.logout();
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
}
