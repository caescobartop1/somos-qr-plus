import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:somos_qr_plus/controllers/practice_controller.dart';
import 'package:go_router/go_router.dart';
import 'package:somos_qr_plus/controllers/auth_controller.dart';
import 'package:somos_qr_plus/helpers/route_helper.dart';
import 'package:somos_qr_plus/models/provider.dart';
import 'package:somos_qr_plus/widgets/provider_dropdown_widget.dart';
import 'package:somos_qr_plus/widgets/spinner.dart';
import '../widgets/app_header_widget.dart';
import '../widgets/app_drawer_widget.dart';
import 'package:somos_qr_plus/models/invite.dart';
import 'package:somos_qr_plus/controllers/practice_controller.dart';
import 'dart:async';

class InvitationScreen extends StatefulWidget {
  const InvitationScreen({super.key});

  @override
  State<InvitationScreen> createState() => _InvitationScreenState();
}

class _InvitationScreenState extends State<InvitationScreen>
    with TickerProviderStateMixin {
  bool _isDrawerOpen = false;
  bool _isLoading = false;
  late TabController _tabController;

  final _formKey = GlobalKey<FormState>();
  final _providerUsersController = TextEditingController();
  final _npiController = TextEditingController();
  final _searchController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  // En tu State
  Timer? _searchDebounce;
  String _selectedStatus = 'all';
  bool setEdit = false;
  Provider _selectedIncentiveProvider = new Provider(name: 'All', id: '-1');
  String _selectedNPI = '';
  String _selectedRoleId = '';
  Invite? _selectedInvite;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Rebuild when tab changes
    });
    final c = Get.find<PracticeController>();
    _selectedIncentiveProvider = c.defaultProvider;
    // Lánzalo después del frame para asegurar que el árbol está listo
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        _isLoading = true;
      });
      await _loadData(_selectedIncentiveProvider);
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _loadData(provider) async {
    final c = Get.find<PracticeController>();
    bool resPractice = await c.getPractice('');
    if (!resPractice) return;

    bool resMyInv = await c.getMyInvitations();
    if (!resMyInv) return;

    bool resRoles = await c.getInvitationRoles();
    if (!resRoles) return;

    bool resInvites =
        await c.getInvites(provider.id.toString(), _searchController.text);
    if (!resInvites) return;

    bool resProviderInv =
        await c.getProviderInvitations(provider.id.toString());
    if (!resProviderInv) return;
    if (!mounted) return;
    setState(() {});
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

  @override
  void dispose() {
    _tabController.dispose();
    _providerUsersController.dispose();
    _npiController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PracticeController>(builder: (practiceController) {
      return SafeArea(
        child: Scaffold(
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
                                  selectedProvider: _selectedIncentiveProvider,
                                  providers: practiceController.practices,
                                  onProviderChanged: (provider) async {
                                    setState(() {
                                      _selectedIncentiveProvider = provider;
                                    });
                                    final c = Get.find<PracticeController>();
                                    c.setProvider(provider);
                                    bool resInvites = await c.getInvites(
                                      provider.id.toString(),
                                      _searchController.text,
                                    );
                                    if (!resInvites) return;

                                    bool resProviderInvitations =
                                        await c.getProviderInvitations(
                                            provider.id.toString());
                                    if (!resProviderInvitations) return;
                                    _showSuccessMessage(
                                        'Showing data for ${provider.name}');
                                  },
                                  maxWidth: 300,
                                ),
                              ),
                            ],
                          ),
                        ),
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
                                      'Invitations',
                                      style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF333333),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: _navigateToMyInvitations,
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1976D2),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.15),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Stack(
                                        children: [
                                          const Icon(
                                            Icons.mail_outline,
                                            color: Colors.white,
                                            size: 28,
                                          ),
                                          Positioned(
                                            right: 0,
                                            top: 0,
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: const BoxDecoration(
                                                color: Colors.red,
                                                shape: BoxShape.circle,
                                              ),
                                              constraints: const BoxConstraints(
                                                minWidth: 20,
                                                minHeight: 20,
                                              ),
                                              child: Text(
                                                practiceController.myInvites
                                                    .where((invite) =>
                                                        invite.status
                                                            .toLowerCase() ==
                                                        'pending')
                                                    .length
                                                    .toString(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Manage user invitations',
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
                            border: Border(
                                bottom:
                                    BorderSide(color: Colors.grey.shade200)),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Row(
                              children: ['Add New', 'View List']
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                final index = entry.key;
                                final tabName = entry.value;
                                final isSelected =
                                    _tabController.index == index;

                                return Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      _tabController.animateTo(index);
                                      final c = Get.find<PracticeController>();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? const Color(0xFF1976D2)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        tabName,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.grey.shade700,
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
                              _buildAddNewTab(),
                              _buildViewListTab(),
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
                activeRoute: 'invitation',
              ),
              if (_isLoading) LoadingSpinner()
            ],
          ),
        ),
      );
    });
  }

  void _showPracticeRequiredDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Practice Required',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You must select a practice before continuing.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Please select a practice from the dropdown above and try again.',
                style: TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFF1976D2),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAddNewTab() {
    final c = Get.find<PracticeController>();
    print(c.invitationRoles.length);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Container(
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
            children: [
              _buildFormField(
                label: 'Role',
                child: DropdownButtonFormField<String>(
                  value: _selectedRoleId.isEmpty ? null : _selectedRoleId,
                  decoration: InputDecoration(
                    hintText: 'Select a Role',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF1976D2)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                  ),
                  items: c.invitationRoles
                      .map((role) => DropdownMenuItem<String>(
                            value: role.id.toString(), // ✅ valor que se enviará
                            child: Text(
                              '${role.name} (${role.roleType})',
                              overflow: TextOverflow.ellipsis,
                            ), // ✅ texto visible
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedRoleId = value ?? '';
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a Role';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              if (_selectedRoleId != '5')
                _buildFormField(
                  label: 'NPI',
                  child: DropdownButtonFormField<String>(
                    value: _selectedNPI.isEmpty ? null : _selectedNPI,
                    decoration: InputDecoration(
                      hintText: 'Select a NPI',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF1976D2)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 16),
                    ),
                    items: c.npiList
                        .map((npi) => DropdownMenuItem<String>(
                              value: npi.npi, // valor que se enviará
                              child: Text(
                                  '${npi.npi} - ${npi.name}'), // texto visible
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedNPI = value ?? '';
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a NPI';
                      }
                      return null;
                    },
                  ),
                ),
              if (_selectedRoleId != '5') const SizedBox(height: 16),

              _buildFormField(
                label: 'First Name',
                child: TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    hintText: 'Enter first name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF1976D2)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'First name is required';
                    }
                    if (value.length < 2) {
                      return 'First name must be at least 2 characters';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),

              _buildFormField(
                label: 'Last Name',
                child: TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    hintText: 'Enter last name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF1976D2)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Last name is required';
                    }
                    if (value.length < 2) {
                      return 'Last name must be at least 2 characters';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),

              _buildFormField(
                label: 'Phone Number',
                child: TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Enter phone number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF1976D2)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone number is required';
                    }
                    if (!RegExp(r'^[\+]?[1-9][\d]{0,15}$').hasMatch(
                        value.replaceAll(RegExp(r'[\s\-\(\)]'), ''))) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),

              _buildFormField(
                label: 'Email Address',
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Enter email address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF1976D2)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email address is required';
                    }
                    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 32),

              // Send Invite Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleFormSubmission,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          setEdit == true ? 'Edit Invite' : 'Send Invite',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildViewListTab() {
    final c = Get.find<PracticeController>();
    final filteredInvites = _selectedStatus == 'all'
        ? c.invites
        : c.invites
            .where((inv) =>
                (inv.status ?? '').toLowerCase() ==
                _selectedStatus.toLowerCase())
            .toList();
    return Column(
      children: [
        // Filter and Search Bar
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search invitations...',
                    prefixIcon:
                        const Icon(Icons.search, color: Color(0xFF666666)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF1976D2)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                  ),
                  onChanged: (value) {
                    // Cancela cualquier búsqueda pendiente
                    if (_searchDebounce?.isActive ?? false)
                      _searchDebounce!.cancel();

                    // Espera 500ms antes de disparar la búsqueda
                    _searchDebounce =
                        Timer(const Duration(milliseconds: 500), () {
                      final c = Get.find<PracticeController>();
                      // Llamada para buscar invitaciones con el texto actual
                      c.getInvites(_selectedIncentiveProvider.id.toString(),
                          value.trim());
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  value: _selectedStatus,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All Status')),
                    DropdownMenuItem(value: 'pending', child: Text('Pending')),
                    DropdownMenuItem(
                        value: 'accepted', child: Text('Accepted')),
                    DropdownMenuItem(
                        value: 'declined', child: Text('Declined')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value ?? 'all';
                    });
                  },
                ),
              ),
            ],
          ),
        ),

        // Invitations List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredInvites.length,
            itemBuilder: (context, index) {
              final invitation = filteredInvites[index];
              return _buildInvitationCard(invitation);
            },
          ),
        ),
      ],
    );
  }

  Future<void> _resendInvitation(int id) async {
    final c = Get.find<PracticeController>();

    try {
      bool res = await c.resendInvitation(id);
      if (!res) {
        return;
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Invitation resent successfully!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('⚠️ Failed to resend invitation: ${e.toString()}'),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  Widget _buildInvitationCard(Invite invitation) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${invitation.firstName} ${invitation.lastName}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      invitation.email,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusChip(invitation.status ?? 'pending'),
            ],
          ),
          const SizedBox(height: 12),

          // Details Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NPI: ${invitation.npi ?? '-'}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    invitation.phoneNumber ?? '-',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF666666),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    invitation.created.split('T').first,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _editInvitation(invitation),
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text(
                    'Edit',
                    style: TextStyle(fontSize: 12),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1976D2),
                    side: const BorderSide(color: Color(0xFF1976D2)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _resendInvitation(invitation.id),
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text(
                    'Resend',
                    style: TextStyle(fontSize: 12),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.orange.shade700,
                    side: BorderSide(color: Colors.orange.shade700),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _viewInvitation(invitation),
                  icon: const Icon(Icons.visibility, size: 16),
                  label: const Text(
                    'View',
                    style: TextStyle(fontSize: 12),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.green,
                    side: const BorderSide(color: Colors.green),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _deleteInvitation(invitation),
                  icon: const Icon(Icons.delete, size: 16),
                  label: const Text(
                    'Delete',
                    style: TextStyle(fontSize: 12),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;
    String displayText;

    switch (status) {
      case 'pending':
        backgroundColor = Colors.orange[100]!;
        textColor = Colors.orange[800]!;
        displayText = 'Pending';
        break;
      case 'accepted':
        backgroundColor = Colors.green[100]!;
        textColor = Colors.green[800]!;
        displayText = 'Accepted';
        break;
      case 'declined':
        backgroundColor = Colors.red[100]!;
        textColor = Colors.red[800]!;
        displayText = 'Declined';
        break;
      default:
        backgroundColor = Colors.grey[100]!;
        textColor = Colors.grey[800]!;
        displayText = 'Unknown';
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

  Future<void> _handleFormSubmission() async {
    if (!_formKey.currentState!.validate()) return;

    final practiceId = _selectedIncentiveProvider.id;

    // ✅ Valida que el Practice no sea -1
    if (practiceId == '-1') {
      _showPracticeRequiredDialog();
      return;
    }

    setState(() => _isLoading = true);

    try {
      final c = Get.find<PracticeController>();

      // ✅ Llama al método POST que creamos
      if (setEdit) {
        bool res = await c.updateUserInvitation(
            email: _emailController.text.trim(),
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            npi: _selectedRoleId != '5' ? _selectedNPI.trim() : '',
            phoneNumber: _phoneController.text.trim(),
            practiceId: practiceId,
            roleId: _selectedRoleId,
            invitationId: _selectedInvite?.id);
        if (!res) {
          return;
        }
      } else {
        bool res = await c.sendUserInvitation(
          email: _emailController.text.trim(),
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          npi: _selectedRoleId != '5' ? _selectedNPI.trim() : '',
          phoneNumber: _phoneController.text.trim(),
          practiceId: practiceId,
          roleId: _selectedRoleId,
        );
        if (!res) {
          return;
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(setEdit
                ? 'Invitation edited successfully!'
                : 'Invitation sent successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // ✅ Limpia el formulario
        _formKey.currentState!.reset();
        setState(() {
          setEdit = false;
          _emailController.text = '';
          _firstNameController.text = '';
          _lastNameController.text = '';
          _selectedNPI = '';
          _phoneController.text = '';

          _selectedRoleId = '';
        });

        // ✅ Cambia a la pestaña de lista
        _tabController.animateTo(1);
        await c.getInvites(
            _selectedIncentiveProvider.id.toString(), _searchController.text);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(setEdit
                ? 'Failed to edit invitation: $e'
                : 'Failed to send invitation: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _editInvitation(Invite invitation) {
    setState(() {
      setEdit = true;
      _selectedInvite = invitation;
    });
    // Pre-fill form with invitation data
    _selectedNPI = invitation.npi ?? '';
    _firstNameController.text = invitation.firstName;
    _lastNameController.text = invitation.lastName;
    _phoneController.text = invitation.phoneNumber ?? '';
    _emailController.text = invitation.email;

    // Switch to Add New tab
    _tabController.animateTo(0);

    // Show message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Form pre-filled for editing. Make changes and submit.'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _viewInvitation(Invite invitation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${invitation.firstName} ${invitation.lastName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Email', invitation.email),
            _buildDetailRow('Phone', invitation.phoneNumber ?? '-'),
            _buildDetailRow('NPI', invitation.npi ?? '-'),
            _buildDetailRow('Status', (invitation.status ?? '').toUpperCase()),
            _buildDetailRow('Created', ''),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(0xFF666666),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF333333),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteInvitation(Invite invitation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Invitation'),
        content: Text(
          'Are you sure you want to delete the invitation for ${invitation.firstName} ${invitation.lastName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                // _invitations
                //     .removeWhere((item) => item['id'] == invitation['id']);
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Invitation deleted successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
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
        Get.offAllNamed(RouteHelper.getSettingsRoute());
        break;
      case 'logout':
        final authController = Get.find<AuthController>();
        authController.logout();
        break;
    }
  }

  int get _pendingInvitationsCount {
    return 2;
  }

  void _navigateToMyInvitations() {
    Get.offAllNamed(RouteHelper.getMyInvitationsRoute());
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
        final authController = Get.find<AuthController>();
        authController.logout();
        break;
    }
  }
}
