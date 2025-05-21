import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  String? _token;
  Map<String, dynamic>? _user;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get token => _token;
  Map<String, dynamic>? get user => _user;
  bool get isAuthenticated => _token != null;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    try {
      _setLoading(true);
      clearError();

      await Future.delayed(const Duration(seconds: 2));
      if (email == 'shaheen@supplierapp.com' && password == 'password') {
        _token = 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}';
        _user = {
          'id': '1',
          'email': email,
          'name': 'John Doe',
          'role': 'admin',
        };
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _setError('Invalid email or password');
        return false;
      }
    } catch (e) {
      _setError('Login failed. Please try again.');
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      _setLoading(true);
      clearError();

      await Future.delayed(const Duration(seconds: 2));

      _token = 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}';
      _user = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'email': email,
        'name': name,
        'role': 'user',
      };
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Registration failed. Please try again.');
      return false;
    }
  }

  Future<bool> socialLogin(String provider) async {
    try {
      _setLoading(true);
      clearError();

      await Future.delayed(const Duration(seconds: 1));

      _token = 'mock_social_token_${DateTime.now().millisecondsSinceEpoch}';
      _user = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'email': 'user@$provider.com',
        'name': 'Social User',
        'role': 'user',
        'provider': provider,
      };

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _setError('$provider login failed. Please try again.');
      return false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    try {
      _setLoading(true);
      clearError();
      await Future.delayed(const Duration(seconds: 1));

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to send reset email. Please try again.');
      return false;
    }
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> validateToken() async {
    try {
      if (_token == null) return false;

      await Future.delayed(const Duration(milliseconds: 500));

      return _token != null;
    } catch (e) {
      await logout();
      return false;
    }
  }
}