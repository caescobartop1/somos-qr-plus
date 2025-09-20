import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:somos_qr_plus/helpers/route_helper.dart';
import 'package:somos_qr_plus/models/provider.dart';
import '../widgets/app_header_widget.dart';
import '../widgets/app_drawer_widget.dart';
import '../widgets/provider_dropdown_widget.dart';
import '../widgets/patient_filter_modal.dart';

import '../models/patient.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  bool _isDrawerOpen = false;
  Provider _selectedProvider = new Provider(name: 'All', id: '-1');
  String _selectedView = 'Day'; // Day, Week, Month
  DateTime _selectedDate = DateTime.now();
  bool _showNewAppointmentModal = false;

  // Filter functionality
  String _mcoFilter = '';
  String _providerFilter = '';
  String _dobFilter = '';

  // Schedule filters
  String _selectedStatusFilter = 'all';
  String _selectedScheduleProviderFilter = 'all';
  bool _showScheduleFilters = false;

  // Patient search functionality
  final TextEditingController _patientSearchController =
      TextEditingController();
  List<Patient> _allPatients = [];
  List<Patient> _filteredPatients = [];
  Patient? _selectedPatient;

  @override
  void initState() {
    super.initState();
    _initializePatients();
    _patientSearchController.addListener(_onPatientSearchChanged);
  }

  @override
  void dispose() {
    _patientSearchController.dispose();
    super.dispose();
  }

  void _initializePatients() {
    _allPatients = [
      Patient('James Anderson', '3/15/1965', 'HealthFirst', 85, 92),
      Patient('Maria Rodriguez', '7/22/1978', 'MetroPlus', 67, 74),
      Patient('Robert Johnson', '11/30/1982', 'Fidelis Care', 91, 88),
      Patient(
          'Sarah Williams', '4/12/1995', 'Empire BlueCross BlueShield', 78, 82),
      Patient(
          'David Chen', '9/3/1973', 'UnitedHealthcare Community Plan', 73, 79),
      Patient('Jennifer Lopez', '2/28/1988', 'HealthFirst', 89, 95),
      Patient('Michael Davis', '6/17/1969', 'MetroPlus', 71, 68),
      Patient('Lisa Thompson', '12/5/1991', 'Fidelis Care', 94, 91),
      Patient('William Martinez', '8/9/1984', 'Empire BlueCross BlueShield', 76,
          83),
      Patient('Emily Wilson', '1/14/1976', 'UnitedHealthcare Community Plan',
          82, 87),
      Patient('Christopher Lee', '5/20/1993', 'HealthFirst', 88, 93),
      Patient('Amanda Brown', '10/8/1987', 'MetroPlus', 75, 81),
      Patient('Daniel Kim', '7/31/1972', 'Fidelis Care', 69, 76),
      Patient(
          'Jessica Taylor', '3/25/1990', 'Empire BlueCross BlueShield', 86, 89),
      Patient('Kevin Patel', '11/12/1981', 'UnitedHealthcare Community Plan',
          72, 77),
    ];
    _filteredPatients = _allPatients;
  }

  void _onPatientSearchChanged() {
    _applyPatientFilters();
  }

  void _selectPatient(Patient patient) {
    setState(() {
      _selectedPatient = patient;
      _patientSearchController.text = patient.fullName;
      _filteredPatients = [];
    });
  }

  void _showFilterModal() {
    showDialog(
      context: context,
      builder: (context) => PatientFilterModal(
        mcoFilter: _mcoFilter,
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

  void _applyPatientFilters() {
    setState(() {
      final query = _patientSearchController.text.toLowerCase();
      List<Patient> filtered = _allPatients;

      // Apply text search
      if (query.isNotEmpty) {
        filtered = filtered.where((patient) {
          return patient.fullName.toLowerCase().contains(query) ||
              patient.mco.toLowerCase().contains(query) ||
              patient.dob.contains(query);
        }).toList();
      }

      // Apply MCO filter
      if (_mcoFilter.isNotEmpty && _mcoFilter != 'All') {
        filtered =
            filtered.where((patient) => patient.mco == _mcoFilter).toList();
      }

      // Apply DOB filter
      if (_dobFilter.isNotEmpty) {
        filtered =
            filtered.where((patient) => patient.dob == _dobFilter).toList();
      }

      _filteredPatients = filtered;
    });
  }

  // Sample appointments data with specific days
  final List<Map<String, dynamic>> _appointments = [
    // Monday appointments
    {
      'id': '1',
      'patientName': 'Sarah Williams',
      'time': '9:00 AM',
      'day': 1, // Monday
      'duration': 30,
      'type': 'GIC',
      'status': 'Confirmed',
      'provider': 'Dr. Smith',
      'notes': 'Annual wellness visit',
    },
    {
      'id': '2',
      'patientName': 'Michael Chen',
      'time': '10:00 AM',
      'day': 1, // Monday
      'duration': 45,
      'type': 'RA',
      'status': 'Pending',
      'provider': 'Dr. Johnson',
      'notes': 'Risk adjustment assessment',
    },
    // Tuesday appointments
    {
      'id': '3',
      'patientName': 'Emily Johnson',
      'time': '9:30 AM',
      'day': 2, // Tuesday
      'duration': 60,
      'type': 'GIC + RA',
      'status': 'Confirmed',
      'provider': 'Dr. Smith',
      'notes': 'Comprehensive visit',
    },
    {
      'id': '4',
      'patientName': 'Robert Davis',
      'time': '11:00 AM',
      'day': 2, // Tuesday
      'duration': 30,
      'type': 'GIC',
      'status': 'Cancelled',
      'provider': 'Dr. Johnson',
      'notes': 'Patient cancelled',
    },
    // Wednesday appointments
    {
      'id': '5',
      'patientName': 'Jennifer Lopez',
      'time': '9:00 AM',
      'day': 3, // Wednesday
      'duration': 30,
      'type': 'GIC',
      'status': 'Confirmed',
      'provider': 'Dr. Smith',
      'notes': 'Follow-up visit',
    },
    {
      'id': '6',
      'patientName': 'David Martinez',
      'time': '10:30 AM',
      'day': 3, // Wednesday
      'duration': 45,
      'type': 'RA',
      'status': 'Confirmed',
      'provider': 'Dr. Johnson',
      'notes': 'Risk assessment',
    },
    // Thursday appointments
    {
      'id': '7',
      'patientName': 'Lisa Thompson',
      'time': '9:00 AM',
      'day': 4, // Thursday
      'duration': 30,
      'type': 'GIC',
      'status': 'Pending',
      'provider': 'Dr. Smith',
      'notes': 'Annual checkup',
    },
    // Friday appointments
    {
      'id': '8',
      'patientName': 'William Brown',
      'time': '10:00 AM',
      'day': 5, // Friday
      'duration': 60,
      'type': 'GIC + RA',
      'status': 'Confirmed',
      'provider': 'Dr. Johnson',
      'notes': 'Comprehensive assessment',
    },
  ];

  @override
  Widget build(BuildContext context) {
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
                    border:
                        Border(bottom: BorderSide(color: Colors.grey.shade200)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: ProviderDropdownWidget(
                          selectedProvider: _selectedProvider,
                          providers: [],
                          onProviderChanged: (provider) {
                            setState(() {
                              _selectedProvider = provider;
                            });
                            _showSuccessMessage(
                                'Showing schedule for ${provider == 'All' ? 'All providers' : provider}');
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
            if (_showNewAppointmentModal) _buildNewAppointmentModal(),
          ],
        ),
      ),
    );
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
                fontSize: 32,
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
                      children: ['Day', 'Week', 'Month'].map((view) {
                        final isSelected = _selectedView == view;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedView = view;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 12 : 16, vertical: 8),
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
                                fontSize: isMobile ? 12 : 14,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const Spacer(),

                  // Date Navigation
                  Expanded(
                    flex: 2,
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
                          },
                          icon: const Icon(Icons.chevron_left),
                          iconSize: isMobile ? 20 : 24,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: _showDatePicker,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: isMobile ? 12 : 20, vertical: 8),
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
                                overflow: TextOverflow.ellipsis,
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
          Row(
            children: [
              const Text(
                'Filter by Status:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildStatusFilterButton('all', 'All', Colors.grey),
                    _buildStatusFilterButton(
                        'pending', 'Pending', Colors.orange),
                    _buildStatusFilterButton(
                        'confirmed', 'Confirmed', Colors.blue),
                    _buildStatusFilterButton(
                        'completed', 'Completed', Colors.green),
                    _buildStatusFilterButton(
                        'no-show', 'No Show', Colors.purple),
                    _buildStatusFilterButton(
                        'cancelled', 'Cancelled', Colors.red),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Provider Filter
          Row(
            children: [
              const Text(
                'Filter by Provider:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 300),
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
                      'all',
                      'dr-smith',
                      'dr-johnson',
                      'dr-williams',
                      'dr-brown',
                      'dr-davis',
                    ].map((provider) {
                      String displayName = provider == 'all'
                          ? 'All Providers'
                          : provider == 'dr-smith'
                              ? 'Dr. Sarah Smith'
                              : provider == 'dr-johnson'
                                  ? 'Dr. Michael Johnson'
                                  : provider == 'dr-williams'
                                      ? 'Dr. Emily Williams'
                                      : provider == 'dr-brown'
                                          ? 'Dr. David Brown'
                                          : provider == 'dr-davis'
                                              ? 'Dr. Lisa Davis'
                                              : provider;

                      return DropdownMenuItem(
                        value: provider,
                        child: Text(displayName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedScheduleProviderFilter = value!;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilterButton(String status, String label, Color color) {
    final isSelected = _selectedStatusFilter == status;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStatusFilter = status;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1976D2) : Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xFF1976D2) : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleHeader() {
    return Row(
      children: [
        const Spacer(),
        Text(
          '${_appointments.length} appointments',
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
    } else {
      return _buildMonthView();
    }
  }

  Widget _buildDayView() {
    return Container(
      decoration: BoxDecoration(
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
      ),
      child: Column(
        children: [
          // Time slots header
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
                Expanded(
                  child: Text(
                    'Appointments',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Time slots
          ...List.generate(12, (index) {
            final hour = 8 + index;
            final timeSlot = '${hour.toString().padLeft(2, '0')}:00';
            final selectedDayOfWeek = _selectedDate.weekday;
            final appointmentsInSlot = _appointments.where((apt) {
              final aptHour =
                  int.parse(apt['time'].split(':')[0].split(' ')[0]);
              final aptDay = apt['day'] as int;
              return aptHour == hour && aptDay == selectedDayOfWeek;
            }).toList();

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(
                      timeSlot,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Expanded(
                    child: appointmentsInSlot.isEmpty
                        ? const SizedBox.shrink()
                        : Column(
                            children: appointmentsInSlot.map((appointment) {
                              return _buildAppointmentCard(appointment);
                            }).toList(),
                          ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildWeekView() {
    final weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final startOfWeek =
        _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));

    return Container(
      decoration: BoxDecoration(
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
      ),
      child: Column(
        children: [
          // Week header
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
                const SizedBox(width: 60), // Time column
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

          // Week grid
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
                    final dayOfWeek = dayDate.weekday; // 1 = Monday, 7 = Sunday
                    final appointmentsInSlot = _appointments.where((apt) {
                      final aptHour =
                          int.parse(apt['time'].split(':')[0].split(' ')[0]);
                      final aptDay = apt['day'] as int;
                      return aptHour == hour && aptDay == dayOfWeek;
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
                            : _buildAppointmentCard(appointmentsInSlot.first,
                                isCompact: true),
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
    final firstDayOfMonth =
        DateTime(_selectedDate.year, _selectedDate.month, 1);
    final lastDayOfMonth =
        DateTime(_selectedDate.year, _selectedDate.month + 1, 0);
    final firstDayOfWeek = firstDayOfMonth.weekday;
    final daysInMonth = lastDayOfMonth.day;

    return Container(
      decoration: BoxDecoration(
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
      ),
      child: Column(
        children: [
          // Month header
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

          // Days of week header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
            ),
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

          // Calendar grid
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
                      weekIndex * 7 + dayIndex - firstDayOfWeek + 1;
                  final isCurrentMonth =
                      dayNumber > 0 && dayNumber <= daysInMonth;
                  final isToday = isCurrentMonth &&
                      dayNumber == _selectedDate.day &&
                      _selectedDate.month == DateTime.now().month &&
                      _selectedDate.year == DateTime.now().year;

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
                          if (isCurrentMonth &&
                              dayNumber <= 5) // Show sample appointments
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(2),
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF4CAF50).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: const Text(
                                  '2 apts',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF2E7D32),
                                  ),
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

  Widget _buildAppointmentCard(Map<String, dynamic> appointment,
      {bool isCompact = false}) {
    Color statusColor;
    switch (appointment['status']) {
      case 'Confirmed':
        statusColor = const Color(0xFF4CAF50);
        break;
      case 'Pending':
        statusColor = const Color(0xFFFF9800);
        break;
      case 'Cancelled':
        statusColor = const Color(0xFFF44336);
        break;
      default:
        statusColor = Colors.grey.shade600;
    }

    if (isCompact) {
      return Container(
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.1),
          border: Border.all(color: statusColor.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appointment['patientName'],
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: statusColor,
                fontSize: 10,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              appointment['type'],
              style: TextStyle(
                color: statusColor,
                fontSize: 8,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        border: Border.all(color: statusColor.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            appointment['patientName'],
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: statusColor,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            appointment['time'],
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            appointment['type'],
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewAppointmentModal() {
    return Container(
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
                        label: const Text('Filter Patients'),
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
                    ProviderDropdownWidget(
                      selectedProvider: _selectedProvider,
                      providers: [],
                      onProviderChanged: (provider) {
                        setState(() {
                          _selectedProvider = provider;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Patient Selection
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                    ),
                    const SizedBox(height: 16),

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
                        onPressed: () {
                          setState(() => _showNewAppointmentModal = false);
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
        // TODO: Handle logout
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
        // TODO: Handle logout
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
