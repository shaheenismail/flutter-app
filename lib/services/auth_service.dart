import 'package:restaurant/services/api_client.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return email == 'shaheen@supplierapp.com' && password == 'password';
  }
}