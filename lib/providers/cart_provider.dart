import 'package:flutter/foundation.dart';
import 'package:restaurant/models/cart_item.dart';
import 'package:restaurant/models/product.dart';
import 'package:restaurant/services/cart_service.dart';

class CartProvider with ChangeNotifier {
  final CartService _cartService = CartService();
  static const double _deliveryFee = 2.99;
  static const double _taxRate = 0.08;

  List<CartItem> get items => _cartService.items;

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
  
  double get subtotal => _cartService.totalPrice;
  
  double get deliveryFee => _deliveryFee;
  
  double get tax => subtotal * _taxRate;
  
  double get total => subtotal + deliveryFee + tax;

  bool get isEmpty => items.isEmpty;

  void addToCart(CartItem item) {
    _cartService.addToCart(item.product);
    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    _cartService.removeFromCart(item.product);
    notifyListeners();
  }

  void updateQuantity(CartItem item, int quantity) {
    if (quantity < 1) {
      removeFromCart(item);
      return;
    }
    _cartService.updateQuantity(item.product, quantity);
    notifyListeners();
  }

  void clearCart() {
    _cartService.clearCart();
    notifyListeners();
  }

  bool containsProduct(int productId) {
    return items.any((item) => item.product.id == productId);
  }
  
  int getProductQuantity(int productId) {
    return items.firstWhere(
      (item) => item.product.id == productId,
      orElse: () => CartItem(product: Product(id: -1, name: '', price: 0, image: '', description: ''), quantity: 0), 
    ).quantity;
  }
}