// cart_provider.dart
import 'package:flutter/material.dart';
import 'package:gestioncoop/models/Produit.dart';
import 'package:gestioncoop/screens/cart/CartItem.dart';

class CartProvider with ChangeNotifier {
  final Map<int, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList();

  double get totalPrice => _items.values
      .fold(0, (total, item) => total + item.produit.prix * item.quantity);

  void addToCart(Produit produit) {
    if (_items.containsKey(produit.id)) {
      _items[produit.id]!.quantity++;
    } else {
      _items[produit.id] = CartItem(produit: produit, quantity: 1);
    }
    notifyListeners();
  }

  void removeFromCart(Produit produit) {
    _items.remove(produit.id);
    notifyListeners();
  }

  void incrementQuantity(int productId) {
    if (_items.containsKey(productId)) {
      _items[productId]!.quantity++;
      notifyListeners();
    }
  }

  void decrementQuantity(int productId) {
    if (_items.containsKey(productId)) {
      if (_items[productId]!.quantity > 1) {
        _items[productId]!.quantity--;
      } else {
        _items.remove(productId);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}