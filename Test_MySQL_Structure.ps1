# Verifier la structure de la table produits
$dllPath = Get-ChildItem -Path ".\packages" -Filter "MySql.Data.dll" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName
[System.Reflection.Assembly]::LoadFrom($dllPath) | Out-Null

$connectionString = "Server=localhost;Port=3306;Database=senapiagriculture;Uid=root;Pwd=root;charset=utf8mb4;SslMode=None;"

try {
    $connection = New-Object MySql.Data.MySqlClient.MySqlConnection($connectionString)
    $connection.Open()

    Write-Host "Structure de la table produits:" -ForegroundColor Cyan
    Write-Host ""

    $cmdDesc = $connection.CreateCommand()
    $cmdDesc.CommandText = "DESCRIBE produits"
    $reader = $cmdDesc.ExecuteReader()

    while ($reader.Read()) {
        $field = $reader.GetString(0)
        $type = $reader.GetString(1)
        $null_val = $reader.GetString(2)
        $key = $reader.GetString(3)

        Write-Host "Colonne: $field | Type: $type | Null: $null_val | Key: $key" -ForegroundColor White
    }
    $reader.Close()

    Write-Host ""
    Write-Host "Requete SQL brute:" -ForegroundColor Cyan

    $cmdRaw = $connection.CreateCommand()
    $cmdRaw.CommandText = "SELECT * FROM produits LIMIT 2"
    $readerRaw = $cmdRaw.ExecuteReader()

    # Afficher les noms de colonnes
    Write-Host "Colonnes disponibles:" -ForegroundColor Yellow
    for ($i = 0; $i -lt $readerRaw.FieldCount; $i++) {
        Write-Host "  [$i] $($readerRaw.GetName($i))" -ForegroundColor White
    }

    Write-Host ""
    Write-Host "Donnees (2 premieres lignes):" -ForegroundColor Yellow
    $rowNum = 0
    while ($readerRaw.Read()) {
        $rowNum++
        Write-Host "Ligne $rowNum :" -ForegroundColor Cyan
        for ($i = 0; $i -lt $readerRaw.FieldCount; $i++) {
            $colName = $readerRaw.GetName($i)
            $value = if ($readerRaw.IsDBNull($i)) { "NULL" } else { $readerRaw.GetValue($i) }
            $typeName = if ($readerRaw.IsDBNull($i)) { "NULL" } else { $readerRaw.GetValue($i).GetType().Name }
            Write-Host "  $colName = $value (Type: $typeName)" -ForegroundColor White
        }
        Write-Host ""
    }
    $readerRaw.Close()

    $connection.Close()

} catch {
    Write-Host "ERREUR: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.InnerException) {
        Write-Host "Details: $($_.Exception.InnerException.Message)" -ForegroundColor Yellow
    }
}
