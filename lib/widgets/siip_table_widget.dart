import 'package:flutter/material.dart';

class SIIPTableWidget extends StatefulWidget {
  const SIIPTableWidget({super.key});

  @override
  State<SIIPTableWidget> createState() => _SIIPTableWidgetState();
}

class _SIIPTableWidgetState extends State<SIIPTableWidget> {
  List<SIIPRecord> _records = [];
  List<SIIPRecord> _filteredRecords = [];
  String _sortColumn = 'id';
  bool _sortAscending = true;
  
  // Pagination
  int _currentPage = 1;
  int _rowsPerPage = 10;
  
  // Filter controllers
  final TextEditingController _idFilterController = TextEditingController();
  final TextEditingController _apptFilterController = TextEditingController();
  final TextEditingController _phoneFilterController = TextEditingController();
  final TextEditingController _earningsFilterController = TextEditingController();
  final TextEditingController _potentialFilterController = TextEditingController();
  String _measureFilter = '';
  String _statusFilter = '';

  @override
  void initState() {
    super.initState();
    _loadSampleData();
    _applyFilters();
  }

  void _loadSampleData() {
    _records = [
      SIIPRecord(
        id: '1959',
        appointment: '05-23-2025',
        measure: 'AWV',
        status: 'Open',
        phone: '3477010754',
        earnings: 0.00,
        potential: 10.00,
      ),
      SIIPRecord(
        id: '1965',
        appointment: '03-31-2025',
        measure: 'AWV',
        status: 'Open',
        phone: '7185366340',
        earnings: 0.00,
        potential: 10.00,
      ),
      SIIPRecord(
        id: '1931',
        appointment: '05-23-2025',
        measure: 'AWV',
        status: 'Completed',
        phone: '5169415555',
        earnings: 10.00,
        potential: 10.00,
      ),
      SIIPRecord(
        id: '1983',
        appointment: '03-31-2025',
        measure: 'AWV',
        status: 'Open',
        phone: '5167700117',
        earnings: 0.00,
        potential: 10.00,
      ),
      SIIPRecord(
        id: '1950',
        appointment: '05-23-2025',
        measure: 'HBD',
        status: 'Completed',
        phone: '5169988581',
        earnings: 10.00,
        potential: 10.00,
      ),
      SIIPRecord(
        id: '1972',
        appointment: '04-15-2025',
        measure: 'AWV',
        status: 'Open',
        phone: '7185551234',
        earnings: 0.00,
        potential: 10.00,
      ),
      SIIPRecord(
        id: '1988',
        appointment: '04-20-2025',
        measure: 'HBD',
        status: 'Completed',
        phone: '9176667777',
        earnings: 10.00,
        potential: 10.00,
      ),
      SIIPRecord(
        id: '1945',
        appointment: '05-10-2025',
        measure: 'AWV',
        status: 'Open',
        phone: '6464445555',
        earnings: 0.00,
        potential: 10.00,
      ),
      SIIPRecord(
        id: '1968',
        appointment: '05-18-2025',
        measure: 'HBD',
        status: 'Completed',
        phone: '2123334444',
        earnings: 10.00,
        potential: 10.00,
      ),
      SIIPRecord(
        id: '1975',
        appointment: '04-25-2025',
        measure: 'AWV',
        status: 'Open',
        phone: '7187778888',
        earnings: 0.00,
        potential: 10.00,
      ),
      SIIPRecord(
        id: '1980',
        appointment: '05-05-2025',
        measure: 'HBD',
        status: 'Completed',
        phone: '9178889999',
        earnings: 10.00,
        potential: 10.00,
      ),
      SIIPRecord(
        id: '1942',
        appointment: '05-12-2025',
        measure: 'AWV',
        status: 'Open',
        phone: '6463162672',
        earnings: 0.00,
        potential: 10.00,
      ),
    ];
    _filteredRecords = List.from(_records);
  }

