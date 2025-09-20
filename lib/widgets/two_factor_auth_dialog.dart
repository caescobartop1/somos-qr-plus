import 'package:flutter/material.dart';

enum TwoFactorMethod {
  faceId,
  authenticator,
  otp,
  biometric,
}

class TwoFactorAuthDialog extends StatefulWidget {
  const TwoFactorAuthDialog({super.key});

  @override
  State<TwoFactorAuthDialog> createState() => _TwoFactorAuthDialogState();
}

class _TwoFactorAuthDialogState extends State<TwoFactorAuthDialog> {
  TwoFactorMethod? _selectedMethod = TwoFactorMethod.otp; // Default to OTP as shown in image
  Map<TwoFactorMethod, bool> _methodStates = {
    TwoFactorMethod.faceId: false,
    TwoFactorMethod.authenticator: false,
    TwoFactorMethod.otp: true, // OTP is selected by default
    TwoFactorMethod.biometric: false,
  };

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '2-Step Verification',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Choose your preferred authentication method',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF666666),
              ),
            ),
            const SizedBox(height: 24),
            
            // Authentication Methods
            _buildAuthMethodOption(
              method: TwoFactorMethod.faceId,
              title: 'Face ID',
              description: 'Use facial recognition for secure login',
              icon: Icons.face,
            ),
            const SizedBox(height: 16),
            
            _buildAuthMethodOption(
              method: TwoFactorMethod.authenticator,
              title: 'Authenticator',
              description: 'Use authenticator app for verification',
              icon: Icons.security,
            ),
            const SizedBox(height: 16),
            
            _buildAuthMethodOption(
              method: TwoFactorMethod.otp,
              title: 'OTP',
              description: 'Receive one-time password via SMS',
              icon: Icons.sms,
            ),
            const SizedBox(height: 16),
            
            _buildAuthMethodOption(
              method: TwoFactorMethod.biometric,
              title: 'Biometric Login',
              description: 'Use fingerprint or face recognition',
              icon: Icons.fingerprint,
            ),
            const SizedBox(height: 32),
            
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF666666),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _saveSettings,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Save Settings',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthMethodOption({
    required TwoFactorMethod method,
    required String title,
    required String description,
    required IconData icon,
  }) {
    final isSelected = _selectedMethod == method;
    final isEnabled = _methodStates[method] ?? false;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMethod = method;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1976D2).withOpacity(0.1) : Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xFF1976D2) : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected 
                    ? const Color(0xFF1976D2).withOpacity(0.1)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? const Color(0xFF1976D2) : Colors.grey.shade600,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            
            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? const Color(0xFF1976D2) : const Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected ? const Color(0xFF1976D2).withOpacity(0.8) : const Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),
            
            // Radio Button
            Radio<TwoFactorMethod>(
              value: method,
              groupValue: _selectedMethod,
              onChanged: (value) {
                setState(() {
                  _selectedMethod = value;
                });
              },
              activeColor: const Color(0xFF1976D2),
            ),
          ],
        ),
      ),
    );
  }

  void _saveSettings() {
    // Here you would typically save the settings to your backend/local storage
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('2-Step Verification configured with ${_getMethodName(_selectedMethod!)}'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.of(context).pop();
  }

  String _getMethodName(TwoFactorMethod method) {
    switch (method) {
      case TwoFactorMethod.faceId:
        return 'Face ID';
      case TwoFactorMethod.authenticator:
        return 'Authenticator';
      case TwoFactorMethod.otp:
        return 'OTP';
      case TwoFactorMethod.biometric:
        return 'Biometric Login';
    }
  }
}
