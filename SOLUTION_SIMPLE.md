# ✅ Solution Simple : Utiliser le même OAuth Client ID que le Web

## 🎯 Pourquoi c'est plus simple ?

Si Google Sign-In fonctionne déjà sur votre site web, vous avez déjà un **OAuth Client ID Web** configuré dans votre backend Laravel. Vous pouvez simplement **réutiliser ce même Client ID** pour le mobile, sans avoir besoin de configurer le SHA-1 !

**C'est exactement le même système d'authentification que votre site web e-commerce !**

## 📋 Étapes (2 minutes)

### 1. Récupérer votre GOOGLE_CLIENT_ID

Vous avez deux options :

#### Option A : Depuis votre fichier .env Laravel
Ouvrez votre fichier `.env` et cherchez :
```
GOOGLE_CLIENT_ID=xxxxxx-xxxxx.apps.googleusercontent.com
```

#### Option B : Depuis Google Cloud Console
1. Allez sur [Google Cloud Console](https://console.cloud.google.com/)
2. Sélectionnez votre projet
3. **APIs & Services** → **Credentials**
4. Cherchez votre **OAuth 2.0 Client ID** de type **Web application**
5. Copiez le **Client ID** (format: `xxxxxx-xxxxx.apps.googleusercontent.com`)

### 2. Configurer dans AuthService.dart

Ouvrez `MobileCoop/lib/services/AuthService.dart` et remplacez :

```dart
AuthService()
    : _googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        serverClientId: null, // ❌ Actuellement null
      );
```

Par :

```dart
AuthService()
    : _googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        serverClientId: 'VOTRE_GOOGLE_CLIENT_ID_ICI.apps.googleusercontent.com', // ✅ Votre Client ID Web
      );
```

**Exemple :**
```dart
serverClientId: '123456789-abcdefghijklmnop.apps.googleusercontent.com',
```

### 3. C'est tout ! 🎉

Rebuild l'application :
```bash
flutter clean
flutter pub get
flutter run
```

Google Sign-In devrait maintenant fonctionner exactement comme sur le web !

## 🔍 Vérification

1. Cliquez sur le bouton de connexion Google dans l'app
2. La fenêtre de sélection de compte Google devrait s'ouvrir
3. Après sélection, vous devriez être connecté

## ❓ Pourquoi ça fonctionne ?

- **Web** : Utilise le OAuth Client ID Web → fonctionne ✅
- **Mobile** : Utilise le même OAuth Client ID Web comme `serverClientId` → fonctionne aussi ✅

Pas besoin de configurer le SHA-1 car on utilise le Client ID Web qui n'en a pas besoin !

## 🆘 Si ça ne fonctionne pas

Si vous obtenez toujours une erreur, vérifiez que :
1. Le Client ID est correct (copié sans espaces)
2. Le format est correct (se termine par `.apps.googleusercontent.com`)
3. Le Client ID est bien de type "Web application" dans Google Cloud Console

