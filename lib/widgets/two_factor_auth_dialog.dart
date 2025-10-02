import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import 'package:somos_qr_plus/constants/app_constants.dart';
import 'package:somos_qr_plus/controllers/practice_controller.dart';
import 'package:somos_qr_plus/models/mfa_method.dart';
import 'package:somos_qr_plus/models/user_settings.dart';
import 'package:somos_qr_plus/widgets/authenticator_popup.dart';

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
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _isBiometric = false;
  bool _isFaceId = false;
  TwoFactorMethod? _selectedMethod = TwoFactorMethod.otp;
  bool _isFaceIdAvailable = false;
  bool _isBiometricAvailable = false;

  /// Mapa que indica si cada método está activo en backend
  Map<TwoFactorMethod, bool> _methodStates = {
    TwoFactorMethod.faceId: false,
    TwoFactorMethod.authenticator: false,
    TwoFactorMethod.otp: false,
    TwoFactorMethod.biometric: false,
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _checkBiometricAvailability();

      final c = Get.find<PracticeController>();

      // ---- Mapear métodos activos desde el backend ----
      final Map<TwoFactorMethod, bool> newStates = {
        TwoFactorMethod.faceId: false,
        TwoFactorMethod.authenticator: false,
        TwoFactorMethod.otp: false,
        TwoFactorMethod.biometric: false,
      };

      for (final m in c.mfaMethods) {
        switch (m.code.toUpperCase()) {
          case 'FACEID':
            newStates[TwoFactorMethod.faceId] =
                m.isActive && _isFaceIdAvailable;
            break;
          case 'AUTHENTICATOR':
            newStates[TwoFactorMethod.authenticator] = m.isActive;
            break;
          case 'OTP':
            newStates[TwoFactorMethod.otp] = m.isActive;
            break;
          case 'TOUCHID':
            newStates[TwoFactorMethod.biometric] =
                m.isActive && _isBiometricAvailable;
            break;
        }
      }

      _methodStates = newStates;

      // ---- Determinar método inicial con base en userSettings ----
      final UserSettings? settings = c.userSettings;
      if (settings != null && settings.mfaId != 0) {
        // Buscar método cuyo id coincida con el mfaId guardado en user settings
        final selected = c.mfaMethods
            .firstWhereOrNull((m) => m.id == settings.mfaId && m.isActive);
        if (selected != null) {
          switch (selected.code.toUpperCase()) {
            case 'FACEID':
              _selectedMethod = TwoFactorMethod.faceId;
              break;
            case 'AUTHENTICATOR':
              _selectedMethod = TwoFactorMethod.authenticator;
              break;
            case 'OTP':
              _selectedMethod = TwoFactorMethod.otp;
              break;
            case 'TOUCHID':
              _selectedMethod = TwoFactorMethod.biometric;
              break;
          }
        } else {
          // Si el guardado no está activo, elegir OTP si está activo o el primero disponible
          _selectedMethod = _fallbackSelection(newStates);
        }
      } else {
        // Si no hay user settings, elegir OTP si está activo o el primero disponible
        _selectedMethod = _fallbackSelection(newStates);
      }
    });
  }

  Future<void> _checkBiometricAvailability() async {
    try {
      final available = await _localAuth.getAvailableBiometrics();
      debugPrint('Available biometrics: $available');

      if (available.contains(BiometricType.face)) {
        _isFaceIdAvailable = true;
      }
      if (available.contains(BiometricType.fingerprint) ||
          available.contains(BiometricType.strong) ||
          available.contains(BiometricType.weak)) {
        _isBiometricAvailable = true;
      }
      setState(() {});
    } catch (e) {
      debugPrint('Biometric check failed: $e');
    }
  }

  Future<bool> _authenticate() async {
    print('aqui entro!');
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Please authenticate to proceed',
        options: AuthenticationOptions(
          biometricOnly: _isBiometric,
          stickyAuth: _isFaceId,
        ),
      );
    } on PlatformException {
      return false;
    }
  }

  /// Selección de respaldo cuando no hay userSettings válidos
  TwoFactorMethod _fallbackSelection(Map<TwoFactorMethod, bool> states) {
    if (states[TwoFactorMethod.otp] == true) {
      return TwoFactorMethod.otp;
    }
    final firstActive = states.entries.firstWhere(
      (e) => e.value,
      orElse: () => const MapEntry(TwoFactorMethod.otp, false),
    );
    return firstActive.key;
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<PracticeController>();

    final faceTexts = _getBackendTexts(c, TwoFactorMethod.faceId);
    final authTexts = _getBackendTexts(c, TwoFactorMethod.authenticator);
    final otpTexts = _getBackendTexts(c, TwoFactorMethod.otp);
    final bioTexts = _getBackendTexts(c, TwoFactorMethod.biometric);
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

            // Métodos
            _buildAuthMethodOption(
              method: TwoFactorMethod.faceId,
              title: faceTexts['title']!,
              description: faceTexts['description']!,
              icon: Icons.face,
            ),
            const SizedBox(height: 16),

            _buildAuthMethodOption(
              method: TwoFactorMethod.authenticator,
              title: authTexts['title']!,
              description: authTexts['description']!,
              icon: Icons.security,
            ),
            const SizedBox(height: 16),

            _buildAuthMethodOption(
              method: TwoFactorMethod.otp,
              title: otpTexts['title']!,
              description: otpTexts['description']!,
              icon: Icons.sms,
            ),
            const SizedBox(height: 16),

            _buildAuthMethodOption(
              method: TwoFactorMethod.biometric,
              title: bioTexts['title']!,
              description: bioTexts['description']!,
              icon: Icons.fingerprint,
            ),
            const SizedBox(height: 32),

            // Botones de acción
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF666666),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
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

  /// Busca en el controlador el método por código y devuelve título y descripción
  Map<String, String> _getBackendTexts(
      PracticeController c, TwoFactorMethod method) {
    String code;
    switch (method) {
      case TwoFactorMethod.faceId:
        code = 'FACEID';
        break;
      case TwoFactorMethod.authenticator:
        code = 'AUTHENTICATOR';
        break;
      case TwoFactorMethod.otp:
        code = 'OTP';
        break;
      case TwoFactorMethod.biometric:
        code = 'TOUCHID';
        break;
    }

    final match = c.mfaMethods.firstWhere(
      (m) => m.code.toUpperCase() == code,
      orElse: () => MfaMethod(
        id: 0,
        code: code,
        description: '',
        isActive: false,
      ),
    );

    return {
      'title': match.code, // puedes mapear si quieres algo más amigable
      'description': match.description.isNotEmpty
          ? match.description
          : 'No description available',
    };
  }

  Widget _buildAuthMethodOption({
    required TwoFactorMethod method,
    required String title,
    required String description,
    required IconData icon,
  }) {
    final isSelected = _selectedMethod == method;
    final isEnabled = _methodStates[method] ?? false;

    return isEnabled
        ? GestureDetector(
            onTap: isEnabled
                ? () {
                    setState(() {
                      _selectedMethod = method;
                    });
                  }
                : null,
            child: Opacity(
              opacity: isEnabled ? 1 : 0.4,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF1976D2).withOpacity(0.1)
                      : Colors.white,
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF1976D2)
                        : Colors.grey.shade300,
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
                        color: isSelected
                            ? const Color(0xFF1976D2)
                            : Colors.grey.shade600,
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
                              color: isSelected
                                  ? const Color(0xFF1976D2)
                                  : const Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            description,
                            style: TextStyle(
                              fontSize: 14,
                              color: isSelected
                                  ? const Color(0xFF1976D2).withOpacity(0.8)
                                  : const Color(0xFF666666),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Radio Button
                    Radio<TwoFactorMethod>(
                      value: method,
                      groupValue: _selectedMethod,
                      onChanged: isEnabled
                          ? (value) {
                              setState(() {
                                _selectedMethod = value;
                              });
                            }
                          : null,
                      activeColor: const Color(0xFF1976D2),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Container();
  }

  void _saveSettings() async {
    final c = Get.find<PracticeController>();

    // Obtener el id de la opción elegida
    final selected = c.mfaMethods.firstWhereOrNull((m) {
      switch (_selectedMethod) {
        case TwoFactorMethod.faceId:
          return m.code.toUpperCase() == 'FACEID';
        case TwoFactorMethod.authenticator:
          return m.code.toUpperCase() == 'AUTHENTICATOR';
        case TwoFactorMethod.otp:
          return m.code.toUpperCase() == 'OTP';
        case TwoFactorMethod.biometric:
          return m.code.toUpperCase() == 'TOUCHID';
        default:
          return false;
      }
    });

    if (selected == null || c.userSettings == null) {
      Get.snackbar(
        'Error',
        'No MFA method or user settings found',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
      return;
    }

    // ✅ Si es biométrico, verificar primero con local_auth
    if (selected.code.toUpperCase() == 'FACEID') {
      _isFaceId = true;
      _isBiometric = true;

      final success = await _authenticate();
      if (!success) {
        Get.snackbar(
          'Authentication Failed',
          'Face ID verification was not successful',
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
        );
        return;
      }
    } else if (selected.code.toUpperCase() == 'TOUCHID') {
      _isFaceId = false;
      _isBiometric = true;

      final success = await _authenticate();
      if (!success) {
        Get.snackbar(
          'Authentication Failed',
          'Fingerprint verification was not successful',
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
        );
        return;
      }
    }

    // ✅ Actualizar en backend si pasó la verificación
    bool res = await c.updateUserMfa(c.userSettings!.id, selected.id);
    if (!res) {
      return;
    }

    if (selected.code.toUpperCase() == 'AUTHENTICATOR') {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt(AppConstants.userId) ?? 0;

      if (userId > 0) {
        final data = await c.getAuthenticatorUrl(userId);
        if (data != null && mounted) {
          // ⚠️ NO cerramos aquí el diálogo principal
          await showDialog(
            context: context,
            builder: (_) => AuthenticatorPopup(
              secret: data['secret_code'] ?? '',
              qrCodeUrl: data['otp_url'] ?? '',
            ),
          );
        }
      }
    } else {
      // Si no es authenticator, cerramos normalmente
      Navigator.of(context).pop();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '2-Step Verification configured with ${_getMethodName(_selectedMethod!)}',
        ),
        backgroundColor: Colors.green,
      ),
    );
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
