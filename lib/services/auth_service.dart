import 'package:restaurant/services/api_client.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  Future<bool> login(String email, String password) async {
    // In a real app, this would call an API
    await Future.delayed(const Duration(seconds: 1));
    return email == 'test@example.com' && password == 'password';
  }
}