
import 'dart:convert';
import 'package:gestioncoop/models/Produit.dart';
import 'package:http/http.dart' as http;
import 'package:gestioncoop/helpers/constants.dart'; // <-- import de baseUrl


class ProduitService {

Future<List<Produit>> fetchProduits() async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/produits'));

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List<dynamic> data = decoded['data']['produits']; // ✅ Bonne cible

      return data.map((json) => Produit.fromJson(json)).toList();
    } else {
      throw Exception('Échec du chargement des produits');
    }
  } catch (e) {
    print('Erreur: $e');
    throw Exception('Erreur lors de la connexion à l’API');
  }
}

  Future<Produit> fetchProduitById(int id) async {
    try {
    final response = await http.get(Uri.parse('$baseUrl/produits/$id'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Produit.fromJson(data);
      } else {
        throw Exception('Produit non trouvé');
      }
    } catch (e) {
      print('Erreur: $e');
      throw Exception('Erreur lors de la connexion à l’API');
    }
  }
}
