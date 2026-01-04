import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gestioncoop/helpers/constants.dart';

class AuthService {
  final GoogleSignIn _googleSignIn;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthService()
      : _googleSignIn = GoogleSignIn(
          scopes: ['email', 'profile'],
          // ✅ Utilise le même OAuth Client ID Web que votre site e-commerce Laravel
          // Récupéré depuis le fichier .env (GOOGLE_CLIENT_ID)
          serverClientId: '748540104556-lo3vre26813begj9c8p8pqjbdvabt8sv.apps.googleusercontent.com',
        );

  /// Connexion avec email et mot de passe (comme le site web)
  Future<Map<String, dynamic>?> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      print('🔹 Connexion avec email/password...');
      
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      print('🔹 Status code: ${response.statusCode}');
      print('🔹 Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        final user = data['user'];
        
        // Sauvegarder le token
        await _storage.write(key: 'auth_token', value: token);
        await _storage.write(key: 'user_data', value: jsonEncode(user));
        
        return {
          'success': true,
          'token': token,
          'user': user,
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'error': error['error'] ?? 'Erreur de connexion',
          'message': error['message'] ?? 'Vérifiez vos identifiants',
        };
      }
    } catch (e) {
      print('❌ Erreur login email/password: $e');
      return {
        'success': false,
        'error': 'Erreur de connexion',
        'message': 'Impossible de se connecter. Vérifiez votre connexion internet.',
      };
    }
  }

  /// Connexion avec Google (comme le site web)
  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      print('🔹 Initialisation de Google Sign-In...');
      print('🔹 ServerClientId configuré: ${_googleSignIn.serverClientId ?? "null"}');
      
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return {
          'success': false,
          'error': 'Annulation',
          'message': 'Connexion Google annulée',
        };
      }

      print('🔹 Récupération du token Google...');
      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;
      
      if (googleAuth.idToken == null) {
        throw Exception('Google ID token is null');
      }

      print('🔹 Envoi au backend Laravel...');
      final response = await http.post(
        Uri.parse('$baseUrl/auth/google'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'id_token': googleAuth.idToken}),
      );

      print('🔹 Status code: ${response.statusCode}');
      print('🔹 Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        final user = data['user'];
        
        // Sauvegarder le token et les données utilisateur
        await _storage.write(key: 'auth_token', value: token);
        await _storage.write(key: 'user_data', value: jsonEncode(user));
        
        return {
          'success': true,
          'token': token,
          'user': user,
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'error': error['error'] ?? 'Erreur de connexion',
          'message': error['message'] ?? 'Erreur lors de la connexion Google',
        };
      }
    } catch (e) {
      print('❌ Erreur Google Sign-In: $e');
      
      // Messages d'erreur spécifiques selon le type d'erreur
      String errorMessage = 'Impossible de se connecter avec Google.';
      String? helpUrl;
      
      if (e.toString().contains('ApiException: 10') || e.toString().contains('sign_in_failed')) {
        errorMessage = '''⚠️ Erreur Google Sign-In (Code 10)

Le serverClientId est déjà configuré, mais Android nécessite aussi un OAuth Client ID Android.

🔧 SOLUTION RAPIDE (Google Cloud Console) :

✅ SHA-1 : 43:91:62:9D:EE:69:11:69:5F:FD:CF:41:24:81:BA:72:2B:BD:73:D3
✅ Nouveau Client ID configuré : 748540104556-lo3vre26813begj9c8p8pqjbdvabt8sv.apps.googleusercontent.com

1️⃣ Ouvrez Google Cloud Console :
   https://console.cloud.google.com/apis/credentials
   (Ou exécutez : MobileCoop\\ouvrir-google-cloud.ps1)

2️⃣ Créez OAuth Client ID Android :
   - + CREATE CREDENTIALS > OAuth 2.0 Client ID
   - Application type : Android
   - Package name : com.example.coop
   - SHA-1 : 43:91:62:9D:EE:69:11:69:5F:FD:CF:41:24:81:BA:72:2B:BD:73:D3
   - Create

3️⃣ Rebuild : flutter clean && flutter pub get && flutter run

📖 Voir CREER_OAUTH_ANDROID.md pour le guide complet

En attendant, utilisez la connexion email/password !''';
        helpUrl = 'https://console.cloud.google.com/apis/credentials';
      } else if (e.toString().contains('ApiException: 12501')) {
        errorMessage = 'Connexion Google annulée par l\'utilisateur.';
      } else {
        errorMessage = 'Échec de la connexion Google. Vérifiez votre configuration OAuth dans Google Cloud Console.';
      }
      
      return {
        'success': false,
        'error': 'Erreur Google',
        'message': errorMessage,
        'helpUrl': helpUrl,
      };
    }
  }

  /// Déconnexion
  Future<void> signOut() async {
    try {
      final token = await getAuthToken();
      
      // Appeler l'API de déconnexion si un token existe
      if (token != null) {
        try {
          await http.post(
            Uri.parse('$baseUrl/auth/logout'),
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            },
          );
        } catch (e) {
          print('⚠️ Erreur lors de la déconnexion serveur: $e');
        }
      }
      
      // Déconnexion Google
      await _googleSignIn.signOut();
      
      // Supprimer les données locales
      await _storage.delete(key: 'auth_token');
      await _storage.delete(key: 'user_data');
    } catch (e) {
      print('❌ Erreur lors de la déconnexion: $e');
    }
  }

  /// Récupérer le token d'authentification
  Future<String?> getAuthToken() async {
    return await _storage.read(key: 'auth_token');
  }

  /// Récupérer les données utilisateur
  Future<Map<String, dynamic>?> getUserData() async {
    final userDataString = await _storage.read(key: 'user_data');
    if (userDataString != null) {
      return jsonDecode(userDataString);
    }
    return null;
  }

  /// Vérifier si l'utilisateur est connecté
  Future<bool> isAuthenticated() async {
    final token = await getAuthToken();
    return token != null && token.isNotEmpty;
  }

  /// Obtenir les en-têtes d'authentification pour les requêtes API
  Future<Map<String, String>> getAuthHeaders() async {
    final token = await getAuthToken();
    if (token != null) {
      return {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };
    }
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
  }
}