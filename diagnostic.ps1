# Script de diagnostic pour le problème "Base de données vide"
# Ce script vérifie étape par étape où se situe le problème

Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  🔍 DIAGNOSTIC : Base de données vide" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Test 1 : Vérifier que MySQL est accessible
Write-Host "📊 Test 1 : Vérification de MySQL..." -ForegroundColor Yellow
$mysqlProcess = Get-Process -Name "mysqld" -ErrorAction SilentlyContinue
if ($mysqlProcess) {
    Write-Host "✅ MySQL est en cours d'exécution (PID: $($mysqlProcess.Id))" -ForegroundColor Green
} else {
    Write-Host "❌ MySQL ne semble pas être en cours d'exécution" -ForegroundColor Red
    Write-Host "   → Démarrez XAMPP ou WAMP" -ForegroundColor Yellow
}
Write-Host ""

# Test 2 : Vérifier le fichier Produit.cs
Write-Host "📊 Test 2 : Vérification du modèle Produit.cs..." -ForegroundColor Yellow
$produitFile = "MetierAppSenagriculture\Model\Produit.cs"
if (Test-Path $produitFile) {
    $content = Get-Content $produitFile -Raw
    if ($content -match "decimal\?.*PrixUnitaire") {
        Write-Host "❌ Le type est encore 'decimal?' (problème de sérialisation WCF)" -ForegroundColor Red
        Write-Host "   → Le fichier a besoin d'être modifié en 'float'" -ForegroundColor Yellow
    } elseif ($content -match "float.*PrixUnitaire") {
        Write-Host "✅ Le type est 'float' (correct pour WCF)" -ForegroundColor Green
    } else {
        Write-Host "⚠️  Type de PrixUnitaire non reconnu" -ForegroundColor Yellow
    }
} else {
    Write-Host "❌ Fichier Produit.cs introuvable" -ForegroundColor Red
}
Write-Host ""

# Test 3 : Vérifier que le service WCF est compilé
Write-Host "📊 Test 3 : Vérification de la compilation du service..." -ForegroundColor Yellow
$serviceDll = "MetierAppSenagriculture\bin\MetierAppSenagriculture.dll"
if (Test-Path $serviceDll) {
    $serviceDate = (Get-Item $serviceDll).LastWriteTime
    Write-Host "✅ Service compilé le : $serviceDate" -ForegroundColor Green

    # Vérifier si récent (< 10 minutes)
    $diff = (Get-Date) - $serviceDate
    if ($diff.TotalMinutes -gt 10) {
        Write-Host "⚠️  La compilation date de $([int]$diff.TotalMinutes) minutes" -ForegroundColor Yellow
        Write-Host "   → Recompilez le service (Rebuild)" -ForegroundColor Yellow
    } else {
        Write-Host "✅ Compilation récente" -ForegroundColor Green
    }
} else {
    Write-Host "❌ Service non compilé" -ForegroundColor Red
    Write-Host "   → Compilez le projet MetierAppSenagriculture" -ForegroundColor Yellow
}
Write-Host ""

# Test 4 : Vérifier que le service WCF est accessible
Write-Host "📊 Test 4 : Test de connexion au service WCF..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:59843/Service1.svc" -TimeoutSec 2 -UseBasicParsing -ErrorAction Stop
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ Service WCF accessible (HTTP 200)" -ForegroundColor Green
    }
} catch {
    Write-Host "❌ Service WCF non accessible" -ForegroundColor Red
    Write-Host "   → Démarrez le projet MetierAppSenagriculture (F5)" -ForegroundColor Yellow
    Write-Host "   → Erreur : $($_.Exception.Message)" -ForegroundColor Gray
}
Write-Host ""

