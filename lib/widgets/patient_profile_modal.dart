import 'package:flutter/material.dart';
import '../models/patient.dart';

class PatientProfileModal extends StatefulWidget {
  final Patient patient;

  const PatientProfileModal({super.key, required this.patient});

  @override
  State<PatientProfileModal> createState() => _PatientProfileModalState();
}

class _PatientProfileModalState extends State<PatientProfileModal> {
  String _selectedTab = 'No Shows';
  String _selectedProvider = 'Select a Provider';

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
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
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                                items: [
                                  'Select a Provider',
                                  'Dr. Maria Garcia',
                                  'Dr. Sarah Chen',
                                  'Dr. John Smith',
                                  'Dr. Michael Brown',
                                  'Dr. James Wilson',
                                ].map((provider) => DropdownMenuItem(
                                  value: provider,
                                  child: Text(provider),
                                )).toList(),
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
                                initialValue: widget.patient.fullName,
                                readOnly: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Tabs
                              Row(
                                children: [
                                  _buildTabButton('No Shows', _selectedTab == 'No Shows'),
                                  const SizedBox(width: 8),
                                  _buildTabButton('Completed Visits', _selectedTab == 'Completed Visits'),
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
    );
  }

  Widget _buildTabButton(String text, bool isActive) {
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = text),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF333333) : Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? Colors.white : const Color(0xFF333333),
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildDemographicsCard() {
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
                _buildDemographicItem('Last DOS:', ''),
                _buildDemographicItem('DOB:', '11/30/1981'),
                _buildDemographicItem('Phone:', '7187020504'),
                _buildDemographicItem('Recert Date:', '09/30/2025'),
                _buildDemographicItem('Next DOS:', ''),
                _buildDemographicItem('Address:', '8917 55th Ave # 1fl, Elmhurst NY, 11373'),
              ],
            ),
          ),
          const SizedBox(width: 20),
          // Right side
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDemographicItem('DOS Status:', ''),
                _buildDemographicItem('Gender:', 'F'),
                _buildDemographicItem('Secondary Phone:', ''),
                _buildDemographicItem('Email:', ''),
                _buildDemographicItem('Language:', 'SPA'),
                _buildDemographicItem('MCO:', 'Anthem'),
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('GAP')),
                DataColumn(label: Text('Description')),
                DataColumn(label: Text('Completed')),
                DataColumn(label: Text('App')),
                DataColumn(label: Text('EHR')),
                DataColumn(label: Text('Claim')),
              ],
              rows: [
                DataRow(
                  cells: [
                    const DataCell(Text('BCS')),
                    const DataCell(Text('Breast Cancer Screen...')),
                    DataCell(Checkbox(
                      value: false, 
                      onChanged: (value) => _showCareGapDialog('BCS', 'Breast Cancer Screening', 'Completed', value ?? false),
                    )),
                    DataCell(Checkbox(
                      value: false, 
                      onChanged: (value) => _showCareGapDialog('BCS', 'Breast Cancer Screening', 'App', value ?? false),
                    )),
                    DataCell(Checkbox(
                      value: false, 
                      onChanged: (value) => _showCareGapDialog('BCS', 'Breast Cancer Screening', 'EHR', value ?? false),
                    )),
                    DataCell(Checkbox(
                      value: false, 
                      onChanged: (value) => _showCareGapDialog('BCS', 'Breast Cancer Screening', 'Claim', value ?? false),
                    )),
                  ],
                ),
                DataRow(
                  cells: [
                    const DataCell(Text('AWV')),
                    const DataCell(Text('Annual Wellness Visi...')),
                    DataCell(Checkbox(
                      value: true, 
                      onChanged: (value) => _showCareGapDialog('AWV', 'Annual Wellness Visit', 'Completed', value ?? true),
                    )),
                    DataCell(Checkbox(
                      value: false, 
                      onChanged: (value) => _showCareGapDialog('AWV', 'Annual Wellness Visit', 'App', value ?? false),
                    )),
                    DataCell(Checkbox(
                      value: true, 
                      onChanged: (value) => _showCareGapDialog('AWV', 'Annual Wellness Visit', 'EHR', value ?? true),
                    )),
                    DataCell(Checkbox(
                      value: true, 
                      onChanged: (value) => _showCareGapDialog('AWV', 'Annual Wellness Visit', 'Claim', value ?? true),
                    )),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildPagination(),
        ],
      ),
    );
  }

  Widget _buildRiskAdjustmentCard() {
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
              rows: [
                DataRow(
                  cells: [
                    const DataCell(Text('')),
                    const DataCell(Text('')),
                    const DataCell(Text('')),
                    const DataCell(Text('')),
                    const DataCell(Text('')),
                    const DataCell(Text('')),
                    const DataCell(Text('')),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
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
          ),
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

  void _showCareGapDialog(String gapCode, String gapName, String field, bool value) {
    // Check if provider is selected first
    if (_selectedProvider == 'Select a Provider') {
      _showProviderRequiredDialog();
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update $gapName'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Gap: $gapCode - $gapName'),
              const SizedBox(height: 8),
              Text('Field: $field'),
              const SizedBox(height: 8),
              Text('Provider: $_selectedProvider'),
              const SizedBox(height: 8),
              Text('Current Status: ${value ? "Completed" : "Not Completed"}'),
              const SizedBox(height: 16),
              Text(
                'Are you sure you want to ${value ? "mark as completed" : "mark as not completed"}?',
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
              onPressed: () {
                // Here you would typically update the data
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$gapName $field status updated successfully'),
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
                    content: Text('Patient assigned to $providerName successfully'),
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

