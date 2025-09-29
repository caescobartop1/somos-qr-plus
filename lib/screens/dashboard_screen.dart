import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:somos_qr_plus/controllers/auth_controller.dart';
import 'package:somos_qr_plus/controllers/practice_controller.dart';
import 'package:somos_qr_plus/helpers/route_helper.dart';
import 'package:somos_qr_plus/models/bonus_detail.dart';
import 'package:somos_qr_plus/models/provider.dart';
import 'package:somos_qr_plus/models/schedule.dart';
import '../widgets/app_header_widget.dart';
import '../widgets/app_drawer_widget.dart';
import '../widgets/provider_dropdown_widget.dart';
// import '../core/constants/providers.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isDrawerOpen = false;
  bool _isScheduleExpanded = true;
  Provider _selectedIncentiveProvider = new Provider(name: 'All', id: '-1');
  bool _showLogoutDialog = false;

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
  void initState() {
    super.initState();
    final c = Get.find<PracticeController>();
    _selectedIncentiveProvider = c.defaultProvider;
    // Lánzalo después del frame para asegurar que el árbol está listo
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _loadData(_selectedIncentiveProvider));
  }

  Future<void> _loadData(provider) async {
    final c = Get.find<PracticeController>();

    await c.getPractice('');
    await c.getPracticeDetails(provider.id);
    await c.getPanelDetails(provider.id);
    // await c.mocListDetails(provider.id);
    await c.getBonusDetails(provider.id);
    await c.getSchedule(provider.id);

    if (!mounted) return;
    setState(() {});
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

                  // Provider Dropdown
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom: BorderSide(color: Colors.grey.shade200)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: ProviderDropdownWidget(
                            selectedProvider: _selectedIncentiveProvider,
                            providers: practiceController.practices,
                            onProviderChanged: (provider) {
                              setState(() {
                                _selectedIncentiveProvider = provider;
                              });
                              final c = Get.find<PracticeController>();
                              c.setProvider(provider);
                              _loadData(provider);
                              _showSuccessMessage(
                                  'Showing data for ${provider.name}');
                            },
                            maxWidth: 300,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildWelcomeSection(),
                          const SizedBox(height: 32),
                          _buildStatisticsGrid(practiceController),
                          const SizedBox(height: 32),
                          _buildPanelChart(practiceController),
                          const SizedBox(height: 32),
                          // _buildIncentiveChart(practiceController),
                          // const SizedBox(height: 32),
                          _buildScheduleCard(practiceController),
                        ],
                      ),
                    ),
                  ),
                ],
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
                activeRoute: 'dashboard',
              ),

              // Logout Dialog
              if (_showLogoutDialog) _buildLogoutDialog(),
            ],
          ),
        ),
      );
    });
  }

  void _handleNavigation(String route) {
    switch (route) {
      case 'dashboard':
        // Already on dashboard page
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
        setState(() {
          _showLogoutDialog = true;
        });
        break;
    }
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

  Widget _buildStatisticsGrid(PracticeController practiceController) {
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
            _buildKPICard('Total Open GIC', practiceController),
            _buildKPICard('Total Members RA', practiceController),
            _buildKPICard('Members without visits', practiceController),
          ],
        );
      },
    );
  }

  Widget _buildKPICard(String title, PracticeController practiceController) {
    String value = '';
    double startValue = 3.5;
    switch (title) {
      case 'Total Open GIC':
        value =
            '${practiceController.practiceDetails.gic} / ${practiceController.practiceDetails.gicAim}';
        startValue = practiceController.practiceDetails.gicStar;
        break;

      case 'Total Members RA':
        value =
            '${practiceController.practiceDetails.ra} / ${practiceController.practiceDetails.raAim}';
        startValue = practiceController.practiceDetails.raStar;
        break;

      case 'Members without visits':
        value =
            '${practiceController.practiceDetails.nu} / ${practiceController.practiceDetails.nuAim}';
        startValue = practiceController.practiceDetails.nuStar;
        break;

      default:
        value = '0 / 0';
    }

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
            RatingBarIndicator(
              rating: startValue,
              itemBuilder: (context, index) => const Icon(
                Icons.star,
                color: Color(0xFFFFC107),
              ),
              itemCount: 5,
              itemSize: 24.0,
              direction: Axis.horizontal,
            ),
            // const SizedBox(height: 4),
            // // Add rating text like in HTML version
            // const Text(
            //   '4.5/5',
            //   style: TextStyle(
            //     fontSize: 12,
            //     fontWeight: FontWeight.w500,
            //     color: Color(0xFF666666),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildPanelChart(PracticeController practiceController) {
    final data = practiceController.panelDetails;

    // Colores (mantenidos)
    const colorEP = Color(0xFF1976D2);
    const colorMCD = Color(0xFF4CAF50);
    const colorMCR = Color(0xFF4DD0E1);

    // Abreviación a 3 chars (solo letras/números)
    String _abbr(String name) {
      final cleaned = name.replaceAll(RegExp(r'[^A-Za-z0-9]'), '');
      if (cleaned.isEmpty) return '';
      return (cleaned.length <= 3 ? cleaned : cleaned.substring(0, 3))
          .toUpperCase();
    }

    // Si no hay datos, render contenedor con mensaje
    if (data.isEmpty) {
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
        child: const SizedBox(
          height: 300,
          child: Center(
            child: Text(
              'My Panel\nNo data',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Color(0xFF666666)),
            ),
          ),
        ),
      );
    }

    // Agrupar por MCO y sumar por LOB
    final Map<String, Map<String, int>> grouped = {};
    for (final item in data) {
      final byLob = grouped.putIfAbsent(
          item.mcoName, () => {'EP': 0, 'MCD': 0, 'MCR': 0});
      byLob[item.lob] = (byLob[item.lob] ?? 0) + item.members;
    }

    // Ordenar MCOs por nombre (ajusta si prefieres otro orden)
    final mcoNames = grouped.keys.toList()..sort();

    // Calcular max para maxY
    int maxMembers = 0;
    for (final lobMap in grouped.values) {
      for (final v in lobMap.values) {
        if (v > maxMembers) maxMembers = v;
      }
    }

    // maxY con margen y redondeo
    double _niceMaxY(int v) {
      if (v <= 0) return 1;
      final withPad = (v * 1.1).ceil(); // +10% de margen
      if (withPad <= 10) return 10;
      if (withPad <= 50) return ((withPad / 10).ceil() * 10).toDouble();
      if (withPad <= 100) return ((withPad / 20).ceil() * 20).toDouble();
      if (withPad <= 500) return ((withPad / 50).ceil() * 50).toDouble();
      return ((withPad / 100).ceil() * 100).toDouble();
    }

    final double maxY = _niceMaxY(maxMembers);

    // Intervalo (aprox 5 líneas)
    double _niceInterval(double maxY) {
      final raw = (maxY / 5).ceilToDouble();
      if (raw <= 1) return 1;
      if (raw <= 5) return 5;
      if (raw <= 10) return 10;
      if (raw <= 20) return 20;
      if (raw <= 50) return 50;
      return 100;
    }

    final double interval = _niceInterval(maxY);

    // Construir grupos de barras
    final List<BarChartGroupData> barGroups = [];
    for (int i = 0; i < mcoNames.length; i++) {
      final mco = mcoNames[i];
      final lobMap = grouped[mco]!;
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
                toY: (lobMap['EP'] ?? 0).toDouble(), color: colorEP, width: 7),
            BarChartRodData(
                toY: (lobMap['MCD'] ?? 0).toDouble(),
                color: colorMCD,
                width: 7),
            BarChartRodData(
                toY: (lobMap['MCR'] ?? 0).toDouble(),
                color: colorMCR,
                width: 7),
          ],
          // opcional: separación entre varillas dentro del grupo
          barsSpace: 3,
        ),
      );
    }

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
                maxY: maxY,
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
                        if (value >= 0 && value < mcoNames.length) {
                          return Text(
                            mcoNames[value.toInt()],
                            style: const TextStyle(
                                color: Color(0xFF666666), fontSize: 12),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: interval,
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
                barGroups: barGroups,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: interval,
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

  Widget _buildIncentiveChart(PracticeController practiceController) {
    final data = practiceController.bonusDetails; // List<BonusDetail>

    String _abbr(String label) {
      // Mapa de abreviaciones conocidas
      const map = {
        'AWV-Total': 'AWV',
        'BCS-Total': 'BCS',
        'CBP-Total': 'CBP',
        'CDC-In Control (<9%)': 'CDC-1C',
        'CDC-Eye Exam': 'CDC-E',
        'COL-Total': 'COL',
        'PCR-Readmissions': 'PCR',
        'POD-Total': 'POD',
        'PPC-Prenatal': 'PPC',
        'SAA-Total': 'SAA',
        'W30A (0 - 15 Months)': 'W30',
        'WCV-Total': 'WCV',
        'HVL-Total': 'HVL',
      };
      if (map.containsKey(label)) return map[label]!;
      // Fallback: tomar antes de " (" o "-"
      final cutParen = label.split(' (').first;
      final cutDash = cutParen.split('-').first;
      final cleaned = cutDash.trim();
      if (cleaned.isEmpty) return '';
      return cleaned.length <= 4
          ? cleaned.toUpperCase()
          : cleaned.substring(0, 4).toUpperCase();
    }

    String _money(num v) {
      final f = NumberFormat.currency(symbol: r'$');
      // Mostrar sin decimales si es entero
      if (v == v.roundToDouble()) {
        return '\$${NumberFormat.decimalPattern().format(v)}';
      }
      return f.format(v);
    }

    // Totales
    final totalEarnings = data.fold<double>(0, (sum, e) => sum + (e.earnings));
    final totalPotential =
        data.fold<double>(0, (sum, e) => sum + (e.potential));

    // Paginamos en bloques de 7
    List<List<BonusDetail>> _chunk(List<BonusDetail> list, int size) {
      final chunks = <List<BonusDetail>>[];
      for (var i = 0; i < list.length; i += size) {
        chunks.add(
            list.sublist(i, i + size > list.length ? list.length : i + size));
      }
      return chunks;
    }

    double _niceMaxY(double maxVal) {
      if (maxVal <= 0) return 1;
      final withPad = (maxVal * 1.1).ceilToDouble(); // +10% margen
      if (withPad <= 1000) return ((withPad / 100).ceil() * 100).toDouble();
      if (withPad <= 5000) return ((withPad / 500).ceil() * 500).toDouble();
      return ((withPad / 1000).ceil() * 1000).toDouble();
    }

    double _niceInterval(double maxY) {
      final raw = (maxY / 5).ceilToDouble();
      if (raw <= 100) return 100;
      if (raw <= 500) return 500;
      if (raw <= 1000) return 1000;
      if (raw <= 2500) return 2500;
      return 5000;
    }

    // Construir páginas
    final pages = _chunk(data, 7).map((pageItems) {
      // max por página entre earnings y potential
      double pageMax = 0;
      for (final it in pageItems) {
        pageMax = [
          pageMax,
          it.earnings,
          it.potential,
        ].reduce((a, b) => a > b ? a : b);
      }
      final maxY = _niceMaxY(pageMax);
      final interval = _niceInterval(maxY);

      final barGroups = <BarChartGroupData>[];
      for (int i = 0; i < pageItems.length; i++) {
        final it = pageItems[i];
        barGroups.add(
          BarChartGroupData(
            x: i,
            barsSpace: 3,
            barRods: [
              BarChartRodData(
                toY: it.earnings.toDouble(),
                color: const Color(0xFF388E3C), // Earnings
                width: 7,
              ),
              BarChartRodData(
                toY: it.potential.toDouble(),
                color: const Color(0xFFA5D6A7), // Potential
                width: 7,
              ),
            ],
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: maxY,
            barTouchData: BarTouchData(enabled: false),
            titlesData: FlTitlesData(
              show: true,
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    if (value >= 0 && value < pageItems.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          pageItems[value.toInt()].labelCode,
                          style: const TextStyle(
                              color: Color(0xFF666666), fontSize: 12),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 48,
                  interval: interval,
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
            barGroups: barGroups,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: interval,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.grey.shade300,
                  strokeWidth: 1,
                );
              },
            ),
          ),
        ),
      );
    }).toList();

    // Si no hay datos, muestra placeholder
    final hasData = data.isNotEmpty;

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
                    Text(
                      hasData ? _money(totalEarnings) : '-',
                      style: const TextStyle(
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
                    Text(
                      hasData ? _money(totalPotential) : '-',
                      style: const TextStyle(
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

          // Chart / Placeholder
          SizedBox(
            height: 300,
            child: hasData
                ? PageView(children: pages)
                : const Center(
                    child: Text(
                      'No data',
                      style: TextStyle(color: Color(0xFF666666)),
                    ),
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

  Widget _buildScheduleCard(PracticeController practiceController) {
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
            padding:
                const EdgeInsets.only(top: 16, left: 16, bottom: 16, right: 0),
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
                        Get.offAllNamed(RouteHelper.getScheduleRoute());
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
            ...practiceController.scheduleDetails
                .map((schedule) => _buildAppointmentItem(schedule))
                .toList(),
        ],
      ),
    );
  }

  Widget _buildAppointmentItem(Schedule schedule) {
    final formattedTime =
        "${schedule.day.hour.toString().padLeft(2, '0')}:${schedule.day.minute.toString().padLeft(2, '0')}";

    // Generar tags dinámicos según el modelo
    List<String> tags = [];
    if (schedule.gic > 0) tags.add("GIC");
    if (schedule.ra > 0) tags.add("RA");
    if (schedule.status.isNotEmpty) tags.add(schedule.status);

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
                  schedule.memberName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formattedTime,
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
            children: tags.map((tag) {
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
                          final authController = Get.find<AuthController>();
                          authController.logout();
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
