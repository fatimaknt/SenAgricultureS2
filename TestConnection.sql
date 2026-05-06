-- Script de test pour vérifier la base de données
-- Exécutez ce script dans MySQL Workbench ou phpMyAdmin

-- 1. Vérifier quelle base de données est sélectionnée
SELECT DATABASE();

-- 2. Utiliser la bonne base de données
USE senapiagriculture;

-- 3. Lister toutes les tables
SHOW TABLES;

-- 4. Vérifier la structure de la table produits
DESCRIBE produits;

-- 5. Compter le nombre de produits
SELECT COUNT(*) as NombreProduits FROM produits;

-- 6. Afficher tous les produits
SELECT * FROM produits;

-- 7. Si la table n'existe pas, vérifier avec d'autres noms possibles
SHOW TABLES LIKE '%produit%';
SHOW TABLES LIKE '%Produit%';
