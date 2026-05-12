-- ETAPE 1: Sauvegarder les donnees
CREATE TABLE produits_backup_final AS SELECT * FROM produits;

-- Verifier la sauvegarde
SELECT COUNT(*) FROM produits_backup_final;
