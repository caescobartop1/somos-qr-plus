import 'package:flutter/material.dart';

class GICTableWidget extends StatefulWidget {
  const GICTableWidget({super.key});

  @override
  State<GICTableWidget> createState() => _GICTableWidgetState();
}

class _GICTableWidgetState extends State<GICTableWidget> {
  List<GICPatient> _patients = [];
  List<GICPatient> _filteredPatients = [];
  String _sortColumn = 'name';
  bool _sortAscending = true;
  
  // Pagination
  int _currentPage = 1;
  int _rowsPerPage = 10;
  
  // Filter controllers
  final TextEditingController _nameFilterController = TextEditingController();
  final TextEditingController _dobFilterController = TextEditingController();
  final TextEditingController _phoneFilterController = TextEditingController();
  String _mcoFilter = '';
  String _apptFilter = '';
  String _measureFilter = '';
  String _statusFilter = '';
  
  // Export fields
  final Map<String, bool> _exportFields = {
    'Name': true,
    'MCO': true,
    'Date of Birth': true,
    'Appointment Date': true,
    'Measure Code': true,
    'Status': true,
    'Phone Number': true,
    'Measure Description': false,
    'Line Of Business': false,
    'Reporting Period': false,
    'PCP Name': false,
    'Gender': false,
    'Member ID': false,
    'Non User Flag': false,
  };

  @override
  void initState() {
    super.initState();
    _loadSampleData();
    _applyFilters();
  }

  void _loadSampleData() {
    _patients = [
      GICPatient(
        name: 'Argentina D Baez Melo',
        mco: 'Healthfirst',
        dob: '01-31-1959',
        appointment: 'KED',
        measure: 'Completed',
        status: 'Completed',
        phone: '17189601223',
      ),
      GICPatient(
        name: 'Eliezer Feliz',
        mco: 'Anthem',
        dob: '05-15-1972',
        appointment: 'CBP',
        measure: 'Open',
        status: 'Open',
        phone: '6466448650',
      ),
      GICPatient(
        name: 'Camilo Rosario',
        mco: 'Emblem',
        dob: '03-22-1985',
        appointment: 'AWV',
        measure: 'Completed',
        status: 'Completed',
        phone: '7185551234',
      ),
      GICPatient(
        name: 'Maria Rodriguez',
        mco: 'Molina',
        dob: '07-08-1968',
        appointment: 'COL',
        measure: 'Open',
        status: 'Open',
        phone: '9178889999',
      ),
      GICPatient(
        name: 'Juan Carlos Lopez',
        mco: 'Healthfirst',
        dob: '11-14-1975',
        appointment: 'CCS',
        measure: 'Completed',
        status: 'Completed',
        phone: '6467778888',
      ),
      GICPatient(
        name: 'Ana Martinez',
        mco: 'Anthem',
        dob: '09-03-1982',
        appointment: 'PPC',
        measure: 'Open',
        status: 'Open',
        phone: '7186667777',
      ),
      GICPatient(
        name: 'Roberto Sanchez',
        mco: 'Emblem',
        dob: '02-18-1965',
        appointment: 'AWV',
        measure: 'Completed',
        status: 'Completed',
        phone: '9175556666',
      ),
      GICPatient(
        name: 'Carmen Torres',
        mco: 'Molina',
        dob: '12-25-1978',
        appointment: 'KED',
        measure: 'Open',
        status: 'Open',
        phone: '6464445555',
      ),
      GICPatient(
        name: 'Luis Gonzalez',
        mco: 'Healthfirst',
        dob: '04-07-1980',
        appointment: 'CBP',
        measure: 'Completed',
        status: 'Completed',
        phone: '7183334444',
      ),
      GICPatient(
        name: 'Isabella Silva',
        mco: 'Anthem',
        dob: '08-12-1970',
        appointment: 'COL',
        measure: 'Open',
        status: 'Open',
        phone: '9172223333',
      ),
      // Additional sample data for pagination testing
      GICPatient(
        name: 'Carlos Mendez',
        mco: 'Healthfirst',
        dob: '06-15-1983',
        appointment: 'AWV',
        measure: 'Completed',
        status: 'Completed',
        phone: '7189998888',
      ),
      GICPatient(
        name: 'Elena Vasquez',
        mco: 'Emblem',
        dob: '03-28-1976',
        appointment: 'KED',
        measure: 'Open',
        status: 'Open',
        phone: '6463334444',
      ),
      GICPatient(
        name: 'Miguel Torres',
        mco: 'Molina',
        dob: '11-05-1969',
        appointment: 'CBP',
        measure: 'Completed',
        status: 'Completed',
        phone: '9177776666',
      ),
      GICPatient(
        name: 'Sofia Ramirez',
        mco: 'Anthem',
        dob: '09-17-1981',
        appointment: 'PPC',
        measure: 'Open',
        status: 'Open',
        phone: '7184445555',
      ),
      GICPatient(
        name: 'Diego Herrera',
        mco: 'Healthfirst',
        dob: '01-22-1974',
        appointment: 'COL',
        measure: 'Completed',
        status: 'Completed',
        phone: '6468889999',
      ),
      GICPatient(
        name: 'Valentina Cruz',
        mco: 'Emblem',
        dob: '07-14-1987',
        appointment: 'AWV',
        measure: 'Open',
        status: 'Open',
        phone: '9171112222',
      ),
      GICPatient(
        name: 'Alejandro Morales',
        mco: 'Molina',
        dob: '04-09-1972',
        appointment: 'KED',
        measure: 'Completed',
        status: 'Completed',
        phone: '7186667777',
      ),
      GICPatient(
        name: 'Camila Jimenez',
        mco: 'Anthem',
        dob: '12-03-1985',
        appointment: 'CBP',
        measure: 'Open',
        status: 'Open',
        phone: '6465556666',
      ),
      GICPatient(
        name: 'Sebastian Ruiz',
        mco: 'Healthfirst',
        dob: '05-26-1978',
        appointment: 'PPC',
        measure: 'Completed',
        status: 'Completed',
        phone: '9179990000',
      ),
    ];
    _filteredPatients = List.from(_patients);
  }

