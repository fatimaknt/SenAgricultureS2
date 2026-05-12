# Test avec charset utf8
$dllPath = Get-ChildItem -Path ".\packages" -Filter "MySql.Data.dll" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName
[System.Reflection.Assembly]::LoadFrom($dllPath) | Out-Null

$connectionString = "Server=localhost;Port=3306;Database=senapiagriculture;Uid=root;Pwd=root;charset=utf8;SslMode=None;Convert Zero Datetime=True;"

try {
    Write-Host "Test avec charset=utf8..." -ForegroundColor Cyan
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
    $cmdSelect.CommandText = "SELECT * FROM produits LIMIT 3"
    $reader = $cmdSelect.ExecuteReader()

    Write-Host "Colonnes:" -ForegroundColor Yellow
    for ($i = 0; $i -lt $reader.FieldCount; $i++) {
        Write-Host "  [$i] $($reader.GetName($i))" -ForegroundColor White
    }

    Write-Host ""
    Write-Host "Donnees (3 premieres lignes):" -ForegroundColor Yellow
    $rowNum = 0
    while ($reader.Read()) {
        $rowNum++
        Write-Host "Produit $rowNum :" -ForegroundColor Cyan
        for ($i = 0; $i -lt $reader.FieldCount; $i++) {
            $colName = $reader.GetName($i)
            $value = if ($reader.IsDBNull($i)) { "NULL" } else { $reader.GetValue($i) }
            Write-Host "  $colName = $value" -ForegroundColor White
        }
        Write-Host ""
    }
    $reader.Close()

    $connection.Close()
    Write-Host "SUCCESS - Les donnees sont lisibles !" -ForegroundColor Green

} catch {
    Write-Host "ERREUR: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.InnerException) {
        Write-Host "Details: $($_.Exception.InnerException.Message)" -ForegroundColor Yellow
    }
}
