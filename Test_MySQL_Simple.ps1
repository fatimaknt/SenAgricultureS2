# Script de test MySQL simplifie
Write-Host "Test de connexion MySQL" -ForegroundColor Cyan
Write-Host ""

# Trouver MySQL.Data.dll
$dllPath = Get-ChildItem -Path ".\packages" -Filter "MySql.Data.dll" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName

if (-not $dllPath) {
    $dllPath = Get-ChildItem -Path ".\MetierAppSenagriculture\bin" -Filter "MySql.Data.dll" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName
}

if ($dllPath) {
    Write-Host "DLL trouve: $dllPath" -ForegroundColor Green
    [System.Reflection.Assembly]::LoadFrom($dllPath) | Out-Null
} else {
    Write-Host "ERREUR: MySql.Data.dll introuvable" -ForegroundColor Red
    exit 1
}

$connectionString = "Server=localhost;Port=3306;Database=senapiagriculture;Uid=root;Pwd=root;charset=utf8mb4;SslMode=None;"

try {
    Write-Host "Connexion a MySQL..." -ForegroundColor Yellow
    $connection = New-Object MySql.Data.MySqlClient.MySqlConnection($connectionString)
    $connection.Open()

    Write-Host "CONNEXION REUSSIE" -ForegroundColor Green
    Write-Host ""

    # Compter les produits
    $cmdCount = $connection.CreateCommand()
    $cmdCount.CommandText = "SELECT COUNT(*) FROM produits"
    $count = $cmdCount.ExecuteScalar()
    Write-Host "Nombre de produits: $count" -ForegroundColor Cyan
    Write-Host ""

    if ($count -gt 0) {
        # Afficher les produits
        $cmdSelect = $connection.CreateCommand()
        $cmdSelect.CommandText = "SELECT idProduit, NomProduit, DescriptionProduit, PrixUnitaire FROM produits"
        $reader = $cmdSelect.ExecuteReader()

        Write-Host "Liste des produits:" -ForegroundColor Cyan
        while ($reader.Read()) {
            $id = $reader.GetValue(0)
            $nom = $reader.GetValue(1)
            $desc = $reader.GetValue(2)
            $prix = $reader.GetValue(3)

            Write-Host "  ID: $id | Nom: $nom | Desc: $desc | Prix: $prix" -ForegroundColor White
        }
        $reader.Close()
    } else {
        Write-Host "TABLE VIDE - Aucun produit" -ForegroundColor Red
    }

    $connection.Close()
    Write-Host ""
    Write-Host "Connexion fermee" -ForegroundColor Gray

} catch {
    Write-Host ""
    Write-Host "ERREUR: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "Verifiez que:" -ForegroundColor Yellow
    Write-Host "  1. MySQL est demarre" -ForegroundColor White
    Write-Host "  2. La base senapiagriculture existe" -ForegroundColor White
    Write-Host "  3. Les identifiants sont corrects" -ForegroundColor White
}