  void _applyFilters() {
    setState(() {
      _filteredPatients = _patients.where((patient) {
        final nameMatch = patient.name.toLowerCase().contains(_nameFilterController.text.toLowerCase());
        final mcoMatch = _mcoFilter.isEmpty || patient.mco == _mcoFilter;
        final dobMatch = patient.dob.contains(_dobFilterController.text);
        final apptMatch = _apptFilter.isEmpty || patient.appointment == _apptFilter;
        final measureMatch = _measureFilter.isEmpty || patient.measure == _measureFilter;
        final statusMatch = _statusFilter.isEmpty || patient.status == _statusFilter;
        final phoneMatch = patient.phone.contains(_phoneFilterController.text);
        
        return nameMatch && mcoMatch && dobMatch && apptMatch && measureMatch && statusMatch && phoneMatch;
      }).toList();
      _currentPage = 1; // Reset to first page when filtering
    });
  }

  List<GICPatient> get _paginatedPatients {
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

  dynamic _getValueForColumn(GICPatient patient, String column) {
    switch (column) {
      case 'name':
        return patient.name;
      case 'mco':
        return patient.mco;
      case 'dob':
        return patient.dob;
      case 'appointment':
        return patient.appointment;
      case 'measure':
        return patient.measure;
      case 'status':
        return patient.status;
      case 'phone':
        return patient.phone;
      default:
        return patient.name;
    }
  }

  @override
  Widget build(BuildContext context) {
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

        return Column(
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
                      'GIC Detailed Report',
                      style: TextStyle(
                        fontSize: fontSize + 2,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF333333),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _showExportDialog();
                    },
                    icon: const Icon(Icons.file_download, size: 20),
                    tooltip: 'Export',
                  ),
                ],
              ),
            ),
            
            // Filter Row
            Container(
              padding: EdgeInsets.all(padding),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Column(
                children: [
                  // First row of filters - 2 columns for better fit
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
                          items: ['', 'Healthfirst', 'Anthem', 'Emblem', 'Molina'],
                          hint: 'MCO',
                          onChanged: (value) {
                            _mcoFilter = value ?? '';
                            _applyFilters();
                          },
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
                          controller: _dobFilterController,
                          hint: 'DOB...',
                          onChanged: (_) => _applyFilters(),
                        ),
                      ),
                      SizedBox(width: padding),
                      Expanded(
                        child: _buildFilterDropdown(
                          value: _apptFilter,
                          items: ['', 'KED', 'CBP', 'AWV', 'COL', 'CCS', 'PPC'],
                          hint: 'Type',
                          onChanged: (value) {
                            _apptFilter = value ?? '';
                            _applyFilters();
                          },
                        ),
                      ),
                      SizedBox(width: padding),
                      Expanded(
                        child: _buildFilterDropdown(
                          value: _measureFilter,
                          items: ['', 'Completed', 'Open'],
                          hint: 'Measure',
                          onChanged: (value) {
                            _measureFilter = value ?? '';
                            _applyFilters();
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: padding),
                  // Third row of filters - 2 columns for remaining filters
                  Row(
                    children: [
                      Expanded(
                        child: _buildFilterDropdown(
                          value: _statusFilter,
                          items: ['', 'Completed', 'Open'],
                          hint: 'Status',
                          onChanged: (value) {
                            _statusFilter = value ?? '';
                            _applyFilters();
                          },
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
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: constraints.maxWidth - 32, // Account for padding
                          ),
                          child: DataTable(
                            columnSpacing: padding * 1.5, // Reduced spacing to prevent overflow
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
                            _buildDataColumn('APPT', 'appointment', fontSize),
                            _buildDataColumn('MEASURE', 'measure', fontSize),
                            _buildDataColumn('STATUS', 'status', fontSize),
                            _buildDataColumn('PHONE', 'phone', fontSize),
                          ],
                          rows: _paginatedPatients.map((patient) {
                            return DataRow(
                              cells: [
                                DataCell(Text(patient.name)),
                                DataCell(Text(patient.mco)),
                                DataCell(Text(patient.dob)),
                                DataCell(Text(patient.appointment)),
                                DataCell(Text(patient.measure)),
                                DataCell(Text(patient.status)),
                                DataCell(Text(patient.phone)),
                              ],
                            );
                          }).toList(),
                          ),
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

  Widget _buildFilterField({
    required TextEditingController controller,
    required String hint,
    required ValueChanged<String> onChanged,
  }) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 80), // Minimum width constraint
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: 11, color: Colors.grey.shade500),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          isDense: true,
        ),
        style: const TextStyle(fontSize: 11),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildPaginationControls() {
    final startIndex = (_currentPage - 1) * _rowsPerPage + 1;
    final endIndex = (_currentPage * _rowsPerPage).clamp(0, _filteredPatients.length);
    
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
                          child: Text('$value', style: const TextStyle(fontSize: 11)),
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
                      style: const TextStyle(fontSize: 11, color: Color(0xFF666666)),
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
                          child: Text('$value', style: const TextStyle(fontSize: 11)),
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
                      style: const TextStyle(fontSize: 11, color: Color(0xFF666666)),
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
          onPressed: _currentPage > 1 ? () => _goToPage(_currentPage - 1) : null,
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
          onPressed: _currentPage < _totalPages ? () => _goToPage(_currentPage + 1) : null,
          icon: const Icon(Icons.chevron_right),
          iconSize: 18,
          padding: const EdgeInsets.all(2),
          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
        ),
      ],
    );
  }


  Widget _buildFilterDropdown({
    required String? value,
    required List<String> items,
    required String hint,
    required ValueChanged<String?> onChanged,
  }) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 80), // Minimum width constraint
      child: DropdownButtonFormField<String>(
        value: value!.isEmpty ? null : value,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: 11, color: Colors.grey.shade500),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
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

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SelectFieldsDialog(
          exportFields: _exportFields,
          onApply: (selectedFields) {
            setState(() {
              _exportFields.clear();
              _exportFields.addAll(selectedFields);
            });
            _exportReport();
          },
        );
      },
    );
  }

  void _exportReport() {
    // Get selected fields
    final selectedFields = _exportFields.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exporting report with fields: ${selectedFields.join(', ')}'),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
    
    // TODO: Implement actual export functionality (CSV, PDF, etc.)
  }

  @override
  void dispose() {
    _nameFilterController.dispose();
    _dobFilterController.dispose();
    _phoneFilterController.dispose();
    super.dispose();
  }
}

