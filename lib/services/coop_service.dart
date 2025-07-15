import 'dart:convert';
import 'package:gestioncoop/models/Coop.dart';
import 'package:gestioncoop/models/Produit.dart';
import 'package:http/http.dart' as http;
import 'package:gestioncoop/helpers/constants.dart'; // baseUrl

class CoopService {
  // Méthode existante pour récupérer toutes les coopératives
  Future<List<Coop>> fetchCoops() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/coops'));
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List<dynamic> data = decoded['coops'];
        return data.map((json) => Coop.fromJson(json)).toList();
      } else {
        throw Exception('Échec du chargement des coopératives');
      }
    } catch (e) {
      print('Erreur: $e');
      throw Exception('Erreur lors de la connexion à l’API');
    }
  }

  // Nouvelle méthode pour récupérer un profil coop complet avec produits paginés et filtres
  Future<Map<String, dynamic>> fetchCoopProfile(
    int coopId, {
    Map<String, String>? filters,
  }) async {
    try {
      final uri = Uri.parse(
        '$baseUrl/profilecooperative/$coopId',
      ).replace(queryParameters: filters);
      print('Requête API URL : $uri');

      final response = await http.get(uri);
      print('Status code: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final coop = Coop.fromJson(data['profileCooperative']);
        final produits =
            (data['produits'] as List<dynamic>)
                .map((json) => Produit.fromJson(json))
                .toList();
        final pagination = data['pagination'] ?? {};

        return {'coop': coop, 'produits': produits, 'reviews': coop.reviews, 'pagination': pagination};
      } else {
        throw Exception('Erreur lors du chargement du profil coop');
      }
    } catch (e) {
      print('Erreur: $e');
      throw Exception('Erreur lors de la connexion à l’API');
    }
  }
}
