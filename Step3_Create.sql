-- ETAPE 3: Recreer la table avec charset latin1
CREATE TABLE produits (
    idProduit INT NOT NULL AUTO_INCREMENT,
    NomProduit VARCHAR(100) NOT NULL,
    DescriptionProduit VARCHAR(255) DEFAULT NULL,
    PrixUnitaire DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (idProduit)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
