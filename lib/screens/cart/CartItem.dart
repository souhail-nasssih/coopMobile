// cart_item.dart
import 'package:gestioncoop/models/Produit.dart';

class CartItem {
  final Produit produit;
  int quantity;

  CartItem({required this.produit, required this.quantity});
}