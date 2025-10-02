import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:somos_qr_plus/constants/app_constants.dart';
import 'package:somos_qr_plus/controllers/auth_controller.dart';
import 'dart:async';

import 'package:somos_qr_plus/helpers/route_helper.dart';
import 'package:somos_qr_plus/widgets/spinner.dart';

class TwoFactorScreen extends StatefulWidget {
  const TwoFactorScreen({super.key});

  @override
  State<TwoFactorScreen> createState() => _TwoFactorScreenState();
}

class _TwoFactorScreenState extends State<TwoFactorScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool _forceOtp = false;

  final List<TextEditingController> _codeControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  final List<FocusNode> _codeFocusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  bool _isLoading = false;
  bool _canResend = false;
  int _countdown = 60;
  Timer? _timer;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    Future.delayed(const Duration(milliseconds: 100), () {
      _animationController.forward();
    });

    _startCountdown();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var focusNode in _codeFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _startCountdown() {
    _canResend = false;
    final authController = Get.find<AuthController>();
    _countdown = (authController.loginResponse?.resendOtpDelay ?? 6) * 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<AuthController>(builder: (authController) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1976D2),
                Color(0xFF4CAF50),
              ],
            ),
          ),
          child: Stack(children: [
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: _buildTwoFactorCard(authController),
                    ),
                  ),
                ),
              ),
            ),
            if (_isLoading) LoadingSpinner()
          ]),
        );
      }),
    );
  }

  Widget _buildTwoFactorCard(AuthController authController) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Card(
        elevation: 20,
        shadowColor: Colors.black.withOpacity(0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                Colors.white,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLogoSection(),
                const SizedBox(height: 20),
                _buildTwoFactorForm(authController),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      children: [
        Image.asset(
          'assets/images/SOMOS QR.png',
          width: 150,
          height: 150,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 150,
              height: 150,
              color: Colors.grey[100],
              child: const Icon(
                Icons.medical_services,
                size: 60,
                color: Color(0xFF1976D2),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTwoFactorForm(AuthController authController) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildFormHeader(),
          const SizedBox(height: 20),
          _buildCodeInputs(),
          const SizedBox(height: 16),
          _buildVerifyButton(authController),
          if ((authController.loginResponse?.loginMethod ?? '').toUpperCase() ==
                  'AUTHENTICATOR' &&
              !_forceOtp) ...[
            const SizedBox(height: 16),
            _buildSwitchToOtpButton(authController),
          ] else ...[
            const SizedBox(height: 16),
            _buildResendButton(authController),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 8),
          _buildBackToLoginButton(),
        ],
      ),
    );
  }

  Widget _buildSwitchToOtpButton(AuthController authController) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          setState(() {
            _forceOtp = true;
          });
          await _handleResendCode(
              authController, true); // 👉 dispara resend de una vez
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Switch to OTP',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildFormHeader() {
    return Column(
      children: [
        Text(
          'Two-Factor Authentication',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Enter the 6-digit code sent to your device',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey[600],
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildCodeInputs() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (index) {
            return SizedBox(
              width: 45,
              child: TextFormField(
                controller: _codeControllers[index],
                focusNode: _codeFocusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  counterText: '',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFF1976D2), width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFFD32F2F), width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  fillColor: _codeControllers[index].text.isNotEmpty
                      ? const Color(0xFF1976D2).withOpacity(0.1)
                      : Colors.grey[50],
                  filled: true,
                ),
                onChanged: (value) {
                  if (value.isNotEmpty && index < 5) {
                    _codeFocusNodes[index + 1].requestFocus();
                  }
                  setState(() {}); // Update fill color
                },
                onTap: () {
                  // Clear field when tapped if it has content
                  if (_codeControllers[index].text.isNotEmpty) {
                    _codeControllers[index].clear();
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '';
                  }
                  return null;
                },
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        // Error message area
        Container(
          height: 20,
          alignment: Alignment.center,
          child: Text(
            '', // Error messages will go here
            style: TextStyle(
              fontSize: 12,
              color: Colors.red[600],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVerifyButton(AuthController authController) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading
            ? null
            : () async {
                final code = _codeControllers
                    .map((controller) => controller.text)
                    .join('');
                if (code.length != 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter the complete 6-digit code'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                setState(() {
                  _isLoading = true;
                });
                await authController.validateCode(code);
                setState(() {
                  _isLoading = false;
                });
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1976D2),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                'Verify Code',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildResendButton(AuthController authController) {
    return TextButton(
      onPressed: _canResend
          ? () {
              _handleResendCode(authController, false);
            }
          : null,
      style: TextButton.styleFrom(
        foregroundColor:
            _canResend ? const Color(0xFF1976D2) : Colors.grey[400],
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: _canResend
          ? Text(
              'Resend Code',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            )
          : Text(
              'Resend Code (${formatTime(_countdown)})',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
    );
  }

  Widget _buildBackToLoginButton() {
    return TextButton(
      onPressed: () {
        Get.toNamed(RouteHelper.getLoginRoute());
      },
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF1976D2),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        'Back to Login',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Future<void> _handleResendCode(
      AuthController authController, bool forceSend) async {
    if (!_canResend && !forceSend) return;
    setState(() {
      _isLoading = true;
    });
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(AppConstants.loginMethod, 'OTP');
    await authController.reSendCode();
    setState(() {
      _isLoading = false;
    });
    _startCountdown();
  }
}
