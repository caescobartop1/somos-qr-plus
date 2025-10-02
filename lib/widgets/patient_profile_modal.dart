import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:somos_qr_plus/controllers/practice_controller.dart';
import 'package:somos_qr_plus/models/provider_schedule.dart';
import 'package:somos_qr_plus/widgets/spinner.dart';
import '../models/patient.dart';
import 'package:somos_qr_plus/models/patient_gap.dart';
import 'package:somos_qr_plus/models/patient_patology.dart';

import 'package:intl/intl.dart';

class PatientProfileModal extends StatefulWidget {
  final Patient patient;
  final List<ProviderSchedule> providers;
  final String practice_id;
  final dynamic member_plan_id;
  final dynamic schedule_id;
  bool shouldUpdate = true;
  VoidCallback onCloseDialog;
  static void _defaultOnCloseDialog() {}

  PatientProfileModal(
      {super.key,
      required this.patient,
      required this.providers,
      required this.practice_id,
      required this.member_plan_id,
      required this.schedule_id,
      this.shouldUpdate = true,
      this.onCloseDialog = _defaultOnCloseDialog});

  @override
  State<PatientProfileModal> createState() => _PatientProfileModalState();
}

class _PatientProfileModalState extends State<PatientProfileModal> {
  String _selectedTab = 'No Shows';
  String _selectedProvider = 'all';
  bool _isLoading = false;
  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('MM/dd/yyyy').format(date.toLocal());
  }

  @override
  void initState() {
    super.initState();
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

    bool resPatient =
        await c.getPatient(widget.patient.id.toString(), widget.practice_id);
    if (!resPatient) return;

    if (widget.member_plan_id == 0) {
      final patient = c.patient;

      bool resGap =
          await c.getPatientGap(patient?.memberPlanId.toString() ?? '');
      if (!resGap) return;

      bool resPatology =
          await c.getPatientPatology(patient?.memberPlanId.toString() ?? '');
      if (!resPatology) return;
    } else {
      bool resGap = await c.getPatientGap(widget.member_plan_id.toString());
      if (!resGap) return;

      bool resPatology =
          await c.getPatientPatology(widget.member_plan_id.toString());
      if (!resPatology) return;
    }

    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final practiceController = Get.find<PracticeController>();
    final patientResp = practiceController.patient;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Patient Profile'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF333333),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Provider Selection
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Provider',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedProvider,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                        items: [
                          const DropdownMenuItem(
                            value: 'all',
                            child: Text('Select a Provider'),
                          ),
                          ...widget.providers
                              .map((provider) => DropdownMenuItem(
                                    value: provider.id.toString(),
                                    child: Text(provider.fullName),
                                  ))
                              .toList()
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedProvider = value);
                            if (value != 'Select a Provider') {
                              _showProviderChangeDialog(value);
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),

                // Patient Name and Tabs
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        initialValue: practiceController.patient?.fullName ??
                            widget.patient.fullName,
                        readOnly: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Tabs
                      Row(
                        children: [
                          _buildTabButton('No Shows', false),
                          const SizedBox(width: 8),
                          _buildTabButton('Completed Visits', false),
                        ],
                      ),
                    ],
                  ),
                ),

                // Demographics Card
                _buildDemographicsCard(),

                // Care Gaps Section
                _buildCareGapsCard(),

                // Risk Adjustment Section
                _buildRiskAdjustmentCard(),
              ],
            ),
          ),
          if (_isLoading) LoadingSpinner()
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, bool isActive) {
    final bool isDisabled = !widget.shouldUpdate; // ✅ Nuevo flag

    return GestureDetector(
      onTap: () async {
        if (isDisabled) return;

        // ✅ Validar provider antes de permitir el cambio
        if (_selectedProvider == 'all') {
          _showProviderRequiredDialog();
          return;
        }
        setState(() {
          _isLoading = true;
        });
        final c = Get.find<PracticeController>();
        await c.updateStatusVisit(
          practiceId: widget.practice_id,
          selectedProvider: _selectedProvider,
          patientId: widget.patient.id,
          field: text,
          schedule_id: widget.schedule_id,
        );
        setState(() {
          _isLoading = false;
        });
        widget.onCloseDialog();
        Navigator.of(context).pop();
        setState(() => _selectedTab = text);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          // ✅ Fondo según estado
          color: isDisabled
              ? Colors.grey.shade200 // 👉 Color inactivo forzado
              : (isActive ? const Color(0xFF333333) : Colors.white),
          border: Border.all(
            color: isDisabled
                ? Colors.grey.shade400 // 👉 Borde inactivo
                : (isActive ? const Color(0xFF333333) : Colors.grey.shade300),
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isDisabled
                ? Colors.grey.shade500 // 👉 Texto inactivo
                : (isActive ? Colors.white : const Color(0xFF333333)),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildDemographicsCard() {
    final practiceController = Get.find<PracticeController>();
    final p = practiceController.patient;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDemographicItem(
                    'Last DOS:', _formatDate(p?.lastVisitDate)),
                _buildDemographicItem('DOB:', _formatDate(p?.birthdate)),
                _buildDemographicItem('Phone:', p?.phoneNumber ?? '-'),
                _buildDemographicItem(
                    'Recert Date:', _formatDate(p?.recertDate)),
                _buildDemographicItem(
                    'Next DOS:', _formatDate(p?.nextAppointment)),
                _buildDemographicItem('Address:', p?.address ?? '-'),
              ],
            ),
          ),
          const SizedBox(width: 20),
          // Right side
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDemographicItem('DOS Status:', p?.lastStatus ?? '-'),
                _buildDemographicItem('Gender:', p?.gender ?? '-'),
                _buildDemographicItem(
                    'Secondary Phone:', p?.phoneNumber2 ?? '-'),
                _buildDemographicItem('Email:', p?.email ?? '-'),
                _buildDemographicItem('Language:', p?.language ?? '-'),
                _buildDemographicItem('MCO:', p?.mcoName ?? '-'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemographicItem(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF666666),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value.isEmpty ? '-' : value,
            style: const TextStyle(
              color: Color(0xFF333333),
              fontSize: 13,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildCareGapsCard() {
    final practiceController = Get.find<PracticeController>();
    final gaps = practiceController.patientGaps;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Care Gaps',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 16),
          if (gaps.isEmpty)
            const Center(
              child: Text(
                'No care gaps found.',
                style: TextStyle(
                  color: Color(0xFF666666),
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Center(child: Text('GAP'))),
                  DataColumn(label: Center(child: Text('Description'))),
                  DataColumn(label: Center(child: Text('Completed'))),
                  DataColumn(label: Center(child: Text('App'))),
                  DataColumn(label: Center(child: Text('EHR'))),
                  DataColumn(label: Center(child: Text('Claim'))),
                ],
                rows: gaps.map((gap) {
                  return DataRow(cells: [
                    DataCell(Text(gap.measureCode)),
                    DataCell(Text(gap.measureDescription ?? '-')),
                    DataCell(
                      Center(
                        child: Checkbox(
                          value: gap.complete,
                          onChanged: null,
                        ),
                      ),
                    ),
                    DataCell(
                      Center(
                        child: Checkbox(
                          value: gap.app,
                          onChanged: (val) => _showCareGapDialog(
                            gap, // 👈 pasamos el objeto completo
                            val ?? false,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Center(
                        child: Checkbox(
                          value: gap.ehr,
                          onChanged: null,
                        ),
                      ),
                    ),
                    DataCell(
                      Center(
                        child: Checkbox(
                          value: gap.claim,
                          onChanged: null,
                        ),
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          const SizedBox(height: 16),
          _buildPagination(),
        ],
      ),
    );
  }

  Widget _buildRiskAdjustmentCard() {
    final practiceController = Get.find<PracticeController>();
    final patologies = practiceController.patientPatologies;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Risk Adjustment',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 16),
          if (patologies.isEmpty)
            Container(
              padding: const EdgeInsets.all(40),
              child: const Center(
                child: Text(
                  'No records found.',
                  style: TextStyle(
                    color: Color(0xFF666666),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('HCC')),
                  DataColumn(label: Text('ICD 10')),
                  DataColumn(label: Text('Present')),
                  DataColumn(label: Text('Inact')),
                  DataColumn(label: Text('App')),
                  DataColumn(label: Text('EHR')),
                  DataColumn(label: Text('Claim')),
                ],
                rows: patologies.map((p) {
                  return DataRow(cells: [
                    DataCell(Text(p.hccCategory ?? '-')),
                    DataCell(Text(p.code ?? '-')),
                    // ✅ Present (solo lectura)
                    DataCell(
                      Center(
                        child: Checkbox(
                          value: p.present,
                          onChanged: null,
                        ),
                      ),
                    ),

// ✅ Inactive (editable)
                    DataCell(
                      Center(
                        child: Checkbox(
                          value: p.inactive,
                          onChanged: (val) => _showPatologyDialog(
                            p,
                            'Inactive',
                            val ?? false,
                          ),
                        ),
                      ),
                    ),

// ✅ App (editable)
                    DataCell(
                      Center(
                        child: Checkbox(
                          value: p.app,
                          onChanged: (val) => _showPatologyDialog(
                            p,
                            'App',
                            val ?? false,
                          ),
                        ),
                      ),
                    ),

// ✅ EHR (solo lectura)
                    DataCell(
                      Center(
                        child: Checkbox(
                          value: p.ehr,
                          onChanged: null,
                        ),
                      ),
                    ),

// ✅ Claim (solo lectura)
                    DataCell(
                      Center(
                        child: Checkbox(
                          value: p.claim,
                          onChanged: null,
                        ),
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          const SizedBox(height: 16),
          _buildPagination(),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: null,
          icon: const Icon(Icons.first_page),
        ),
        IconButton(
          onPressed: null,
          icon: const Icon(Icons.chevron_left),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF1976D2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            '1',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        IconButton(
          onPressed: null,
          icon: const Icon(Icons.chevron_right),
        ),
        IconButton(
          onPressed: null,
          icon: const Icon(Icons.last_page),
        ),
      ],
    );
  }

  void _showPatologyDialog(
      PatientPatology patology, String field, bool newValue) {
    // Verificar que el provider esté seleccionado
    if (_selectedProvider == 'all') {
      _showProviderRequiredDialog();
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text('Update ${patology.hccDescription ?? patology.code ?? ''}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ICD10: ${patology.code ?? '-'}'),
              const SizedBox(height: 8),
              Text('Field: $field'),
              const SizedBox(height: 8),
              Text('Provider: $_selectedProvider'),
              const SizedBox(height: 8),
              Text('Current Status: ${newValue ? "Yes" : "No"}'),
              const SizedBox(height: 16),
              Text(
                'Are you sure you want to ${newValue ? "enable" : "disable"} $field?',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final c = Get.find<PracticeController>();
                final idx =
                    c.patientPatologies.indexWhere((g) => g.id == patology.id);
                if (idx != -1) {
                  // 👇 Aquí suponemos que tienes un método de update en tu controlador
                  await c.updatePatientPatologyField(
                    index: idx,
                    patologyId: patology.id,
                    practiceId: widget.practice_id,
                    selectedProvider: _selectedProvider,
                    field: field,
                    value: newValue,
                  );
                  setState(() {});
                }

                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${patology.hccDescription ?? patology.code ?? ''} '
                      '$field updated successfully',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _showCareGapDialog(PatientGap gap, bool newValue) {
    // Verificar que el provider esté seleccionado
    if (_selectedProvider == 'all') {
      _showProviderRequiredDialog();
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update ${gap.measureDescription ?? gap.measureCode}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Gap: ${gap.measureCode} - ${gap.measureDescription ?? ''}'),
              const SizedBox(height: 8),
              Text('Field: App'),
              const SizedBox(height: 8),
              Text('Provider: $_selectedProvider'),
              const SizedBox(height: 8),
              Text(
                  'Current Status: ${newValue ? "Completed" : "Not Completed"}'),
              const SizedBox(height: 16),
              Text(
                'Are you sure you want to ${newValue ? "mark as completed" : "mark as not completed"}?',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // ✅ Actualizar el valor en el controlador
                final c = Get.find<PracticeController>();
                final idx = c.patientGaps.indexWhere((g) => g.id == gap.id);
                if (idx != -1) {
                  setState(() {
                    _isLoading = true;
                  });
                  // Creamos una copia inmutable para no romper la lista
                  await c.updatePatientGaps(newValue, idx, gap.id,
                      widget.practice_id, _selectedProvider);
                  setState(() {
                    _isLoading = false;
                  });
                  setState(() {});
                }

                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        '${gap.measureDescription ?? gap.measureCode} App status updated successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _showProviderChangeDialog(String providerName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Provider Assignment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Assigning patient to: $providerName'),
              const SizedBox(height: 16),
              const Text(
                'This will update the patient\'s primary care provider. Are you sure you want to proceed?',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('Patient assigned to $providerName successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _showProviderRequiredDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Provider Required'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You must select a provider before updating care gaps.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Please select a provider from the dropdown above, then try again.',
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
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
