import 'package:flutter/foundation.dart';
import 'package:restaurant/models/supplier.dart';
import 'package:restaurant/services/supplier_service.dart';

class SupplierProvider with ChangeNotifier {
  final SupplierService _supplierService = SupplierService();
  List<Supplier> _suppliers = [];
  bool _isLoading = false;
  String? _error;

  List<Supplier> get suppliers => _suppliers;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadSuppliers() async {
    _isLoading = true;
    notifyListeners();

    try {
      _suppliers = await _supplierService.getSuppliers();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Supplier> getSupplierDetails(int supplierId) async {
    try {
      return await _supplierService.getSupplierDetails(supplierId);
    } catch (e) {
      throw Exception("Failed to load supplier details: $e");
    }
  }
}