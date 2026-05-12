-- SCRIPT DE CORRECTION DE LA TABLE PRODUITS
-- Ce script corrige le probleme de charset utf8mb3 incompatible avec .NET Framework

-- Etape 1: Sauvegarder les donnees existantes
CREATE TABLE IF NOT EXISTS produits_backup_final AS SELECT * FROM produits;

-- Verifier la sauvegarde
SELECT COUNT(*) as 'Nombre de produits sauvegardes' FROM produits_backup_final;

-- Etape 2: Supprimer l'ancienne table
DROP TABLE produits;

-- Etape 3: Recreer la table avec charset latin1 (compatible .NET Framework)
CREATE TABLE produits (
    idProduit INT NOT NULL AUTO_INCREMENT,
    NomProduit VARCHAR(100) NOT NULL,
    DescriptionProduit VARCHAR(255) DEFAULT NULL,
    PrixUnitaire DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (idProduit)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Etape 4: Restaurer les donnees depuis la sauvegarde
INSERT INTO produits (idProduit, NomProduit, DescriptionProduit, PrixUnitaire)
SELECT idProduit, NomProduit, DescriptionProduit, PrixUnitaire 
FROM produits_backup_final;

-- Etape 5: Verifier que tout est OK
SELECT COUNT(*) as 'Nombre de produits restaures' FROM produits;
SELECT * FROM produits ORDER BY idProduit LIMIT 10;

-- Etape 6: Verifier la nouvelle structure
SHOW CREATE TABLE produits;

-- Si tout est OK, vous pouvez supprimer la sauvegarde (OPTIONNEL):
-- DROP TABLE produits_backup_final;
