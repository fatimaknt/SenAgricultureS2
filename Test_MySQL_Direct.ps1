# Script PowerShell pour tester directement la connexion MySQL
# Et vérifier les données dans la table produits

Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "🔍 TEST DE CONNEXION MYSQL DIRECTE" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Charger l'assembly MySQL
try {
    $dllPath = "C:\Users\kanou\source\repos\AppSenagriculture\MetierAppSenagriculture\bin\MySql.Data.dll"
    if (Test-Path $dllPath) {
        [System.Reflection.Assembly]::LoadFrom($dllPath) | Out-Null
        Write-Host "✅ MySQL.Data.dll chargé" -ForegroundColor Green
    } else {
        Write-Host "❌ MySQL.Data.dll introuvable à : $dllPath" -ForegroundColor Red
        Write-Host "   Cherchons ailleurs..." -ForegroundColor Yellow

        # Chercher dans packages
        $dllPath = Get-ChildItem -Path "C:\Users\kanou\source\repos\AppSenagriculture\packages" -Filter "MySql.Data.dll" -Recurse | Select-Object -First 1 -ExpandProperty FullName

        if ($dllPath) {
            [System.Reflection.Assembly]::LoadFrom($dllPath) | Out-Null
            Write-Host "✅ MySQL.Data.dll trouvé et chargé depuis : $dllPath" -ForegroundColor Green
        } else {
            Write-Host "❌ Impossible de trouver MySQL.Data.dll" -ForegroundColor Red
            exit 1
        }
    }
} catch {
    Write-Host "❌ Erreur lors du chargement de MySQL.Data.dll : $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "─────────────────────────────────────────────────────" -ForegroundColor Gray

# Paramètres de connexion
$server = "localhost"
$port = "3306"
$database = "senapiagriculture"
$user = "root"
$password = "root"

$connectionString = "Server=$server;Port=$port;Database=$database;Uid=$user;Pwd=$password;charset=utf8mb4;SslMode=None;"

Write-Host "📋 Paramètres de connexion :" -ForegroundColor Cyan
Write-Host "   Server   : $server" -ForegroundColor White
Write-Host "   Port     : $port" -ForegroundColor White
Write-Host "   Database : $database" -ForegroundColor White
Write-Host "   User     : $user" -ForegroundColor White
Write-Host "   Password : ****" -ForegroundColor White
Write-Host ""

# Tester la connexion
try {
    Write-Host "🔌 Tentative de connexion..." -ForegroundColor Yellow
    $connection = New-Object MySql.Data.MySqlClient.MySqlConnection($connectionString)
    $connection.Open()

    Write-Host "✅ CONNEXION RÉUSSIE !" -ForegroundColor Green
    Write-Host ""
    Write-Host "─────────────────────────────────────────────────────" -ForegroundColor Gray

    # Vérifier la version de MySQL
    $cmdVersion = $connection.CreateCommand()
    $cmdVersion.CommandText = "SELECT VERSION();"
    $version = $cmdVersion.ExecuteScalar()
    Write-Host "📦 Version MySQL : $version" -ForegroundColor Cyan
    Write-Host ""

    # Vérifier que la base de données existe
    $cmdDB = $connection.CreateCommand()
    $cmdDB.CommandText = "SELECT DATABASE();"
    $currentDB = $cmdDB.ExecuteScalar()
    Write-Host "🗄️  Base de données actuelle : $currentDB" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "─────────────────────────────────────────────────────" -ForegroundColor Gray

    # Lister toutes les tables
    Write-Host "📑 Liste des tables dans la base '$database' :" -ForegroundColor Cyan
    $cmdTables = $connection.CreateCommand()
    $cmdTables.CommandText = "SHOW TABLES;"
    $reader = $cmdTables.ExecuteReader()

    $tables = @()
    while ($reader.Read()) {
        $tableName = $reader.GetString(0)
        $tables += $tableName
        Write-Host "   ✓ $tableName" -ForegroundColor White
    }
    $reader.Close()

    if ($tables.Count -eq 0) {
        Write-Host "   ⚠️  AUCUNE TABLE TROUVÉE !" -ForegroundColor Red
        $connection.Close()
        exit 1
    }

    Write-Host ""
    Write-Host "─────────────────────────────────────────────────────" -ForegroundColor Gray

    # Vérifier si la table 'produits' existe
    if ($tables -contains "produits") {
        Write-Host "✅ La table 'produits' existe" -ForegroundColor Green
        Write-Host ""

        # Compter les produits
        $cmdCount = $connection.CreateCommand()
        $cmdCount.CommandText = "SELECT COUNT(*) FROM produits;"
        $count = $cmdCount.ExecuteScalar()
        Write-Host "📊 Nombre de produits : $count" -ForegroundColor Cyan
        Write-Host ""

        if ($count -gt 0) {
            # Afficher la structure de la table
            Write-Host "🏗️  Structure de la table 'produits' :" -ForegroundColor Cyan
            $cmdDesc = $connection.CreateCommand()
            $cmdDesc.CommandText = "DESCRIBE produits;"
            $readerDesc = $cmdDesc.ExecuteReader()

            Write-Host ""
            Write-Host "   Colonne          | Type              | Null | Key | Default" -ForegroundColor Yellow
            Write-Host "   ─────────────────────────────────────────────────────────────" -ForegroundColor Gray

            while ($readerDesc.Read()) {
                $field = $readerDesc.GetString(0).PadRight(16)
                $type = $readerDesc.GetString(1).PadRight(17)
                $null_val = $readerDesc.GetString(2).PadRight(4)
                $key = $readerDesc.GetString(3).PadRight(3)
                $default = if ($readerDesc.IsDBNull(4)) { "NULL" } else { $readerDesc.GetString(4) }

                Write-Host "   $field | $type | $null_val | $key | $default" -ForegroundColor White
            }
            $readerDesc.Close()

            Write-Host ""
            Write-Host "─────────────────────────────────────────────────────" -ForegroundColor Gray

            # Récupérer tous les produits
            Write-Host "📦 Liste des produits :" -ForegroundColor Cyan
            Write-Host ""

            $cmdSelect = $connection.CreateCommand()
            $cmdSelect.CommandText = "SELECT * FROM produits;"
            $readerProducts = $cmdSelect.ExecuteReader()

            $productCount = 0
            while ($readerProducts.Read()) {
                $productCount++

                $id = $readerProducts.GetValue(0)
                $nom = $readerProducts.GetValue(1)
                $description = $readerProducts.GetValue(2)
                $prix = $readerProducts.GetValue(3)

                Write-Host "   ─────────────────────────────────────────────────────" -ForegroundColor Gray
                Write-Host "   🌾 Produit #$productCount" -ForegroundColor Yellow
                Write-Host "      ID          : $id" -ForegroundColor White
                Write-Host "      Nom         : $nom" -ForegroundColor White
                Write-Host "      Description : $description" -ForegroundColor White
                Write-Host "      Prix        : $prix FCFA" -ForegroundColor White
                Write-Host "      Type Prix   : $($prix.GetType().Name)" -ForegroundColor Cyan
            }
            $readerProducts.Close()

            Write-Host ""
            Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Green
            Write-Host "✅ TOTAL : $productCount produit(s) trouvé(s)" -ForegroundColor Green
            Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Green
        } else {
            Write-Host "⚠️  LA TABLE 'produits' EST VIDE !" -ForegroundColor Red
            Write-Host ""
            Write-Host "📝 Pour ajouter des produits de test, exécutez :" -ForegroundColor Yellow
            Write-Host "   INSERT INTO produits (NomProduit, DescriptionProduit, PrixUnitaire)" -ForegroundColor White
            Write-Host "   VALUES ('Mango', 'Kilo 600', 600.00);" -ForegroundColor White
        }
    } else {
        Write-Host "❌ LA TABLE 'produits' N'EXISTE PAS !" -ForegroundColor Red
        Write-Host ""
        Write-Host "📝 Créez la table avec :" -ForegroundColor Yellow
        Write-Host "   CREATE TABLE produits (" -ForegroundColor White
        Write-Host "       idProduit INT PRIMARY KEY AUTO_INCREMENT," -ForegroundColor White
        Write-Host "       NomProduit VARCHAR(100) NOT NULL," -ForegroundColor White
        Write-Host "       DescriptionProduit VARCHAR(255)," -ForegroundColor White
        Write-Host "       PrixUnitaire DECIMAL(10,2) NOT NULL" -ForegroundColor White
        Write-Host "   );" -ForegroundColor White
    }

    # Fermer la connexion
    $connection.Close()
    Write-Host ""
    Write-Host "🔌 Connexion fermée" -ForegroundColor Gray

} catch {
    Write-Host ""
    Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Red
    Write-Host "❌ ERREUR DE CONNEXION" -ForegroundColor Red
    Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Red
    Write-Host ""
    Write-Host "Message : $($_.Exception.Message)" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "📋 Vérifiez que :" -ForegroundColor Cyan
    Write-Host "   1. MySQL est démarré (XAMPP/WAMP)" -ForegroundColor White
    Write-Host "   2. Le port 3306 est bien celui de MySQL" -ForegroundColor White
    Write-Host "   3. L'utilisateur 'root' avec le mot de passe 'root' existe" -ForegroundColor White
    Write-Host "   4. La base de données 'senapiagriculture' existe" -ForegroundColor White
    Write-Host ""
    exit 1
}
