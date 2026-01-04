# Script automatique pour créer OAuth Client ID Android via gcloud CLI
# Ce script remplace la création manuelle dans Google Cloud Console

Write-Host "🚀 Création automatique OAuth Client ID Android" -ForegroundColor Cyan
Write-Host ""

# Informations de configuration
$sha1 = "43:91:62:9D:EE:69:11:69:5F:FD:CF:41:24:81:BA:72:2B:BD:73:D3"
$packageName = "com.example.coop"
$clientName = "Coop Android App"
$projectId = "glass-turbine-464801-e7"  # Project ID depuis le JSON

Write-Host "📋 Configuration :" -ForegroundColor Yellow
Write-Host "   Project ID: $projectId" -ForegroundColor White
Write-Host "   Client Name: $clientName" -ForegroundColor White
Write-Host "   Package Name: $packageName" -ForegroundColor White
Write-Host "   SHA-1: $sha1" -ForegroundColor White
Write-Host ""

# Vérifier si gcloud est installé
Write-Host "🔍 Vérification de gcloud CLI..." -ForegroundColor Cyan
$gcloudPath = Get-Command gcloud -ErrorAction SilentlyContinue

if (-not $gcloudPath) {
    Write-Host "❌ gcloud CLI n'est pas installé !" -ForegroundColor Red
    Write-Host ""
    Write-Host "📥 Installation :" -ForegroundColor Yellow
    Write-Host "   1. Téléchargez Google Cloud SDK :" -ForegroundColor White
    Write-Host "      https://cloud.google.com/sdk/docs/install" -ForegroundColor Cyan
    Write-Host "   2. Ou installez via PowerShell :" -ForegroundColor White
    Write-Host "      (New-Object Net.WebClient).DownloadFile('https://dl.google.com/dl/cloudsdk/channels/rapid/GoogleCloudSDKInstaller.exe', 'GoogleCloudSDKInstaller.exe')" -ForegroundColor Cyan
    Write-Host "      .\GoogleCloudSDKInstaller.exe" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "💡 Alternative : Utilisez le script ouvrir-google-cloud.ps1 pour la création manuelle" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ gcloud CLI trouvé : $($gcloudPath.Source)" -ForegroundColor Green
Write-Host ""

# Vérifier l'authentification
Write-Host "🔐 Vérification de l'authentification..." -ForegroundColor Cyan
$authStatus = gcloud auth list --filter=status:ACTIVE --format="value(account)" 2>&1

if (-not $authStatus -or $authStatus -match "ERROR") {
    Write-Host "⚠️  Vous n'êtes pas authentifié !" -ForegroundColor Yellow
    Write-Host "🔑 Connexion à Google Cloud..." -ForegroundColor Cyan
    gcloud auth login
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Échec de l'authentification" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "✅ Authentifié : $authStatus" -ForegroundColor Green
}
Write-Host ""

# Définir le projet
Write-Host "📁 Configuration du projet : $projectId" -ForegroundColor Cyan
gcloud config set project $projectId
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Impossible de définir le projet. Vérifiez que vous avez accès au projet." -ForegroundColor Red
    exit 1
}
Write-Host "✅ Projet configuré" -ForegroundColor Green
Write-Host ""

# Créer le OAuth Client ID Android
Write-Host "🔨 Création du OAuth Client ID Android..." -ForegroundColor Cyan
Write-Host "   Cela peut prendre quelques secondes..." -ForegroundColor Yellow
Write-Host ""

# Note: La commande exacte peut varier selon la version de gcloud
# Essayons d'abord avec la commande standard
$createCommand = "gcloud alpha iam oauth-clients create `"$clientName`" --application-type=ANDROID --package-name=`"$packageName`" --sha1-fingerprint=`"$sha1`" --format=json"

Write-Host "📝 Commande exécutée :" -ForegroundColor Yellow
Write-Host "   $createCommand" -ForegroundColor Gray
Write-Host ""

try {
    $result = Invoke-Expression $createCommand 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ OAuth Client ID Android créé avec succès !" -ForegroundColor Green
        Write-Host ""
        Write-Host "📋 Résultat :" -ForegroundColor Yellow
        Write-Host $result -ForegroundColor White
        Write-Host ""
        Write-Host "🎉 Configuration terminée !" -ForegroundColor Green
        Write-Host ""
        Write-Host "📱 Prochaines étapes :" -ForegroundColor Cyan
        Write-Host "   1. Attendez 2-3 minutes pour la propagation" -ForegroundColor White
        Write-Host "   2. Rebuild l'application :" -ForegroundColor White
        Write-Host "      cd MobileCoop" -ForegroundColor Cyan
        Write-Host "      flutter clean && flutter pub get && flutter run" -ForegroundColor Cyan
    } else {
        Write-Host "❌ Erreur lors de la création" -ForegroundColor Red
        Write-Host ""
        Write-Host "💡 Solutions possibles :" -ForegroundColor Yellow
        Write-Host "   1. Vérifiez que vous avez les permissions nécessaires" -ForegroundColor White
        Write-Host "   2. Activez l'API OAuth2 : gcloud services enable oauth2.googleapis.com" -ForegroundColor White
        Write-Host "   3. Utilisez le script ouvrir-google-cloud.ps1 pour la création manuelle" -ForegroundColor White
        Write-Host ""
        Write-Host "📝 Détails de l'erreur :" -ForegroundColor Yellow
        Write-Host $result -ForegroundColor Red
    }
} catch {
    Write-Host "❌ Erreur : $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "💡 Utilisez le script ouvrir-google-cloud.ps1 pour la création manuelle" -ForegroundColor Yellow
}

