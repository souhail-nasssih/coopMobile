# Script pour creer OAuth Client ID Android directement
# Ouvre Google Cloud Console avec les informations pre-remplies

Write-Host "Creation directe OAuth Client ID Android" -ForegroundColor Cyan
Write-Host ""

# Informations de configuration
$sha1 = "43:91:62:9D:EE:69:11:69:5F:FD:CF:41:24:81:BA:72:2B:BD:73:D3"
$packageName = "com.example.coop"
$clientName = "Coop Android App"
$projectId = "glass-turbine-464801-e7"

Write-Host "Configuration :" -ForegroundColor Yellow
Write-Host "   Project ID: $projectId" -ForegroundColor White
Write-Host "   Client Name: $clientName" -ForegroundColor White
Write-Host "   Package Name: $packageName" -ForegroundColor White
Write-Host "   SHA-1: $sha1" -ForegroundColor White
Write-Host ""

# Ouvrir la page de creation OAuth Client ID
Write-Host "Ouverture de Google Cloud Console..." -ForegroundColor Cyan
Start-Process "https://console.cloud.google.com/apis/credentials?project=$projectId"

Write-Host "Page Google Cloud Console ouverte dans votre navigateur !" -ForegroundColor Green
Write-Host ""
Write-Host "Etapes a suivre :" -ForegroundColor Yellow
Write-Host ""
Write-Host "   1. Cliquez sur '+ CREATE CREDENTIALS' en haut" -ForegroundColor White
Write-Host "   2. Selectionnez 'OAuth 2.0 Client ID'" -ForegroundColor White
Write-Host "   3. Dans le formulaire :" -ForegroundColor White
Write-Host "      - Application type : Android" -ForegroundColor Cyan
Write-Host "      - Name : $clientName" -ForegroundColor Cyan
Write-Host "      - Package name : $packageName" -ForegroundColor Cyan
Write-Host "      - SHA-1 : $sha1" -ForegroundColor Cyan
Write-Host "   4. Cliquez sur 'Create'" -ForegroundColor White
Write-Host ""
Write-Host "Les valeurs sont deja affichees ci-dessus - copiez-collez les !" -ForegroundColor Yellow
Write-Host ""

# Copier les valeurs dans le presse-papiers
$valuesToCopy = "Package name: $packageName`nSHA-1: $sha1"

try {
    $valuesToCopy | Set-Clipboard
    Write-Host "Valeurs copiees dans le presse-papiers !" -ForegroundColor Green
} catch {
    Write-Host "Impossible de copier automatiquement" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Apres la creation, attendez 2-3 minutes puis rebuild l'app :" -ForegroundColor Cyan
Write-Host "   cd MobileCoop" -ForegroundColor White
Write-Host "   flutter clean" -ForegroundColor White
Write-Host "   flutter pub get" -ForegroundColor White
Write-Host "   flutter run" -ForegroundColor White
