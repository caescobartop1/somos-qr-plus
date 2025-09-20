class AppConstants {
  static const String appName = 'SOMOS QR+';
  static const String appKey = 'WSCVvTeovuXzk9VURCqx5isl7GkV58sB';
  static const String theme = 'theme';
  // static const String baseUrl = 'https://hsmc-dev.top1solutions.com/api';
  // static const String baseUrl = 'http://192.168.1.19:8000/api';
  static const String baseUrl = 'https://appapi-db-dev.top1solutions.com';
  static const String baseAuthUrl =
      'https://authapi-meta-dev.top1solutions.com';
  static const String token = 'token';
  static const String tokenOtp = 'tokenOtp';
  static const String tokenResetPassword = 'tokenResetPassword';
  static const String loginMethod = 'loginMethod';
  static const String refreshToken = 'refreshToken';

  // URI
  // Auth
  static const String loginUrl = '/auth/login/';
  static const String resendCodeUrl = '/auth/resend_verification_code/';
  static const String validateCodeUrl = '/auth/verification_code/';
  static const String getEmailInvitationUrl = '/orders/get_email_invitation/';
  static const String createAccountUrl = '/auth/registration/';
  static const String forgotPasswordUrl = '/auth/password/reset/';
  static const String forgotPasswordConfirmUrl =
      '/auth/password/reset/confirm/';

   // Practice

   static const String practiceUrl = '/accounts/practice/';
   static const String practiceDetailsUrl = '/catalog/kpi/';
   static const String panelDetailsUrl = '/catalog/practice_mco_product/';
   static const String mocListDetailsUrl = '/accounts/mco_list/';
   static const String bonusDetailsUrl = '/accounts/bonus_chart_data/';
   static const String scheduleUrl = '/accounts/schedule/';
}
