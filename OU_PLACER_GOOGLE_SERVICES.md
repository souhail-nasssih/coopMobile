# 📁 Où placer le fichier google-services.json

## ✅ Emplacement exact

Le fichier `google-services.json` téléchargé depuis Firebase Console ou Google Cloud Console doit être placé dans :

```
MobileCoop/android/app/google-services.json
```

## 📋 Étapes détaillées

### 1. Télécharger le fichier

- Depuis **Firebase Console** : Project Settings > Your apps > Download `google-services.json`
- Depuis **Google Cloud Console** : Si vous avez configuré Firebase

### 2. Remplacer le fichier existant

**Chemin complet :**
```
C:\Users\souha\OneDrive\Bureau\gestionCoop\MobileCoop\android\app\google-services.json
```

### 3. Vérifier que le fichier est au bon endroit

Le fichier doit être dans le même dossier que `build.gradle.kts` :
```
MobileCoop/android/app/
├── build.gradle.kts          ← Ici
├── google-services.json       ← Ici (même dossier)
└── src/
```

## ⚠️ Important

- Le fichier doit s'appeler exactement : `google-services.json`
- Il doit être dans : `MobileCoop/android/app/` (pas dans `android/app/` à la racine)
- Après avoir remplacé le fichier, **rebuild l'application** :
  ```bash
  cd MobileCoop
  flutter clean
  flutter pub get
  flutter run
  ```

## 🔍 Vérification

Le fichier `build.gradle.kts` contient déjà la ligne :
```kotlin
id("com.google.gms.google-services")
```

Cela signifie que le plugin Google Services est déjà configuré et cherchera automatiquement le fichier `google-services.json` dans `android/app/`.

## 📝 Note

Si vous avez téléchargé le fichier JSON depuis Google Cloud Console après avoir créé le OAuth Client ID Android, remplacez simplement l'ancien fichier par le nouveau.

