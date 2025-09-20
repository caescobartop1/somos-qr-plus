import 'package:flutter/material.dart';

class APPTTableWidget extends StatefulWidget {
  const APPTTableWidget({super.key});

  @override
  State<APPTTableWidget> createState() => _APPTTableWidgetState();
}

class _APPTTableWidgetState extends State<APPTTableWidget> {
  List<APPTPatient> _patients = [];
  List<APPTPatient> _filteredPatients = [];
  String _sortColumn = 'name';
  bool _sortAscending = true;
  
  // Pagination
  int _currentPage = 1;
  int _rowsPerPage = 10;
  
  // Filter controllers
  final TextEditingController _nameFilterController = TextEditingController();
  final TextEditingController _dobFilterController = TextEditingController();
  final TextEditingController _dosFilterController = TextEditingController();
  final TextEditingController _missedFilterController = TextEditingController();
  final TextEditingController _phoneFilterController = TextEditingController();
  final TextEditingController _addressFilterController = TextEditingController();
  String _mcoFilter = '';

  @override
  void initState() {
    super.initState();
    _loadSampleData();
    _applyFilters();
  }

  void _loadSampleData() {
    _patients = [
      APPTPatient(
        name: 'Rosa Martinez',
        mco: 'Anthem',
        dob: '03-15-1955',
        lastDos: '01-15-2024',
        missedDate: '02-20-2024',
        phone: '7185551234',
        address: '123 Main St, Brooklyn, NY',
      ),
      APPTPatient(
        name: 'Jose Rodriguez',
        mco: 'Emblem',
        dob: '07-22-1948',
        lastDos: '12-10-2023',
        missedDate: '01-15-2024',
        phone: '9176667777',
        address: '456 Oak Ave, Queens, NY',
      ),
      APPTPatient(
        name: 'Maria Lopez',
        mco: 'Molina',
        dob: '11-08-1960',
        lastDos: '02-05-2024',
        missedDate: '03-10-2024',
        phone: '6464445555',
        address: '789 Pine St, Bronx, NY',
      ),
      APPTPatient(
        name: 'Carlos Santos',
        mco: 'Healthfirst',
        dob: '09-14-1952',
        lastDos: '01-28-2024',
        missedDate: '02-15-2024',
        phone: '2123334444',
        address: '321 Elm St, Manhattan, NY',
      ),
      APPTPatient(
        name: 'Ana Garcia',
        mco: 'Anthem',
        dob: '05-30-1958',
        lastDos: '12-20-2023',
        missedDate: '01-25-2024',
        phone: '7187778888',
        address: '654 Maple Dr, Staten Island, NY',
      ),
      APPTPatient(
        name: 'Luis Torres',
        mco: 'Emblem',
        dob: '02-18-1945',
        lastDos: '01-10-2024',
        missedDate: '02-05-2024',
        phone: '9178889999',
        address: '987 Cedar Ln, Brooklyn, NY',
      ),
      APPTPatient(
        name: 'Carmen Rivera',
        mco: 'Healthfirst',
        dob: '08-12-1950',
        lastDos: '02-01-2024',
        missedDate: '03-01-2024',
        phone: '7189990000',
        address: '147 Washington Ave, Brooklyn, NY',
      ),
      APPTPatient(
        name: 'Miguel Hernandez',
        mco: 'Molina',
        dob: '12-03-1947',
        lastDos: '01-05-2024',
        missedDate: '02-10-2024',
        phone: '9171112222',
        address: '258 Broadway, Manhattan, NY',
      ),
      APPTPatient(
        name: 'Isabella Fernandez',
        mco: 'Anthem',
        dob: '06-20-1955',
        lastDos: '12-15-2023',
        missedDate: '01-20-2024',
        phone: '6463334444',
        address: '369 5th Ave, Brooklyn, NY',
      ),
      APPTPatient(
        name: 'Roberto Jimenez',
        mco: 'Emblem',
        dob: '04-08-1953',
        lastDos: '01-22-2024',
        missedDate: '02-28-2024',
        phone: '2125556666',
        address: '741 Atlantic Ave, Brooklyn, NY',
      ),
      // Additional sample data for pagination testing
      APPTPatient(
        name: 'Elena Vasquez',
        mco: 'Healthfirst',
        dob: '03-28-1976',
        lastDos: '02-10-2024',
        missedDate: '03-15-2024',
        phone: '6463334444',
        address: '852 Madison St, Queens, NY',
      ),
      APPTPatient(
        name: 'Carlos Mendez',
        mco: 'Anthem',
        dob: '06-15-1983',
        lastDos: '01-30-2024',
        missedDate: '03-05-2024',
        phone: '7189998888',
        address: '963 Lexington Ave, Manhattan, NY',
      ),
      APPTPatient(
        name: 'Sofia Ramirez',
        mco: 'Molina',
        dob: '09-17-1981',
        lastDos: '02-15-2024',
        missedDate: '03-20-2024',
        phone: '6464445555',
        address: '174 3rd Ave, Brooklyn, NY',
      ),
      APPTPatient(
        name: 'Diego Herrera',
        mco: 'Emblem',
        dob: '01-22-1974',
        lastDos: '01-25-2024',
        missedDate: '02-28-2024',
        phone: '6468889999',
        address: '285 4th St, Bronx, NY',
      ),
      APPTPatient(
        name: 'Valentina Cruz',
        mco: 'Healthfirst',
        dob: '07-14-1987',
        lastDos: '02-20-2024',
        missedDate: '03-25-2024',
        phone: '9171112222',
        address: '396 5th St, Staten Island, NY',
      ),
      APPTPatient(
        name: 'Alejandro Morales',
        mco: 'Anthem',
        dob: '04-09-1972',
        lastDos: '01-18-2024',
        missedDate: '02-22-2024',
        phone: '7186667777',
        address: '407 6th Ave, Queens, NY',
      ),
      APPTPatient(
        name: 'Camila Jimenez',
        mco: 'Molina',
        dob: '12-03-1985',
        lastDos: '02-25-2024',
        missedDate: '03-30-2024',
        phone: '6465556666',
        address: '518 7th St, Brooklyn, NY',
      ),
      APPTPatient(
        name: 'Sebastian Ruiz',
        mco: 'Emblem',
        dob: '05-26-1978',
        lastDos: '01-12-2024',
        missedDate: '02-18-2024',
        phone: '9179990000',
        address: '629 8th Ave, Manhattan, NY',
      ),
      APPTPatient(
        name: 'Gabriela Torres',
        mco: 'Healthfirst',
        dob: '08-19-1980',
        lastDos: '02-08-2024',
        missedDate: '03-12-2024',
        phone: '7187778888',
        address: '730 9th St, Bronx, NY',
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
        final dosMatch = patient.lastDos.contains(_dosFilterController.text);
        final missedMatch = patient.missedDate.contains(_missedFilterController.text);
        final phoneMatch = patient.phone.contains(_phoneFilterController.text);
        final addressMatch = patient.address.toLowerCase().contains(_addressFilterController.text.toLowerCase());
        
        return nameMatch && mcoMatch && dobMatch && dosMatch && missedMatch && phoneMatch && addressMatch;
      }).toList();
      _currentPage = 1; // Reset to first page when filtering
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
                      'APPT Detailed Report',
                      style: TextStyle(
                        fontSize: fontSize + 2,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF333333),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Export functionality - silent for now
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
                          items: ['', 'Healthfirst', 'Anthem', 'Emblem', 'Molina'],
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
                            _buildDataColumn('LAST DOS', 'lastDos', fontSize),
                            _buildDataColumn('MISSED DATE', 'missedDate', fontSize),
                            _buildDataColumn('PHONE', 'phone', fontSize),
                            _buildDataColumn('ADDRESS', 'address', fontSize),
                          ],
                          rows: _paginatedPatients.map((patient) {
                            return DataRow(
                              cells: [
                                DataCell(Text(patient.name)),
                                DataCell(Text(patient.mco)),
                                DataCell(Text(patient.dob)),
                                DataCell(Text(patient.lastDos)),
                                DataCell(Text(patient.missedDate)),
                                DataCell(Text(patient.phone)),
                                DataCell(
                                  ConstrainedBox(
                                    constraints: BoxConstraints(maxWidth: 200),
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
