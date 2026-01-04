# 🔧 Configuration Google Sign-In pour Mobile

## ❌ Erreur actuelle : `ApiException: 10` (DEVELOPER_ERROR)

Cette erreur signifie que les credentials OAuth ne sont pas correctement configurés.

**Problème détecté** : Le fichier `google-services.json` a un tableau `oauth_client` vide (`[]`), ce qui signifie qu'aucun OAuth client Android n'a été configuré dans Firebase Console.

## 📋 Étapes de configuration

### 1. **Obtenir le SHA-1 fingerprint**

#### Méthode 1 : Avec Gradle (Recommandé)
```powershell
cd MobileCoop\android
.\gradlew signingReport
```

Cherchez dans la sortie la section pour `debug` variant et copiez la valeur SHA1 (format: `AA:BB:CC:DD:EE:FF:...`)

#### Méthode 2 : Avec keytool (Windows)
```powershell
keytool -list -v -keystore "$env:USERPROFILE\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```

Cherchez la ligne "SHA1:" et copiez la valeur.

#### Méthode 3 : Avec keytool (Linux/Mac)
```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

### 2. **Configurer dans Firebase Console (MÉTHODE RECOMMANDÉE)**

1. Allez sur [Firebase Console](https://console.firebase.google.com/)
2. Sélectionnez votre projet (`coop-41b51`)
3. Allez dans **Project Settings** (⚙️ en haut à gauche)
4. Allez dans l'onglet **Your apps**
5. Cliquez sur votre app Android (`com.example.coop`)
6. Dans la section **SHA certificate fingerprints**, cliquez sur **Add fingerprint**
7. Collez le SHA-1 obtenu à l'étape 1
8. Cliquez sur **Save**
9. **Téléchargez le nouveau `google-services.json`** et remplacez `MobileCoop/android/app/google-services.json`

**Important** : Firebase va automatiquement créer un OAuth client Android avec le SHA-1 que vous ajoutez. C'est la méthode la plus simple !

### 2bis. **Alternative : Configurer dans Google Cloud Console**

Si vous préférez configurer manuellement :

1. Allez sur [Google Cloud Console](https://console.cloud.google.com/)
2. Sélectionnez votre projet Firebase (`coop-41b51`)
3. Allez dans **APIs & Services** → **Credentials**
4. Cliquez sur **+ CREATE CREDENTIALS** → **OAuth 2.0 Client ID**

#### Pour Android :
- **Application type** : Android
- **Name** : `Coop Android App`
- **Package name** : `com.example.coop` (vérifiez dans `android/app/build.gradle.kts`)
- **SHA-1 certificate fingerprint** : Collez le SHA-1 obtenu à l'étape 1

#### Pour Web (si vous utilisez serverClientId) :
- **Application type** : Web application
- **Name** : `Coop Web Client`
- **Authorized redirect URIs** : 
  - `http://localhost:8000/auth/callback/google`
  - `http://10.0.2.2:8000/auth/callback/google` (pour émulateur)

### 3. **Vérifier que google-services.json contient les OAuth clients**

Après avoir ajouté le SHA-1 dans Firebase Console et téléchargé le nouveau `google-services.json`, vérifiez que le fichier contient maintenant des OAuth clients :

```json
"oauth_client": [
  {
    "client_id": "123456789-abcdefgh.apps.googleusercontent.com",
    "client_type": 1,
    "android_info": {
      "package_name": "com.example.coop",
      "certificate_hash": "VOTRE_SHA1_ICI"
    }
  }
]
```

Si le tableau est toujours vide (`[]`), cela signifie que :
- Le SHA-1 n'a pas été correctement ajouté dans Firebase Console
- Ou le fichier n'a pas été re-téléchargé après l'ajout du SHA-1

### 4. **Configurer AuthService.dart (optionnel)**

Si vous voulez utiliser un `serverClientId` explicite :

```dart
AuthService()
    : _googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        serverClientId: 'VOTRE_WEB_CLIENT_ID.apps.googleusercontent.com',
      );
```

**Note** : Sur Android, Google Sign-In peut fonctionner sans `serverClientId` si `google-services.json` est correctement configuré.

### 5. **Vérifier la configuration**

1. Assurez-vous que `google-services.json` contient des `oauth_client` :
```json
"oauth_client": [
  {
    "client_id": "...",
    "client_type": 1,
    "android_info": {
      "package_name": "com.example.coop",
      "certificate_hash": "VOTRE_SHA1"
    }
  }
]
```

2. Vérifiez que le package name correspond :
   - `android/app/build.gradle.kts` : `applicationId = "com.example.coop"`
   - Google Cloud Console : même package name
   - `google-services.json` : même package name

### 6. **Rebuild l'application**

```bash
cd MobileCoop
flutter clean
flutter pub get
flutter run
```

## ✅ Vérification

Après configuration, Google Sign-In devrait :
- Ouvrir la fenêtre de sélection de compte Google
- Retourner un token d'authentification
- Créer l'utilisateur dans votre backend Laravel

## 🔍 Dépannage

### Erreur 10 (DEVELOPER_ERROR)
- ✅ Vérifiez que le SHA-1 est ajouté dans Google Cloud Console
- ✅ Vérifiez que le package name correspond
- ✅ Vérifiez que `google-services.json` est à jour

### Erreur 12501 (SIGN_IN_CANCELLED)
- Normal : l'utilisateur a annulé la connexion

### Pas de fenêtre de connexion
- Vérifiez que Google Play Services est installé sur l'émulateur/appareil
- Vérifiez la connexion internet

## 📚 Ressources

- [Google Sign-In Flutter](https://pub.dev/packages/google_sign_in)
- [Firebase Console](https://console.firebase.google.com/)
- [Google Cloud Console](https://console.cloud.google.com/)

