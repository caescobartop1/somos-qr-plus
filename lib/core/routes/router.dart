import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/create_account_screen.dart';
import '../../screens/auth/forgot_password_screen.dart';
import '../../screens/auth/reset_password_screen.dart';
import '../../screens/auth/two_factor_screen.dart';
import '../../screens/settings_screen.dart';
import '../../screens/quality_scorecards_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/create-account',
      builder: (context, state) => const CreateAccountScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/reset-password',
      builder: (context, state) => const ResetPasswordScreen(),
    ),
    GoRoute(
      path: '/2fa',
      builder: (context, state) => const TwoFactorScreen(),
    ),
            GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: '/quality-scorecards',
          builder: (context, state) => const QualityScorecardsScreen(),
        ),
  ],
); 