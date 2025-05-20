import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/models/cart_item.dart';
import 'package:restaurant/models/supplier.dart';
import 'package:restaurant/providers/cart_provider.dart';
import 'package:restaurant/providers/supplier_provider.dart';
import 'package:restaurant/widgets/product_card.dart';

class SupplierDetailScreen extends StatefulWidget {
  const SupplierDetailScreen({super.key});

  @override
  _SupplierDetailScreenState createState() => _SupplierDetailScreenState();
}

class _SupplierDetailScreenState extends State<SupplierDetailScreen> {
  late Future<Supplier> _supplierFuture;
  int? _supplierId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _supplierId = ModalRoute.of(context)!.settings.arguments as int;
    _supplierFuture = Provider.of<SupplierProvider>(context, listen: false)
        .getSupplierDetails(_supplierId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Supplier>(
          future: _supplierFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data!.name);
            }
            return const Text('Supplier Details');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
        ],
      ),
      body: FutureBuilder<Supplier>(
        future: _supplierFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No supplier found'));
          }

          final supplier = snapshot.data!;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(supplier.logo),
                      radius: 30,
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          supplier.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber),
                            Text('${supplier.rating}'),
                          ],
                        ),
                        Text(
                          supplier.categories.join(', '),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: supplier.products.length,
                  itemBuilder: (context, index) {
                    final product = supplier.products[index];
                    return ProductCard(
                      product: product,
                      onAddToCart: () {
                        Provider.of<CartProvider>(context, listen: false)
                            .addToCart(CartItem(product: product));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product.name} added to cart'),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}