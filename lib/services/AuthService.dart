import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static const String _baseUrl = 'http://10.0.2.2:8000'; // URL de votre backend
  final GoogleSignIn _googleSignIn;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthService()
      : _googleSignIn = GoogleSignIn(
          scopes: ['email', 'profile'],
          serverClientId: 'YOUR_SERVER_CLIENT_ID.apps.googleusercontent.com',
          clientId: 'YOUR_CLIENT_ID.apps.googleusercontent.com', // Pour iOS
        );

  Future<bool> signInWithGoogle() async {
    try {
      print('🔹 Initialisation de Google Sign-In...');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return false;

      print('🔹 Récupération du token Google...');
      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;
      
      if (googleAuth.idToken == null) {
        throw Exception('Google ID token is null');
      }

      print('🔹 Envoi au backend Laravel...');
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id_token': googleAuth.idToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _storage.write(key: 'auth_token', value: data['token']);
        return true;
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Erreur Google Sign-In: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _storage.delete(key: 'auth_token');
  }

  Future<String?> getAuthToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<bool> testBackendConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/sanctum/csrf-cookie'),
      );
      return response.statusCode == 204;
    } catch (e) {
      return false;
    }
  }
}