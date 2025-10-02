import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:somos_qr_plus/controllers/auth_controller.dart';
import 'package:somos_qr_plus/controllers/practice_controller.dart';
import 'package:somos_qr_plus/helpers/route_helper.dart';
import 'package:somos_qr_plus/widgets/spinner.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/app_header_widget.dart';
import '../widgets/app_drawer_widget.dart';
import '../widgets/two_factor_auth_dialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _twoFactorEnabled = false;
  bool _darkModeEnabled = false;
  bool _isDrawerOpen = false;
  final _password = TextEditingController();
  final _passwordConfirm = TextEditingController();
  final _oldPassword = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final c = Get.find<PracticeController>();
      c.getUserSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: const Color(0xFFF8F9FA),
            body: Column(
              children: [
                // Navigation Header
                AppHeaderWidget(
                  onMenuPressed: () {
                    setState(() {
                      _isDrawerOpen = true;
                    });
                  },
                  onProfileAction: (value) {
                    switch (value) {
                      case 'language':
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Language clicked')),
                        );
                        break;
                      case 'invitations':
                        Get.offAllNamed(RouteHelper.getInvitationsRoute());
                        break;
                      case 'logout':
                        final authController = Get.find<AuthController>();
                        authController.logout();
                        break;
                    }
                  },
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
                            'Settings',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF333333),
                            ),
                          ),
                        ),
                        _buildSettingsCards(),
                      ],
                    ),
                  ),
                ),
              ],
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
            activeRoute: 'settings',
          ),
          // if (_isLoading) LoadingSpinner()
        ],
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
        // Already on settings page
        break;
      case 'logout':
        final authController = Get.find<AuthController>();
        authController.logout();
        break;
    }
  }

  Future<void> _openBugReportForm() async {
    final Uri url = Uri.parse(
        'https://forms.monday.com/forms/1bedf197ce04c17470e11bab777f0ce8?r=use1');

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'No se pudo abrir el navegador';
    }
  }

  Widget _buildSettingsCards() {
    return Column(
      children: [
        _buildSettingCard(
          icon: Icons.bug_report,
          title: 'Report a Bug',
          description: 'Help us improve by reporting issues',
          action: _buildActionButton('Report', () => _openBugReportForm()),
        ),
        const SizedBox(height: 16),
        _buildTappableSettingCard(
          icon: Icons.security,
          title: '2-Step Verification',
          description: 'Add an extra layer of security',
          onTap: _showTwoFactorDialog,
        ),
        const SizedBox(height: 16),
        _buildSettingCard(
          icon: Icons.lock,
          title: 'Change Password',
          description: 'Update your account password',
          action:
              _buildActionButton('Change', () => _showChangePasswordModal()),
        ),
        const SizedBox(height: 16),
        _buildSettingCard(
          icon: Icons.dark_mode,
          title: 'Dark Mode',
          description: 'Switch to dark theme',
          action: _buildToggleSwitch(
            value: _darkModeEnabled,
            onChanged: (value) {
              setState(() {
                _darkModeEnabled = value;
              });
              _showDarkModeMessage(value);
            },
          ),
        ),
        const SizedBox(height: 16),
        _buildTappableSettingCard(
          icon: Icons.mail,
          title: 'Invite',
          description: 'Invite colleagues to join',
          onTap: () => Get.offAllNamed(RouteHelper.getInvitationsRoute()),
        ),
        const SizedBox(height: 16),
        _buildTappableSettingCard(
          icon: Icons.people,
          title: 'Accounts',
          description: 'Manage your account settings',
          onTap: () => Get.offAllNamed(RouteHelper.getUserManagementRoute()),
        ),
      ],
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required String description,
    required Widget action,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF1976D2).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF1976D2),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          action,
        ],
      ),
    );
  }

  Widget _buildTappableSettingCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
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
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF1976D2).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF1976D2),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Icon(
              Icons.chevron_right,
              color: Colors.grey.shade400,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        elevation: 0,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildToggleSwitch({
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xFF1976D2),
      activeTrackColor: const Color(0xFF1976D2).withOpacity(0.3),
      inactiveThumbColor: Colors.grey[400],
      inactiveTrackColor: Colors.grey[300],
    );
  }

  void _showChangePasswordModal() {
    showDialog(
      context: context,
      builder: (context) => _buildChangePasswordDialog(),
    );
  }

  Future<void> _showTwoFactorDialog() async {
    final c = Get.find<PracticeController>();
    await c.getMfaMethods();
    showDialog(
      context: context,
      builder: (context) => TwoFactorAuthDialog(),
    );
  }

  void _showDarkModeMessage(bool enabled) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Dark mode ${enabled ? 'enabled' : 'disabled'}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildChangePasswordDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Change Password',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Color(0xFF666666)),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Form Fields
            _buildFormField(
              label: 'Current Password',
              child: TextField(
                obscureText: true,
                controller: _oldPassword,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),

            _buildFormField(
              label: 'New Password',
              child: TextField(
                obscureText: true,
                controller: _password,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),

            _buildFormField(
              label: 'Confirm New Password',
              child: TextField(
                obscureText: true,
                controller: _passwordConfirm,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF666666),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () async {
                    final authController = Get.find<AuthController>();
                    setState(() {
                      _isLoading = true;
                    });
                    await authController.changePassword(_password.text,
                        _passwordConfirm.text, _oldPassword.text);
                    setState(() {
                      _isLoading = false;
                    });
                    _password.clear();
                    _passwordConfirm.clear();
                    _oldPassword.clear();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Change Password',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
