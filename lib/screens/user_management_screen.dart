import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:somos_qr_plus/controllers/auth_controller.dart';
import 'package:somos_qr_plus/models/staff_login.dart';
import 'package:somos_qr_plus/widgets/provider_dropdown_widget.dart';
import '../helpers/route_helper.dart';
import '../widgets/app_header_widget.dart';
import '../widgets/app_drawer_widget.dart';
import 'package:somos_qr_plus/controllers/practice_controller.dart';
import 'package:somos_qr_plus/models/provider.dart';

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
  final List<Map<String, dynamic>> _users = [];

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

  int get _totalPages => (_filteredUsers.length / _itemsPerPage).ceil();
  Provider _selectedIncentiveProvider = new Provider(name: 'All', id: '-1');

  @override
  void initState() {
    super.initState();
    final c = Get.find<PracticeController>();
    _selectedIncentiveProvider = c.defaultProvider;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Reemplaza '522248589' por el practiceId actual
      await c.getUserManagement(_selectedIncentiveProvider.id);
      await c.getInvitationRoles();
      await c.getPractice('');
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PracticeController>(builder: (c) {
      return SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              Column(
                children: [
                  // Header
                  AppHeaderWidget(
                    onMenuPressed: () {
                      setState(() => _isDrawerOpen = true);
                    },
                    onProfileAction: (action) => _handleProfileAction(action),
                  ),

                  // Contenido principal
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey.shade200)),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: ProviderDropdownWidget(
                                    selectedProvider:
                                        _selectedIncentiveProvider,
                                    providers: c.practices,
                                    onProviderChanged: (provider) {
                                      setState(() {
                                        _selectedIncentiveProvider = provider;
                                      });
                                      final c = Get.find<PracticeController>();
                                      c.getUserManagement(
                                          _selectedIncentiveProvider.id);
                                      _showSuccessMessage(
                                          'Showing data for ${provider.name}');
                                    },
                                    maxWidth: 300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Text(
                            'User Management',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Search
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
                                      setState(() => _currentPage = 1);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Cards de usuarios obtenidos del controlador
                          ..._buildUserCards(c.usersAccounts),

                          const SizedBox(height: 16),

                          // Paginación (si decides paginar en local)
                          _buildPagination(c.usersAccounts),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (_isDrawerOpen)
                GestureDetector(
                  onTap: () => setState(() => _isDrawerOpen = false),
                  child: Container(color: Colors.transparent),
                ),
              AppDrawerWidget(
                isOpen: _isDrawerOpen,
                onClose: () => setState(() => _isDrawerOpen = false),
                onNavigation: (route) {
                  setState(() => _isDrawerOpen = false);
                  _handleNavigation(route);
                },
                activeRoute: 'user-management',
              ),
            ],
          ),
        ),
      );
    });
  }

  List<StaffLogin> getFilteredUsers(List<StaffLogin> users) {
    if (_searchController.text.isEmpty) return users;
    return users
        .where((u) =>
            u.fullName
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()) ||
            u.roleName
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
        .toList();
  }

  List<Widget> _buildUserCards(List<StaffLogin> users) {
    final filtered = getFilteredUsers(users);
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    final paginated = filtered.sublist(
      startIndex,
      endIndex > filtered.length ? filtered.length : endIndex,
    );

    return paginated
        .map((u) => _buildMobileUserCard(u.fullName, u.roleName,
            u.userLastLogin?.toString() ?? 'Never', u.isVerified, u.id))
        .toList();
  }

  Widget _buildPagination(List<StaffLogin> users) {
    final filtered = getFilteredUsers(users);
    final totalPages = (filtered.length / _itemsPerPage).ceil();
    if (totalPages <= 1) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed:
              _currentPage > 1 ? () => setState(() => _currentPage--) : null,
          icon: const Icon(Icons.chevron_left, color: Color(0xFF666666)),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
          onPressed: _currentPage < totalPages
              ? () => setState(() => _currentPage++)
              : null,
          icon: const Icon(Icons.chevron_right, color: Color(0xFF666666)),
        ),
      ],
    );
  }

  Widget _buildMobileUserCard(
      String name, String role, String lastLogin, bool isActive, int id) {
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
                onChanged: (value) async {
                  final c = Get.find<PracticeController>();
                  if (value) {
                    await c.enableUserAccount(
                      userId: id,
                      practiceId: _selectedIncentiveProvider.id,
                    );
                  } else {
                    await c.disableUserAccount(
                      userId: id,
                      practiceId: _selectedIncentiveProvider.id,
                    );
                  }
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
              onPressed: () => _showRoleSelectionDialog(name, role, id),
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

  void _showRoleSelectionDialog(
      String userName, String currentRole, int userId) {
    final c = Get.find<PracticeController>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Role for $userName'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: c.invitationRoles.map((role) {
            return ListTile(
              title: Text(role.name),
              subtitle: role.description.isNotEmpty
                  ? Text(
                      role.description,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    )
                  : null,
              leading: Radio<String>(
                value: role.name,
                groupValue: currentRole,
                onChanged: (value) {
                  Navigator.of(context).pop();
                  // Aquí actualizas el rol en tu lógica local
                  _updateUserRole(userName, value!, userId, role.id);
                },
              ),
            );
          }).toList(),
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

  Future<void> _updateUserRole(
      String userName, String newRole, int userId, int roleId) async {
    final c = Get.find<PracticeController>();
    await c.changeUserRole(
        userId: userId,
        practiceId: _selectedIncentiveProvider.id,
        newRoleId: roleId,
        newRoleName: newRole);
    setState(() {});
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
