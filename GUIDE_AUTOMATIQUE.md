# 🚀 Guide : Création Automatique OAuth Client ID Android

## ✅ Script Automatique Disponible

Un script PowerShell a été créé pour automatiser la création du OAuth Client ID Android via la ligne de commande.

## 📋 Prérequis

### 1. Installer Google Cloud SDK (gcloud CLI)

**Option A : Installation via le site officiel**
1. Allez sur : https://cloud.google.com/sdk/docs/install
2. Téléchargez et installez Google Cloud SDK pour Windows

**Option B : Installation rapide via PowerShell**
```powershell
# Télécharger l'installateur
(New-Object Net.WebClient).DownloadFile('https://dl.google.com/dl/cloudsdk/channels/rapid/GoogleCloudSDKInstaller.exe', 'GoogleCloudSDKInstaller.exe')

# Lancer l'installation
.\GoogleCloudSDKInstaller.exe
```

### 2. Vérifier l'installation
```powershell
gcloud --version
```

## 🎯 Utilisation du Script Automatique

### Étape 1 : Exécuter le script

```powershell
cd MobileCoop
.\creer-oauth-android-auto.ps1
```

### Étape 2 : Le script va :
1. ✅ Vérifier si gcloud est installé
2. ✅ Vérifier votre authentification Google
3. ✅ Configurer le projet Google Cloud
4. ✅ Créer automatiquement le OAuth Client ID Android avec :
   - **Package name** : `com.example.coop`
   - **SHA-1** : `43:91:62:9D:EE:69:11:69:5F:FD:CF:41:24:81:BA:72:2B:BD:73:D3`
   - **Nom** : `Coop Android App`

### Étape 3 : Si vous n'êtes pas authentifié

Le script vous demandera de vous connecter :
```powershell
gcloud auth login
```

Suivez les instructions pour vous connecter à votre compte Google.

## 📝 Commande Manuelle (Alternative)

Si vous préférez exécuter la commande manuellement :

```powershell
# 1. Se connecter (si nécessaire)
gcloud auth login

# 2. Définir le projet
gcloud config set project glass-turbine-464801-e7

# 3. Créer le OAuth Client ID Android
gcloud alpha iam oauth-clients create "Coop Android App" `
  --application-type=ANDROID `
  --package-name="com.example.coop" `
  --sha1-fingerprint="43:91:62:9D:EE:69:11:69:5F:FD:CF:41:24:81:BA:72:2B:BD:73:D3"
```

## ⚠️ Si la commande ne fonctionne pas

Si `gcloud alpha iam oauth-clients create` n'est pas disponible, utilisez l'interface web :

```powershell
.\ouvrir-google-cloud.ps1
```

Puis suivez les instructions dans `CREER_OAUTH_ANDROID.md`

## ✅ Après la création

1. **Attendez 2-3 minutes** pour la propagation
2. **Rebuild l'application** :
   ```bash
   cd MobileCoop
   flutter clean
   flutter pub get
   flutter run
   ```

## 🎉 C'est tout !

Votre OAuth Client ID Android sera créé automatiquement et Google Sign-In fonctionnera dans votre application mobile !

