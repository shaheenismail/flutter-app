import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/providers/supplier_provider.dart';
import 'package:restaurant/widgets/supplier_card.dart';

class SupplierListScreen extends StatefulWidget {
  const SupplierListScreen({super.key});

  @override
  _SupplierListScreenState createState() => _SupplierListScreenState();
}

class _SupplierListScreenState extends State<SupplierListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SupplierProvider>(context, listen: false).loadSuppliers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final supplierProvider = Provider.of<SupplierProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Suppliers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
        ],
      ),
      body: supplierProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : supplierProvider.error != null
              ? Center(child: Text(supplierProvider.error!))
              : ListView.builder(
                  itemCount: supplierProvider.suppliers.length,
                  itemBuilder: (context, index) {
                    final supplier = supplierProvider.suppliers[index];
                    return SupplierCard(
                      supplier: supplier,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/supplier-details',
                          arguments: supplier.id,
                        );
                      },
                    );
                  },
                ),
    );
  }
}