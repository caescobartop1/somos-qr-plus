import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:somos_qr_plus/controllers/auth_controller.dart';

class AppHeaderWidget extends StatelessWidget {
  final VoidCallback onMenuPressed;
  final Function(String) onProfileAction;

  const AppHeaderWidget({
    super.key,
    required this.onMenuPressed,
    required this.onProfileAction,
  });

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
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
        child: Stack(
          children: [
            // Left side - Hamburger Menu
            Positioned(
              left: 8,
              top: 0,
              bottom: 0,
              child: IconButton(
                onPressed: onMenuPressed,
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
            ),

            // Center - Logo/Title (perfectly centered)
            const Center(
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

            // Right side - Notifications and Profile
            Positioned(
              right: 8,
              top: 0,
              bottom: 0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Notifications Button
                  PopupMenuButton<String>(
                    offset: const Offset(0, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.white,
                    child: Stack(
                      children: [
                        IconButton(
                          onPressed: null, // Handled by PopupMenuButton
                          icon: const Icon(
                            Icons.notifications_outlined,
                            color: Color(0xFF333333),
                            size: 24,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            padding: const EdgeInsets.all(8),
                          ),
                        ),
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              '3',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    itemBuilder: (context) => [
                      // Header
                      PopupMenuItem<String>(
                        value: 'header',
                        enabled: false,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF1976D2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                child: const Icon(
                                  Icons.notifications,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Notifications',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF333333),
                                      ),
                                    ),
                                    Text(
                                      '3 unread',
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
                        ),
                      ),
                      // Divider
                      const PopupMenuDivider(),
                      // Sample Notifications
                      PopupMenuItem<String>(
                        value: 'notification_1',
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'New Quality Scorecard Available',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF333333),
                              ),
                            ),
                            Text(
                              'Your Q2 2025 quality scorecard is ready for review.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF666666),
                              ),
                            ),
                            Text(
                              '2 hours ago',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF999999),
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'notification_2',
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Patient Appointment Reminder',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF333333),
                              ),
                            ),
                            Text(
                              '5 patients have appointments scheduled for tomorrow.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF666666),
                              ),
                            ),
                            Text(
                              '4 hours ago',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF999999),
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'notification_3',
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Monthly Report Generated',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF333333),
                              ),
                            ),
                            Text(
                              'Your July 2025 performance report has been generated.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF666666),
                              ),
                            ),
                            Text(
                              '1 day ago',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF999999),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Divider
                      const PopupMenuDivider(),
                      // Mark All Read
                      PopupMenuItem<String>(
                        value: 'mark_all_read',
                        child: Row(
                          children: [
                            const Icon(Icons.done_all,
                                size: 16, color: Color(0xFF666666)),
                            const SizedBox(width: 8),
                            const Text(
                              'Mark All Read',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF666666),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'mark_all_read') {
                        // Handle mark all read
                      } else if (value.startsWith('notification_')) {
                        // Handle individual notification
                      }
                    },
                  ),
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
                      child: const Center(
                        child: Text(
                          'JC',
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
                          padding: const EdgeInsets.symmetric(vertical: 8),
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
                                child: const Center(
                                  child: Text(
                                    'JC',
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Joel Cedano',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF333333),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'jcedano@somosipa.com',
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
                    onSelected: onProfileAction,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
