import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:somos_qr_plus/helpers/route_helper.dart';

import '../controllers/auth_controller.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isDrawerOpen = false;
  bool _isNotificationsOpen = false;
  bool _isProfileOpen = false;
  bool _isScheduleExpanded = true;
  String _selectedProvider = 'All';
  String _selectedIncentiveProvider = 'all';
  int _unreadNotifications = 3;
  bool _showLogoutDialog = false;

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

  final List<Map<String, dynamic>> _appointments = [
    {
      'name': 'Sarah Williams',
      'time': '9:00 AM',
      'tags': ['GIC', 'Confirmed'],
    },
    {
      'name': 'Michael Chen',
      'time': '9:30 AM',
      'tags': ['RA', 'Pending'],
    },
    {
      'name': 'Emily Johnson',
      'time': '10:00 AM',
      'tags': ['GIC', 'RA', 'Confirmed'],
    },
    {
      'name': 'Robert Davis',
      'time': '10:30 AM',
      'tags': ['Cancelled'],
    },
    {
      'name': 'Jennifer Lopez',
      'time': '11:00 AM',
      'tags': ['GIC', 'Confirmed'],
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
      return Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: SafeArea(
          child: Stack(
            children: [
              // Main Content
              Column(
                children: [
                  _buildNavigationHeader(initials, fullName, authController),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildWelcomeSection(),
                          const SizedBox(height: 32),
                          _buildStatisticsGrid(),
                          const SizedBox(height: 32),
                          _buildPanelChart(),
                          const SizedBox(height: 32),
                          _buildIncentiveChart(),
                          const SizedBox(height: 32),
                          _buildScheduleCard(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Drawer Overlay
              if (_isDrawerOpen)
                GestureDetector(
                  onTap: () => setState(() => _isDrawerOpen = false),
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),

              // Navigation Drawer
              if (_isDrawerOpen) _buildNavigationDrawer(authController),

              // Logout Dialog
              if (_showLogoutDialog) _buildLogoutDialog(),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildNavigationHeader(
      String initials, String fullName, AuthController authController) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // Hamburger Menu
            IconButton(
              onPressed: () => setState(() => _isDrawerOpen = true),
              icon: const Icon(Icons.menu, size: 24, color: Color(0xFF333333)),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),

            const SizedBox(width: 8),

            // Logo
            const Expanded(
              child: Text(
                'SOMOS QR+',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF333333),
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Provider Dropdown
            _buildProviderDropdown(),

            const SizedBox(width: 8),

            // Notifications
            _buildNotificationsButton(),

            const SizedBox(width: 8),

            // Profile
            _buildProfileButton(initials, fullName, authController),
          ],
        ),
      ),
    );
  }

  Widget _buildProviderDropdown() {
    return PopupMenuButton<String>(
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: Colors.white,
      child: Container(
        width: 80, // 👈 ancho fijo
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                overflow: TextOverflow.ellipsis, // 👈 recorta con ...
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
      itemBuilder: (context) => _providers.map((provider) {
        return PopupMenuItem<String>(
          value: provider,
          child: SizedBox(
            width: 180, // 👈 también controlas el ancho en la lista
            child: Text(
              provider,
              overflow: TextOverflow.ellipsis, // 👈 mismo efecto
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

  Widget _buildProfileButton(
      String initials, String fullName, AuthController authController) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 40),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
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
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          enabled: false,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Center(
                      child: Text(
                        'JC',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fullName,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Color(0xFF333333),
                          ),
                        ),
                        Text(
                          authController.user?.email ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 32),
              _buildProfileOption('Language', '🇺🇸 English'),
              _buildProfileOption('Invitations', ''),
              GestureDetector(
                  onTap: () {
                    authController.logout();
                  },
                  child: _buildProfileOption('Log Out', '')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileOption(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
            ),
          ),
          if (value.isNotEmpty)
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNavigationDrawer(AuthController authController) {
    return Positioned(
      left: 0,
      top: 0,
      bottom: 0,
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          color: Colors.white,
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
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF1976D2),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      border:
                          Border.all(color: const Color(0xFF4CAF50), width: 3),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'JC',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'SOMOS QR',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w100,
                          letterSpacing: -1.2,
                        ),
                      ),
                      Text(
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

            // Drawer Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem('Dashboard', true),
                  _buildDrawerItem('Quality Score Cards', false, onTap: () {
                    Get.toNamed(RouteHelper.getQualityScoreCardsRoute());
                  }),
                  _buildDrawerItem('My Schedule', false),
                  _buildDrawerItem('My Patients', false),
                  _buildDrawerItem('Reports', false),
                  _buildDrawerItem('Resources', false),
                  const Divider(height: 32),
                  _buildDrawerItem('Settings', false, onTap: () {
                    Get.toNamed(RouteHelper.getSettingsRoute());
                  }),
                  _buildDrawerItem('Log Out', false, onTap: () {
                    authController.logout();
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForItem(String text) {
    switch (text) {
      case 'Dashboard':
        return Icons.dashboard;
      case 'Quality Score Cards':
        return Icons.assessment;
      case 'My Schedule':
        return Icons.schedule;
      case 'My Patients':
        return Icons.people;
      case 'Reports':
        return Icons.bar_chart;
      case 'Resources':
        return Icons.folder;
      case 'Settings':
        return Icons.settings;
      case 'Log Out':
        return Icons.logout;
      default:
        return Icons.help;
    }
  }

  Widget _buildDrawerItem(String text, bool isActive, {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFE3F2FD) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(
            color: isActive ? const Color(0xFF1976D2) : Colors.transparent,
            width: 3,
          ),
        ),
      ),
      child: ListTile(
        leading: Icon(
          _getIconForItem(text),
          color: isActive ? const Color(0xFF1976D2) : const Color(0xFF333333),
          size: 20,
        ),
        title: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
            color: isActive ? const Color(0xFF1976D2) : const Color(0xFF333333),
          ),
        ),
        onTap: onTap ??
            () {
              // Handle navigation
              setState(() => _isDrawerOpen = false);
            },
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back!',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        return GridView.count(
          crossAxisCount: isMobile ? 1 : 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: isMobile ? 16 : 24,
          mainAxisSpacing: isMobile ? 16 : 24,
          childAspectRatio: isMobile ? 2.5 : 1.2,
          children: [
            _buildKPICard('Total Open GIC', '1,250 / 2,100'),
            _buildKPICard('Total Members RA', '1,950 / 2,400'),
            _buildKPICard('Members without visits', '200 / 4,000'),
          ],
        );
      },
    );
  }

  Widget _buildKPICard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: FittedBox(
        alignment: Alignment.topLeft,
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFF666666),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: List.generate(
                5,
                (index) => const Padding(
                  padding: EdgeInsets.only(right: 2),
                  child: Icon(
                    Icons.star,
                    color: Color(0xFFFFC107),
                    size: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              '4.5/5',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF666666),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPanelChart() {
    return Container(
      padding: const EdgeInsets.all(24),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Panel',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 300,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 1000,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const labels = [
                          'Anthem',
                          'Emblem',
                          'Healthfirst',
                          'Humana',
                          'Metroplus',
                          'Molina',
                          'United'
                        ];
                        const abbreviations = [
                          'ANT',
                          'EMB',
                          'HF',
                          'HUM',
                          'MET',
                          'MOL',
                          'UNI'
                        ];
                        if (value >= 0 && value < labels.length) {
                          return Text(
                            abbreviations[value.toInt()],
                            style: const TextStyle(
                                color: Color(0xFF666666), fontSize: 12),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                              color: Color(0xFF666666), fontSize: 12),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  BarChartGroupData(x: 0, barRods: [
                    BarChartRodData(
                        toY: 238, color: const Color(0xFF1976D2), width: 7),
                    BarChartRodData(
                        toY: 714, color: const Color(0xFF4CAF50), width: 7),
                    BarChartRodData(
                        toY: 0, color: const Color(0xFF4DD0E1), width: 7),
                  ]),
                  BarChartGroupData(x: 1, barRods: [
                    BarChartRodData(
                        toY: 238, color: const Color(0xFF1976D2), width: 7),
                    BarChartRodData(
                        toY: 96, color: const Color(0xFF4CAF50), width: 7),
                    BarChartRodData(
                        toY: 0, color: const Color(0xFF4DD0E1), width: 7),
                  ]),
                  BarChartGroupData(x: 2, barRods: [
                    BarChartRodData(
                        toY: 550, color: const Color(0xFF1976D2), width: 7),
                    BarChartRodData(
                        toY: 700, color: const Color(0xFF4CAF50), width: 7),
                    BarChartRodData(
                        toY: 750, color: const Color(0xFF4DD0E1), width: 7),
                  ]),
                  BarChartGroupData(x: 3, barRods: [
                    BarChartRodData(
                        toY: 170, color: const Color(0xFF1976D2), width: 7),
                    BarChartRodData(
                        toY: 240, color: const Color(0xFF4CAF50), width: 7),
                    BarChartRodData(
                        toY: 190, color: const Color(0xFF4DD0E1), width: 7),
                  ]),
                  BarChartGroupData(x: 4, barRods: [
                    BarChartRodData(
                        toY: 476, color: const Color(0xFF1976D2), width: 7),
                    BarChartRodData(
                        toY: 238, color: const Color(0xFF4CAF50), width: 7),
                    BarChartRodData(
                        toY: 0, color: const Color(0xFF4DD0E1), width: 7),
                  ]),
                  BarChartGroupData(x: 5, barRods: [
                    BarChartRodData(
                        toY: 0, color: const Color(0xFF1976D2), width: 7),
                    BarChartRodData(
                        toY: 476, color: const Color(0xFF4CAF50), width: 7),
                    BarChartRodData(
                        toY: 572, color: const Color(0xFF4DD0E1), width: 7),
                  ]),
                  BarChartGroupData(x: 6, barRods: [
                    BarChartRodData(
                        toY: 238, color: const Color(0xFF1976D2), width: 7),
                    BarChartRodData(
                        toY: 96, color: const Color(0xFF4CAF50), width: 7),
                    BarChartRodData(
                        toY: 0, color: const Color(0xFF4DD0E1), width: 7),
                  ]),
                ],
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 200,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.shade300,
                      strokeWidth: 1,
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 600;
              return Wrap(
                alignment: WrapAlignment.center,
                spacing: isMobile ? 16 : 24,
                runSpacing: 8,
                children: [
                  _buildLegendItem(const Color(0xFF1976D2), 'EP'),
                  _buildLegendItem(const Color(0xFF4CAF50), 'MCD'),
                  _buildLegendItem(const Color(0xFF4DD0E1), 'MCR'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF666666),
          ),
        ),
      ],
    );
  }

  Widget _buildIncentiveChart() {
    return Container(
      padding: const EdgeInsets.all(24),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SOMOS Innovation Incentive Program',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 20),

          // Provider Toggles
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 600;
                return Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    _buildProviderToggle('all', 'All'),
                    _buildProviderToggle('emblem', 'Emblem'),
                    _buildProviderToggle('anthem', 'Anthem'),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          // Stats
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Earnings',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF666666),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '\$xx,xxx',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
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
                    const Text(
                      'Potential',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF666666),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '\$xx,xxx',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Chart
          SizedBox(
            height: 300,
            child: PageView(
              children: [
                // First chart - Categories 1-7
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 5000,
                      barTouchData: BarTouchData(enabled: false),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              const labels = [
                                'AWV',
                                'BCS',
                                'CBP',
                                'CCS',
                                'CDC-E',
                                'CDC-1C',
                                'COL'
                              ];
                              if (value >= 0 && value < labels.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    labels[value.toInt()],
                                    style: const TextStyle(
                                        color: Color(0xFF666666), fontSize: 12),
                                  ),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                '\$${value.toInt()}',
                                style: const TextStyle(
                                    color: Color(0xFF666666), fontSize: 12),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: List.generate(7, (index) {
                        final earnings =
                            [1764, 1596, 2142, 1218, 1428, 1932, 1344][index];
                        final potential =
                            [1960, 2240, 1680, 2870, 2520, 1540, 2660][index];

                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: earnings.toDouble(),
                              color: const Color(0xFF388E3C),
                              width: 7,
                            ),
                            BarChartRodData(
                              toY: potential.toDouble(),
                              color: const Color(0xFFA5D6A7),
                              width: 7,
                            ),
                          ],
                        );
                      }),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 1000,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey.shade300,
                            strokeWidth: 1,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                // Second chart - Categories 8-14
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 5000,
                      barTouchData: BarTouchData(enabled: false),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              const labels = [
                                'PCR',
                                'POD',
                                'PPC',
                                'SAA',
                                'W30',
                                'WCV',
                                'HVL'
                              ];
                              if (value >= 0 && value < labels.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    labels[value.toInt()],
                                    style: const TextStyle(
                                        color: Color(0xFF666666), fontSize: 12),
                                  ),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                '\$${value.toInt()}',
                                style: const TextStyle(
                                    color: Color(0xFF666666), fontSize: 12),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: List.generate(7, (index) {
                        final earnings =
                            [2016, 1638, 1848, 1512, 2184, 1722, 1554][index];
                        final potential =
                            [1400, 2170, 1820, 2380, 1260, 2030, 2310][index];

                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: earnings.toDouble(),
                              color: const Color(0xFF388E3C),
                              width: 7,
                            ),
                            BarChartRodData(
                              toY: potential.toDouble(),
                              color: const Color(0xFFA5D6A7),
                              width: 7,
                            ),
                          ],
                        );
                      }),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 1000,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey.shade300,
                            strokeWidth: 1,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Legend
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 600;
              return Wrap(
                alignment: WrapAlignment.center,
                spacing: isMobile ? 16 : 24,
                runSpacing: 8,
                children: [
                  _buildLegendItem(const Color(0xFF388E3C), 'Earnings'),
                  _buildLegendItem(const Color(0xFFA5D6A7), 'Potential'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProviderToggle(String provider, String label) {
    final isActive = _selectedIncentiveProvider == provider;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIncentiveProvider = provider;
        });
        _showSuccessMessage(
            'Showing data for ${provider == 'all' ? 'All providers' : label}');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF1976D2) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isActive ? Colors.white : const Color(0xFF666666),
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleCard() {
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
          // Header
          Padding(
            padding: EdgeInsets.only(top: 16, left: 16, bottom: 16, right: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Today's Schedule",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        // Navigate to schedule page
                      },
                      icon: const Text('📅'),
                      label: const Text(
                        'View All',
                        style: TextStyle(color: Color(0xFF1976D2)),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isScheduleExpanded = !_isScheduleExpanded;
                        });
                      },
                      icon: Icon(
                        _isScheduleExpanded
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_right,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Content
          if (_isScheduleExpanded)
            ..._appointments
                .map((appointment) => _buildAppointmentItem(appointment)),
        ],
      ),
    );
  }

  Widget _buildAppointmentItem(Map<String, dynamic> appointment) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  appointment['time'],
                  style: const TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Wrap(
            spacing: 8,
            children: (appointment['tags'] as List<String>).map((tag) {
              Color backgroundColor;
              Color textColor;

              switch (tag) {
                case 'GIC':
                  backgroundColor = const Color(0xFFE3F2FD);
                  textColor = const Color(0xFF1976D2);
                  break;
                case 'RA':
                  backgroundColor = const Color(0xFFF3E5F5);
                  textColor = const Color(0xFF7B1FA2);
                  break;
                case 'Confirmed':
                  backgroundColor = const Color(0xFFE8F5E8);
                  textColor = const Color(0xFF2E7D32);
                  break;
                case 'Pending':
                  backgroundColor = const Color(0xFFFFF3E0);
                  textColor = const Color(0xFFF57C00);
                  break;
                case 'Cancelled':
                  backgroundColor = const Color(0xFFFFEBEE);
                  textColor = const Color(0xFFC62828);
                  break;
                default:
                  backgroundColor = Colors.grey.shade200;
                  textColor = Colors.grey.shade700;
              }

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutDialog() {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
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
                child: Column(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Color(0xFFDC3545),
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                      ),
                      child: const Icon(
                        Icons.logout,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Log Out',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
              ),

              // Body
              const Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      'Are you sure you want to log out of your account?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF333333),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "You'll need to sign in again to access your dashboard.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                      ),
                      textAlign: TextAlign.center,
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
                          setState(() => _showLogoutDialog = false);
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
                          setState(() => _showLogoutDialog = false);
                          // Handle logout
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDC3545),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Log Out',
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
