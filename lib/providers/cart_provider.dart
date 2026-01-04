// cart_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gestioncoop/models/Produit.dart';
import 'package:gestioncoop/screens/cart/CartItem.dart';
import 'package:gestioncoop/services/AuthService.dart';
import 'package:gestioncoop/helpers/constants.dart';

class CartProvider with ChangeNotifier {
  final Map<int, CartItem> _items = {};
  bool _isLoading = false;
  bool _isSyncing = false;
  final AuthService _authService = AuthService();

  CartProvider() {
    _checkAuthAndLoadCart();
  }

  List<CartItem> get items => _items.values.toList();

  double get totalPrice => _items.values
      .fold(0, (total, item) => total + item.produit.prix * item.quantity);

  bool get isLoading => _isLoading;
  bool get isSyncing => _isSyncing;

  /// Vérifier l'authentification et charger le panier
  Future<void> _checkAuthAndLoadCart() async {
    _isLoading = true;
    notifyListeners();

    try {
      final isAuthenticated = await _authService.isAuthenticated();
      if (isAuthenticated) {
        // Si connecté, charger depuis le serveur
        await _loadCartFromServer();
      } else {
        // Si déconnecté, vider le panier
        _items.clear();
      }
    } catch (e) {
      print('Erreur lors du chargement du panier: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Charger le panier depuis le serveur
  Future<void> _loadCartFromServer() async {
    try {
      final token = await _authService.getAuthToken();
      if (token == null) {
        _items.clear();
        return;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/cart'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> items = data['items'] ?? [];

        _items.clear();
        for (var item in items) {
          try {
            final produit = Produit.fromJson(item);
            final quantity = item['quantity'] as int;
            _items[produit.id] = CartItem(produit: produit, quantity: quantity);
          } catch (e) {
            print('Erreur lors du chargement d\'un produit du panier: $e');
          }
        }
      } else if (response.statusCode == 401) {
        // Non authentifié, vider le panier
        _items.clear();
      }
    } catch (e) {
      print('Erreur lors du chargement du panier depuis le serveur: $e');
    }
  }


  /// Ajouter un produit au panier
  Future<void> addToCart(Produit produit) async {
    if (_items.containsKey(produit.id)) {
      _items[produit.id]!.quantity++;
    } else {
      _items[produit.id] = CartItem(produit: produit, quantity: 1);
    }
    notifyListeners();

    // Synchroniser avec le serveur si connecté
    final isAuthenticated = await _authService.isAuthenticated();
    if (isAuthenticated) {
      await _addToCartOnServer(produit.id, _items[produit.id]!.quantity);
    }
  }

  /// Ajouter un produit au panier sur le serveur
  Future<void> _addToCartOnServer(int produitId, int quantity) async {
    try {
      final token = await _authService.getAuthToken();
      if (token == null) return;

      final response = await http.post(
        Uri.parse('$baseUrl/cart'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'produit_id': produitId,
          'quantity': quantity,
        }),
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        final error = jsonDecode(response.body);
        print('Erreur serveur lors de l\'ajout au panier: ${error['message']}');
        // Optionnel : afficher un message d'erreur à l'utilisateur
      }
    } catch (e) {
      print('Erreur lors de l\'ajout au panier sur le serveur: $e');
    }
  }

  /// Retirer un produit du panier
  Future<void> removeFromCart(Produit produit) async {
    _items.remove(produit.id);
    notifyListeners();

    // Synchroniser avec le serveur si connecté
    final isAuthenticated = await _authService.isAuthenticated();
    if (isAuthenticated) {
      await _removeFromCartOnServer(produit.id);
    }
  }

  /// Retirer un produit du panier sur le serveur
  Future<void> _removeFromCartOnServer(int produitId) async {
    try {
      final token = await _authService.getAuthToken();
      if (token == null) return;

      await http.delete(
        Uri.parse('$baseUrl/cart/$produitId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    } catch (e) {
      print('Erreur lors de la suppression du panier sur le serveur: $e');
    }
  }

  /// Incrémenter la quantité
  Future<void> incrementQuantity(int productId) async {
    if (_items.containsKey(productId)) {
      _items[productId]!.quantity++;
      notifyListeners();

      // Synchroniser avec le serveur si connecté
      final isAuthenticated = await _authService.isAuthenticated();
      if (isAuthenticated) {
        await _updateQuantityOnServer(productId, _items[productId]!.quantity);
      }
    }
  }

  /// Décrémenter la quantité
  Future<void> decrementQuantity(int productId) async {
    if (_items.containsKey(productId)) {
      if (_items[productId]!.quantity > 1) {
        _items[productId]!.quantity--;
        notifyListeners();

        // Synchroniser avec le serveur si connecté
        final isAuthenticated = await _authService.isAuthenticated();
        if (isAuthenticated) {
          await _updateQuantityOnServer(productId, _items[productId]!.quantity);
        }
      } else {
        // Si quantité = 1, supprimer
        final produit = _items[productId]!.produit;
        await removeFromCart(produit);
      }
    }
  }

  /// Mettre à jour la quantité sur le serveur
  Future<void> _updateQuantityOnServer(int produitId, int quantity) async {
    try {
      final token = await _authService.getAuthToken();
      if (token == null) return;

      final response = await http.put(
        Uri.parse('$baseUrl/cart/$produitId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'quantity': quantity,
        }),
      );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        print('Erreur serveur lors de la mise à jour: ${error['message']}');
        // Si erreur (ex: stock insuffisant), recharger depuis le serveur
        if (response.statusCode == 400) {
          await _loadCartFromServer();
          notifyListeners();
        }
      }
    } catch (e) {
      print('Erreur lors de la mise à jour de la quantité sur le serveur: $e');
    }
  }

  /// Vider le panier
  Future<void> clearCart() async {
    _items.clear();
    notifyListeners();

    // Synchroniser avec le serveur si connecté
    final isAuthenticated = await _authService.isAuthenticated();
    if (isAuthenticated) {
      await _clearCartOnServer();
    }
  }

  /// Vider le panier sur le serveur
  Future<void> _clearCartOnServer() async {
    try {
      final token = await _authService.getAuthToken();
      if (token == null) return;

      await http.delete(
        Uri.parse('$baseUrl/cart'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    } catch (e) {
      print('Erreur lors du vidage du panier sur le serveur: $e');
    }
  }

  /// Recharger le panier depuis le serveur (utile après connexion)
  Future<void> reloadCart() async {
    await _checkAuthAndLoadCart();
  }

  /// Vider le panier local (appelé lors de la déconnexion)
  void clearLocalCart() {
    _items.clear();
    notifyListeners();
  }
}
