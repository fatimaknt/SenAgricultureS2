using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using MetierAppSenagriculture.Model;
using MySql.Data.MySqlClient;

namespace MetierAppSenagriculture.Library
{
    public class DiagnosticController
    {
        public string TestDatabaseConnection()
        {
            try
            {
                string connectionString = "server=localhost;port=3306;database=senapiagriculture;user=root;password=root";

                using (var connection = new MySqlConnection(connectionString))
                {
                    connection.Open();

                    string result = "=== TEST DE CONNEXION ===\n\n";
                    result += "✓ Connexion réussie!\n\n";

                    // Test 1: Lister toutes les tables
                    result += "=== TABLES DANS LA BASE ===\n";
                    using (var cmd = new MySqlCommand("SHOW TABLES", connection))
                    {
                        using (var reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                result += $"- {reader.GetString(0)}\n";
                            }
                        }
                    }

                    // Test 2: Vérifier si la table produits existe
                    result += "\n=== STRUCTURE DE LA TABLE produits ===\n";
                    try
                    {
                        using (var cmd = new MySqlCommand("DESCRIBE produits", connection))
                        {
                            using (var reader = cmd.ExecuteReader())
                            {
                                while (reader.Read())
                                {
                                    result += $"Colonne: {reader.GetString(0)} | Type: {reader.GetString(1)}\n";
                                }
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        result += $"ERREUR: Table 'produits' introuvable! {ex.Message}\n";
                    }

                    // Test 3: Compter les enregistrements
                    result += "\n=== NOMBRE D'ENREGISTREMENTS ===\n";
                    try
                    {
                        using (var cmd = new MySqlCommand("SELECT COUNT(*) FROM produits", connection))
                        {
                            var count = cmd.ExecuteScalar();
                            result += $"Nombre de produits: {count}\n";
                        }
                    }
                    catch (Exception ex)
                    {
                        result += $"ERREUR lors du comptage: {ex.Message}\n";
                    }

                    // Test 4: Afficher les premiers enregistrements
                    result += "\n=== PREMIERS ENREGISTREMENTS ===\n";
                    try
                    {
                        using (var cmd = new MySqlCommand("SELECT * FROM produits LIMIT 3", connection))
                        {
                            using (var reader = cmd.ExecuteReader())
                            {
                                // Afficher les noms des colonnes
                                result += "Colonnes: ";
                                for (int i = 0; i < reader.FieldCount; i++)
                                {
                                    result += $"{reader.GetName(i)} | ";
                                }
                                result += "\n\n";

                                // Afficher les données
                                while (reader.Read())
                                {
                                    for (int i = 0; i < reader.FieldCount; i++)
                                    {
                                        result += $"{reader.GetValue(i)} | ";
                                    }
                                    result += "\n";
                                }
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        result += $"ERREUR lors de la lecture: {ex.Message}\n";
                    }

                    return result;
                }
            }
            catch (Exception ex)
            {
                return $"ERREUR DE CONNEXION:\n{ex.Message}\n\nStackTrace:\n{ex.StackTrace}";
            }
        }
    }
}
