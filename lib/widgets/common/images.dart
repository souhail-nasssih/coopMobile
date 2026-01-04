import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gestioncoop/helpers/constants.dart';

/// URL de l'image par défaut pour les produits sans image
String getDefaultProductImageUrl() {
  String serverBaseUrl = baseUrl.replaceAll('/api', '');
  return '$serverBaseUrl/images/placeholder-product.jpg';
}

/// Fonction utilitaire pour corriger les URLs d'images
/// Gère les différents formats d'URLs retournés par l'API Laravel
/// Retourne une chaîne vide si l'image est vide (les widgets gèrent le placeholder local)
String fixImageUrl(String? rawUrl, {bool useDefault = false}) {
  if (rawUrl == null || rawUrl.isEmpty) {
    // Ne pas retourner l'URL du serveur par défaut pour éviter les erreurs de connexion
    // Les widgets utiliseront le placeholder local à la place
    return '';
  }

  // Extraire l'URL de base depuis la constante (enlever /api)
  String serverBaseUrl = baseUrl.replaceAll('/api', '');
  
  // Si l'URL est déjà complète et valide
  if (rawUrl.startsWith('http://') || rawUrl.startsWith('https://')) {
    String correctedUrl = rawUrl;
    
    // Remplacer localhost/127.0.0.1 par l'adresse appropriée selon la plateforme
    if (Platform.isAndroid && !kIsWeb) {
      // Pour Android émulateur, utiliser 10.0.2.2
      correctedUrl = correctedUrl.replaceAll('http://localhost', 'http://10.0.2.2');
      correctedUrl = correctedUrl.replaceAll('https://localhost', 'https://10.0.2.2');
      correctedUrl = correctedUrl.replaceAll('127.0.0.1', '10.0.2.2');
    } else if (Platform.isIOS && !kIsWeb) {
      // Pour iOS simulateur, localhost fonctionne généralement
      // Mais on peut aussi utiliser l'IP locale si nécessaire
      correctedUrl = correctedUrl.replaceAll('127.0.0.1', 'localhost');
    }
    
    return correctedUrl;
  }

  // Si c'est un chemin relatif commençant par /storage
  if (rawUrl.startsWith('/storage')) {
    return '$serverBaseUrl$rawUrl';
  }

  // Si le chemin commence par storage/ (sans slash initial)
  if (rawUrl.startsWith('storage/')) {
    return '$serverBaseUrl/$rawUrl';
  }

  // Si c'est un chemin sans slash initial et qui ne commence pas par storage
  if (rawUrl.isNotEmpty && !rawUrl.startsWith('/') && !rawUrl.startsWith('http')) {
    // Essayer de construire l'URL complète
    return '$serverBaseUrl/storage/$rawUrl';
  }

  // Retourner l'URL telle quelle si aucun pattern ne correspond
  return rawUrl;
}

/// Vérifie si une URL d'image est valide
bool isValidImageUrl(String? url) {
  if (url == null || url.isEmpty) return false;
  return url.startsWith('http://') || url.startsWith('https://');
}

/// Widget placeholder local pour les produits sans image
/// Ne dépend pas du serveur, toujours disponible
Widget buildDefaultProductPlaceholder({
  double? width,
  double? height,
  BoxFit fit = BoxFit.cover,
}) {
  return Container(
    width: width,
    height: height,
    color: Colors.grey[200],
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.shopping_bag_outlined,
          size: (width != null && height != null) 
              ? (width < height ? width * 0.25 : height * 0.25)
              : 50,
          color: Colors.grey[400],
        ),
        if (height != null && height > 80) ...[
          const SizedBox(height: 6),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Image non disponible',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ],
    ),
  );
}

