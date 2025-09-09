import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:somos_qr_plus/controllers/auth_controller.dart';
import 'package:somos_qr_plus/helpers/route_helper.dart';

class QualityScorecardsScreen extends StatefulWidget {
  const QualityScorecardsScreen({super.key});

  @override
  State<QualityScorecardsScreen> createState() =>
      _QualityScorecardsScreenState();
}

class _QualityScorecardsScreenState extends State<QualityScorecardsScreen> {
  bool _isDrawerOpen = false;
  String _selectedProvider = 'All';
  bool _showNotifications = false;
  int _notificationCount = 3;
  int _unreadNotifications = 3;

  final List<String> _providers = [
    'All',
    'Delmont Medical, PC',
    'Provider 2',
    'Provider 3',
    'Provider 4',
  ];
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'title': 'New Quality Scorecard Available',
      'message': 'Your Q2 2025 quality scorecard is ready for review.',
      'time': '2 hours ago',
      'icon': '📋',
      'unread': true,
    },
    {
      'id': '2',
      'title': 'Patient Appointment Reminder',
      'message': '5 patients have appointments scheduled for tomorrow.',
      'time': '4 hours ago',
      'icon': '👥',
      'unread': true,
    },
    {
      'id': '3',
      'title': 'Monthly Report Generated',
      'message': 'Your July 2025 performance report has been generated.',
      'time': '1 day ago',
      'icon': '📊',
      'unread': true,
    },
    {
      'id': '4',
      'title': 'Document Upload Complete',
      'message': 'Patient records have been successfully uploaded.',
      'time': '2 days ago',
      'icon': '✅',
      'unread': false,
    },
    {
      'id': '5',
      'title': 'System Maintenance',
      'message': 'Scheduled maintenance completed successfully.',
      'time': '3 days ago',
      'icon': '🔔',
      'unread': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      final initials = (authController.user?.firstName.isNotEmpty == true
              ? authController.user!.firstName[0]
              : '') +
          (authController.user?.lastName.isNotEmpty == true
              ? authController.user!.lastName[0]
              : '');
      final fullName =
          '${authController.user?.firstName ?? ''} ${authController.user?.lastName ?? ''}'
              .trim();

      return SafeArea(
        child: Stack(
          children: [
            Scaffold(
              backgroundColor: const Color(0xFFF5F5F5),
              body: Column(
                children: [
                  // Navigation Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[200]!),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Hamburger Menu
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _isDrawerOpen = true;
                            });
                          },
                          icon: const Icon(
                            Icons.menu,
                            color: Color(0xFF333333),
                            size: 28,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            padding: const EdgeInsets.all(8),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Logo/Title
                        const Expanded(
                          child: Center(
                            child: Text(
                              'SOMOS QR+',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF000000),
                                letterSpacing: 2.0,
                                shadows: [
                                  Shadow(
                                    offset: Offset(0, 0),
                                    blurRadius: 0,
                                    color: Color(0xFF000000),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Provider Dropdown
                        Container(
                          margin: const EdgeInsets.only(right: 16),
                          child: PopupMenuButton<String>(
                            offset: const Offset(0, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            color: Colors.white,
                            child: Container(
                              width: 80, // 👈 ancho fijo
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    // 👈 Para controlar el texto
                                    child: Text(
                                      _selectedProvider,
                                      overflow: TextOverflow
                                          .ellipsis, // 👈 recorta con ...
                                      maxLines: 1,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF333333),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 16,
                                    color: Color(0xFF666666),
                                  ),
                                ],
                              ),
                            ),
                            itemBuilder: (context) =>
                                _providers.map((provider) {
                              return PopupMenuItem<String>(
                                value: provider,
                                child: SizedBox(
                                  width:
                                      180,
                                  child: Text(
                                    provider,
                                    overflow: TextOverflow
                                        .ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: _selectedProvider == provider
                                          ? const Color(0xFF1976D2)
                                          : const Color(0xFF333333),
                                      fontWeight: _selectedProvider == provider
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                            onSelected: (value) {
                              setState(() {
                                _selectedProvider = value;
                              });
                            },
                          ),
                        ),

                        // Notifications
                        _buildNotificationsButton(),

                        const SizedBox(width: 16),

                        // Avatar with Dropdown
                        PopupMenuButton<String>(
                          offset: const Offset(0, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: Colors.white,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                initials,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                          itemBuilder: (context) => [
                            // User Info Section
                            PopupMenuItem<String>(
                              value: 'user_info',
                              enabled: false,
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  children: [
                                    // User Avatar
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF667eea),
                                            Color(0xFF764ba2)
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Center(
                                        child: Text(
                                          initials,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    // User Details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            fullName,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF333333),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            authController.user?.email ?? '',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Divider
                            const PopupMenuDivider(),
                            // Language Option
                            PopupMenuItem<String>(
                              value: 'language',
                              child: Row(
                                children: [
                                  const Text(
                                    'Language',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF333333),
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.flag,
                                          size: 16,
                                          color: Color(0xFF666666),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'English',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Invitations Option
                            const PopupMenuItem<String>(
                              value: 'invitations',
                              child: Text(
                                'Invitations',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF333333),
                                ),
                              ),
                            ),
                            // Log Out Option
                            const PopupMenuItem<String>(
                              value: 'logout',
                              child: Text(
                                'Log Out',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF333333),
                                ),
                              ),
                            ),
                          ],
                          onSelected: (value) {
                            switch (value) {
                              case 'language':
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Language clicked')),
                                );
                                break;
                              case 'invitations':
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Invitations clicked')),
                                );
                                break;
                              case 'logout':
                                authController.logout();
                                break;
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  // Main Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Page Title
                          const Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Text(
                              'Quality Score Cards',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF333333),
                              ),
                            ),
                          ),

                          // Score Cards Table
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                headingRowHeight: 80,
                                dataRowHeight: 60,
                                columnSpacing: 0,
                                border: TableBorder.all(
                                  color: Colors.grey[200]!,
                                  width: 1,
                                ),
                                columns: [
                                  // Measures Column
                                  DataColumn(
                                    label: Container(
                                      padding: const EdgeInsets.all(16),
                                      child: const Text(
                                        'Measures',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF333333),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Closed Section
                                  ...List.generate(
                                      3,
                                      (index) => DataColumn(
                                            label: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFE3F2FD),
                                                border: Border(
                                                  bottom: BorderSide(
                                                      color: Colors.grey[200]!),
                                                ),
                                              ),
                                              child: Column(
                                                children: [
                                                  const Text(
                                                    'Closed',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color(0xFF1976D2),
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    index == 0
                                                        ? 'MCO'
                                                        : index == 1
                                                            ? 'CLAIM'
                                                            : 'EHR*',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )),
                                  // Benchmarks Section
                                  ...List.generate(
                                      3,
                                      (index) => DataColumn(
                                            label: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF3E5F5),
                                                border: Border(
                                                  bottom: BorderSide(
                                                      color: Colors.grey[200]!),
                                                ),
                                              ),
                                              child: Column(
                                                children: [
                                                  const Text(
                                                    'Benchmarks',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color(0xFF7B1FA2),
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    index == 0
                                                        ? '50TH/3 START'
                                                        : index == 1
                                                            ? '75TH/4 START'
                                                            : '90TH/5STAR',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )),
                                  // Hits Needed Section
                                  ...List.generate(
                                      3,
                                      (index) => DataColumn(
                                            label: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFE8F5E8),
                                                border: Border(
                                                  bottom: BorderSide(
                                                      color: Colors.grey[200]!),
                                                ),
                                              ),
                                              child: Column(
                                                children: [
                                                  const Text(
                                                    'Hits Needed',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color(0xFF2E7D32),
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    index == 0
                                                        ? '50TH/3 START'
                                                        : index == 1
                                                            ? '75TH/4 START'
                                                            : '90TH/5STAR',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )),
                                ],
                                rows: [
                                  _buildDataRow(
                                      'COA-PA',
                                      ['123', '456', '789'],
                                      ['50%', '75%', '90%'],
                                      ['10', '20', '30']),
                                  _buildDataRow(
                                      'CCS',
                                      ['234', '567', '890'],
                                      ['55%', '80%', '95%'],
                                      ['15', '25', '35']),
                                  _buildDataRow(
                                      'CAW',
                                      ['345', '678', '901'],
                                      ['60%', '85%', '92%'],
                                      ['12', '22', '32']),
                                  _buildDataRow(
                                      'CBP',
                                      ['456', '789', '012'],
                                      ['65%', '90%', '98%'],
                                      ['18', '28', '38']),
                                  _buildDataRow(
                                      'CBC',
                                      ['567', '890', '123'],
                                      ['70%', '95%', '99%'],
                                      ['25', '35', '45']),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Drawer Overlay
            if (_isDrawerOpen)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isDrawerOpen = false;
                  });
                },
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),

            // Navigation Drawer
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              left: _isDrawerOpen ? 0 : -280,
              top: 0,
              bottom: 0,
              width: 280,
              child: Material(
                color: Colors.white,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(2, 0),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Drawer Header
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: Color(0xFF1976D2),
                        ),
                        child: Column(
                          children: [
                            // Avatar Circle
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF667eea),
                                    Color(0xFF764ba2)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                    color: const Color(0xFF4CAF50), width: 3),
                              ),
                              child: const Center(
                                child: Text(
                                  'JC',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Title
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'SOMOS QR',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w100,
                                    letterSpacing: -1.2,
                                  ),
                                ),
                                const Text(
                                  '+',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w100,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Drawer Content
                      Expanded(
                        child: Container(
                          color: Colors.white,
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: [
                              _buildDrawerItem(
                                  'Dashboard', Icons.dashboard, false, () {
                                Get.toNamed(RouteHelper.getDashboardRoute());
                              }),
                              _buildDrawerItem('Quality Score Cards',
                                  Icons.assessment, true, () {}),
                              _buildDrawerItem(
                                  'My Schedule', Icons.schedule, false, () {}),
                              _buildDrawerItem(
                                  'My Patients', Icons.people, false, () {}),
                              _buildDrawerItem(
                                  'Reports', Icons.bar_chart, false, () {}),
                              _buildDrawerItem(
                                  'Resources', Icons.folder, false, () {}),

                              // Divider
                              Container(
                                height: 1,
                                color: const Color(0xFFE0E0E0),
                                margin: const EdgeInsets.symmetric(vertical: 8),
                              ),

                              _buildDrawerItem(
                                  'Settings', Icons.settings, false, () {
                                Get.toNamed(RouteHelper.getSettingsRoute());
                              }),
                              _buildDrawerItem('Log Out', Icons.logout, false,
                                  () {
                                authController.logout();
                              }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  DataRow _buildDataRow(String measure, List<String> closed,
      List<String> benchmarks, List<String> hitsNeeded) {
    return DataRow(
      cells: [
        DataCell(
          Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              measure,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
          ),
        ),
        ...closed.map((value) => DataCell(
              Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF333333),
                  ),
                ),
              ),
            )),
        ...benchmarks.map((value) => DataCell(
              Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF333333),
                  ),
                ),
              ),
            )),
        ...hitsNeeded.map((value) => DataCell(
              Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF333333),
                  ),
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildNotificationsButton() {
    return PopupMenuButton<String>(
      offset: const Offset(0, 40),
      child: Stack(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.notifications_outlined,
                color: Color(0xFF333333)),
          ),
          if (_unreadNotifications > 0)
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: const BoxDecoration(
                  color: Color(0xFFE74C3C),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Text(
                  _unreadNotifications.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Notifications',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _unreadNotifications = 0;
                        for (var notification in _notifications) {
                          notification['unread'] = false;
                        }
                      });
                      _showSuccessMessage('All notifications marked as read');
                    },
                    child: const Text(
                      'Mark all read',
                      style: TextStyle(color: Color(0xFF667EEA), fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ..._notifications
                  .map((notification) => _buildNotificationItem(notification)),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'View all notifications',
                  style: TextStyle(color: Color(0xFF667EEA), fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: notification['unread'] ? const Color(0xFFF0F7FF) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: notification['unread']
            ? const Border(left: BorderSide(color: Color(0xFF667EEA), width: 3))
            : null,
      ),
      child: Row(
        children: [
          Text(notification['icon'], style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification['title'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification['message'],
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF666666),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification['time'],
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _notifications
                    .removeWhere((n) => n['id'] == notification['id']);
                if (notification['unread']) {
                  _unreadNotifications--;
                }
              });
              _showSuccessMessage('Notification removed');
            },
            icon: const Icon(Icons.close, size: 16, color: Color(0xFF999999)),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
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

  Widget _buildDrawerItem(
      String title, IconData icon, bool isActive, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFE3F2FD) : Colors.transparent,
        border: Border(
          left: BorderSide(
            color: isActive ? const Color(0xFF1976D2) : Colors.transparent,
            width: 3,
          ),
        ),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? const Color(0xFF1976D2) : const Color(0xFF333333),
          size: 20,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: isActive ? const Color(0xFF1976D2) : const Color(0xFF333333),
            fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      ),
    );
  }
}
