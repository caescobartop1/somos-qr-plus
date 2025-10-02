import 'package:flutter/material.dart';
import 'package:somos_qr_plus/models/provider.dart';

class ProviderDropdownWidget extends StatefulWidget {
  final Provider selectedProvider;
  final List<Provider> providers;
  final Function(Provider) onProviderChanged;
  final String? hintText;
  final double? maxWidth;

  const ProviderDropdownWidget({
    super.key,
    required this.selectedProvider,
    required this.providers,
    required this.onProviderChanged,
    this.hintText,
    this.maxWidth,
  });

  @override
  State<ProviderDropdownWidget> createState() => _ProviderDropdownWidgetState();
}

class _ProviderDropdownWidgetState extends State<ProviderDropdownWidget> {
  late TextEditingController _searchController;
  List<Provider> _filteredProviders = [];
  bool _isDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredProviders = widget.providers;
  }

  @override
  void didUpdateWidget(covariant ProviderDropdownWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.providers != widget.providers) {
      setState(() {
        if (_searchController.text.isEmpty) {
          _filteredProviders = widget.providers;
        } else {
          _filteredProviders = widget.providers
              .where((provider) => provider.name
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()))
              .toList();
        }
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterProviders(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredProviders = widget.providers;
      } else {
        _filteredProviders = widget.providers
            .where((provider) =>
                provider.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: widget.maxWidth != null
          ? BoxConstraints(maxWidth: widget.maxWidth!)
          : null,
      child: Column(
        children: [
          // Dropdown Button
          GestureDetector(
            onTap: () {
              setState(() {
                _isDropdownOpen = !_isDropdownOpen;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.selectedProvider.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: widget.selectedProvider.name == 'All'
                            ? Colors.grey.shade600
                            : Colors.black87,
                      ),
                    ),
                  ),
                  Icon(
                    _isDropdownOpen
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),
          ),

          // Dropdown List with Search
          if (_isDropdownOpen)
            Container(
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
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
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search providers...',
                        prefixIcon: Icon(Icons.search, size: 20),
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      style: const TextStyle(fontSize: 14),
                      onChanged: _filterProviders,
                    ),
                  ),

                  // Provider List
                  Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filteredProviders.length,
                      itemBuilder: (context, index) {
                        final provider = _filteredProviders[index];
                        final isSelected = provider == widget.selectedProvider;

                        return InkWell(
                          onTap: () {
                            widget.onProviderChanged(provider);
                            setState(() {
                              _isDropdownOpen = false;
                              _searchController.clear();
                              _filteredProviders = widget.providers;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.grey.shade100
                                  : Colors.transparent,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    provider.name,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                      color: isSelected
                                          ? const Color(0xFF333333)
                                          : const Color(0xFF333333),
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check,
                                    size: 16,
                                    color: Color(0xFF666666),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
