import 'package:restaurant/models/product.dart';

class Supplier {
  final int id;
  final String name;
  final String logo;
  final double rating;
  final List<String> categories;
  final List<Product> products;

  Supplier({
    required this.id,
    required this.name,
    required this.logo,
    required this.rating,
    required this.categories,
    required this.products,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: json['id'],
      name: json['name'],
      logo: json['logo'],
      rating: json['rating'].toDouble(),
      categories: List<String>.from(json['categories']),
      products: (json['products'] as List)
          .map((product) => Product.fromJson(product))
          .toList(),
    );
  }
}