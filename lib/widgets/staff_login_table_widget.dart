import 'package:flutter/material.dart';

class StaffLoginTableWidget extends StatefulWidget {
  const StaffLoginTableWidget({super.key});

  @override
  State<StaffLoginTableWidget> createState() => _StaffLoginTableWidgetState();
}

class _StaffLoginTableWidgetState extends State<StaffLoginTableWidget> {
  List<StaffMember> _staff = [];
  List<StaffMember> _filteredStaff = [];
  String _sortColumn = 'name';
  bool _sortAscending = true;
  
  // Pagination
  int _currentPage = 1;
  int _rowsPerPage = 10;
  
  // Filter controllers
  final TextEditingController _nameFilterController = TextEditingController();
  final TextEditingController _userFilterController = TextEditingController();
  final TextEditingController _loginFilterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSampleData();
    _applyFilters();
  }

  void _loadSampleData() {
    _staff = [
      StaffMember(
        name: 'Mirza Morales-Diaz',
        username: 'broadwayinternalmed@gmail.com',
        lastLogin: '04-29-2025',
      ),
      StaffMember(
        name: 'Joel Cedano',
        username: 'joel.cedano@somos.com',
        lastLogin: '07-29-2025',
      ),
      StaffMember(
        name: 'Maria Garcia',
        username: 'maria.garcia@somos.com',
        lastLogin: '07-28-2025',
      ),
      StaffMember(
        name: 'John Smith',
        username: 'john.smith@somos.com',
        lastLogin: '07-27-2025',
      ),
      StaffMember(
        name: 'Michael Brown',
        username: 'michael.brown@somos.com',
        lastLogin: '07-26-2025',
      ),
      StaffMember(
        name: 'Sarah Chen',
        username: 'sarah.chen@somos.com',
        lastLogin: '07-25-2025',
      ),
      StaffMember(
        name: 'David Wilson',
        username: 'david.wilson@somos.com',
        lastLogin: '07-24-2025',
      ),
      StaffMember(
        name: 'Lisa Rodriguez',
        username: 'lisa.rodriguez@somos.com',
        lastLogin: '07-23-2025',
      ),
      StaffMember(
        name: 'Robert Johnson',
        username: 'robert.johnson@somos.com',
        lastLogin: '07-22-2025',
      ),
      StaffMember(
        name: 'Jennifer Davis',
        username: 'jennifer.davis@somos.com',
        lastLogin: '07-21-2025',
      ),
      StaffMember(
        name: 'Amanda Thompson',
        username: 'amanda.thompson@somos.com',
        lastLogin: '07-20-2025',
      ),
      StaffMember(
        name: 'Christopher Lee',
        username: 'chris.lee@somos.com',
        lastLogin: '07-19-2025',
      ),
      StaffMember(
        name: 'Jessica Martinez',
        username: 'jessica.martinez@somos.com',
        lastLogin: '07-18-2025',
      ),
      StaffMember(
        name: 'Daniel Anderson',
        username: 'daniel.anderson@somos.com',
        lastLogin: '07-17-2025',
      ),
      StaffMember(
        name: 'Emily Taylor',
        username: 'emily.taylor@somos.com',
        lastLogin: '07-16-2025',
      ),
    ];
    _filteredStaff = List.from(_staff);
  }

  void _applyFilters() {
    setState(() {
      _filteredStaff = _staff.where((member) {
        final nameMatch = member.name.toLowerCase().contains(_nameFilterController.text.toLowerCase());
        final userMatch = member.username.toLowerCase().contains(_userFilterController.text.toLowerCase());
        final loginMatch = member.lastLogin.contains(_loginFilterController.text);
        
        return nameMatch && userMatch && loginMatch;
      }).toList();
      _currentPage = 1; // Reset to first page when filtering
    });
  }

  List<StaffMember> get _paginatedStaff {
    final startIndex = (_currentPage - 1) * _rowsPerPage;
    final endIndex = startIndex + _rowsPerPage;
    return _filteredStaff.sublist(
      startIndex,
      endIndex > _filteredStaff.length ? _filteredStaff.length : endIndex,
    );
  }

  int get _totalPages => (_filteredStaff.length / _rowsPerPage).ceil();

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
      
      _filteredStaff.sort((a, b) {
        var aValue = _getValueForColumn(a, column);
        var bValue = _getValueForColumn(b, column);
        
        int comparison = aValue.compareTo(bValue);
        return _sortAscending ? comparison : -comparison;
      });
    });
  }

  dynamic _getValueForColumn(StaffMember member, String column) {
    switch (column) {
      case 'name':
        return member.name;
      case 'username':
        return member.username;
      case 'lastLogin':
        return member.lastLogin;
      default:
        return member.name;
    }
  }

  String _getInitials(String name) {
    final names = name.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    } else if (names.length == 1) {
      return names[0][0].toUpperCase();
    }
    return '';
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
                      'Staff Login Detailed Report',
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
              child: Row(
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
                    child: _buildFilterField(
                      controller: _userFilterController,
                      hint: 'Username...',
                      onChanged: (_) => _applyFilters(),
                    ),
                  ),
                  SizedBox(width: padding),
                  Expanded(
                    child: _buildFilterField(
                      controller: _loginFilterController,
                      hint: 'Login Date...',
                      onChanged: (_) => _applyFilters(),
                    ),
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
                            _buildDataColumn('USERNAME', 'username', fontSize),
                            _buildDataColumn('LAST LOGIN', 'lastLogin', fontSize),
                          ],
                          rows: _paginatedStaff.map((member) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  Row(
                                    children: [
                                      Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF9C27B0),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Center(
                                          child: Text(
                                            _getInitials(member.name),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          member.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    member.username,
                                    style: TextStyle(
                                      color: Colors.blue.shade700,
                                      fontSize: fontSize - 1,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    member.lastLogin,
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: fontSize - 1,
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
    final endIndex = (_currentPage * _rowsPerPage).clamp(0, _filteredStaff.length);
    
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
                      'Showing $startIndex-$endIndex of ${_filteredStaff.length}',
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
                      'Showing $startIndex-$endIndex of ${_filteredStaff.length}',
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

  @override
  void dispose() {
    _nameFilterController.dispose();
    _userFilterController.dispose();
    _loginFilterController.dispose();
    super.dispose();
  }
}

class StaffMember {
  final String name;
  final String username;
  final String lastLogin;

  StaffMember({
    required this.name,
    required this.username,
    required this.lastLogin,
  });
}
