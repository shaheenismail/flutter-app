import 'package:flutter/foundation.dart';
import 'package:restaurant/models/cart_item.dart';
import 'package:restaurant/services/cart_service.dart';

class CartProvider with ChangeNotifier {
  final CartService _cartService = CartService();

  List<CartItem> get items => _cartService.items;
  double get totalPrice => _cartService.totalPrice;

  void addToCart(CartItem item) {
    _cartService.addToCart(item.product);
    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    _cartService.removeFromCart(item.product);
    notifyListeners();
  }

  void updateQuantity(CartItem item, int quantity) {
    _cartService.updateQuantity(item.product, quantity);
    notifyListeners();
  }

  void clearCart() {
    _cartService.clearCart();
    notifyListeners();
  }
}