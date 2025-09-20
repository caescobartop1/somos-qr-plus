import 'package:flutter/material.dart';

class AppDrawerWidget extends StatelessWidget {
  final bool isOpen;
  final VoidCallback onClose;
  final Function(String) onNavigation;
  final String activeRoute;

  const AppDrawerWidget({
    super.key,
    required this.isOpen,
    required this.onClose,
    required this.onNavigation,
    required this.activeRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Drawer Overlay
        if (isOpen)
          GestureDetector(
            onTap: onClose,
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
        
        // Navigation Drawer
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          left: isOpen ? 0 : -280,
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
                              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: const Color(0xFF4CAF50), width: 3),
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
                          _buildDrawerItem('Dashboard', Icons.dashboard, activeRoute == 'dashboard', () => onNavigation('dashboard')),
                          _buildDrawerItem('Quality Score Cards', Icons.assessment, activeRoute == 'quality', () => onNavigation('quality')),
                          _buildDrawerItem('My Schedule', Icons.schedule, activeRoute == 'schedule', () => onNavigation('schedule')),
                          _buildDrawerItem('My Patients', Icons.people, activeRoute == 'patients', () => onNavigation('patients')),
                          _buildDrawerItem('Reports', Icons.bar_chart, activeRoute == 'reports', () => onNavigation('reports')),
                          _buildDrawerItem('Resources', Icons.folder, activeRoute == 'resources', () => onNavigation('resources')),
                          
                          // Divider
                          Container(
                            height: 1,
                            color: const Color(0xFFE0E0E0),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          
                          _buildDrawerItem('Settings', Icons.settings, activeRoute == 'settings', () => onNavigation('settings')),
                          _buildDrawerItem('Log Out', Icons.logout, false, () => onNavigation('logout')),
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
    );
  }

  Widget _buildDrawerItem(String title, IconData icon, bool isActive, VoidCallback onTap) {
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
