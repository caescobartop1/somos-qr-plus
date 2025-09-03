import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _token;
  Map<String, dynamic>? _user;

  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;
  Map<String, dynamic>? get user => _user;

  Future<void> login(String email, String password) async {
    // TODO: Implement actual login logic with your backend
    _isAuthenticated = true;
    _token = 'dummy_token';
    _user = {
      'email': email,
      'name': 'Provider Name',
      'role': 'provider',
    };
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', _token!);
    notifyListeners();
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    _token = null;
    _user = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    _isAuthenticated = _token != null;
    notifyListeners();
  }
} 