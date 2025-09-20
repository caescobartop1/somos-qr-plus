import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:somos_qr_plus/controllers/auth_controller.dart';
import '../helpers/route_helper.dart';
import '../widgets/app_header_widget.dart';
import '../widgets/app_drawer_widget.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  bool _isDrawerOpen = false;
  final TextEditingController _searchController = TextEditingController();
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  // Sample user data
  final List<Map<String, dynamic>> _users = [
    {
      'name': 'Mirza Morales-Diaz',
      'role': 'Admin',
      'status': true,
      'lastLogin': '04/29/2025',
    },
    {
      'name': 'Joel Cedano',
      'role': 'Provider',
      'status': true,
      'lastLogin': '04/28/2025',
    },
    {
      'name': 'Sarah Johnson',
      'role': 'Nurse',
      'status': false,
      'lastLogin': '04/27/2025',
    },
    {
      'name': 'Michael Davis',
      'role': 'Viewer',
      'status': true,
      'lastLogin': '04/26/2025',
    },
    {
      'name': 'Lisa Thompson',
      'role': 'Provider',
      'status': false,
      'lastLogin': '04/25/2025',
    },
  ];

  List<Map<String, dynamic>> get _filteredUsers {
    if (_searchController.text.isEmpty) {
      return _users;
    }
    return _users.where((user) {
      return user['name']
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()) ||
          user['role']
              .toLowerCase()
              .contains(_searchController.text.toLowerCase());
    }).toList();
  }

  List<Map<String, dynamic>> get _paginatedUsers {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    return _filteredUsers.sublist(
      startIndex,
      endIndex > _filteredUsers.length ? _filteredUsers.length : endIndex,
    );
  }

  int get _totalPages => (_filteredUsers.length / _itemsPerPage).ceil();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Page Title
                      const Text(
                        'User Management',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Search/Filter Bar
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search,
                                color: Color(0xFF666666), size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                decoration: const InputDecoration(
                                  hintText: 'Filter',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _currentPage =
                                        1; // Reset to first page when filtering
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Mobile-optimized user cards
                      ..._paginatedUsers
                          .map((user) => _buildMobileUserCard(
                                user['name'],
                                user['role'],
                                user['lastLogin'],
                                user['status'],
                              ))
                          .toList(),

                      const SizedBox(height: 16),

                      // Pagination
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: _currentPage > 1
                                ? () => setState(() => _currentPage--)
                                : null,
                            icon: const Icon(Icons.first_page,
                                color: Color(0xFF666666)),
                          ),
                          IconButton(
                            onPressed: _currentPage > 1
                                ? () => setState(() => _currentPage--)
                                : null,
                            icon: const Icon(Icons.chevron_left,
                                color: Color(0xFF666666)),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1976D2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '$_currentPage',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: _currentPage < _totalPages
                                ? () => setState(() => _currentPage++)
                                : null,
                            icon: const Icon(Icons.chevron_right,
                                color: Color(0xFF666666)),
                          ),
                          IconButton(
                            onPressed: _currentPage < _totalPages
                                ? () =>
                                    setState(() => _currentPage = _totalPages)
                                : null,
                            icon: const Icon(Icons.last_page,
                                color: Color(0xFF666666)),
                          ),
                        ],
                      ),
                    ],
                  ),
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
            activeRoute: 'user-management',
          ),
        ],
      ),
    );
  }

  Widget _buildMobileUserCard(
      String name, String role, String lastLogin, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name and Status Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              Switch(
                value: isActive,
                onChanged: (value) {
                  setState(() {
                    // Update user status
                    final userIndex =
                        _users.indexWhere((user) => user['name'] == name);
                    if (userIndex != -1) {
                      _users[userIndex]['status'] = value;
                    }
                  });
                },
                activeColor: Colors.white,
                activeTrackColor: const Color(0xFF6F42C1),
                inactiveThumbColor: Colors.grey[400],
                inactiveTrackColor: Colors.grey[300],
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Role and Last Login Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Role',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      role,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Last Login',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      lastLogin,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Action Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showRoleSelectionDialog(name, role),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF28A745),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Select Role',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRoleSelectionDialog(String userName, String currentRole) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Role for $userName'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Admin'),
              leading: Radio<String>(
                value: 'Admin',
                groupValue: currentRole,
                onChanged: (value) {
                  Navigator.of(context).pop();
                  _updateUserRole(userName, value!);
                },
              ),
            ),
            ListTile(
              title: const Text('Provider'),
              leading: Radio<String>(
                value: 'Provider',
                groupValue: currentRole,
                onChanged: (value) {
                  Navigator.of(context).pop();
                  _updateUserRole(userName, value!);
                },
              ),
            ),
            ListTile(
              title: const Text('Nurse'),
              leading: Radio<String>(
                value: 'Nurse',
                groupValue: currentRole,
                onChanged: (value) {
                  Navigator.of(context).pop();
                  _updateUserRole(userName, value!);
                },
              ),
            ),
            ListTile(
              title: const Text('Viewer'),
              leading: Radio<String>(
                value: 'Viewer',
                groupValue: currentRole,
                onChanged: (value) {
                  Navigator.of(context).pop();
                  _updateUserRole(userName, value!);
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _updateUserRole(String userName, String newRole) {
    setState(() {
      final userIndex = _users.indexWhere((user) => user['name'] == userName);
      if (userIndex != -1) {
        _users[userIndex]['role'] = newRole;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Role updated to $newRole for $userName'),
        backgroundColor: Colors.green,
      ),
    );
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
        Get.offAllNamed(RouteHelper.getSettingsRoute());
        break;
      case 'logout':
        final authController = Get.find<AuthController>();
        authController.logout();
        break;
    }
  }
}
