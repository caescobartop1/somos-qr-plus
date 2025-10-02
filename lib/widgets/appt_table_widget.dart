import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:somos_qr_plus/controllers/practice_controller.dart';
import 'package:somos_qr_plus/widgets/spinner.dart';

class APPTTableWidget extends StatefulWidget {
  final String practice_id;
  const APPTTableWidget({super.key, required this.practice_id});

  @override
  State<APPTTableWidget> createState() => _APPTTableWidgetState();
}

class _APPTTableWidgetState extends State<APPTTableWidget> {
  List<APPTPatient> _patients = [];
  List<APPTPatient> _filteredPatients = [];
  String _sortColumn = 'name';
  bool _sortAscending = true;
  bool _isLoading = false;

  // Pagination
  int _currentPage = 1;
  int _rowsPerPage = 10;

  // Filter controllers
  final TextEditingController _nameFilterController = TextEditingController();
  final TextEditingController _dobFilterController = TextEditingController();
  final TextEditingController _dosFilterController = TextEditingController();
  final TextEditingController _missedFilterController = TextEditingController();
  final TextEditingController _phoneFilterController = TextEditingController();
  final TextEditingController _addressFilterController =
      TextEditingController();
  String _mcoFilter = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        _isLoading = true;
      });
      await _loadPatients();
      setState(() {
        _isLoading = false;
      });
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

  Future<void> _loadPatients() async {
    final c = Get.find<PracticeController>();

    // ✅ Cargar lista de MCOs para el dropdown
    bool resMco = await c.getMco(widget.practice_id);
    if (!resMco) return;

    bool resApptList = await c.getReportKpiApptList(
      widget.practice_id,
      memberName: _nameFilterController.text,
      mcoName: _mcoFilter == 'all' ? null : _mcoFilter,
      dob: _dobFilterController.text,
      lastVisitDate: _dosFilterController.text,
      messedDate: _missedFilterController.text,
      address: _addressFilterController.text,
      phone: _phoneFilterController.text,
    );
    if (!resApptList) return;

    if (!mounted) return;
    setState(() {
      // ✅ Mapear los datos del controlador a nuestro modelo de tabla
      _patients = c.apptList
          .map((e) => APPTPatient(
                name: e.memberName,
                mco: e.mcoName,
                dob: e.dob,
                lastDos: e.dateTime,
                missedDate: e.messedDate ?? '',
                phone: e.phoneNumber,
                address: e.address,
              ))
          .toList();

      _filteredPatients = List.from(_patients);
      _currentPage = 1;
    });
  }

  void _applyFilters() async {
    setState(() {
      _isLoading = true;
    });
    final c = Get.find<PracticeController>();

    // ✅ Llamar al método que llena _apptList en el controlador
    await c.getReportKpiApptList(
      widget.practice_id,
      memberName: _nameFilterController.text,
      mcoName: _mcoFilter == 'all' ? null : _mcoFilter,
      dob: _dobFilterController.text,
      lastVisitDate: _dosFilterController.text,
      messedDate: _missedFilterController.text,
      address: _addressFilterController.text,
      phone: _phoneFilterController.text,
    );
    setState(() {
      _isLoading = false;
    });
    setState(() {
      // ✅ Mapear los datos del controlador a nuestro modelo de tabla
      _patients = c.apptList
          .map((e) => APPTPatient(
                name: e.memberName,
                mco: e.mcoName,
                dob: e.dob,
                lastDos: e.dateTime,
                missedDate: e.messedDate ?? '',
                phone: e.phoneNumber,
                address: e.address,
              ))
          .toList();

      _filteredPatients = List.from(_patients);
      _currentPage = 1;
    });
  }

  List<APPTPatient> get _paginatedPatients {
    final startIndex = (_currentPage - 1) * _rowsPerPage;
    final endIndex = startIndex + _rowsPerPage;
    return _filteredPatients.sublist(
      startIndex,
      endIndex > _filteredPatients.length ? _filteredPatients.length : endIndex,
    );
  }

  int get _totalPages => (_filteredPatients.length / _rowsPerPage).ceil();

  void _goToPage(int page) {
    if (page >= 1 && page <= _totalPages) {
      setState(() {
        _currentPage = page;
      });
    }
  }

  void _sortTable(String column) {
    setState(() {
      if (_sortColumn == column) {
        _sortAscending = !_sortAscending;
      } else {
        _sortColumn = column;
        _sortAscending = true;
      }

      _filteredPatients.sort((a, b) {
        var aValue = _getValueForColumn(a, column);
        var bValue = _getValueForColumn(b, column);

        int comparison = aValue.compareTo(bValue);
        return _sortAscending ? comparison : -comparison;
      });
    });
  }

  dynamic _getValueForColumn(APPTPatient patient, String column) {
    switch (column) {
      case 'name':
        return patient.name;
      case 'mco':
        return patient.mco;
      case 'dob':
        return patient.dob;
      case 'lastDos':
        return patient.lastDos;
      case 'missedDate':
        return patient.missedDate;
      case 'phone':
        return patient.phone;
      case 'address':
        return patient.address;
      default:
        return patient.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<PracticeController>();
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive sizing
        double fontSize, padding;
        if (constraints.maxWidth < 600) {
          fontSize = 11;
          padding = 6;
        } else if (constraints.maxWidth < 900) {
          fontSize = 12;
          padding = 8;
        } else {
          fontSize = 14;
          padding = 12;
        }

        return Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Table Header
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(padding),
                  decoration: BoxDecoration(
                    color: const Color(0xFFf8f9fa),
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'APPT Detailed Report',
                          style: TextStyle(
                            fontSize: fontSize + 2,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF333333),
                          ),
                        ),
                      ),
                      // IconButton(
                      //   onPressed: () {
                      //     // Export functionality - silent for now
                      //   },
                      //   icon: const Icon(Icons.file_download, size: 20),
                      //   tooltip: 'Export',
                      // ),
                    ],
                  ),
                ),

                // Filter Row
                Container(
                  padding: EdgeInsets.all(padding),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border:
                        Border(bottom: BorderSide(color: Colors.grey.shade200)),
                  ),
                  child: Column(
                    children: [
                      // First row of filters - 3 columns for better fit
                      Row(
                        children: [
                          Expanded(
                            child: _buildFilterField(
                              controller: _nameFilterController,
                              hint: 'Name...',
                              onChanged: (_) => _applyFilters(),
                            ),
                          ),
                          SizedBox(width: padding),
                          Expanded(
                            child: _buildFilterDropdown(
                              value: _mcoFilter,
                              items: [
                                'all',
                                ...c.mcoList.map((mco) => mco.mcoName),
                              ],
                              hint: 'MCO',
                              onChanged: (value) {
                                _mcoFilter = value ?? '';
                                _applyFilters();
                              },
                            ),
                          ),
                          SizedBox(width: padding),
                          Expanded(
                            child: _buildFilterField(
                              controller: _dobFilterController,
                              hint: 'DOB...',
                              onChanged: (_) => _applyFilters(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: padding),
                      // Second row of filters - 3 columns for better fit
                      Row(
                        children: [
                          Expanded(
                            child: _buildFilterField(
                              controller: _dosFilterController,
                              hint: 'DOS...',
                              onChanged: (_) => _applyFilters(),
                            ),
                          ),
                          SizedBox(width: padding),
                          Expanded(
                            child: _buildFilterField(
                              controller: _missedFilterController,
                              hint: 'Missed...',
                              onChanged: (_) => _applyFilters(),
                            ),
                          ),
                          SizedBox(width: padding),
                          Expanded(
                            child: _buildFilterField(
                              controller: _phoneFilterController,
                              hint: 'Phone...',
                              onChanged: (_) => _applyFilters(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: padding),
                      // Third row of filters - 1 column for address
                      Row(
                        children: [
                          Expanded(
                            child: _buildFilterField(
                              controller: _addressFilterController,
                              hint: 'Address...',
                              onChanged: (_) => _applyFilters(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Table
                Expanded(
                  child: Column(
                    children: [
                      // Table with horizontal scroll
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            child: DataTable(
                              columnSpacing: padding * 2,
                              dataTextStyle: TextStyle(fontSize: fontSize),
                              headingTextStyle: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF333333),
                              ),
                              columns: [
                                _buildDataColumn('NAME', 'name', fontSize),
                                _buildDataColumn('MCO', 'mco', fontSize),
                                _buildDataColumn('DOB', 'dob', fontSize),
                                _buildDataColumn(
                                    'LAST DOS', 'lastDos', fontSize),
                                _buildDataColumn(
                                    'MISSED DATE', 'missedDate', fontSize),
                                _buildDataColumn('PHONE', 'phone', fontSize),
                                _buildDataColumn(
                                    'ADDRESS', 'address', fontSize),
                              ],
                              rows: _paginatedPatients.map((patient) {
                                return DataRow(
                                  cells: [
                                    DataCell(Text(patient.name)),
                                    DataCell(Text(patient.mco)),
                                    DataCell(Text(_formatDate(patient.dob))),
                                    DataCell(Text(patient.lastDos)),
                                    DataCell(Text(patient.missedDate)),
                                    DataCell(Text(patient.phone)),
                                    DataCell(
                                      ConstrainedBox(
                                        constraints:
                                            BoxConstraints(maxWidth: 200),
                                        child: Text(
                                          patient.address,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      // Pagination Controls
                      const SizedBox(height: 16),
                      _buildPaginationControls(),
                    ],
                  ),
                ),
              ],
            ),
            if (_isLoading) LoadingSpinner()
          ],
        );
      },
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

  Widget _buildFilterField({
    required TextEditingController controller,
    required String hint,
    required ValueChanged<String> onChanged,
  }) {
    return ConstrainedBox(
      constraints:
          const BoxConstraints(minWidth: 80), // Minimum width constraint
      child: TextField(
        controller: controller,
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
        style: const TextStyle(fontSize: 11),
        onChanged: onChanged,
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

  @override
  void dispose() {
    _nameFilterController.dispose();
    _dobFilterController.dispose();
    _dosFilterController.dispose();
    _missedFilterController.dispose();
    _phoneFilterController.dispose();
    _addressFilterController.dispose();
    super.dispose();
  }
}

class APPTPatient {
  final String name;
  final String mco;
  final String dob;
  final String lastDos;
  final String missedDate;
  final String phone;
  final String address;

  APPTPatient({
    required this.name,
    required this.mco,
    required this.dob,
    required this.lastDos,
    required this.missedDate,
    required this.phone,
    required this.address,
  });
}
