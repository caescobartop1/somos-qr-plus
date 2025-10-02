import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:somos_qr_plus/controllers/auth_controller.dart';
import 'package:somos_qr_plus/controllers/practice_controller.dart';
import 'package:somos_qr_plus/helpers/route_helper.dart';
import 'package:somos_qr_plus/models/pocket_guide.dart';
import 'package:somos_qr_plus/widgets/spinner.dart';
import '../widgets/app_header_widget.dart';
import '../widgets/app_drawer_widget.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  bool _isDrawerOpen = false;
  bool _showLogoutDialog = false;

  // Quality card state
  bool _isQualityExpanded = false;
  String _qualitySearchQuery = '';

  // Risk Adjustments card state
  bool _isRiskExpanded = false;
  String _riskSearchQuery = '';

  // Quality items data
  final List<Map<String, dynamic>> _qualityItems = [];
  // Risk Adjustments items data
  final List<Map<String, dynamic>> _riskItems = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Primera carga: obtener solo los Pocket Guides (padres)

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        _isLoading = true;
      });
      await _loadData();
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _loadData() async {
    final c = Get.find<PracticeController>();
    bool resQuality = await c.getPocketQuality(null, null);
    if (!resQuality) return;

    bool resRa = await c.getPocketRa(null);
    if (!resRa) return;
  }

  void _handleProfileAction(String action) {
    switch (action) {
      case 'language':
        // Handle language change
        break;
      case 'invitations':
        // Handle invitations
        break;
      case 'logout':
        setState(() {
          _showLogoutDialog = true;
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PracticeController>(builder: (practiceController) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          body: Stack(
            children: [
              // Main content
              Column(
                children: [
                  // Header
                  AppHeaderWidget(
                    onMenuPressed: () {
                      setState(() {
                        _isDrawerOpen = !_isDrawerOpen;
                      });
                    },
                    onProfileAction: (action) {
                      // Handle profile action
                      _handleProfileAction(action);
                    },
                  ),

                  // Page content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 24.0),
                      child: Column(
                        children: [
                          // Page title
                          const Text(
                            'Pocket Guides',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF333333),
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 32),

                          // Resources container
                          Container(
                            constraints: const BoxConstraints(maxWidth: 800),
                            width: double.infinity,
                            child: Column(
                              children: [
                                // Quality Card
                                _buildResourceCard(
                                  title: 'Quality',
                                  isExpanded: _isQualityExpanded,
                                  searchQuery: _qualitySearchQuery,
                                  items: practiceController.pocketGuides,
                                  onToggle: () {
                                    setState(() {
                                      _isQualityExpanded = !_isQualityExpanded;
                                    });
                                  },
                                  onSearchChanged: (query) async {
                                    setState(() {
                                      _qualitySearchQuery = query;
                                    });
                                    final controller =
                                        Get.find<PracticeController>();
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    await controller.getPocketQuality(
                                        null, _qualitySearchQuery);
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  },
                                ),

                                const SizedBox(height: 20),

                                PocketRaCard(
                                  title: 'Risk Adjustments',
                                  isExpanded: _isRiskExpanded,
                                  searchQuery: _riskSearchQuery,
                                  items: practiceController.pocketRaList,
                                  onToggle: () {
                                    setState(() =>
                                        _isRiskExpanded = !_isRiskExpanded);
                                  },
                                  onSearchChanged: (query) async {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    setState(() => _riskSearchQuery = query);
                                    final c = Get.find<PracticeController>();
                                    await c.getPocketRa(_riskSearchQuery);
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  },
                                ),

                                // Risk Adjustments Card
                                // _buildResourceCard(
                                //   title: 'Risk Adjustments',
                                //   isExpanded: _isRiskExpanded,
                                //   searchQuery: _riskSearchQuery,
                                //   items: _riskItems,
                                //   onToggle: () {
                                //     setState(() {
                                //       _isRiskExpanded = !_isRiskExpanded;
                                //     });
                                //   },
                                //   onSearchChanged: (query) {
                                //     setState(() {
                                //       _riskSearchQuery = query;
                                //     });
                                //   },
                                // ),
                                const SizedBox(height: 32),

                                // 🔹 Nueva Sección Training & Knowledge Base
                                const Text(
                                  'Training & Knowledge Base',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF333333),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),

                                _buildComingSoonResourceCard('Videos'),
                                const SizedBox(height: 20),
                                _buildComingSoonResourceCard('PDF Guides'),
                                const SizedBox(height: 20),
                                _buildComingSoonResourceCard('Contacts'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Navigation drawer
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
                activeRoute: 'resources',
              ),

              // Logout dialog
              if (_showLogoutDialog) _buildLogoutDialog(),
              if (_isLoading) LoadingSpinner()
            ],
          ),
        ),
      );
    });
  }

  Widget _buildComingSoonResourceCard(String title) {
    bool isExpanded = false; // estado local del widget

    return StatefulBuilder(
      builder: (context, setInnerState) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE0E0E0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header similar a Quality/Risk
              InkWell(
                onTap: () => setInnerState(() => isExpanded = !isExpanded),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    border: Border(
                      bottom: BorderSide(
                        color: isExpanded
                            ? const Color(0xFFE0E0E0)
                            : Colors.transparent,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                      ),
                      Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_right,
                        color: const Color(0xFF666666),
                      ),
                    ],
                  ),
                ),
              ),

              // Contenido expandido con Coming Soon
              if (isExpanded)
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: const Text(
                    'Coming soon',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF666666),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
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
        break;
      case 'settings':
        Get.offAllNamed(RouteHelper.getSettingsRoute());
        break;
      case 'logout':
        setState(() {
          _showLogoutDialog = true;
        });
        break;
    }
  }

  Widget _buildResourceCard({
    required String title,
    required bool isExpanded,
    required String searchQuery,
    required List<PocketGuide> items,
    required VoidCallback onToggle,
    required Function(String) onSearchChanged,
  }) {
    // Filter items based on search query
    final filteredItems = items.where((item) {
      if (searchQuery.isEmpty) return true;
      return item.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Card header
          InkWell(
            onTap: onToggle,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                border: Border(
                  bottom: BorderSide(color: const Color(0xFFE0E0E0)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                    color: const Color(0xFF666666),
                  ),
                ],
              ),
            ),
          ),

          // Card content
          if (isExpanded)
            Column(
              children: [
                // Search container
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFF0F0F0)),
                    ),
                  ),
                  child: TextField(
                    onChanged: onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: const TextStyle(color: Color(0xFF666666)),
                      prefixIcon:
                          const Icon(Icons.search, color: Color(0xFF666666)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: Color(0xFF1976D2)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                ),

                // Items list
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: filteredItems
                        .map((item) => _buildExpandableItem(item))
                        .toList(),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildExpandableItem(PocketGuide guide) {
    return _ExpandableItemWidget(
      guide: guide,
      onChangeLoad: (value) {
        setState(() {
          _isLoading = value;
        });
      },
    );
  }

  Widget _buildLogoutDialog() {
    return Container(
      color: Colors.black.withOpacity(0.5),
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
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFF8F9FA), Color(0xFFE9ECEF)],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Color(0xFFDC3545),
                        shape: BoxShape.circle,
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
              Container(
                padding: const EdgeInsets.all(24),
                child: const Column(
                  children: [
                    Text(
                      'Are you sure you want to log out of your account?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF333333),
                        height: 1.5,
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
              Container(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _showLogoutDialog = false;
                          });
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(color: Color(0xFFE0E0E0)),
                          ),
                          backgroundColor: const Color(0xFFF8F9FA),
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
                          // Handle logout
                          final authController = Get.find<AuthController>();
                          authController.logout();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: const Color(0xFFDC3545),
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
}

class _ExpandableItemWidget extends StatefulWidget {
  final PocketGuide guide;
  final Function(bool state) onChangeLoad;

  const _ExpandableItemWidget(
      {required this.guide, required this.onChangeLoad});

  @override
  State<_ExpandableItemWidget> createState() => _ExpandableItemWidgetState();
}

class _ExpandableItemWidgetState extends State<_ExpandableItemWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          // Item header
          InkWell(
            onTap: () async {
              setState(() {
                _isExpanded = !_isExpanded;
              });
              if (_isExpanded && widget.guide.categories.isEmpty) {
                widget.onChangeLoad(true);
                final controller = Get.find<PracticeController>();

                await controller.getPocketQuality(
                    widget.guide.id.toString(), null);
                widget.onChangeLoad(false);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1976D2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.guide.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                    color: Colors.white,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),

          // Item content
          if (_isExpanded)
            Container(
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                children: widget.guide.categories.map<Widget>((cat) {
                  return Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: const Color(0xFF1976D2), width: 2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      children: [
                        // Section header
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: const BoxDecoration(
                            color: Color(0xFF1976D2),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  cat.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Section content
                        Container(
                          padding: const EdgeInsets.all(16),
                          constraints: const BoxConstraints(maxHeight: 400),
                          width: double.infinity,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _buildSectionContent(cat),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildSectionContent(PocketQualityCategory category) {
    // Si no hay códigos en la categoría mostramos un mensaje
    if (category.codes.isEmpty) {
      return [
        const Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            'No codes available',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF666666),
            ),
          ),
        )
      ];
    }

    // Listado de códigos de la categoría
    return category.codes.map<Widget>((code) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFE0E0E0)),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Código (tipo Z00.00)
            Container(
              width: double.infinity,
              child: Text(
                code.code,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1976D2),
                  fontFamily: 'Courier New',
                  fontSize: 12,
                ),
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ),
            const SizedBox(height: 4),
            // Descripción
            Container(
              width: double.infinity,
              child: Text(
                code.description,
                style: const TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 13,
                  height: 1.4,
                ),
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}

class PocketRaCard extends StatefulWidget {
  final String title;
  final bool isExpanded;
  final String searchQuery;
  final List<PocketRaParent> items;
  final VoidCallback onToggle;
  final Function(String) onSearchChanged;

  const PocketRaCard({
    super.key,
    required this.title,
    required this.isExpanded,
    required this.searchQuery,
    required this.items,
    required this.onToggle,
    required this.onSearchChanged,
  });

  @override
  State<PocketRaCard> createState() => _PocketRaCardState();
}

class _PocketRaCardState extends State<PocketRaCard> {
  @override
  Widget build(BuildContext context) {
    // Filtrado por texto
    final filteredParents = widget.items.where((parent) {
      if (widget.searchQuery.isEmpty) return true;
      return parent.parentName
          .toLowerCase()
          .contains(widget.searchQuery.toLowerCase());
    }).toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header del card
          InkWell(
            onTap: widget.onToggle,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                border: Border(
                  bottom: BorderSide(color: const Color(0xFFE0E0E0)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                  Icon(
                    widget.isExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                    color: const Color(0xFF666666),
                  ),
                ],
              ),
            ),
          ),

          // Contenido
          if (widget.isExpanded)
            Column(
              children: [
                // Buscador
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFF0F0F0)),
                    ),
                  ),
                  child: TextField(
                    onChanged: widget.onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: const TextStyle(color: Color(0xFF666666)),
                      prefixIcon:
                          const Icon(Icons.search, color: Color(0xFF666666)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: Color(0xFF1976D2)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                ),

                // Listado de padres
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: filteredParents
                        .map((parent) => _ParentExpandableItem(parent: parent))
                        .toList(),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _ParentExpandableItem extends StatefulWidget {
  final PocketRaParent parent;

  const _ParentExpandableItem({required this.parent});

  @override
  State<_ParentExpandableItem> createState() => _ParentExpandableItemState();
}

class _ParentExpandableItemState extends State<_ParentExpandableItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          // Header del ítem
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1976D2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.parent.parentName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                    color: Colors.white,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),

          // Contenido expandido estilo PocketGuide
          if (_expanded)
            Container(
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                children: widget.parent.childs.map((child) {
                  return Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: const Color(0xFF1976D2), width: 2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      children: [
                        // Encabezado de la sección (azul)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: const BoxDecoration(
                            color: Color(0xFF1976D2),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${child.diagnosisCode} – ${child.diagnosisCodeDescription}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Contenido de la sección
                        Container(
                          padding: const EdgeInsets.all(16),
                          constraints: const BoxConstraints(maxHeight: 300),
                          width: double.infinity,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'HCC: ${child.hccCode}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF333333),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Model: ${child.model}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF666666),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
