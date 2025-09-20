import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:somos_qr_plus/controllers/auth_controller.dart';
import 'package:somos_qr_plus/helpers/route_helper.dart';
import '../widgets/app_header_widget.dart';
import '../widgets/app_drawer_widget.dart';

enum InvitationStatus { pending, accepted, declined }

class PatientInvitation {
  final String id;
  final String patientName;
  final String patientEmail;
  final String patientPhone;
  final DateTime sentDate;
  final InvitationStatus status;
  final String? notes;

  PatientInvitation({
    required this.id,
    required this.patientName,
    required this.patientEmail,
    required this.patientPhone,
    required this.sentDate,
    required this.status,
    this.notes,
  });
}

class MyInvitationsScreen extends StatefulWidget {
  const MyInvitationsScreen({super.key});

  @override
  State<MyInvitationsScreen> createState() => _MyInvitationsScreenState();
}

class _MyInvitationsScreenState extends State<MyInvitationsScreen>
    with SingleTickerProviderStateMixin {
  bool _isDrawerOpen = false;
  late TabController _tabController;

  List<PatientInvitation> _invitations = [
    PatientInvitation(
      id: '1',
      patientName: 'Dr. Sarah Wilson',
      patientEmail: 'sarah.wilson@clinic.com',
      patientPhone: '(555) 123-4567',
      sentDate: DateTime.now().subtract(const Duration(days: 2)),
      status: InvitationStatus.pending,
      notes: 'Invitation to join SOMOS QR+ network',
    ),
    PatientInvitation(
      id: '2',
      patientName: 'Dr. Michael Chen',
      patientEmail: 'michael.chen@healthcare.com',
      patientPhone: '(555) 987-6543',
      sentDate: DateTime.now().subtract(const Duration(days: 5)),
      status: InvitationStatus.accepted,
      notes: 'Provider network invitation',
    ),
    PatientInvitation(
      id: '3',
      patientName: 'Dr. Lisa Rodriguez',
      patientEmail: 'lisa.rodriguez@medical.com',
      patientPhone: '(555) 456-7890',
      sentDate: DateTime.now().subtract(const Duration(days: 1)),
      status: InvitationStatus.pending,
      notes: 'Quality improvement program invitation',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int get _pendingInvitationsCount {
    return _invitations.where((inv) => inv.status == InvitationStatus.pending).length;
  }

  void _updateInvitationStatus(String invitationId, InvitationStatus newStatus) {
    setState(() {
      final index = _invitations.indexWhere((inv) => inv.id == invitationId);
      if (index != -1) {
        _invitations[index] = PatientInvitation(
          id: _invitations[index].id,
          patientName: _invitations[index].patientName,
          patientEmail: _invitations[index].patientEmail,
          patientPhone: _invitations[index].patientPhone,
          sentDate: _invitations[index].sentDate,
          status: newStatus,
          notes: _invitations[index].notes,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Page Title
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
                                onPressed: () => Get.offAllNamed(RouteHelper.getInvitationsRoute()),
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Color(0xFF333333),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Manage invitations you\'ve received',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF666666),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Tab Bar
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          children: ['Pending', 'Accepted'].asMap().entries.map((entry) {
                            final index = entry.key;
                            final tabName = entry.value;
                            final isSelected = _tabController.index == index;
                            
                            return Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  _tabController.animateTo(index);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: isSelected ? const Color(0xFF1976D2) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    tabName,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : Colors.grey.shade700,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    
                    // Tab Content
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildPendingTab(),
                          _buildAcceptedTab(),
                        ],
                      ),
                    ),
                  ],
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
            activeRoute: 'my-invitations',
          ),
        ],
      ),
    );
  }

  Widget _buildPendingTab() {
    final pendingInvitations = _invitations.where((inv) => inv.status == InvitationStatus.pending).toList();
    
    if (pendingInvitations.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No pending invitations',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'You have no new invitations to review',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: pendingInvitations.length,
      itemBuilder: (context, index) {
        final invitation = pendingInvitations[index];
        return _buildInvitationCard(invitation);
      },
    );
  }

  Widget _buildAcceptedTab() {
    final acceptedInvitations = _invitations.where((inv) => inv.status == InvitationStatus.accepted).toList();
    
    if (acceptedInvitations.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No accepted invitations',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'You haven\'t accepted any invitations yet',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: acceptedInvitations.length,
      itemBuilder: (context, index) {
        final invitation = acceptedInvitations[index];
        return _buildInvitationCard(invitation);
      },
    );
  }

  Widget _buildInvitationCard(PatientInvitation invitation) {
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
          // Header Row
          Row(
            children: [
              Expanded(
                child: Text(
                  invitation.patientName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              _buildStatusChip(invitation.status),
            ],
          ),
          const SizedBox(height: 12),
          
          // Details
          Text('From: ${invitation.patientEmail}'),
          const SizedBox(height: 4),
          Text('Phone: ${invitation.patientPhone}'),
          const SizedBox(height: 4),
          Text('${invitation.status == InvitationStatus.pending ? 'Received' : 'Accepted'}: ${_formatDate(invitation.sentDate)}'),
          if (invitation.notes?.isNotEmpty == true) ...[
            const SizedBox(height: 8),
            Text('Message: ${invitation.notes}'),
          ],
          
          // Action Buttons (only for pending invitations)
          if (invitation.status == InvitationStatus.pending) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _updateInvitationStatus(invitation.id, InvitationStatus.declined),
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
                    onPressed: () => _updateInvitationStatus(invitation.id, InvitationStatus.accepted),
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
          ],
        ],
      ),
    );
  }

  Widget _buildStatusChip(InvitationStatus status) {
    Color backgroundColor;
    Color textColor;
    String displayText;
    
    switch (status) {
      case InvitationStatus.pending:
        backgroundColor = Colors.orange[100]!;
        textColor = Colors.orange[800]!;
        displayText = 'Pending';
        break;
      case InvitationStatus.accepted:
        backgroundColor = Colors.green[100]!;
        textColor = Colors.green[800]!;
        displayText = 'Accepted';
        break;
      case InvitationStatus.declined:
        backgroundColor = Colors.red[100]!;
        textColor = Colors.red[800]!;
        displayText = 'Declined';
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        displayText,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  void _handleNavigation(String route) {
    switch (route) {
      case 'dashboard':
        Get.offAllNamed(RouteHelper.getPatientsRoute());
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
      case 'invitation':
        Get.offAllNamed(RouteHelper.getInvitationsRoute());
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
        // Already on invitations page
        break;
      case 'logout':
        // Handle logout logic
        break;
    }
  }
}