  void _applyFilters() {
    setState(() {
      _filteredRecords = _records.where((record) {
        final idMatch = record.id.contains(_idFilterController.text);
        final apptMatch = record.appointment.contains(_apptFilterController.text);
        final measureMatch = _measureFilter.isEmpty || record.measure == _measureFilter;
        final statusMatch = _statusFilter.isEmpty || record.status == _statusFilter;
        final phoneMatch = record.phone.contains(_phoneFilterController.text);
        final earningsMatch = record.earnings.toString().contains(_earningsFilterController.text);
        final potentialMatch = record.potential.toString().contains(_potentialFilterController.text);
        
        return idMatch && apptMatch && measureMatch && statusMatch && phoneMatch && earningsMatch && potentialMatch;
      }).toList();
      _currentPage = 1; // Reset to first page when filtering
    });
  }

  List<SIIPRecord> get _paginatedRecords {
    final startIndex = (_currentPage - 1) * _rowsPerPage;
    final endIndex = startIndex + _rowsPerPage;
    return _filteredRecords.sublist(
      startIndex,
      endIndex > _filteredRecords.length ? _filteredRecords.length : endIndex,
    );
  }

  int get _totalPages => (_filteredRecords.length / _rowsPerPage).ceil();

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
      
      _filteredRecords.sort((a, b) {
        var aValue = _getValueForColumn(a, column);
        var bValue = _getValueForColumn(b, column);
        
        int comparison = aValue.compareTo(bValue);
        return _sortAscending ? comparison : -comparison;
      });
    });
  }

  dynamic _getValueForColumn(SIIPRecord record, String column) {
    switch (column) {
      case 'id':
        return record.id;
      case 'appointment':
        return record.appointment;
      case 'measure':
        return record.measure;
      case 'status':
        return record.status;
      case 'phone':
        return record.phone;
      case 'earnings':
        return record.earnings;
      case 'potential':
        return record.potential;
      default:
        return record.id;
    }
  }

  String _formatCurrency(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
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
                      'SIIP Detailed Report',
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
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // For mobile devices, stack filters vertically
                  if (constraints.maxWidth < 600) {
                    return Column(
                      children: [
                        // First row - 2 columns
                        Row(
                          children: [
                            Expanded(
                              child: _buildFilterField(
                                controller: _idFilterController,
                                hint: 'ID...',
                                onChanged: (_) => _applyFilters(),
                              ),
                            ),
                            SizedBox(width: padding),
                            Expanded(
                              child: _buildFilterField(
                                controller: _apptFilterController,
                                hint: 'Appt...',
                                onChanged: (_) => _applyFilters(),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: padding),
                        // Second row - 2 columns
                        Row(
                          children: [
                            Expanded(
                              child: _buildFilterDropdown(
                                value: _measureFilter,
                                items: ['', 'AWV', 'HBD'],
                                hint: 'Measure',
                                onChanged: (value) {
                                  _measureFilter = value ?? '';
                                  _applyFilters();
                                },
                              ),
                            ),
                            SizedBox(width: padding),
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
                          ],
                        ),
                        SizedBox(height: padding),
                        // Third row - 3 columns
                        Row(
                          children: [
                            Expanded(
                              child: _buildFilterField(
                                controller: _phoneFilterController,
                                hint: 'Phone...',
                                onChanged: (_) => _applyFilters(),
                              ),
                            ),
                            SizedBox(width: padding),
                            Expanded(
                              child: _buildFilterField(
                                controller: _earningsFilterController,
                                hint: 'Earnings...',
                                onChanged: (_) => _applyFilters(),
                              ),
                            ),
                            SizedBox(width: padding),
                            Expanded(
                              child: _buildFilterField(
                                controller: _potentialFilterController,
                                hint: 'Potential...',
                                onChanged: (_) => _applyFilters(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else {
                    // For larger screens, use the original layout
                    return Column(
                      children: [
                        // First row of filters - 4 columns for better fit
                        Row(
                          children: [
                            Expanded(
                              child: _buildFilterField(
                                controller: _idFilterController,
                                hint: 'ID...',
                                onChanged: (_) => _applyFilters(),
                              ),
                            ),
                            SizedBox(width: padding),
                            Expanded(
                              child: _buildFilterField(
                                controller: _apptFilterController,
                                hint: 'Appt...',
                                onChanged: (_) => _applyFilters(),
                              ),
                            ),
                            SizedBox(width: padding),
                            Expanded(
                              child: _buildFilterDropdown(
                                value: _measureFilter,
                                items: ['', 'AWV', 'HBD'],
                                hint: 'Measure',
                                onChanged: (value) {
                                  _measureFilter = value ?? '';
                                  _applyFilters();
                                },
                              ),
                            ),
                            SizedBox(width: padding),
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
                          ],
                        ),
                        SizedBox(height: padding),
                        // Second row of filters - 3 columns for better fit
                        Row(
                          children: [
                            Expanded(
                              child: _buildFilterField(
                                controller: _phoneFilterController,
                                hint: 'Phone...',
                                onChanged: (_) => _applyFilters(),
                              ),
                            ),
                            SizedBox(width: padding),
                            Expanded(
                              child: _buildFilterField(
                                controller: _earningsFilterController,
                                hint: 'Earnings...',
                                onChanged: (_) => _applyFilters(),
                              ),
                            ),
                            SizedBox(width: padding),
                            Expanded(
                              child: _buildFilterField(
                                controller: _potentialFilterController,
                                hint: 'Potential...',
                                onChanged: (_) => _applyFilters(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                },
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
                            _buildDataColumn('ID', 'id', fontSize),
                            _buildDataColumn('APPT', 'appointment', fontSize),
                            _buildDataColumn('MEASURE', 'measure', fontSize),
                            _buildDataColumn('STATUS', 'status', fontSize),
                            _buildDataColumn('PHONE', 'phone', fontSize),
                            _buildDataColumn('EARNINGS', 'earnings', fontSize),
                            _buildDataColumn('POTENTIAL', 'potential', fontSize),
                          ],
                          rows: _paginatedRecords.map((record) {
                            return DataRow(
                              cells: [
                                DataCell(Text(record.id)),
                                DataCell(Text(record.appointment)),
                                DataCell(Text(record.measure)),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: record.status == 'Completed' 
                                          ? Colors.green.shade100 
                                          : Colors.blue.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: record.status == 'Completed' 
                                            ? Colors.green.shade300 
                                            : Colors.blue.shade300,
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      record.status,
                                      style: TextStyle(
                                        color: record.status == 'Completed' 
                                            ? Colors.green.shade700 
                                            : Colors.blue.shade700,
                                        fontSize: fontSize - 1,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(Text(record.phone)),
                                DataCell(
                                  Text(
                                    _formatCurrency(record.earnings),
                                    style: TextStyle(
                                      color: record.earnings > 0 ? Colors.green.shade700 : Colors.grey.shade600,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    _formatCurrency(record.potential),
                                    style: TextStyle(
                                      color: Colors.blue.shade700,
                                      fontWeight: FontWeight.w500,
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
    final endIndex = (_currentPage * _rowsPerPage).clamp(0, _filteredRecords.length);
    
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
                      'Showing $startIndex-$endIndex of ${_filteredRecords.length}',
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
                      'Showing $startIndex-$endIndex of ${_filteredRecords.length}',
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
    _idFilterController.dispose();
    _apptFilterController.dispose();
    _phoneFilterController.dispose();
    _earningsFilterController.dispose();
    _potentialFilterController.dispose();
    super.dispose();
  }
}

class SIIPRecord {
  final String id;
  final String appointment;
  final String measure;
  final String status;
  final String phone;
  final double earnings;
  final double potential;

  SIIPRecord({
    required this.id,
    required this.appointment,
    required this.measure,
    required this.status,
    required this.phone,
    required this.earnings,
    required this.potential,
  });
}
