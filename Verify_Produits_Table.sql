-- Verifier la structure actuelle de la table
SHOW CREATE TABLE produits;

-- Voir les donnees
SELECT * FROM produits LIMIT 5;

-- Si necessaire, recree la table COMPLETEMENT
-- ATTENTION: Cela supprime les donnees existantes !
/*
DROP TABLE IF EXISTS produits;

CREATE TABLE produits (
    idProduit INT NOT NULL AUTO_INCREMENT,
    NomProduit VARCHAR(100) NOT NULL,
    DescriptionProduit VARCHAR(255) DEFAULT NULL,
    PrixUnitaire DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (idProduit)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Reinserer des donnees de test
INSERT INTO produits (NomProduit, DescriptionProduit, PrixUnitaire) VALUES
('Mango', 'Kilo 600', 600.00),
('Banane', 'Regime', 500.00),
('Tomate', 'Kilo', 300.00);

SELECT * FROM produits;
*/