# Test 5 : Vérifier la date de la référence du service
Write-Host "📊 Test 5 : Vérification de la référence du service..." -ForegroundColor Yellow
$referenceFile = "FrontSenAgriculture\Connected Services\ServiceSenAgriculture\Reference.cs"
if (Test-Path $referenceFile) {
    $refDate = (Get-Item $referenceFile).LastWriteTime
    Write-Host "✅ Référence générée le : $refDate" -ForegroundColor Green

    $diff = (Get-Date) - $refDate
    if ($diff.TotalHours -gt 1) {
        Write-Host "⚠️  La référence date de $([int]$diff.TotalHours) heures" -ForegroundColor Yellow
        Write-Host "   → Mettez à jour la référence du service (Update Service Reference)" -ForegroundColor Yellow
    } else {
        Write-Host "✅ Référence récente" -ForegroundColor Green
    }
} else {
    Write-Host "❌ Fichier de référence introuvable" -ForegroundColor Red
}
Write-Host ""

# Test 6 : Vérifier le Web.config
Write-Host "📊 Test 6 : Vérification de la chaîne de connexion..." -ForegroundColor Yellow
$webConfig = "MetierAppSenagriculture\Web.config"
if (Test-Path $webConfig) {
    $content = Get-Content $webConfig -Raw
    if ($content -match 'connectionString="([^"]+)"') {
        $connString = $matches[1]
        Write-Host "✅ Chaîne de connexion trouvée :" -ForegroundColor Green
        Write-Host "   $connString" -ForegroundColor Gray

        # Vérifier les paramètres
        if ($connString -match "server=([^;]+)") {
            Write-Host "   → Serveur : $($matches[1])" -ForegroundColor Gray
        }
        if ($connString -match "database=([^;]+)") {
            Write-Host "   → Base : $($matches[1])" -ForegroundColor Gray
        }
        if ($connString -match "user id=([^;]+)") {
            Write-Host "   → Utilisateur : $($matches[1])" -ForegroundColor Gray
        }
    } else {
        Write-Host "❌ Chaîne de connexion non trouvée" -ForegroundColor Red
    }
} else {
    Write-Host "❌ Fichier Web.config introuvable" -ForegroundColor Red
}
Write-Host ""

# Résumé et recommandations
Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  📋 RÉSUMÉ ET RECOMMANDATIONS" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

Write-Host "🎯 ACTIONS À FAIRE MAINTENANT :" -ForegroundColor Yellow
Write-Host ""
Write-Host "1️⃣  Vérifiez que MySQL contient des produits :" -ForegroundColor White
Write-Host "   → Ouvrez phpMyAdmin : http://localhost/phpmyadmin" -ForegroundColor Gray
Write-Host "   → SELECT * FROM senapiagriculture.produits;" -ForegroundColor Gray
Write-Host ""

Write-Host "2️⃣  Recompilez le service WCF :" -ForegroundColor White
Write-Host "   → Clic droit sur MetierAppSenagriculture > Rebuild" -ForegroundColor Gray
Write-Host ""

Write-Host "3️⃣  Redémarrez le service WCF :" -ForegroundColor White
Write-Host "   → Shift+F5 puis F5 sur MetierAppSenagriculture" -ForegroundColor Gray
Write-Host ""

Write-Host "4️⃣  Mettez à jour la référence du service :" -ForegroundColor White
Write-Host "   → Clic droit sur ServiceSenAgriculture > Update Service Reference" -ForegroundColor Gray
Write-Host ""

Write-Host "5️⃣  Recompilez le client :" -ForegroundColor White
Write-Host "   → Clic droit sur FrontSenAgriculture > Rebuild" -ForegroundColor Gray
Write-Host ""

Write-Host "6️⃣  Testez l'application :" -ForegroundColor White
Write-Host "   → F5 sur FrontSenAgriculture" -ForegroundColor Gray
Write-Host ""

Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Proposer d'ouvrir phpMyAdmin
$response = Read-Host "Voulez-vous ouvrir phpMyAdmin pour vérifier les données ? (O/N)"
if ($response -eq "O" -or $response -eq "o") {
    Start-Process "http://localhost/phpmyadmin"
}

Write-Host ""
Write-Host "Appuyez sur une touche pour quitter..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
