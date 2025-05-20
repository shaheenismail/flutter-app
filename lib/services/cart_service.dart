import 'package:restaurant/models/cart_item.dart';
import 'package:restaurant/models/product.dart';

class CartService {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addToCart(Product product) {
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);
    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
  }

  void removeFromCart(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
  }

  void updateQuantity(Product product, int quantity) {
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);
    if (existingIndex >= 0) {
      if (quantity <= 0) {
        _items.removeAt(existingIndex);
      } else {
        _items[existingIndex].quantity = quantity;
      }
    }
  }

  double get totalPrice {
    return _items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  void clearCart() {
    _items.clear();
  }
}