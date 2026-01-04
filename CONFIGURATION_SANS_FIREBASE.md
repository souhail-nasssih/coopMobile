# ✅ Configuration Google Sign-In SANS Firebase

## 🎯 Solution Simple : Utiliser Google Cloud Console Directement

Vous n'avez **PAS besoin de Firebase** ! Utilisez directement **Google Cloud Console**, exactement comme vous avez configuré le web.

## 📋 Étapes (3 minutes)

### 1. Obtenir votre SHA-1

#### Option A : Avec le script PowerShell
```powershell
cd MobileCoop
.\get-sha1.ps1
```

#### Option B : Avec Gradle
```powershell
cd MobileCoop\android
.\gradlew signingReport
```

Cherchez la ligne avec **"SHA1:"** et copiez la valeur (format: `AA:BB:CC:DD:EE:FF:...`)

### 2. Créer un OAuth Client ID Android dans Google Cloud Console

1. Allez sur [Google Cloud Console](https://console.cloud.google.com/)
2. **Sélectionnez le même projet** que celui utilisé pour votre site web (celui avec votre `GOOGLE_CLIENT_ID`)
3. **APIs & Services** → **Credentials**
4. Cliquez sur **+ CREATE CREDENTIALS** → **OAuth 2.0 Client ID**
5. Configurez :
   - **Application type** : `Android`
   - **Name** : `Coop Android App` (ou un nom de votre choix)
   - **Package name** : `com.example.coop` (vérifiez dans `android/app/build.gradle.kts`)
   - **SHA-1 certificate fingerprint** : Collez le SHA-1 obtenu à l'étape 1
6. Cliquez sur **Create**

### 3. C'est tout ! 🎉

Rebuild l'application :
```bash
cd MobileCoop
flutter clean
flutter pub get
flutter run
```

## ✅ Résultat

Maintenant vous avez :
- ✅ **OAuth Client ID Web** : Utilisé par votre site web Laravel
- ✅ **OAuth Client ID Android** : Utilisé par votre app mobile
- ✅ **Même projet Google Cloud** : Tout est centralisé
- ✅ **Pas besoin de Firebase** : Utilisez directement Google Cloud Console

## 🔍 Vérification

1. Cliquez sur l'icône de connexion (👤) dans l'app
2. Sélectionnez "Se connecter avec Google"
3. Choisissez votre compte Google
4. Vous êtes connecté ! 🎊

## ❓ Pourquoi ça fonctionne ?

- **Site Web** : Utilise le OAuth Client ID Web → Fonctionne ✅
- **App Mobile** : Utilise le OAuth Client ID Android (même projet) → Fonctionne ✅
- **Backend Laravel** : Reçoit le même token Google → Fonctionne ✅

C'est le **même système**, juste avec deux types de Client ID (Web et Android) dans le même projet Google Cloud !

## 🆘 Si ça ne fonctionne pas

1. Vérifiez que le SHA-1 est correct (copié sans espaces)
2. Vérifiez que le package name correspond (`com.example.coop`)
3. Vérifiez que vous êtes dans le **bon projet** Google Cloud (celui avec votre GOOGLE_CLIENT_ID)
4. Attendez quelques minutes après la création du Client ID (propagation)
5. Rebuild l'app après configuration

