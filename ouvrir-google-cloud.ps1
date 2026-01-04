# Script pour ouvrir directement la page de création OAuth Client ID dans Google Cloud Console

Write-Host "🔗 Ouverture de Google Cloud Console..." -ForegroundColor Cyan

# Informations pré-remplies
$sha1 = "43:91:62:9D:EE:69:11:69:5F:FD:CF:41:24:81:BA:72:2B:BD:73:D3"
$packageName = "com.example.coop"
$projectId = "748540104556" # Extrait du GOOGLE_CLIENT_ID

Write-Host "`n📋 Informations à utiliser :" -ForegroundColor Yellow
Write-Host "   SHA-1: $sha1" -ForegroundColor White
Write-Host "   Package name: $packageName" -ForegroundColor White
Write-Host "`n🔗 Ouverture de la page Credentials..." -ForegroundColor Cyan

# Ouvrir la page Credentials dans le navigateur
Start-Process "https://console.cloud.google.com/apis/credentials"

Write-Host "`n✅ Page ouverte dans votre navigateur !" -ForegroundColor Green
Write-Host "`n📝 Étapes à suivre :" -ForegroundColor Yellow
Write-Host "   1. Cliquez sur '+ CREATE CREDENTIALS' > 'OAuth 2.0 Client ID'" -ForegroundColor White
Write-Host "   2. Application type : Android" -ForegroundColor White
Write-Host "   3. Name : Coop Android App" -ForegroundColor White
Write-Host "   4. Package name : $packageName" -ForegroundColor White
Write-Host "   5. SHA-1 : $sha1" -ForegroundColor White
Write-Host "   6. Cliquez sur 'Create'" -ForegroundColor White
Write-Host "`n💡 Voir CREER_OAUTH_ANDROID.md pour le guide complet" -ForegroundColor Cyan

