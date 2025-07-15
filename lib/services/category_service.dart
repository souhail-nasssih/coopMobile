import 'dart:convert';
import 'package:gestioncoop/models/GrandCategory.dart';
import 'package:gestioncoop/models/Produit.dart';
import 'package:http/http.dart' as http;
import 'package:gestioncoop/helpers/constants.dart'; // <-- import de baseUrl


class CategoryService {

  Future<List<GrandCategory>> fetchGrandCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories'));

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List<dynamic> grandsJson = decoded['grandCategories'];
      return grandsJson.map((json) => GrandCategory.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors du chargement des grandes catégories');
    }
  }

  Future<List<Produit>> fetchProduits() async {
    final response = await http.get(Uri.parse('$baseUrl/categories'));

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List<dynamic> produitsJson = decoded['products'];
      return produitsJson.map((json) => Produit.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors du chargement des produits');
    }
  }

  Future<List<Produit>> fetchProduitsByCategory(int categoryId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/categories/$categoryId/products'),
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List<dynamic> produitsJson = decoded['data'] ?? decoded['products'];
      return produitsJson.map((json) => Produit.fromJson(json)).toList();
    } else {
      throw Exception(
        'Erreur lors du chargement des produits (${response.statusCode})',
      );
    }
  }
}