class GICPatient {
  final String name;
  final String mco;
  final String dob;
  final String appointment;
  final String measure;
  final String status;
  final String phone;

  GICPatient({
    required this.name,
    required this.mco,
    required this.dob,
    required this.appointment,
    required this.measure,
    required this.status,
    required this.phone,
  });
}

class SelectFieldsDialog extends StatefulWidget {
  final Map<String, bool> exportFields;
  final Function(Map<String, bool>) onApply;

  const SelectFieldsDialog({
    super.key,
    required this.exportFields,
    required this.onApply,
  });

  @override
  State<SelectFieldsDialog> createState() => _SelectFieldsDialogState();
}

class _SelectFieldsDialogState extends State<SelectFieldsDialog> {
  late Map<String, bool> _selectedFields;

  @override
  void initState() {
    super.initState();
    _selectedFields = Map.from(widget.exportFields);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 400,
        constraints: const BoxConstraints(maxHeight: 600),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                      'Select Fields',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, size: 20),
                    tooltip: 'Close',
                  ),
                ],
              ),
            ),
            
            // Fields List
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _selectedFields.entries.map((entry) {
                    return CheckboxListTile(
                      title: Text(
                        entry.key,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF333333),
                        ),
                      ),
                      value: entry.value,
                      onChanged: (bool? value) {
                        setState(() {
                          _selectedFields[entry.key] = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    );
                  }).toList(),
                ),
              ),
            ),
            
            // Footer Buttons
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        'Close',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onApply(_selectedFields);
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        'Apply',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
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
    );
  }
}
