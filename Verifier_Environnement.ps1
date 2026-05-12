# Script de vérification de l'environnement SenAgriculture
# Exécutez ce script avant de démarrer l'application

Write-Host "`n============================================" -ForegroundColor Cyan
Write-Host "  VERIFICATION ENVIRONNEMENT SENAGRICULTURE" -ForegroundColor Cyan
Write-Host "============================================`n" -ForegroundColor Cyan

$allOk = $true

# 1. Vérifier si MySQL est en cours d'exécution
Write-Host "[1/5] Vérification MySQL..." -ForegroundColor Yellow
$mysqlProcess = Get-Process -Name "mysqld" -ErrorAction SilentlyContinue
if ($mysqlProcess) {
    Write-Host "  ✅ MySQL est en cours d'exécution (PID: $($mysqlProcess.Id))" -ForegroundColor Green
} else {
    Write-Host "  ❌ MySQL n'est PAS en cours d'exécution" -ForegroundColor Red
    Write-Host "     → Démarrez XAMPP ou WAMP" -ForegroundColor Yellow
    $allOk = $false
}

# 2. Vérifier si le port MySQL (3306) est accessible
Write-Host "`n[2/5] Vérification port MySQL (3306)..." -ForegroundColor Yellow
$mysqlPort = Test-NetConnection -ComputerName localhost -Port 3306 -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
if ($mysqlPort.TcpTestSucceeded) {
    Write-Host "  ✅ Port MySQL 3306 accessible" -ForegroundColor Green
} else {
    Write-Host "  ❌ Port MySQL 3306 NON accessible" -ForegroundColor Red
    $allOk = $false
}

# 3. Vérifier si le port WCF (59843) est libre ou utilisé
Write-Host "`n[3/5] Vérification port WCF (59843)..." -ForegroundColor Yellow
$wcfPort = Test-NetConnection -ComputerName localhost -Port 59843 -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
if ($wcfPort.TcpTestSucceeded) {
    Write-Host "  ✅ Port 59843 en cours d'utilisation (Service WCF probablement démarré)" -ForegroundColor Green
} else {
    Write-Host "  ⚠️  Port 59843 libre (Service WCF NON démarré)" -ForegroundColor Yellow
    Write-Host "     → Démarrez d'abord le projet MetierAppSenagriculture" -ForegroundColor Yellow
}

# 4. Vérifier si les fichiers de configuration existent
Write-Host "`n[4/5] Vérification fichiers de configuration..." -ForegroundColor Yellow
$webConfig = Test-Path "MetierAppSenagriculture\Web.config"
$appConfig = Test-Path "FrontSenAgriculture\App.config"
$sqlScript = Test-Path "Database_Setup.sql"

if ($webConfig) {
    Write-Host "  ✅ Web.config trouvé" -ForegroundColor Green
} else {
    Write-Host "  ❌ Web.config NON trouvé" -ForegroundColor Red
    $allOk = $false
}

if ($appConfig) {
    Write-Host "  ✅ App.config trouvé" -ForegroundColor Green
} else {
    Write-Host "  ❌ App.config NON trouvé" -ForegroundColor Red
    $allOk = $false
}

if ($sqlScript) {
    Write-Host "  ✅ Database_Setup.sql trouvé" -ForegroundColor Green
} else {
    Write-Host "  ⚠️  Database_Setup.sql NON trouvé" -ForegroundColor Yellow
    Write-Host "     → Créez la base de données manuellement" -ForegroundColor Yellow
}

# 5. Tester la connexion MySQL (si possible)
Write-Host "`n[5/5] Test de connexion MySQL..." -ForegroundColor Yellow
try {
    # Essayer de charger le driver MySQL
    $null = [System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")
    Write-Host "  ℹ️  Driver MySQL.Data disponible" -ForegroundColor Cyan

    # Note: Le test réel nécessite le mot de passe, on ne peut pas le faire automatiquement
    Write-Host "  ℹ️  Test de connexion manuel requis via phpMyAdmin" -ForegroundColor Cyan
} catch {
    Write-Host "  ℹ️  Driver MySQL.Data non chargeable (normal)" -ForegroundColor Cyan
}

# Résumé
Write-Host "`n============================================" -ForegroundColor Cyan
Write-Host "  RÉSUMÉ" -ForegroundColor Cyan
Write-Host "============================================`n" -ForegroundColor Cyan

if ($allOk -and $mysqlProcess -and $mysqlPort.TcpTestSucceeded) {
    Write-Host "✅ TOUT EST PRÊT !" -ForegroundColor Green
    Write-Host "`nÉtapes suivantes :" -ForegroundColor Cyan
    Write-Host "1. Démarrez le projet MetierAppSenagriculture" -ForegroundColor White
    Write-Host "2. Attendez que http://localhost:59843/Service1.svc s'ouvre" -ForegroundColor White
    Write-Host "3. Démarrez le projet FrontSenAgriculture" -ForegroundColor White
} else {
    Write-Host "⚠️  ACTIONS REQUISES :" -ForegroundColor Yellow
    if (-not $mysqlProcess) {
        Write-Host "  → Démarrez MySQL (XAMPP/WAMP)" -ForegroundColor Red
    }
    if (-not $mysqlPort.TcpTestSucceeded) {
        Write-Host "  → Vérifiez que MySQL écoute sur le port 3306" -ForegroundColor Red
    }
    if (-not $sqlScript) {
        Write-Host "  → Créez la base de données 'senapiagriculture' manuellement" -ForegroundColor Yellow
    }
}

Write-Host "`n============================================`n" -ForegroundColor Cyan

# Pause pour lire les résultats
Write-Host "Appuyez sur une touche pour fermer..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
