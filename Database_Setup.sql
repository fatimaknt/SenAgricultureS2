-- Script de création de la base de données SenAgriculture
-- À exécuter dans MySQL Workbench ou phpMyAdmin

-- Créer la base de données si elle n'existe pas
CREATE DATABASE IF NOT EXISTS senapiagriculture;

-- Utiliser la base de données
USE senapiagriculture;

-- Créer la table produits
CREATE TABLE IF NOT EXISTS produits (
    idProduit INT PRIMARY KEY AUTO_INCREMENT,
    NomProduit VARCHAR(100) NOT NULL,
    DescriptionProduit VARCHAR(100) NOT NULL,
    PrixUnitaire FLOAT
);

-- Insérer des données de test
INSERT INTO produits (NomProduit, DescriptionProduit, PrixUnitaire) VALUES
('Tomate', 'Tomates fraîches de qualité', 500),
('Pomme de terre', 'Pommes de terre locales', 350),
('Oignon', 'Oignons frais', 400),
('Carotte', 'Carottes bio', 450),
('Salade', 'Salade verte fraîche', 300);

-- Vérifier les données insérées
SELECT * FROM produits;
