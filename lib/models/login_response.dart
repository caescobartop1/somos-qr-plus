class LoginResponse {
  final String token;
  final String tokenExpiryTime;
  final String otpExpiryTime;
  final bool isPhoneVerified;
  final int resendOtpDelay;
  final String loginMethod;
  final String csrfToken;

  LoginResponse({
    required this.token,
    required this.tokenExpiryTime,
    required this.otpExpiryTime,
    required this.isPhoneVerified,
    required this.resendOtpDelay,
    required this.loginMethod,
    required this.csrfToken,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] ?? '',
      tokenExpiryTime: json['token_expiry_time'] ?? '',
      otpExpiryTime: json['otp_expiry_time'] ?? '',
      isPhoneVerified: json['is_phone_verified'] ?? false,
      resendOtpDelay: json['resend_otp_delay'] ?? 0,
      loginMethod: json['login_method'] ?? '',
      csrfToken: json['csrf_token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'token_expiry_time': tokenExpiryTime,
      'otp_expiry_time': otpExpiryTime,
      'is_phone_verified': isPhoneVerified,
      'resend_otp_delay': resendOtpDelay,
      'login_method': loginMethod,
      'csrf_token': csrfToken,
    };
  }
}
