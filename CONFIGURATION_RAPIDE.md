# ⚡ Configuration Rapide - Google Sign-In Mobile

## 🎯 Objectif
Utiliser **exactement le même système d'authentification** que votre site web e-commerce Laravel.

## ✅ Solution en 3 étapes (2 minutes)

### Étape 1 : Trouver votre GOOGLE_CLIENT_ID

Ouvrez votre fichier `.env` à la racine du projet Laravel et cherchez :
```env
GOOGLE_CLIENT_ID=xxxxxx-xxxxx.apps.googleusercontent.com
```

**Copiez cette valeur complète** (elle se termine par `.apps.googleusercontent.com`)

### Étape 2 : Configurer dans l'app mobile

Ouvrez le fichier : `MobileCoop/lib/services/AuthService.dart`

Trouvez la ligne 18 qui contient :
```dart
serverClientId: null, // ⚠️ Remplacez par votre GOOGLE_CLIENT_ID du .env
```

Remplacez par :
```dart
serverClientId: 'VOTRE_GOOGLE_CLIENT_ID_ICI.apps.googleusercontent.com',
```

**Exemple concret :**
Si dans votre `.env` vous avez :
```
GOOGLE_CLIENT_ID=123456789-abcdefghijklmnop.apps.googleusercontent.com
```

Alors dans `AuthService.dart` ligne 18, mettez :
```dart
serverClientId: '123456789-abcdefghijklmnop.apps.googleusercontent.com',
```

### Étape 3 : Rebuild l'application

```bash
cd MobileCoop
flutter clean
flutter pub get
flutter run
```

## 🎉 C'est tout !

Maintenant, Google Sign-In fonctionne **exactement comme sur votre site web** :
- ✅ Même OAuth Client ID
- ✅ Même backend Laravel
- ✅ Même logique d'authentification
- ✅ Même création de compte utilisateur

## 🔍 Vérification

1. Cliquez sur l'icône de connexion (👤) dans l'app
2. Sélectionnez "Se connecter avec Google"
3. Choisissez votre compte Google
4. Vous êtes connecté ! 🎊

## ❓ Pourquoi ça fonctionne ?

- **Site Web** : Utilise `GOOGLE_CLIENT_ID` du `.env` → Fonctionne ✅
- **App Mobile** : Utilise le même `GOOGLE_CLIENT_ID` comme `serverClientId` → Fonctionne aussi ✅

C'est le **même système**, juste utilisé différemment selon la plateforme !

## 🆘 Si ça ne fonctionne pas

1. Vérifiez que le Client ID est correct (copié sans espaces)
2. Vérifiez le format (doit se terminer par `.apps.googleusercontent.com`)
3. Vérifiez que le Client ID est bien de type "Web application" dans Google Cloud Console
4. Rebuild l'app après modification : `flutter clean && flutter run`

## 📝 Note

En attendant la configuration, vous pouvez utiliser la **connexion email/password** qui fonctionne déjà parfaitement avec votre backend Laravel !

