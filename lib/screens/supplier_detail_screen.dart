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
  final ScrollController _scrollController = ScrollController();
  bool _showAppBarShadow = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _showAppBarShadow = _scrollController.offset > 10;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _supplierId = ModalRoute.of(context)!.settings.arguments as int;
    _supplierFuture = Provider.of<SupplierProvider>(context, listen: false)
        .getSupplierDetails(_supplierId!);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: FutureBuilder<Supplier>(
          future: _supplierFuture,
          builder: (context, snapshot) {
            return Text(
              snapshot.hasData ? snapshot.data!.name : 'Supplier Details',
              style: const TextStyle(fontWeight: FontWeight.bold),
            );
          },
        ),
        centerTitle: true,
        elevation: _showAppBarShadow ? 4 : 0,
        actions: [
          IconButton(
            icon: Badge(
              label: Consumer<CartProvider>(
                builder: (context, cart, _) => Text(
                  cart.items.length.toString(),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
        ],
      ),
      body: FutureBuilder<Supplier>(
        future: _supplierFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: colors.primary),
                  const SizedBox(height: 16),
                  Text(
                    'Loading supplier...',
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: colors.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load supplier',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => setState(() {
                        _supplierFuture = Provider.of<SupplierProvider>(context, listen: false)
                            .getSupplierDetails(_supplierId!);
                      }),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: Text(
                'No supplier found',
                style: theme.textTheme.titleLarge,
              ),
            );
          }

          final supplier = snapshot.data!;
          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: _buildSupplierHeader(supplier, theme),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = supplier.products[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ProductCard(
                          product: product,
                          onAddToCart: () {
                            Provider.of<CartProvider>(context, listen: false)
                                .addToCart(CartItem(product: product));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${product.name} added to cart'),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                    childCount: supplier.products.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSupplierHeader(Supplier supplier, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(supplier.logo),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  supplier.name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      supplier.rating.toString(),
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurface.withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "12:00 PM",//supplier.deliveryTime,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: supplier.categories.map((category) {
                    return Chip(
                      label: Text(category),
                      visualDensity: VisualDensity.compact,
                      backgroundColor: theme.colorScheme.surfaceVariant,
                      labelStyle: theme.textTheme.labelSmall,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


