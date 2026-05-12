# Test SANS charset
$dllPath = Get-ChildItem -Path ".\packages" -Filter "MySql.Data.dll" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName
[System.Reflection.Assembly]::LoadFrom($dllPath) | Out-Null

$connectionString = "Server=localhost;Port=3306;Database=senapiagriculture;Uid=root;Pwd=root;SslMode=None;Convert Zero Datetime=True;"

try {
    Write-Host "Test SANS charset..." -ForegroundColor Cyan
    $connection = New-Object MySql.Data.MySqlClient.MySqlConnection($connectionString)
    $connection.Open()

    Write-Host "CONNEXION REUSSIE" -ForegroundColor Green
    Write-Host ""

    $cmdCount = $connection.CreateCommand()
    $cmdCount.CommandText = "SELECT COUNT(*) FROM produits"
    $count = $cmdCount.ExecuteScalar()
    Write-Host "Nombre de produits: $count" -ForegroundColor Cyan
    Write-Host ""

    $cmdSelect = $connection.CreateCommand()
    $cmdSelect.CommandText = "SELECT idProduit, NomProduit, DescriptionProduit, PrixUnitaire FROM produits LIMIT 3"
    $reader = $cmdSelect.ExecuteReader()

    Write-Host "Produits:" -ForegroundColor Yellow
    $rowNum = 0
    while ($reader.Read()) {
        $rowNum++
        $id = $reader.GetValue(0)
        $nom = $reader.GetValue(1)
        $desc = $reader.GetValue(2)
        $prix = $reader.GetValue(3)
        Write-Host "  $rowNum. ID=$id | Nom=$nom | Desc=$desc | Prix=$prix" -ForegroundColor White
    }
    $reader.Close()

    $connection.Close()
    Write-Host ""
    Write-Host "SUCCESS - Les donnees sont lisibles !" -ForegroundColor Green

} catch {
    Write-Host "ERREUR: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.InnerException) {
        Write-Host "Details: $($_.Exception.InnerException.Message)" -ForegroundColor Yellow
    }
}
