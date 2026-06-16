# 🌾 CoopMobile — Application de Gestion Coopérative

Une application mobile multiplateforme développée avec **Flutter**, destinée à la gestion d'une coopérative. Elle permet aux membres et administrateurs de gérer les activités coopératives depuis leur smartphone.

---

## 📱 Aperçu

`CoopMobile` (package : `gestioncoop`) est une application Flutter connectée à **Firebase**, offrant une expérience fluide sur Android, iOS, Web, et Desktop.

---

## 🚀 Fonctionnalités

- 🔐 **Authentification** via Google Sign-In et stockage sécurisé des tokens
- 🌐 **Connexion à une API REST** via le package `http`
- 🖼️ **Chargement d'images optimisé** avec cache réseau (`cached_network_image`)
- ⭐ **Système de notation** avec `flutter_rating_bar`
- 💾 **Persistance locale** avec `shared_preferences` et `path_provider`
- 🔒 **Stockage sécurisé** avec `flutter_secure_storage`
- 🎨 **Icônes enrichies** avec Font Awesome
- 🔥 **Intégration Firebase** (`firebase_core`)
- 🧩 **Gestion d'état** avec `provider`

---

## 🛠️ Technologies utilisées

| Technologie | Version |
|---|---|
| Flutter | ≥ 3.7.2 |
| Dart SDK | ^3.7.2 |
| Firebase Core | ^3.15.1 |
| Google Sign-In | ^6.2.1 |
| Provider | ^6.1.5 |
| HTTP | ^1.4.0 |
| Flutter Secure Storage | ^9.2.4 |
| Shared Preferences | ^2.2.2 |
| Font Awesome Flutter | ^10.8.0 |
| Cached Network Image | ^3.4.1 |
| Flutter Rating Bar | ^4.0.1 |

---

## 📋 Prérequis

Avant de commencer, assurez-vous d'avoir installé :

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (≥ 3.7.2)
- [Dart SDK](https://dart.dev/get-dart) (^3.7.2)
- [Android Studio](https://developer.android.com/studio) ou [VS Code](https://code.visualstudio.com/)
- Un compte [Firebase](https://firebase.google.com/)
- Un projet configuré dans [Google Cloud Console](https://console.cloud.google.com/) (pour Google Sign-In)

---

## ⚙️ Installation

### 1. Cloner le dépôt

```bash
git clone https://github.com/souhail-nasssih/coopMobile.git
cd coopMobile
```

### 2. Installer les dépendances

```bash
flutter pub get
```

### 3. Configurer Firebase

1. Créez un projet Firebase sur [console.firebase.google.com](https://console.firebase.google.com/)
2. Ajoutez votre application Android/iOS au projet Firebase
3. Téléchargez le fichier `google-services.json` (Android) et placez-le dans `android/app/`
4. Téléchargez `GoogleService-Info.plist` (iOS) et placez-le dans `ios/Runner/`

> 📄 Consultez le fichier `CONFIGURATION_RAPIDE.md` inclus dans le projet pour un guide détaillé.

### 4. Configurer Google Sign-In

Référez-vous au fichier `GOOGLE_SIGNIN_CONFIG.md` pour la configuration OAuth 2.0 dans Google Cloud Console.

Pour Android, récupérez votre empreinte SHA-1 :

```bash
# Windows (PowerShell)
.\get-sha1.ps1

# Ou manuellement
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

---

## ▶️ Lancer l'application

```bash
# Android
flutter run

# iOS
flutter run -d ios

# Web
flutter run -d chrome

# Desktop (Windows/macOS/Linux)
flutter run -d windows
flutter run -d macos
flutter run -d linux
```

---

## 🏗️ Structure du projet

```
coopMobile/
├── lib/                    # Code source Dart principal
├── android/                # Configuration Android native
├── ios/                    # Configuration iOS native
├── web/                    # Configuration Web
├── windows/                # Configuration Windows
├── macos/                  # Configuration macOS
├── linux/                  # Configuration Linux
├── test/                   # Tests unitaires et widgets
├── pubspec.yaml            # Dépendances et métadonnées
├── firebase.json           # Configuration Firebase
├── CONFIGURATION_RAPIDE.md
├── CONFIGURATION_SANS_FIREBASE.md
├── GOOGLE_SIGNIN_CONFIG.md
└── CREER_OAUTH_ANDROID.md
```

---

## 📚 Documentation complémentaire

Le projet inclut plusieurs guides de configuration :

| Fichier | Description |
|---|---|
| `CONFIGURATION_RAPIDE.md` | Guide de démarrage rapide |
| `CONFIGURATION_SANS_FIREBASE.md` | Utilisation sans Firebase |
| `GOOGLE_SIGNIN_CONFIG.md` | Configuration Google Sign-In |
| `CREER_OAUTH_ANDROID.md` | Création des identifiants OAuth Android |
| `GUIDE_AUTOMATIQUE.md` | Guide de configuration automatique |
| `OU_PLACER_GOOGLE_SERVICES.md` | Emplacement des fichiers de configuration |

---

## 🧪 Tests

```bash
flutter test
```

---

## 📦 Build de production

```bash
# APK Android
flutter build apk --release

# App Bundle Android (Google Play)
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

---

## 🤝 Contribution

Les contributions sont les bienvenues ! Pour contribuer :

1. Forkez le projet
2. Créez une branche pour votre fonctionnalité (`git checkout -b feature/ma-fonctionnalite`)
3. Committez vos modifications (`git commit -m 'Ajout de ma fonctionnalité'`)
4. Poussez la branche (`git push origin feature/ma-fonctionnalite`)
5. Ouvrez une Pull Request

---

## 👤 Auteur

**Souhail Nasssih**
- GitHub : [@souhail-nasssih](https://github.com/souhail-nasssih)

---

## 📄 Licence

Ce projet est privé. Tous droits réservés.
