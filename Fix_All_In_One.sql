-- ============================================
-- SCRIPT COMPLET DE CORRECTION - EXECUTEZ TOUT D'UN COUP
-- ============================================

-- 1. Supprimer les anciennes sauvegardes si elles existent
DROP TABLE IF EXISTS produits_backup_final;

-- 2. Sauvegarder la table actuelle
CREATE TABLE produits_backup_final AS SELECT * FROM produits;

-- 3. Verifier la sauvegarde
SELECT 'Sauvegarde creee' as Etape, COUNT(*) as NombreProduits FROM produits_backup_final;

-- 4. Supprimer l'ancienne table
DROP TABLE produits;

-- 5. Recreer la table avec charset latin1 (compatible .NET)
CREATE TABLE produits (
    idProduit INT NOT NULL AUTO_INCREMENT,
    NomProduit VARCHAR(100) NOT NULL,
    DescriptionProduit VARCHAR(255) DEFAULT NULL,
    PrixUnitaire DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (idProduit)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- 6. Restaurer les donnees
INSERT INTO produits (idProduit, NomProduit, DescriptionProduit, PrixUnitaire)
SELECT idProduit, NomProduit, DescriptionProduit, PrixUnitaire 
FROM produits_backup_final;

-- 7. Verifier la restauration
SELECT 'Donnees restaurees' as Etape, COUNT(*) as NombreProduits FROM produits;

-- 8. Afficher quelques produits
SELECT * FROM produits ORDER BY idProduit LIMIT 5;

-- 9. Verifier la nouvelle structure (DOIT MONTRER latin1, PAS utf8mb3)
SHOW CREATE TABLE produits;
