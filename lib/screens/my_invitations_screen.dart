import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:somos_qr_plus/controllers/practice_controller.dart';
import 'package:somos_qr_plus/helpers/route_helper.dart';

import 'package:somos_qr_plus/models/my_invites.dart';
import 'package:somos_qr_plus/widgets/spinner.dart';
import '../widgets/app_header_widget.dart';
import '../widgets/app_drawer_widget.dart';
import 'package:somos_qr_plus/controllers/auth_controller.dart';

class MyInvitationsScreen extends StatefulWidget {
  const MyInvitationsScreen({super.key});

  @override
  State<MyInvitationsScreen> createState() => _MyInvitationsScreenState();
}

class _MyInvitationsScreenState extends State<MyInvitationsScreen>
    with SingleTickerProviderStateMixin {
  bool _isDrawerOpen = false;
  late TabController _tabController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Llamar al controlador para traer los datos
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final c = Get.find<PracticeController>();
    //   c.getMyInvitations();
    // });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PracticeController>(builder: (c) {
      final invites = c.myInvites;
      final pending = invites.where((i) => i.status == 'pending').toList();
      final accepted = invites.where((i) => i.status != 'pending').toList();

      return SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          body: Stack(
            children: [
              Column(
                children: [
                  AppHeaderWidget(
                    onMenuPressed: () => setState(() => _isDrawerOpen = true),
                    onProfileAction: (action) => _handleProfileAction(action),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Expanded(
                                    child: Text(
                                      'My Invitations',
                                      style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF333333),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => Get.offAllNamed(
                                        RouteHelper.getInvitationsRoute()),
                                    icon: const Icon(Icons.arrow_back,
                                        color: Color(0xFF333333)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Manage invitations you\'ve received',
                                style: TextStyle(
                                    fontSize: 16, color: Color(0xFF666666)),
                              ),
                            ],
                          ),
                        ),

                        // Tabs
                        Container(
                          padding: const EdgeInsets.all(16),
                          color: Colors.white,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Row(
                              children: ['Pending', 'Accepted']
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                final index = entry.key;
                                final name = entry.value;
                                final selected = _tabController.index == index;
                                return Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      _tabController.animateTo(index);
                                      setState(() {});
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      decoration: BoxDecoration(
                                        color: selected
                                            ? const Color(0xFF1976D2)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        name,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: selected
                                              ? Colors.white
                                              : Colors.grey.shade700,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),

                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              _buildList(pending, 'pending'),
                              _buildList(accepted, 'accepted'),
                            ],
                          ),
                        ),
                      ],
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
                activeRoute: 'my-invitations',
              ),
              if (_isLoading) LoadingSpinner()
            ],
          ),
        ),
      );
    });
  }

  Widget _buildList(List<MyInvite> list, String type) {
    if (list.isEmpty) {
      final icon = type == 'pending' ? Icons.inbox : Icons.check_circle_outline;
      final msg = type == 'pending'
          ? 'No pending invitations'
          : 'No accepted invitations';
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(msg, style: const TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (_, i) => _buildCard(list[i]),
    );
  }

  Widget _buildCard(MyInvite inv) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(inv.firstName + ' ' + inv.lastName,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333))),
              ),
              _chip(inv.status),
            ],
          ),
          const SizedBox(height: 12),
          Text('Email: ${inv.email}'),
          if (inv.phoneNumber.isNotEmpty) Text('Phone: ${inv.phoneNumber}'),
          const SizedBox(height: 4),
          Text('Request #: ${inv.requestNumber}'),
          if (inv.practiceNames.isNotEmpty)
            Text('Practices: ${inv.practiceNames.join(", ")}'),
          if (inv.status.toLowerCase() == 'pending') ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final c = Get.find<PracticeController>();
                      setState(() {
                        _isLoading = true;
                      });
                      bool res = await c.denyInvitation(inv.id);
                      setState(() {
                        _isLoading = false;
                      });
                      if (!res) {
                        return;
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Invitation declined successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Decline'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final c = Get.find<PracticeController>();
                      setState(() {
                        _isLoading = true;
                      });
                      bool res = await c.acceptInvitation(inv.id);
                      setState(() {
                        _isLoading = false;
                      });
                      if (!res) {
                        return;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Invitation accepted successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1976D2),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Accept'),
                  ),
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }

  Widget _chip(String status) {
    Color bg, fg;
    final normalized = status.toLowerCase();

    switch (normalized) {
      case 'pending':
        bg = Colors.orange[100]!;
        fg = Colors.orange[800]!;
        break;
      case 'accepted':
        bg = Colors.green[100]!;
        fg = Colors.green[800]!;
        break;
      case 'cancelled':
        bg = Colors.red[100]!;
        fg = Colors.red[800]!;
        break;
      case 'denied':
        bg = Colors.purple[100]!;
        fg = Colors.purple[800]!;
        break;
      default:
        bg = Colors.grey[200]!;
        fg = Colors.grey[700]!;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        // Muestra el texto original, pero en formato Title Case para mejor estética
        status[0].toUpperCase() + status.substring(1).toLowerCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: fg,
        ),
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
    if (action == 'logout') {
      final auth = Get.find<AuthController>();
      auth.logout();
    }
  }
}
