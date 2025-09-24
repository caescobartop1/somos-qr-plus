import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:somos_qr_plus/controllers/auth_controller.dart';
import 'package:somos_qr_plus/controllers/practice_controller.dart';

class AppHeaderWidget extends StatefulWidget {
  final VoidCallback onMenuPressed;
  final Function(String) onProfileAction;

  const AppHeaderWidget({
    super.key,
    required this.onMenuPressed,
    required this.onProfileAction,
  });

  @override
  State<AppHeaderWidget> createState() => _AppHeaderWidgetState();
}

class _AppHeaderWidgetState extends State<AppHeaderWidget> {
  late final PracticeController _practiceController;

  @override
  void initState() {
    super.initState();
    // obtenemos la instancia y llamamos al método de carga
    _practiceController = Get.find<PracticeController>();
    _practiceController.getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PracticeController>(builder: (practiceController) {
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
                  onPressed: widget.onMenuPressed,
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

              // Center - Logo/Title
              const Center(
                child: Text(
                  'SOMOS QR+',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF000000),
                    letterSpacing: 2.0,
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
                            onPressed: null,
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
                              child: Text(
                                practiceController.notifications.length
                                    .toString(),
                                style: const TextStyle(
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
                        const PopupMenuItem<String>(
                          value: 'header',
                          enabled: false,
                          child: Text(
                            'Notifications',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF333333),
                            ),
                          ),
                        ),
                        const PopupMenuDivider(),
                        if (practiceController.notifications.isEmpty)
                          const PopupMenuItem<String>(
                            value: 'empty',
                            enabled: false,
                            child: Text('No notifications'),
                          )
                        else
                          ...practiceController.notifications
                              .map((n) => PopupMenuItem<String>(
                                    value: 'notification_${n.id}',
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          n.title,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          n.message,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF666666),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                        const PopupMenuDivider(),
                        const PopupMenuItem<String>(
                          value: 'mark_all_read',
                          child: Row(
                            children: [
                              Icon(Icons.done_all,
                                  size: 16, color: Color(0xFF666666)),
                              SizedBox(width: 8),
                              Text('Mark All Read'),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'mark_all_read') {
                          // acción para marcar todas como leídas
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
                        ),
                        child: Center(
                          child: Text(
                            initials,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem<String>(
                          value: 'user_info',
                          enabled: false,
                          child: Text(fullName),
                        ),
                        const PopupMenuDivider(),
                        const PopupMenuItem<String>(
                          value: 'logout',
                          child: Text('Log Out'),
                        ),
                      ],
                      onSelected: widget.onProfileAction,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      });
    });
  }
}
