# 🚀 Créer OAuth Client ID Android - Guide Complet

## ✅ Informations déjà récupérées

- **SHA-1** : `43:91:62:9D:EE:69:11:69:5F:FD:CF:41:24:81:BA:72:2B:BD:73:D3`
- **Package name** : `com.example.coop`
- **GOOGLE_CLIENT_ID Web** : `748540104556-lo3vre26813begj9c8p8pqjbdvabt8sv.apps.googleusercontent.com`

## 📋 Étapes dans Google Cloud Console

### 1. Ouvrir Google Cloud Console

Allez sur : **https://console.cloud.google.com/**

### 2. Sélectionner le bon projet

Dans le menu déroulant en haut, sélectionnez le projet qui contient votre `GOOGLE_CLIENT_ID` (celui qui commence par `748540104556-...` ou le projet `glass-turbine-464801-e7`)

### 3. Aller dans Credentials

1. Dans le menu de gauche, cliquez sur **APIs & Services**
2. Cliquez sur **Credentials** (ou allez directement : https://console.cloud.google.com/apis/credentials)

### 4. Créer un OAuth Client ID Android

1. Cliquez sur le bouton **+ CREATE CREDENTIALS** en haut
2. Sélectionnez **OAuth 2.0 Client ID**

### 5. Configurer le Client ID Android

Dans le formulaire qui s'ouvre :

- **Application type** : Sélectionnez **Android** (pas Web!)
- **Name** : `Coop Android App` (ou un nom de votre choix)
- **Package name** : `com.example.coop`
- **SHA-1 certificate fingerprint** : `43:91:62:9D:EE:69:11:69:5F:FD:CF:41:24:81:BA:72:2B:BD:73:D3`

### 6. Créer

Cliquez sur le bouton **Create**

### 7. Notez le Client ID (optionnel)

Un Client ID Android sera créé (format: `xxxxxx-xxxxx.apps.googleusercontent.com`). Vous pouvez le noter, mais ce n'est pas nécessaire car Google Sign-In le détectera automatiquement depuis `google-services.json` une fois mis à jour.

## ⚠️ Important

Après avoir créé le OAuth Client ID Android :
- **Attendez 2-3 minutes** pour la propagation
- **Rebuild l'application** : `flutter clean && flutter pub get && flutter run`

## ✅ Vérification

Vous devriez maintenant avoir dans Google Cloud Console :
- ✅ **OAuth Client ID Web** : Pour votre site web (déjà existant)
- ✅ **OAuth Client ID Android** : Pour votre app mobile (nouvellement créé)

Les deux sont dans le **même projet Google Cloud** !

## 🎉 C'est tout !

Après le rebuild, Google Sign-In devrait fonctionner exactement comme sur votre site web.

