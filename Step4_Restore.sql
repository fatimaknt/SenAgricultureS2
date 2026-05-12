-- ETAPE 4: Restaurer les donnees
INSERT INTO produits (idProduit, NomProduit, DescriptionProduit, PrixUnitaire)
SELECT idProduit, NomProduit, DescriptionProduit, PrixUnitaire 
FROM produits_backup_final;

-- Verifier
SELECT COUNT(*) FROM produits;
SELECT * FROM produits LIMIT 10;
