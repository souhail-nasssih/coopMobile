# Script PowerShell pour obtenir le SHA-1 fingerprint
# Usage: .\get-sha1.ps1

Write-Host "🔍 Recherche du SHA-1 fingerprint..." -ForegroundColor Cyan

# Méthode 1: Avec Gradle
Write-Host "`n📦 Méthode 1: Avec Gradle (Recommandé)" -ForegroundColor Yellow
Write-Host "Exécution de: gradlew signingReport" -ForegroundColor Gray

Push-Location android
if (Test-Path "gradlew.bat") {
    .\gradlew.bat signingReport 2>&1 | Select-String -Pattern "SHA1|Variant|Config" | ForEach-Object {
        Write-Host $_ -ForegroundColor White
    }
} else {
    Write-Host "❌ gradlew.bat non trouvé dans le dossier android" -ForegroundColor Red
}
Pop-Location

Write-Host "`n📋 Méthode 2: Avec keytool (Alternative)" -ForegroundColor Yellow
$keystorePath = "$env:USERPROFILE\.android\debug.keystore"

if (Test-Path $keystorePath) {
    Write-Host "Exécution de: keytool -list -v -keystore $keystorePath" -ForegroundColor Gray
    keytool -list -v -keystore $keystorePath -alias androiddebugkey -storepass android -keypass android 2>&1 | Select-String -Pattern "SHA1" | ForEach-Object {
        Write-Host $_ -ForegroundColor Green
    }
} else {
    Write-Host "❌ Keystore non trouvé à: $keystorePath" -ForegroundColor Red
}

Write-Host "`n✅ Copiez la valeur SHA1 et ajoutez-la dans Firebase Console" -ForegroundColor Green
Write-Host "   Firebase Console > Project Settings > Your apps > Add fingerprint" -ForegroundColor Cyan

