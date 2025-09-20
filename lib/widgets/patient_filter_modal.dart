import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PatientFilterModal extends StatefulWidget {
  final String mcoFilter;
  final String providerFilter;
  final String dobFilter;
  final Function(String, String, String) onApply;

  const PatientFilterModal({
    super.key,
    required this.mcoFilter,
    required this.providerFilter,
    required this.dobFilter,
    required this.onApply,
  });

  @override
  State<PatientFilterModal> createState() => _PatientFilterModalState();
}

class _PatientFilterModalState extends State<PatientFilterModal> {
  late String _mcoFilter;
  late String _providerFilter;
  late String _dobFilter;
  final TextEditingController _dobController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mcoFilter = widget.mcoFilter;
    _providerFilter = widget.providerFilter;
    _dobFilter = widget.dobFilter;
    _dobController.text = _dobFilter;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final dialogWidth = constraints.maxWidth * 0.9;
          final maxWidth = 500.0;
          
          return Container(
            width: dialogWidth > maxWidth ? maxWidth : dialogWidth,
            constraints: const BoxConstraints(maxWidth: 500, minWidth: 300),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter Patients',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey.shade100,
                          padding: const EdgeInsets.all(4),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Body
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // MCO Filter
                      _buildFilterSection(
                        'MCO',
                        DropdownButtonFormField<String>(
                          value: _mcoFilter.isEmpty ? null : _mcoFilter,
                          decoration: InputDecoration(
                            hintText: 'Select MCO',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          items: [
                            'All',
                            'HealthFirst',
                            'MetroPlus',
                            'Fidelis Care',
                            'Empire BCBS',
                            'UHC Community',
                          ].map((mco) => DropdownMenuItem(
                            value: mco,
                            child: Text(
                              mco,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14),
                            ),
                          )).toList(),
                          onChanged: (value) {
                            setState(() => _mcoFilter = value ?? '');
                          },
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Provider Filter
                      _buildFilterSection(
                        'Provider',
                        DropdownButtonFormField<String>(
                          value: _providerFilter.isEmpty ? null : _providerFilter,
                          decoration: InputDecoration(
                            hintText: 'Select Provider',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          items: [
                            'All',
                            'Dr. John Smith',
                            'Dr. Maria Garcia',
                            'Dr. James Wilson',
                            'Dr. Sarah Chen',
                            'Dr. Michael Brown',
                          ].map((provider) => DropdownMenuItem(
                            value: provider,
                            child: Text(
                              provider,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14),
                            ),
                          )).toList(),
                          onChanged: (value) {
                            setState(() => _providerFilter = value ?? '');
                          },
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Date of Birth Filter
                      _buildFilterSection(
                        'Date of Birth',
                        TextFormField(
                          controller: _dobController,
                          decoration: InputDecoration(
                            hintText: 'MM/DD/YYYY',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          inputFormatters: [
                            _DateInputFormatter(),
                          ],
                          onChanged: (value) {
                            setState(() => _dobFilter = value);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Footer
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _clearFilters,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        child: const Text(
                          'Clear',
                          style: TextStyle(
                            color: Color(0xFF666666),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _applyFilters,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1976D2),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        child: const Text(
                          'Apply',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterSection(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }

  void _clearFilters() {
    setState(() {
      _mcoFilter = '';
      _providerFilter = '';
      _dobFilter = '';
      _dobController.clear();
    });
  }

  void _applyFilters() {
    widget.onApply(_mcoFilter, _providerFilter, _dobFilter);
    Navigator.of(context).pop();
  }
}

class _DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove any non-digit characters
    String text = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    
    if (text.length > 8) {
      text = text.substring(0, 8);
    }
    
    if (text.length >= 4) {
      // Add month/day separator
      text = text.substring(0, 2) + '/' + text.substring(2);
    }
    if (text.length >= 7) {
      // Add day/year separator
      text = text.substring(0, 5) + '/' + text.substring(5);
    }
    
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
