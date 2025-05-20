import 'package:restaurant/models/supplier.dart';
import 'package:restaurant/services/api_client.dart';

class SupplierService {
  final ApiClient _apiClient = ApiClient();

  Future<List<Supplier>> getSuppliers() async {
    final response = await _apiClient.loadJsonData('assets/json/suppliers.json');
    return response.map<Supplier>((json) => Supplier.fromJson(json)).toList();
  }

  Future<Supplier> getSupplierDetails(int supplierId) async {
    final suppliers = await getSuppliers();
    return suppliers.firstWhere((supplier) => supplier.id == supplierId);
  }
}